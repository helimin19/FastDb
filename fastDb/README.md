# FastDb

## 1. 简介与推荐
[FastDb](https://github.com/helimin19/FastDb)
是一个适用于快速操作数据库的库，能够按对象进行新增，修改，删除，查询等

## 2. 下载安装

`ohpm i @hlm/fastdb`

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)


## 3. 实体类的创建
```
@TableDecorator({name: "T_Student"})
export class Student {
  @FieldDecorator({name: "ID"})
  id?: number;
  @FieldDecorator({name: "NAME"}) name?: string;
  @FieldDecorator({name: "AGE"}) age?: number;
}
```
### 使用说明
1. @TableDecorator: 表装饰器, 参数: name: 数据库表名称
2. @FieldDecorator: 字段装饰器， 参数: name: 数据库字段名称

## 2. 数据库版本管理
### + 使用类装饰器来管理数据库脚本
```
@TableDecorator({name: "T_Student"})
@SqlDecorator(1, "CREATE TABLE IF NOT EXISTS T_Student (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)")
@SqlDecorator(2, "INSERT INTO T_Student(NAME, AGE) VALUES('李太白', 99)") 
export class Student {
  @FieldDecorator({name: "ID"})
  id?: number;
  @FieldDecorator({name: "NAME"}) name?: string;
  @FieldDecorator({name: "AGE"}) age?: number;
}
```
#### 使用说明
1. @SqlDecorator: sql装饰器 
- 参数说明
+ version: number: 数据库的版本, 同一个app项目版本可以一致，也可以不一致，必须要大于现有数据库的版本，第一次使用是为1
+ sql: string: 要执行的sql语句
+ order?: number: 同一数据库版本内，sql语句执行的顺序，默认为1
### 当存在多个表时，需要在使用DB之前进行所有表的初使化
```
fastDb.DataBaseVersionManager.init(() => {
  new Student();
  new Subject();
});
```
这样才能执行实体类上的装饰器
### + 自定义管理
```
fastDb.DataBaseVersionManager.add({
  version: 1,
  order: 1,
  script: "CREATE TABLE IF NOT EXISTS T_Student (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)"
});
```

## 4. 取得数据库
```
private db = new fastDb.Database(this.context, "数据库名称不带.db");
```
## 5. 新增、修改、删除、查询、计算
### 1. 新增
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
### 2. 修改
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
### 3. 删除
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
### 4. 按对象查询
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
### 5. 按SQL查询
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
### 5. 执行SQL取得单个值
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