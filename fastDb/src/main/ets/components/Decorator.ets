import { SqliteDatabaseConstant } from './SqliteDatabaseConstant';
import { SqliteDataBaseVersionManager } from './SqliteDatabaseVersion';

/**
 * Sql装饰器
 * @param args 表格装饰器参数
 * @returns 装饰器工厂
 */
export function SqlTextDecorator(version: number, sql: string, order?: number) {
  return <T extends Function>(_constructor: T) => {
    SqliteDataBaseVersionManager.add({ version: version, order: order ? order : 1, script: sql });
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
    constructor.prototype[SqliteDatabaseConstant.METADATA_TABLE] = args;
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
    if (Reflect.has(target.constructor.prototype, SqliteDatabaseConstant.METADATA_FIELDS)) {
      metadata = Reflect.get(target.constructor.prototype, SqliteDatabaseConstant.METADATA_FIELDS);
    }
    Reflect.set(metadata, propertyName, args);
    Reflect.set(target.constructor.prototype, SqliteDatabaseConstant.METADATA_FIELDS, metadata);
  }
}
