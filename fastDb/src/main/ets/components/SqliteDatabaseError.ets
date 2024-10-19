
/**
 * 数据库异常类
 */
export class SqliteDataBaseError extends Error {

  public static NO_DATA:SqliteDataBaseError = new SqliteDataBaseError(10001, "没有数据");

  public code: number;
  public message: string;

  constructor(code: number, message: string) {
    super();
    this.code = code;
    this.message = message;
  }

}