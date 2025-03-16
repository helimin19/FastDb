import { FieldDecorator, SqlDecorator, TableDecorator } from "fast";

/**
 * 成绩表
 */
@TableDecorator({name: "T_Score"})
export class Score {

  @FieldDecorator({ name: "ID" })
  id?: number;

  // 学生ID
  @FieldDecorator({ name: "STUDENT_ID" })
  studentId?: number;

  // 课程ID
  @FieldDecorator({ name: "COURSE_ID" })
  courseId?: number;

  // 分数
  @FieldDecorator({ name: "GRADE" })
  grade?: number;

}