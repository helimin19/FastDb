import { fastDb } from "fast";
import { relationalStore } from "@kit.ArkData";

/**
 * 数据库配置
 */
export class DbConfig extends fastDb.DataBaseConfig {

  public getMaxVersion(databaseName: string, version : number): number {
    if (databaseName === "student2.db") {
      return 1;
    }
    return 0;
  }

  public getInitSqlTexts(databaseName: string, version: number): string[] {
    const sqlTexts = new Array<string>();
    if (databaseName === "student2.db") {
      if (version === 0) {
        sqlTexts.push("CREATE TABLE IF NOT EXISTS T_Student (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)");
        sqlTexts.push("CREATE TABLE IF NOT EXISTS T_Course (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL)");
        sqlTexts.push("CREATE TABLE IF NOT EXISTS T_Score (ID INTEGER PRIMARY KEY AUTOINCREMENT, STUDENT_ID INTEGER NOT NULL, COURSE_ID INTEGER NOT NULL, GRADE INTEGER NOT NULL)");
        sqlTexts.push("INSERT INTO T_Student(ID, NAME, AGE) VALUES(1, '李太白', 109)");
        sqlTexts.push("INSERT INTO T_Course(ID, NAME) VALUES(1, '语文')");
        sqlTexts.push("INSERT INTO T_Course(ID, NAME) VALUES(2, '数学')");
        sqlTexts.push("INSERT INTO T_Course(ID, NAME) VALUES(3,'英文')");
        sqlTexts.push("INSERT INTO T_Score(STUDENT_ID, COURSE_ID, GRADE) VALUES(1, 1, 98)");
        sqlTexts.push("INSERT INTO T_Score(STUDENT_ID, COURSE_ID, GRADE) VALUES(1, 2, 99)");
        sqlTexts.push("INSERT INTO T_Score(STUDENT_ID, COURSE_ID, GRADE) VALUES(1, 3, 100)");
      }
    }
    return sqlTexts;
  }

  public getStoreConfig(databaseName: string): relationalStore.StoreConfig {
    return {
      name: databaseName,
      securityLevel: relationalStore.SecurityLevel.S3,
      encrypt: false,
      isReadOnly: false
    };
  }

}