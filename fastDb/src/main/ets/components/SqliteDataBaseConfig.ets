import { relationalStore } from "@kit.ArkData";


export abstract class SqliteDataBaseConfig {

  public abstract getMaxVersion(databaseName: string): number;

  public abstract getInitSqlTexts(databaseName: string, version : number): Array<string>;

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
