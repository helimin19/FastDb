import { Database, fastDb, SelectRecordBySql, SelectBySql,
  CalculateBySql, Insert, Update, Delete, Select,
  SelectRecord} from "fast";
import { relationalStore } from "@kit.ArkData";

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