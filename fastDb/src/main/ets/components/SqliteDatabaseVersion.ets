
/**
 * 数据库版本配置
 */
export interface SqliteDataBaseVersionConfig {
  // 数据库名称
  dbName: string;
  // 所属版本
  version: number;
  // 执行顺序
  order: number;
  // 执行脚本
  script: string;
}

/**
 * 数据库版本管理
 */
export class SqliteDataBaseVersionManager {
  // 存储各版本需要执行的脚本
  private static scriptMap: Map<string, Array<SqliteDataBaseVersionConfig>> = new Map<string, Array<SqliteDataBaseVersionConfig>>();

  /**
   * 添加需要执行的脚本
   * @param config 数据库版本配置
   */
  public static add(config: SqliteDataBaseVersionConfig) {
    config.dbName = config.dbName + ".db";
    let items = SqliteDataBaseVersionManager.scriptMap.get(config.dbName);
    if (!items) {
      items = new Array<SqliteDataBaseVersionConfig>();
    }
    items.push(config);
    SqliteDataBaseVersionManager.scriptMap.set(config.dbName, items);
  }

  /**
   * 取得需要执行的脚本
   * @param databaseName 数据库名称(带.db)
   * @param version 当前数据库的版本
   * @returns 需要执行的脚本
   */
  public static get(databaseName: string, version: number): Array<string> {
    let items = SqliteDataBaseVersionManager.scriptMap.get(databaseName);
    if (!items || items.length === 0) {
      return new Array<string>();
    }

    return items.filter((config: SqliteDataBaseVersionConfig) => {
      return config.version > version;
    }).sort((config1: SqliteDataBaseVersionConfig, config2: SqliteDataBaseVersionConfig) => {
      return config1.order - config2.order;
    }).map<string>((config: SqliteDataBaseVersionConfig, _index: number, _array: SqliteDataBaseVersionConfig[]) => {
      return config.script;
    });
  }

  /**
   * 取得最大版本
   * @returns 最大版本
   */
  public static getMaxVersion(databaseName: string): number {
    let items = SqliteDataBaseVersionManager.scriptMap.get(databaseName);
    if (!items || items.length === 0) {
      return 0;
    }

    return items.map<number>((config: SqliteDataBaseVersionConfig, _index: number, _array: SqliteDataBaseVersionConfig[]) => {
      return config.version;
    }).sort((a: number, b: number) => {
      return a - b;
    }).pop()!;
  }

  /**
   * 清空需要执行的脚本
   */
  public static clear(databaseName: string) {
    let items = SqliteDataBaseVersionManager.scriptMap.get(databaseName);
    if (items) {
      items.length = 0;
      SqliteDataBaseVersionManager.scriptMap.set(databaseName, items);
    }
  }

  /**
   * 运行数据库脚本处理程序
   */
  public static init(handler: Function) {
    handler();
  }

}
