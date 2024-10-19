
/**
 * 数据库版本配置
 */
export interface SqliteDataBaseVersionConfig {
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
  private static scriptList: Array<SqliteDataBaseVersionConfig> = new Array();

  /**
   * 添加需要执行的脚本
   * @param config 数据库版本配置
   */
  public static add(config: SqliteDataBaseVersionConfig) {
    SqliteDataBaseVersionManager.scriptList.push(config);
  }

  /**
   * 取得需要执行的脚本
   * @param version 当前数据库的版本
   * @returns 需要执行的脚本
   */
  public static get(version: number): Array<string> {
    return SqliteDataBaseVersionManager.scriptList.filter((config: SqliteDataBaseVersionConfig) => {
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
  public static getMaxVersion(): number {
    return SqliteDataBaseVersionManager.scriptList.map<number>((config: SqliteDataBaseVersionConfig, _index: number, _array: SqliteDataBaseVersionConfig[]) => {
      return config.version;
    }).sort((a: number, b: number) => {
      return a - b;
    }).pop()!;
  }

  /**
   * 清空需要执行的脚本
   */
  public static clear() {
    SqliteDataBaseVersionManager.scriptList.length = 0;
  }

  /**
   * 运行数据库脚本处理程序
   */
  public static init(handler: Function) {
    handler();
  }

}
