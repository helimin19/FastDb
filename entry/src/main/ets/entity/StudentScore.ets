import { FieldDecorator } from "fast";
import { Student } from "./Student";

export class StudentScore extends Student {

  @FieldDecorator({name: "CourseName"})
  courseName?: string;

  @FieldDecorator({name: "GRADE"})
  grade?: number

}