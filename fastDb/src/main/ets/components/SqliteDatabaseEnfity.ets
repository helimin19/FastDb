import { relationalStore } from '@kit.ArkData'

/**
 * 表字段
 */
export interface DataTableField {
  // 实体属性名称
  attributeName?: string;
  // 表字段名称
  fieldName: string;
  // 值
  value: relationalStore.ValueType;
}

/**
 * 表记录
 */
export interface DataTableRecord extends Array<DataTableField> {

}
