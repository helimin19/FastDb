import { relationalStore } from "@kit.ArkData";


export abstract class SqliteDataBaseConfig {

  /**
   * 取得数据库的最大版本，即最新版本
   * @param databaseName 数据库名称
   * @param version 当前数据库的版本
   * @returns 将要设置的数据库版本，0表示不设置数据库版本
   */
  public abstract getMaxVersion(databaseName: string, version : number): number;

  /**
   * 取得初使化数据库的sql脚本数组
   * @param databaseName 数据库名称
   * @param version 当前数据库的版本
   * @returns 初使化数据库的sql脚本数组
   */
  public abstract getInitSqlTexts(databaseName: string, version : number): Array<string>;

  /**
   * 取得数据库的配置，如:全安性，是否加密等
   * @param databaseName 数据库名称
   * @returns 数据库的配置
   */
  public abstract getStoreConfig(databaseName: string): relationalStore.StoreConfig;

}

/**
 * 数据库配置管理
 */
export class SqliteDataBaseConfigManager {

  private static config?: SqliteDataBaseConfig;

  /**
   * 初使化数据库配置档
   * @param config 数据库配置
   */
  public static initConfig(config: SqliteDataBaseConfig) {
    SqliteDataBaseConfigManager.config = config;
  }

  public static getConfig() {
    return SqliteDataBaseConfigManager.config;
  }

}
