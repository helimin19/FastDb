import { relationalStore } from '@kit.ArkData'
import { BusinessError } from '@kit.BasicServicesKit';
import { SqliteDataBaseConfigManager } from './SqliteDataBaseConfig';
import { DataTableField, DataTableRecord } from './SqliteDatabaseEnfity';
import { SqliteDatabaseEntityParser } from './SqliteDatabaseEntityParser';
import { SqliteDataBaseError } from './SqliteDatabaseError';
import { DeleteEntity, UpdateEntity, QueryWhere } from './SqliteDatabaseQuery';
import { SqliteDataBaseVersionManager } from './SqliteDatabaseVersion';

export class SqliteDatabase {

  private context: Context;
  private databaseName: string;
  private store?: relationalStore.RdbStore;

  constructor(context: Context, name: string) {
    this.context = context.getApplicationContext();
    this.databaseName = name + ".db";
  }

  /**
   * 取得配置档
   * @returns 配置档
   */
  private getStoreConfig(): relationalStore.StoreConfig {
    let config: relationalStore.StoreConfig|undefined;
    const dataBaseConfig = SqliteDataBaseConfigManager.getConfig();
    if (dataBaseConfig) {
      config = dataBaseConfig.getStoreConfig(this.databaseName);
    } else {
      config = {
        name: this.databaseName,
        securityLevel: relationalStore.SecurityLevel.S1,
        encrypt: true,
        isReadOnly: false
      };
    }
    return config;
  }

  public async getStoreAsync() {
    if (this.store) {
      return Promise.resolve(this.store);
    }

    let config = this.getStoreConfig();
    this.store = await relationalStore.getRdbStore(this.context, config);
    this.initDatabase();
    return Promise.resolve(this.store);
  }

  public getStore(callback: (error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => void) {
    if (this.store) {
      return callback(null, this.store);
    }

    let config = this.getStoreConfig();
    relationalStore.getRdbStore(this.context, config, (err: BusinessError | null | undefined, store: relationalStore.RdbStore) => {
      if (err) {
        callback(err);
        return;
      }

      this.store = store;
      this.initDatabase();
      callback(null, this.store);
    });
  }

  /**
   * 新增
   * @param entity 需要新的的对象或对象列表
   * @param callback 新增的个数回调
   */
  public async insertAsync(entity: Object | Object[]) : Promise<number> {
    if (entity instanceof Array) {
      if ((entity as Array<Object>).length === 0) {
        return Promise.reject(new SqliteDataBaseError(100101,"未指定要新增的数据."));
      }
    }

    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(entity);
    const store = await this.getStoreAsync();
    return store.batchInsert(entityParser.getTableDecoratorParameter().name, entityParser.getEntityValuesBucketList());
  }

  /**
   * 新增
   * @param entity 需要新的的对象或对象列表
   * @param callback 新增的个数回调
   */
  public insert(entity: Object | Object[], callback?: (err: BusinessError | null | undefined, num: number) => void) {
    if (entity instanceof Array) {
      if ((entity as Array<Object>).length === 0) {
        callback!(SqliteDataBaseError.NO_DATA, 0);
        return;
      }
    }

    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(entity);
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        callback!(error, 0);
        return;
      }

      store?.batchInsert(entityParser.getTableDecoratorParameter().name, entityParser.getEntityValuesBucketList(), (err: BusinessError, data:number) => {
        if (err) {
          callback!(err, 0);
          return;
        }

        callback!(null, data);
      });
    });
  }

  /**
   * 更新
   * @param where 需更新的的条件
   * @param callback 更新的个数回调
   */
  public async updateAsync(where: QueryWhere) : Promise<number> {
    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(where.entity);

    const store = await this.getStoreAsync();
    return store.update(entityParser.getEntityValuesBucketList()[0], where);
  }

  /**
   * 更新
   * @param where 需更新的的条件
   * @param callback 更新的个数回调
   */
  public update(where: UpdateEntity | QueryWhere, callback?: (err: BusinessError | null | undefined, num: number) => void) {
    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(where.entity);
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        if (callback) {
          callback!(error, 0);
        }
        return;
      }

      store?.update(entityParser.getEntityValuesBucketList()[0], where, (err: BusinessError, data:number) => {
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
   * @param where 需删除的条件
   * @param callback 删除的个数回调
   */
  public async deleteAsync(where: QueryWhere) : Promise<number> {
    const store = await this.getStoreAsync();
    return store.delete(where);
  }

  /**
   * 删除
   * @param where 需删除的的条件
   * @param callback 删除的个数回调
   */
  public delete(where: DeleteEntity | QueryWhere, callback?: (err: BusinessError | null | undefined, num: number) => void) {
    this.getStore((error: BusinessError | null | undefined, store?: relationalStore.RdbStore) => {
      if (error) {
        if (callback) {
          callback!(error, 0);
        }
        return;
      }

      store?.delete(where, (err: BusinessError, data: number) => {
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
   * 异步查询记录
   * @param where 查询的条件
   * @returns 查询数把记录数组
   */
  public async selectRecordAsync(where: QueryWhere) : Promise<Array<DataTableRecord>> {
    const entityParser: SqliteDatabaseEntityParser =  new SqliteDatabaseEntityParser(where.entity);
    const store = await this.getStoreAsync();
    const resultSet = await store.query(where, entityParser.getFields());
    const list: Array<DataTableRecord> = this.resultSetToDataTableRecordByEntity(entityParser, resultSet);
    // 释放数据集的内存
    resultSet.close();
    return Promise.resolve(list);
  }

  /**
   * 查询记录
   * @param where 查询的条件
   * @param callback 查询回调
   */
  public selectRecord(where: QueryWhere, callback: (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => void) {
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

        const list: Array<DataTableRecord> = this.resultSetToDataTableRecordByEntity(entityParser, resultSet);
        // 释放数据集的内存
        resultSet.close();
        callback(null, list);
      });

    });
  }

  /**
   * 异步按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @returns 查询记录数组
   */
  public async selectRecordBySqlAsync(sql: string, args: Array<relationalStore.ValueType>) : Promise<Array<DataTableRecord>> {
    const store = await this.getStoreAsync();
    const resultSet = await store.querySql(sql, args);
    const list: Array<DataTableRecord> = this.resultSetToDataTableRecordBySql(resultSet);
    // 释放数据集的内存
    resultSet.close();
    return Promise.resolve(list);
  }

  /**
   * 按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param callback 查询结果回调
   */
  public selectRecordBySql(sql: string, args: Array<relationalStore.ValueType>, callback: (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => void) {
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

        const list: Array<DataTableRecord> = this.resultSetToDataTableRecordBySql(resultSet);
        // 释放数据集的内存
        resultSet.close();
        callback(null, list);
      });
    });
  }

  /**
   * 异步查询
   * @param where 查询条件
   * @param creator 对象创建函数
   * returns 查询对象数组
   */
  public async selectAsync<T extends object>(where: QueryWhere, creator: () => T) : Promise<Array<T>> {
    const list = await this.selectRecordAsync(where);
    const items = this.dataTableRecordToEntityByEntity(list, creator);
    return Promise.reject(items);
  }

  /**
   * 查询
   * @param where 查询条件
   * @param creator 对象创建函数
   * @param callback 查询回调
   */
  public select<T extends object>(where: QueryWhere, creator: () => T, callback: (err: BusinessError | null | undefined, list?: Array<T>) => void) {
    this.selectRecord(where, (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => {
      if (err) {
        callback(err);
        return;
      }

      const items = this.dataTableRecordToEntityByEntity(list!, creator);
      callback(null, items);
    });
  }

  /**
   * 异步按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param creator 对象创建函数
   * @returns 对象数组
   */
  public async selectBySqlAsync<T extends object>(sql: string, args: Array<relationalStore.ValueType>, creator: () => T) : Promise<Array<T>> {
    const list = await this.selectRecordBySqlAsync(sql, args);
    const items = this.dataTableRecordToEntityBySql(list, creator);
    return Promise.resolve(items);
  }

  /**
   * 按SQL查询
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param creator 对象创建函数
   * @param callback 查询结果回调
   */
  public selectBySql<T extends object>(sql: string, args: Array<relationalStore.ValueType>, creator: () => T, callback: (err: BusinessError | null | undefined, list?: Array<T>) => void) {
    this.selectRecordBySql(sql, args, (err: BusinessError | null | undefined, list?: Array<DataTableRecord>) => {
      if (err) {
        callback(err);
        return;
      }

      const items = this.dataTableRecordToEntityBySql(list!, creator);
      callback(null, items);
    });
  }

  /**
   * 异步按SQL进行统计计算
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param callback 查询结果回调
   */
  public async calculateBySqlAsync(sql: string, args: Array<relationalStore.ValueType>) : Promise<relationalStore.ValueType> {
    const store = await this.getStoreAsync();
    const resultSet = await store.querySql(sql, args);
    let fieldValue: relationalStore.ValueType = null;
    if (resultSet.goToNextRow()) {
      fieldValue =  resultSet.getValue(0);
    }
    // 释放数据集的内存
    resultSet.close();
    return Promise.resolve(fieldValue);
  }

  /**
   * 按SQL进行统计计算
   * @param sql 要查询的SQL语句
   * @param args SqL语句的参数
   * @param callback 查询结果回调
   */
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
        if (resultSet.goToNextRow()) {
          fieldValue =  resultSet.getValue(0);
        }
        // 释放数据集的内存
        resultSet.close();
        callback(null, fieldValue);
      });
    });
  }


  /**
   * 数据化数据库
   */
  private initDatabase() {
    // 当数据库创建时，数据库默认版本为0
    // 取得大于当前数据库版本的SQL脚本
    let scriptList = SqliteDataBaseVersionManager.get(this.databaseName, this.store!.version);
    if (scriptList.length > 0) {
      scriptList.forEach(script => {
        this.store?.executeSql(script);
      });

      // 设置数据库的版本，入参为大于0的整数
      const maxVersion = SqliteDataBaseVersionManager.getMaxVersion(this.databaseName);
      if (maxVersion > 0) {
        this.store!.version = maxVersion;
      }
      SqliteDataBaseVersionManager.clear(this.databaseName);
    }

    const config = SqliteDataBaseConfigManager.getConfig();
    if (config) {
      scriptList = config.getInitSqlTexts(this.databaseName, this.store!.version);
      if (scriptList.length > 0) {
        scriptList.forEach(script => {
          this.store?.executeSql(script);
        });
      }
      const maxVersion = config.getMaxVersion(this.databaseName, this.store!.version);
      if (maxVersion > 0) {
        this.store!.version = maxVersion;
      }
    }
  }

  /**
   * 将ResultSet转换成DataTableRecord数组 - 按对象返回DataTableRecord
   * @param entityParser 查询解析器
   * @param resultSet ResultSet
   * @returns DataTableRecord数组
   */
  private resultSetToDataTableRecordByEntity(entityParser: SqliteDatabaseEntityParser, resultSet: relationalStore.ResultSet) : Array<DataTableRecord> {
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
    return list;
  }

  /**
   * 将ResultSet转换成DataTableRecord数组 - 按查询结果返回DataTableRecord
   * @param entityParser 查询解析器
   * @param resultSet ResultSet
   * @returns DataTableRecord数组
   */
  private resultSetToDataTableRecordBySql(resultSet: relationalStore.ResultSet) : Array<DataTableRecord> {
    const list: Array<DataTableRecord> = [];
    while (resultSet.goToNextRow()) {
      let items = new Array<DataTableField>();
      resultSet.columnNames.forEach(columnName => {
        const fieldValue =  resultSet.getValue(resultSet.getColumnIndex(columnName));
        items.push({ fieldName: columnName, value: fieldValue });
      });
      list.push(items);
    }
    return list;
  }

  /**
   * DataTableRecord数组转换成对象数组 - 按对象转换
   * @param list DataTableRecord数组
   * @param creator 对象创建函数
   * @returns 对象数组
   */
  private dataTableRecordToEntityByEntity<T extends object>(list: Array<DataTableRecord>, creator: () => T) : Array<T> {
    const items = new Array<T>();
    list.forEach(record => {
      let item = creator();
      record.forEach(field => {
        Reflect.set(item, field.attributeName!, field.value);
      })
      items.push(item);
    });
    return items;
  }

  /**
   * DataTableRecord数组转换成对象数组 - 按Sql转换
   * @param list DataTableRecord数组
   * @param creator 对象创建函数
   * @returns 对象数组
   */
  private dataTableRecordToEntityBySql<T extends object>(list: Array<DataTableRecord>, creator: () => T) : Array<T> {
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

    return items;
  }


}