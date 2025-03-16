import { Student } from '../entity/Student';
import { StudentService } from '../service/StudentService';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { fastDb } from 'fast';
import { StudentScore } from '../entity/StudentScore';

@Entry
@Component
struct SearchStudent {

  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Button("新增")
        .width("100%")
        .onClick(() => {
          this.add();
        })

      Button("批量新增")
        .width("100%")
        .onClick(() => {
          this.batchAdd();
        })

      Button("更新")
        .width("100%")
        .onClick(() => {
          this.update();
        })

      Button("删除")
        .width("100%")
        .onClick(() => {
          this.delete();
        })

      Button("查询对象列表")
        .width("100%")
        .onClick(() => {
          this.select();
        })

      Button("查询记录列表")
        .width("100%")
        .onClick(() => {
          this.selectRecord();
        })

      Button("按SQL查询记录列表")
        .width("100%")
        .onClick(() => {
          this.selectRecordBySql();
        })

      Button("按SQL查询对象列表")
        .width("100%")
        .onClick(() => {
          this.selectBySql();
        })

      Button("取得最大ID")
        .width("100%")
        .onClick(() => {
          this.getMaxId();
        })

      Button("多表查询")
        .width("100%")
        .onClick(() => {
          this.multiSelect();
        })

    }
    .height('100%')
    .width('100%')
  }

  add() {
    const service = new StudentService<Student>();
    const entity = new Student();
    entity.id = 1;
    entity.name = "李太白";
    entity.age = 2000;
    service.insert(this.context, entity).then((result: number) => {
      promptAction.showToast({message: `insert result: ${result}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  batchAdd() {
    const service = new StudentService<Student>();
    const entitys = new Array<Student>();
    for(let i = 0; i < 5000; i++) {
      const entity = new Student();
      entity.id = i;
      entity.name = `李太白${i}`;
      entity.age = 2000 + i;

      entitys.push(entity);
    }
    service.batchInsert(this.context, entitys).then((result: number) => {
      promptAction.showToast({message: `insert result: ${result}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public update() {
    const service = new StudentService<Student>();

    const student: Student = new Student();
    student.age = 100;
    const where: fastDb.Where = new fastDb.Where(student);
    where.greaterThanOrEqualTo("id", 20);
    where.and();
    where.lessThan("id", 50);
    service.update(this.context, where).then((result: number) => {
      promptAction.showToast({message: `update result: ${result}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public delete() {
    const service = new StudentService<Student>();
    const where: fastDb.Where = new fastDb.Where(new Student());
    where.lessThan("id", 1000);
    where.or();
    where.greaterThan("id", 2000);
    service.delete(this.context, where).then((result: number) => {
      promptAction.showToast({message: `delete result: ${result}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public select() {
    const service = new StudentService<Student>();
    let where: fastDb.Where = new fastDb.Where(new Student());
    where.lessThan("id",10);
    service.select(this.context, where).then((result: Array<Student>) => {
      promptAction.showToast({message: `query result: ${JSON.stringify(result)}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })

  }

  public selectRecord() {
    const service = new StudentService<Student>();
    let where: fastDb.Where = new fastDb.Where(new Student());
    where.lessThan("id",20);
    service.selectRecord(this.context, where).then((result: Array<fastDb.TableRecord>) => {
      promptAction.showToast({message: `query result: ${JSON.stringify(result)}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public selectRecordBySql() {
    const service = new StudentService<Student>();
    service.selectRecordBySql(this.context, [50]).then((result: Array<fastDb.TableRecord>) => {
      promptAction.showToast({message: `query result: ${JSON.stringify(result)}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public selectBySql() {
    const service = new StudentService<Student>();
    service.selectBySql(this.context, [50], () => new Student()).then((result: Array<Student>) => {
      promptAction.showToast({message: `query result: ${JSON.stringify(result)}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  public getMaxId() {
    const service = new StudentService<Student>();
    service.getMaxId(this.context, [50]).then((result: number) => {
      promptAction.showToast({message: `query result: ${result}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

  private multiSelect() {
    const service = new StudentService<Student>();
    service.multiSelect(this.context, [1], () => new StudentScore()).then((result: Array<StudentScore>) => {
      promptAction.showToast({message: `query result: ${JSON.stringify(result)}`})
    }).catch((error: Error) => {
      promptAction.showToast({message: `${JSON.stringify(error)}`})
    })
  }

}