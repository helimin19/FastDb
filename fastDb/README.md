# FastDb

## 一. 简介与推荐
[FastDb](https://github.com/helimin19/FastDb)
是一个适用于快速操作数据库的库，能够按对象进行新增，修改，删除，查询等

## 二. 下载安装

`ohpm i @hlm/fastdb`

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)

## 三. 数据库配置
1. 在调用数据库之前需要先配置相应的数据库, 例如在AbilityStage的onCreate方法中
```
fastDb.DataBaseConfigManager.initConfig(new DbConfig());
```
2. 数据库配置类，可以按不同的数据库不同版本配置不同
```
export class DbConfig extends fastDb.DataBaseConfig {
  /**
   * 取得数据库的最大版本，即最新版本
   * @param databaseName 数据库名称
   * @param version 当前数据库的版本
   * @returns 将要设置的数据库版本，0表示不设置数据库版本
   */
  public getMaxVersion(databaseName: string, version : number): number {
    return 1;
  }

  /**
   * 取得初使化数据库的sql脚本数组
   * @param databaseName 数据库名称
   * @param version 当前数据库的版本
   * @returns 初使化数据库的sql脚本数组
   */
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
  
  /**
   * 取得数据库的配置，如:全安性，是否加密等
   * @param databaseName 数据库名称
   * @returns 数据库的配置
   */
  public getStoreConfig(databaseName: string): relationalStore.StoreConfig {
    return {
      name: databaseName,
      securityLevel: relationalStore.SecurityLevel.S1,
      encrypt: true,
      isReadOnly: false
    };
  }
}
```

## 四. 实体类与表的映射
```
@TableDecorator({name: "T_Student"})
export class Student {
  @FieldDecorator({name: "ID"})
  id?: number;
  @FieldDecorator({name: "NAME"}) 
  name?: string;
  @FieldDecorator({name: "AGE"}) 
  age?: number;
}
```
### 使用说明
1. @TableDecorator: 表装饰器, 参数: name: 数据库表名称
2. @FieldDecorator: 字段装饰器， 参数: name: 数据库字段名称

## 四. 使用装饰器操作数据库
### 1. 定义一个数据库操作类
```
@Database("student2")
export class StudentService<T> {
  @Insert
  insert(context: Context, entity: T, result?: Promise<number>): Promise<number> {
    return result!;
  }
  @Insert
  batchInsert(context: Context, entity: T[], result?: Promise<number>): Promise<number> {
    return result!;
  }
  @Update
  update(context: Context, entity: fastDb.Where, result?: Promise<number>): Promise<number> {
    return result!;
  }
  @Delete
  delete(context: Context, entity: fastDb.Where, result?: Promise<number>): Promise<number> {
    return result!;
  }
  @Select(() => new Object())
  select(context: Context, entity: fastDb.Where, result?: Promise<Array<T>>): Promise<Array<T>> {
    return result!;
  }
  @SelectRecord
  selectRecord(context: Context, entity: fastDb.Where, result?: Promise<Array<fastDb.TableRecord>>): Promise<Array<fastDb.TableRecord>> {
    return result!;
  }
  @SelectRecordBySql("select * FROM T_Student where id < ?")
  selectRecordBySql(context: Context, args: Array<relationalStore.ValueType>, result?: Promise<Array<fastDb.TableRecord>>): Promise<Array<fastDb.TableRecord>> {
    return result!;
  }
  @SelectBySql("select * FROM T_Student where id < ?")
  selectBySql<T extends object>(context: Context, args: Array<relationalStore.ValueType>, creator: () => T, result?: Promise<Array<T>>): Promise<Array<T>> {
    return result!;
  }
  @CalculateBySql("select max(id) FROM T_Student where id > ?")
  getMaxId(context: Context, args: Array<relationalStore.ValueType>, result?: Promise<number>): Promise<number> {
    return result!;
  }
  @SelectBySql("select a.ID, a.NAME, a.AGE,c.NAME as CourseName, b.GRADE FROM T_Student a INNER JOIN T_Score b ON a.ID=b.STUDENT_ID INNER JOIN T_Course c ON b.COURSE_ID=c.ID WHERE a.ID=?")
  multiSelect<StudentScore>(context: Context, args: Array<relationalStore.ValueType>, creator: () => StudentScore, result?: Promise<Array<StudentScore>>): Promise<Array<StudentScore>> {
    return result!;
  }
}
```
### 2. 装饰器说明
#### a. @Database: 类装饰器，参数为数据库名称不带.db
#### b. @Insert: 方法装饰器，对应方法的第一个参数为Context, 第二个参数为对象或对象数组，第三个参数是数据库的操作结果，类型为Promise<number>
#### c. @Update: 方法装饰器，对应方法的第一个参数为Context, 第二个参数为fastDb.Where，第三个参数是数据库的操作结果，类型为Promise<number>


## 四. 使用API操作数据库
### 取得数据库
```
private db = new fastDb.Database(this.context, "数据库名称不带.db");
```
### 新增、修改、删除、查询、计算
#### 1. 新增
```
    const student: Student = new Student();
    student.name = "李太白";
    student.age = Math.floor(Math.random() * 120) + 1;

    this.db.insert(student, (err, num) => {
      if (err) {
        promptAction.showToast({message: `新增失败:${err.message}`});
        return;
      }
      promptAction.showToast({message: `新增成功:${num}`});
    });
```
```
    const studentList:Array<Student> = new Array();
    for(let i = 0; i < 100; i++) {
      const student: Student = new Student();
      student.name = "李太白";
      student.age = Math.floor(Math.random() * 120) + 1;
      studentList.push(student);
    }

    this.db.insert(studentList, (err, num) => {
      if (err) {
        promptAction.showToast({message: `新增失败:${err.message}`});
        return;
      }
      promptAction.showToast({message: `新增成功:${num}`});
    });
```
#### 2. 修改
```
    const student: Student = new Student();
    student.age = 100;
    const entity: fastDb.UpdateWhere = new fastDb.UpdateWhere(student);
    entity.greaterThanOrEqualTo("id", 20);
    entity.and();
    entity.lessThan("id", 50);

    this.db.update(entity, (err, num) => {
      if (err) {
        promptAction.showToast({message: `更新失败:${err.message}`});
        return;
      }
      promptAction.showToast({message: `更新成功:${num}`});
    });
```
#### 3. 删除
```
    const entity: fastDb.DeleteWhere = new fastDb.DeleteWhere(new Student());
    entity.lessThan("id", 1000);
    entity.or();
    entity.greaterThan("id", 2000);
    this.db.delete(entity, (err, num) => {
      if (err) {
        promptAction.showToast({message: `删除失败:${err.message}`});
        return;
      }
      promptAction.showToast({message: `删除成功:${num}`});
    });
```
#### 4. 按对象查询
```
    let where: fastDb.Where = new fastDb.Where(new Student());
    where.greaterThan("id", 0);

    this.db.query(where, () => new Student(), (err: BusinessError | null | undefined, list?: Array<Student>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }

      list?.forEach(employee => {
        console.log("helimin", JSON.stringify(employee));
      });
    });
```
#### 5. 按SQL查询
```
    let sql = "select id, name FROM T_Student where id > ?";
    this.db.queryBySql(sql, [50], () => new Student(), (err: BusinessError | null | undefined, list?: Array<Student>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }

      list?.forEach(employee => {
        console.log("helimin", JSON.stringify(employee));
      });
    });
```
#### 5. 执行SQL取得单个值
```
    let sql = "select max(id) FROM T_Student where id > ?";
    this.db.calculateBySql(sql, [50], (err: BusinessError | null | undefined, result?: relationalStore.ValueType) => {
      if (err) {
        promptAction.showToast({message: `失败:${err.message}`});
        return;
      }

      promptAction.showToast({message: `最大ID:${result}`});
    });
```