import { TableDecorator,FieldDecorator, SqlDecorator  } from 'fast';

@TableDecorator({name: "T_Subject"})
@SqlDecorator(1, "CREATE TABLE IF NOT EXISTS T_Subject (ID INTEGER PRIMARY KEY AUTOINCREMENT, STUDENT_ID INTEGER NOT NULL, NAME TEXT NOT NULL, SCORE INTEGER)")
@SqlDecorator(2, "CREATE TABLE IF NOT EXISTS T_Subject1 (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)")
@SqlDecorator(3, "CREATE TABLE IF NOT EXISTS T_Subject2 (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)")
export class Subject {
  @FieldDecorator({name: "ID"})
  id?: number;
  @FieldDecorator({name: "STUDENT_ID"}) studentId?: number;
  @FieldDecorator({name: "NAME"}) name?: string;
  @FieldDecorator({name: "SCORE"}) score?: number;
}
