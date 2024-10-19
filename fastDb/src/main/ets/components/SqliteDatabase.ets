import { relationalStore } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit';
import { DataTableField, DataTableRecord } from './SqliteDatabaseEnfity';
import { SqliteDatabaseEntityParser } from './SqliteDatabaseEntityParser';
import { SqliteDataBaseError } from './SqliteDatabaseError';
import { DeleteEntity, UpdateEntity, QueryWhere } from './SqliteDatabaseQuery';
import { SqliteDataBaseVersionManager } from './SqliteDatabaseVersion';

export class SqliteDatabase {

  private context: Context;
  private databaseName: string;
  private securityLevel = relationalStore.SecurityLevel.S1;
  private encrypt = true;
  private isReadOnly = false;
  private store?: relationalStore.RdbStore;

  constructor(context: Context, name: string) {
    this.context = context.getApplicationContext();
    this.databaseName = name + ".db";
  }

  public setSecurityLevel(level: relationalStore.SecurityLevel): SqliteDatabase {
    this.securityLevel = level;
    return this;
  }

  public setEncrypt(encrypt: boolean): SqliteDatabase {
    this.encrypt = encrypt;
    return this;
  }

  public setReadOnly(isReadOnly: boolean): SqliteDatabase {
    this.isReadOnly = isReadOnly;
    return this;
  }

  public getStore(callback: (error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => void) {
    if (this.store) {
      return callback(null, this.store);
    }

    const config: relationalStore.StoreConfig = {
      name: this.databaseName,
      securityLevel: this.securityLevel,
      encrypt: this.encrypt,
      isReadOnly: this.isReadOnly
    };
    relationalStore.getRdbStore(this.context, config, (err: BusinessError | null | undefined, store: relationalStore.RdbStore) => {
      if (err) {
        callback(err);
        return;
      }

      this.store = store;

      // 当数据库创建时，数据库默认版本为0
      let scriptList = SqliteDataBaseVersionManager.get(store.version);
      scriptList.forEach(script => {
        store.executeSql(script);
      });
      // 设置数据库的版本，入参为大于0的整数
      store.version = SqliteDataBaseVersionManager.getMaxVersion();
      SqliteDataBaseVersionManager.clear();
      callback(null, this.store);
    });
  }

  /**
   * 新增
   * @param entity 需要新的的对象或对象列表
   * @param callback 新增的个数回调
   */
  public insert(entity: Object | Object[], callback?: (err: BusinessError | null | undefined, num: number) => void) {
    if (entity instanceof Array) {
      if ((entity as Array<Object>).length === 0) {
        if (callback) {
          callback!(SqliteDataBaseError.NO_DATA, 0);
        }
        return;
      }
    }

    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(entity);
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        if (callback) {
          callback!(error, 0);
        }
        return;
      }

      store?.batchInsert(entityParser.getTableDecoratorParameter().name, entityParser.getEntityValuesBucketList(), (err: BusinessError, data:number) => {
        if (err) {
          if (callback) {
            callback!(err, 0);
          }
          return;
        }

        if (callback) {
          callback!(null, data);
        }
      });
    });
  }

  /**
   * 更新
   * @param updateEntity 更新对象
   * @param callback 更新的个数回调
   */
  public update(updateEntity: UpdateEntity, callback?: (err: BusinessError | null | undefined, num: number) => void) {
    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(updateEntity.entity);
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        if (callback) {
          callback!(error, 0);
        }
        return;
      }

      store?.update(entityParser.getEntityValuesBucketList()[0], updateEntity, (err: BusinessError, data:number) => {
        if (err) {
          if (callback) {
            callback!(err, 0);
          }
          return;
        }

        if (callback) {
          callback!(null, data);
        }
      });
    });
  }

  /**
   * 删除
   * @param deleteEntity 删除对象
   * @param callback 删除的个数回调
   */
  public delete(deleteEntity: DeleteEntity, callback?: (err: BusinessError | null | undefined, num: number) => void) {
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        if (callback) {
          callback!(error, 0);
        }
        return;
      }

      store?.delete(deleteEntity, (err: BusinessError, data: number) => {
        if (err) {
          if (callback) {
            callback!(err, 0);
          }
          return;
        }
        if (callback) {
          callback!(null, data);
        }
      });
    });
  }

  public select(where: QueryWhere, callback: (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => void) {
    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(where.entity);

    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        callback(error);
        return;
      }

      store?.query(where, entityParser.getFields(), (err: BusinessError, resultSet) => {
        if (err) {
          callback(err);
          return;
        }

        const list: Array<DataTableRecord> = [];
        // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
        while (resultSet.goToNextRow()) {
          const record: DataTableRecord = entityParser.getTableFields();
          record.forEach(tableField => {
            const fieldValue =  resultSet.getValue(resultSet.getColumnIndex(tableField.fieldName));
            tableField.value = fieldValue;
          });
          list.push(record);
        }
        // 释放数据集的内存
        resultSet.close();
        callback(null, list);
      });

    });
  }

  public query<T extends object>(where: QueryWhere, creator: () => T, callback: (err: BusinessError | null | undefined, list?: Array<T>) => void) {
    this.select(where, (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => {
      if (err) {
        callback(err);
        return;
      }

      const items = new Array<T>();
      list?.forEach(record => {
        let item = creator();
        record.forEach(field => {
          Reflect.set(item, field.attributeName!, field.value);
        })
        items.push(item);
      });
      callback(null, items);
    });

  }

  /**
   * 按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param callback 查询结果回调
   */
  public selectBySql(sql: string, args: Array<relationalStore.ValueType>, callback: (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => void) {
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        callback(error);
        return;
      }

      store?.querySql(sql, args, (err: BusinessError, resultSet) => {
        if (err) {
          callback(err);
          return;
        }

        const list: Array<DataTableRecord> = [];
        while (resultSet.goToNextRow()) {
          let items = new Array<DataTableField>();
          resultSet.columnNames.forEach(columnName => {
            const fieldValue =  resultSet.getValue(resultSet.getColumnIndex(columnName));
            items.push({ fieldName: columnName, value: fieldValue });
          });
          list.push(items);
        }
        // 释放数据集的内存
        resultSet.close();
        callback(null, list);
      });
    });
  }

  /**
   * 按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param creator 对象创建函数
   * @param callback 查询结果回调
   */
  public queryBySql<T extends object>(sql: string, args: Array<relationalStore.ValueType>, creator: () => T, callback: (err: BusinessError | null | undefined, list?: Array<T>) => void) {
    this.selectBySql(sql, args, (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => {
      if (err) {
        callback(err);
        return;
      }

      const entityParser: SqliteDatabaseEntityParser = new SqliteDatabaseEntityParser(creator());
      const fields = entityParser.getTableFields();

      const items = new Array<T>();
      list?.forEach(record => {
        let item = creator();
        record.forEach(tableField => {
          let field = fields.find(field => field.fieldName === tableField.fieldName);
          if (field) {
            Reflect.set(item, field.attributeName!, tableField.value);
          }
        })
        items.push(item);
      });
      callback(null, items);
    });
  }


  public calculateBySql(sql: string, args: Array<relationalStore.ValueType>, callback: (err: BusinessError | null | undefined, result?: relationalStore.ValueType) => void) {
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        callback(error);
        return;
      }

      store?.querySql(sql, args, (err: BusinessError, resultSet) => {
        if (err) {
          callback(err);
          return;
        }
        let fieldValue: relationalStore.ValueType = null;
        const list: Array<DataTableRecord> = [];
        if (resultSet.goToNextRow()) {
          fieldValue =  resultSet.getValue(0);
        }

        // 释放数据集的内存
        resultSet.close();
        callback(null, fieldValue);
      });
    });
  }


}