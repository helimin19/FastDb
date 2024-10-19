import { SqliteDatabaseConstant } from './SqliteDatabaseConstant';
import { relationalStore, ValueType } from '@kit.ArkData';
import { DataTableField } from './SqliteDatabaseEnfity';
import { DataFieldDecoratorParameter, DataTableDecoratorParameter } from './Decorator';

/**
 * 对象解析器
 */
export class SqliteDatabaseEntityParser {

  private entityList: Object[] = new Array();
  private tableMetadata: DataTableDecoratorParameter;
  private fieldsMetadata: Object;
  private fieldMapping: Map<string, DataFieldDecoratorParameter> = new Map();

  constructor(entity: Object|Object[]) {
    if (entity instanceof Array) {
      this.entityList = entity;
    } else {
      this.entityList.push(entity);
    }
    this.tableMetadata =  Reflect.get(this.entityList[0], SqliteDatabaseConstant.METADATA_TABLE) as DataTableDecoratorParameter;
    this.fieldsMetadata = Reflect.get(this.entityList[0], SqliteDatabaseConstant.METADATA_FIELDS) as Object;
    Object.keys(this.fieldsMetadata).forEach(key => {
      const fieldDecoratorParameter = Reflect.get(this.fieldsMetadata, key) as DataFieldDecoratorParameter;
      this.fieldMapping.set(key, fieldDecoratorParameter);
    })
  }

  public getTableDecoratorParameter(): DataTableDecoratorParameter {
    return this.tableMetadata;
  }

  public getFieldsMetadata(): Object {
    return this.fieldsMetadata;
  }

  /**
   * 取得对象属性的字段装饰器
   * @param attributeName 对象属性名称
   * @returns 字段装饰器
   */
  public getFieldDecoratorParameter(attributeName: string): DataFieldDecoratorParameter | undefined {
    return this.fieldMapping.get(attributeName);
  }

  /**
   * 取得对象的ValuesBucket列表
   * 用于新增与更新
   * @returns 对象的ValuesBucket列表
   */
  public getEntityValuesBucketList(): Array<relationalStore.ValuesBucket> {
    const valueBuckets: Array<relationalStore.ValuesBucket> = [];
    this.entityList.forEach(entity => {
      const valueBucket: relationalStore.ValuesBucket = {};
      Object.keys(entity).forEach(key => {
        if (this.fieldMapping.has(key)) {
          const fieldName = this.fieldMapping.get(key)!.name;
          const fieldValue =  Reflect.get(entity, key) as ValueType;
          valueBucket[fieldName] = fieldValue;
        }
      });
      valueBuckets.push(valueBucket);
    });
    return valueBuckets;
  }

  public getTableFields(): Array<DataTableField> {
    const items = new Array<DataTableField>();
    Object.keys(this.fieldsMetadata).forEach(key => {
      const fieldDecoratorParameter = Reflect.get(this.fieldsMetadata, key) as DataFieldDecoratorParameter;
      const fieldName = fieldDecoratorParameter.name;
      const item:DataTableField = {attributeName: key, fieldName: fieldName, value: null };
      items.push(item);
    })
    return items;
  }

  /**
   * 取得所有字段
   * 用于新增与更新
   * @returns 对象的ValuesBucket列表
   */
  public getFields(): Array<string> {
    const items = new Array<string>();
    Object.keys(this.fieldsMetadata).forEach(key => {
      const fieldDecoratorParameter = Reflect.get(this.fieldsMetadata, key) as DataFieldDecoratorParameter;
      const fieldName = fieldDecoratorParameter.name;
      items.push(fieldName);
    })
    return items;
  }


}