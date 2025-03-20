
/**
 * 常量
 */
export class SqliteDatabaseConstant {
  /**
   * 表的元数据
   */
  private static METADATA_TABLE = "__table__metadata__";
  /**
   * 字段的元数据
   */
  private static METADATA_FIELDS = "__fields__metadata__";

  public static getMetadataTable(className: string): string {
    return `${SqliteDatabaseConstant.METADATA_TABLE}${className}`;
  }

  public static getMetadataFields(className: string): string {
    return `${SqliteDatabaseConstant.METADATA_FIELDS}${className}`;
  }

}