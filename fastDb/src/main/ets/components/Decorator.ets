import { SqliteDatabaseConstant } from './SqliteDatabaseConstant';
import { SqliteDataBaseVersionManager } from './SqliteDatabaseVersion';

/**
 * Sql装饰器
 * @param args 表格装饰器参数
 * @returns 装饰器工厂
 */
export function SqlTextDecorator(dbName: string, version: number, sql: string, order?: number) {
  return <T extends Function>(_constructor: T) => {
    SqliteDataBaseVersionManager.add({ dbName: dbName, version: version, order: order ? order : 1, script: sql });
  }
}

/**
 * 数据库装饰器方法
 * @param datableName 数据库名称
 * @returns 装饰器方法
 */
export function Database(datableName: string) {

  return <T extends Function>(constructor: T) => {
    const target: Object = constructor.prototype;
    Reflect.set(target, "__database__name", datableName);
  }

}

/**
 * 表格装饰器参数
 */
export interface DataTableDecoratorParameter {
  name: string
}

/**
 * 表格装饰器
 * @param args 表格装饰器参数
 * @returns 装饰器工厂
 */
export function DataTableDecorator(args: DataTableDecoratorParameter) {
  return <T extends Function>(constructor: T) => {
    constructor.prototype[SqliteDatabaseConstant.getMetadataTable(constructor.name)] = args;
  }
}

/**
 * 字段装饰器参数
 */
export interface DataFieldDecoratorParameter {
  name: string
}

/**
 * 字段装饰器
 * @param args 字段装饰器参数
 * @returns 字段装饰器工厂
 */
export function DataFieldDecorator(args: DataFieldDecoratorParameter) {
    return (target: Object, propertyName: string) => {
    let metadata = new Object();
    const metadataFields = SqliteDatabaseConstant.getMetadataFields(target.constructor.name);
    if (Reflect.has(target.constructor.prototype, metadataFields)) {
      metadata = Reflect.get(target.constructor.prototype, metadataFields);
    }
    Reflect.set(metadata, propertyName, args);
    Reflect.set(target.constructor.prototype, metadataFields, metadata);
  }
}
