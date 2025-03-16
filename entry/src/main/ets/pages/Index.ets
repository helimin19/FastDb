import { common } from '@kit.AbilityKit';
import { fastDb } from 'fast';
import { Student } from '../entity/Student';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { relationalStore } from '@kit.ArkData';

@Entry
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;

  private db = new fastDb.Database(this.context, "student2");

  aboutToAppear(): void {

  }

  build() {
    Column() {
      Button('新增')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.insert();
        })

      Button('更新')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.update();
        })

      Button('删除')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.delete();
        })

      Button('按对象查询TableRecord')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.selectTableRecord();
        })

      Button('按对象查询对象列表')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.selectEntity();
        })

      Button('按SQL查询TableRecord')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.selectBysqlTableRecord();
        })

      Button('按SQL查询对象列表')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.selectBysqlEntity();
        })

      Button('取得最大ID')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          this.getMaxId();
        })

      Button('学生管理')
        .width("100%")
        .margin({top: 16})
        .onClick(() => {
          router.pushUrl({ url: "pages/SearchStudent"})
        })

    }
    .height('100%')
    .width('100%')
  }

  private insert() {
    const studentList:Array<Student> = new Array();
    for(let i = 0; i < 100; i++) {
      const student: Student = new Student();
      student.name = "李太白";
      student.age = Math.floor(Math.random() * 120) + 1;
      studentList.push(student);
    }

    // this.db.insertAsync(studentList).then((num) => {
    //   promptAction.showToast({message: `新增成功:${num}`});
    // }).catch((err: BusinessError) => {
    //   promptAction.showToast({message: `新增失败:${err.message}`});
    // })

    const fastdb = new fastDb.Database(this.context, "student2");

    fastdb.insert(studentList, (err, num) => {
      if (err) {
        promptAction.showToast({message: `新增失败:${err.message}`});
        return;
      }
      promptAction.showToast({message: `新增成功:${num}`});
    });
  }

  private update() {
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
  }

  private delete() {
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
  }

  private selectTableRecord() {
    let where: fastDb.Where = new fastDb.Where(new Student());
    where.greaterThan("id", 0);
    this.db.selectRecord(where, (err: BusinessError | null | undefined, list?: Array<fastDb.TableRecord>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }
      list?.forEach(record => {
        let employee = new Object();
        record.forEach(field => {
          Reflect.set(employee, field.attributeName!, field.value);
        })
        console.log("helimin", JSON.stringify(employee));
      });
    });
  }

  private selectEntity() {
    let where: fastDb.Where = new fastDb.Where(new Student());
    where.greaterThan("id", 0);

    this.db.select(where, () => new Student(), (err: BusinessError | null | undefined, list?: Array<Student>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }

      list?.forEach(employee => {
        console.log("helimin", JSON.stringify(employee));
      });
    });

  }

  private selectBysqlTableRecord() {
    let sql = "select id, name FROM T_Student where id > ?";
    this.db.selectRecordBySql(sql, [50], (err: BusinessError | null | undefined, list?: Array<fastDb.TableRecord>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }

      list?.forEach(record => {
        console.log("helimin", JSON.stringify(record));
      });
    });
  }

  private selectBysqlEntity() {
    let sql = "select id, name FROM T_Student where id > ?";
    this.db.selectBySql(sql, [50], () => new Student(), (err: BusinessError | null | undefined, list?: Array<Student>) => {
      if (err) {
        promptAction.showToast({message: `查询失败:${err.message}`});
        return;
      }

      list?.forEach(employee => {
        console.log("helimin", JSON.stringify(employee));
      });
    });
  }

  private getMaxId() {
    let sql = "select max(id) FROM T_Student where id > ?";
    this.db.calculateBySql(sql, [50], (err: BusinessError | null | undefined, result?: relationalStore.ValueType) => {
      if (err) {
        promptAction.showToast({message: `失败:${err.message}`});
        return;
      }

      promptAction.showToast({message: `最大ID:${result}`});
    });
  }


}