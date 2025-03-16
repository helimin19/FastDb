import { relationalStore } from '@kit.ArkData';
import { DataTableDecoratorParameter } from './Decorator';

import { SqliteDatabaseConstant } from './SqliteDatabaseConstant';

import { SqliteDatabaseEntityParser } from './SqliteDatabaseEntityParser';

/**
 * 查询条件
 */
export class QueryWhere extends relationalStore.RdbPredicates {

  public entity: Object;
  private entityParser: SqliteDatabaseEntityParser;

  constructor(entity: Object) {
    super((Reflect.get(entity, SqliteDatabaseConstant.METADATA_TABLE) as DataTableDecoratorParameter).name);
    this.entity = entity;
    this.entityParser = new SqliteDatabaseEntityParser(this.entity);
  }

  inDevices(devices: Array<string>): QueryWhere {
    super.inDevices(devices);
    return this;
  }

  inAllDevices(): QueryWhere {
    super.inAllDevices();
    return this;
  }

  equalTo(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.equalTo(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  notEqualTo(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.notEqualTo(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  beginWrap(): QueryWhere {
    super.beginWrap();
    return this;
  }

  endWrap(): QueryWhere {
    super.endWrap();
    return this;
  }

  or(): QueryWhere {
    super.or();
    return this;
  }

  and(): QueryWhere {
    super.and();
    return this;
  }

  contains(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.contains(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  beginsWith(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.beginsWith(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  endsWith(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.endsWith(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  isNull(field: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.isNull(fieldDecoratorParameter.name);
    }
    return this;
  }

  isNotNull(field: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.isNotNull(fieldDecoratorParameter.name);
    }
    return this;
  }

  like(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.like(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  glob(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.glob(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  between(field: string, low: relationalStore.ValueType, high: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.between(fieldDecoratorParameter.name, low, high);
    }
    return this;
  }

  notBetween(field: string, low: relationalStore.ValueType, high: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.notBetween(fieldDecoratorParameter.name, low, high);
    }
    return this;
  }

  greaterThan(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.greaterThan(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  lessThan(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.lessThan(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  greaterThanOrEqualTo(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.greaterThanOrEqualTo(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  lessThanOrEqualTo(field: string, value: relationalStore.ValueType): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.lessThanOrEqualTo(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  orderByAsc(field: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.orderByAsc(fieldDecoratorParameter.name);
    }
    return this;
  }

  orderByDesc(field: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.orderByDesc(fieldDecoratorParameter.name);
    }
    return this;
  }

  distinct(): QueryWhere {
    super.distinct();
    return this;
  }

  limitAs(value: number): QueryWhere {
    super.limitAs(value);
    return this;
  }

  offsetAs(rowOffset: number): QueryWhere {
    super.offsetAs(rowOffset);
    return this;
  }

  groupBy(fields: Array<string>): QueryWhere {
    let items = new Array<string>();
    fields.forEach(field => {
      const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
      if (fieldDecoratorParameter) {
        items.push(fieldDecoratorParameter.name);
      }
    });
    super.groupBy(items);
    return this;
  }

  indexedBy(field: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.indexedBy(fieldDecoratorParameter.name);
    }
    return this;
  }

  in(field: string, value: Array<relationalStore.ValueType>): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.in(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  notIn(field: string, value: Array<relationalStore.ValueType>): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.notIn(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  notContains(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.notContains(fieldDecoratorParameter.name, value);
    }
    return this;
  }

  notLike(field: string, value: string): QueryWhere {
    const fieldDecoratorParameter = this.entityParser.getFieldDecoratorParameter(field);
    if (fieldDecoratorParameter) {
      super.notLike(fieldDecoratorParameter.name, value);
    }
    return this;
  }

}

/**
 * 更新对象
 */
export class UpdateEntity extends QueryWhere {

  constructor(entity: Object) {
    super(entity);
  }

}

/**
 * 删除对象
 */
export class DeleteEntity extends QueryWhere {

  constructor(entity: Object) {
    super(entity);
  }

}