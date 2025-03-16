import { fastDb } from "./Entry";
import { DataTableRecord } from "./SqliteDatabaseEnfity";
import { QueryWhere } from "./SqliteDatabaseQuery";
import { relationalStore } from "@kit.ArkData";

/**
 * 装饰器属性 - 新增
 * @param classObject 类结构对象
 * @param _methodName 方法名称
 * @param descriptor 方法描述对象
 */
export function Insert(target: Object, _methodName: string, descriptor: PropertyDescriptor) {
  // 获取原来的方法
  const originalMethod = descriptor.value as Function;

  // 重写原来的方法
  descriptor.value = (...args: Object[]) => {
    let databaseName: string = Reflect.get(target, "__database__name");
    if (!databaseName) {
      const fn = Reflect.get(target, "getDatableName") as Function;
      databaseName = fn();
    }
    const db = new fastDb.Database(args[0] as Context, databaseName);
    const result = db.insertAsync(args[1]);
    const promise = result as Object;
    args.push(promise);
    const res = originalMethod(...args) as Promise<number>;
    return res;
  };
}

/**
 * 装饰器属性 - 更新
 * @param classObject 类结构对象
 * @param _methodName 方法名称
 * @param descriptor 方法描述对象
 */
export function Update(target: Object, _methodName: string, descriptor: PropertyDescriptor) {
  // 获取原来的方法
  const originalMethod = descriptor.value as Function;

  // 重写原来的方法
  descriptor.value = (...args: Object[]) => {
    const databaseName: string = Reflect.get(target, "__database__name");

    const db = new fastDb.Database(args[0] as Context, databaseName);
    const result = db.updateAsync(args[1] as QueryWhere);
    const promise =  result as Object;
    args.push(promise);
    const res = originalMethod(...args) as Promise<number>;
    return res;
  };
}

/**
 * 装饰器属性 - 删除
 * @param classObject 类结构对象
 * @param _methodName 方法名称
 * @param descriptor 方法描述对象
 */
export function Delete(target: Object, _methodName: string, descriptor: PropertyDescriptor) {
  // 获取原来的方法
  const originalMethod = descriptor.value as Function;

  // 重写原来的方法
  descriptor.value = (...args: Object[]) => {
    const databaseName: string = Reflect.get(target, "__database__name");

    const db = new fastDb.Database(args[0] as Context, databaseName);
    const result = db.deleteAsync(args[1] as QueryWhere);
    const promise =  result as Object;
    args.push(promise);
    const res = originalMethod(...args) as Promise<number>;
    return res;
  };
}

/**
 * 装饰器属性 - 查询记录
 * @param classObject 类结构对象
 * @param _methodName 方法名称
 * @param descriptor 方法描述对象
 */
export function SelectRecord(target: Object, _methodName: string, descriptor: PropertyDescriptor) {
  // 获取原来的方法
  const originalMethod = descriptor.value as Function;

  // 重写原来的方法
  descriptor.value = (...args: Object[]) => {
    const databaseName: string = Reflect.get(target, "__database__name");

    const db = new fastDb.Database(args[0] as Context, databaseName);
    const result = db.selectRecordAsync(args[1] as QueryWhere);
    const promise =  result as Object;
    args.push(promise);
    const res = originalMethod(...args) as Promise<Array<DataTableRecord>>;
    return res;
  };
}

/**
 * 装饰器方法 - 查询对象
 * @param creator 对象创建函数
 */
export function Select(creator: () => Object) {
  return (target: Object, _methodName: string, descriptor: PropertyDescriptor) => {
    // 获取原来的方法
    const originalMethod = descriptor.value as Function;

    // 重写原来的方法
    descriptor.value = (...args: Object[]) => {
      const databaseName: string = Reflect.get(target, "__database__name");

      const db = new fastDb.Database(args[0] as Context, databaseName);
      const result = db.selectAsync(args[1] as QueryWhere, creator);
      const promise =  result as Object;
      args.push(promise);
      const res = originalMethod(...args) as Promise<Object[]>;
      return res;
    };
  };
}

/**
 * 装饰器方法 - 按Sql查询记录
 */
export function SelectRecordBySql(sql: string) {
  return (target: Object, _methodName: string, descriptor: PropertyDescriptor) => {
    // 获取原来的方法
    const originalMethod = descriptor.value as Function;

    // 重写原来的方法
    descriptor.value = (...args: Object[]) => {
      const databaseName: string = Reflect.get(target, "__database__name");

      const db = new fastDb.Database(args[0] as Context, databaseName);
      const result = db.selectRecordBySqlAsync(sql, args[1] as Array<relationalStore.ValueType>);
      const promise =  result as Object;
      args.push(promise);
      const res = originalMethod(...args) as Promise<Array<DataTableRecord>>;
      return res;
    };
  };
}

/**
 * 装饰器方法 - 按Sql查询对象
 * @param creator 对象创建函数
 */
export function SelectBySql(sql: string) {
  return (target: Object, _methodName: string, descriptor: PropertyDescriptor) => {
    // 获取原来的方法
    const originalMethod = descriptor.value as Function;

    // 重写原来的方法
    descriptor.value = (...args: Object[]) => {
      const databaseName: string = Reflect.get(target, "__database__name");

      const db = new fastDb.Database(args[0] as Context, databaseName);
      const result = db.selectBySqlAsync(sql, args[1] as Array<relationalStore.ValueType>, args[2] as () => Object);
      const promise =  result as Object;
      args.push(promise);
      const res = originalMethod(...args) as Promise<Object[]>;
      return res;
    };
  };
}

/**
 * 装饰器方法 - 按Sql进行查询
 */
export function CalculateBySql(sql: string) {
  return (target: Object, _methodName: string, descriptor: PropertyDescriptor) => {
    // 获取原来的方法
    const originalMethod = descriptor.value as Function;

    // 重写原来的方法
    descriptor.value = (...args: Object[]) => {
      const databaseName: string = Reflect.get(target, "__database__name");

      const db = new fastDb.Database(args[0] as Context, databaseName);
      const result = db.calculateBySqlAsync(sql, args[1] as Array<relationalStore.ValueType>);
      const promise =  result as Object;
      args.push(promise);
      const res = originalMethod(...args) as Promise<relationalStore.ValueType>;
      return res;
    };
  };
}
