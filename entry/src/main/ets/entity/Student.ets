import { TableDecorator,FieldDecorator, SqlDecorator  } from 'fast';

@TableDecorator({name: "T_Student"})
@SqlDecorator(1, "CREATE TABLE IF NOT EXISTS T_Student (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER)")
export class Student {
  @FieldDecorator({name: "ID"})
  id?: number;
  @FieldDecorator({name: "NAME"}) name?: string;
  @FieldDecorator({name: "AGE"}) age?: number;
}

