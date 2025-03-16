import { TableDecorator,FieldDecorator, SqlDecorator  } from 'fast';

/**
 * 学生表
 */
@TableDecorator({name: "T_Student"})
export class Student {
  @FieldDecorator({name: "ID"})
  id?: number;

  @FieldDecorator({name: "NAME"})
  name?: string;

  @FieldDecorator({name: "AGE"})
  age?: number;

}

