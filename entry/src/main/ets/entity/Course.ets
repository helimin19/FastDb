import { FieldDecorator, SqlDecorator, TableDecorator } from "fast";

/**
 * 课程表
 */
@TableDecorator({name: "T_Course"})
export class Course {

  @FieldDecorator({ name: "ID" })
  id?: number;

  // 课程名称
  @FieldDecorator({ name: "NAME" })
  name?: string;

}