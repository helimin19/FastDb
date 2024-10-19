import { DataFieldDecoratorParameter, DataTableDecoratorParameter } from './Decorator';
import { SqliteDatabase } from './SqliteDatabase';
import { DataTableField, DataTableRecord } from './SqliteDatabaseEnfity';
import { SqliteDataBaseError } from './SqliteDatabaseError'
import { DeleteEntity, QueryWhere, UpdateEntity } from './SqliteDatabaseQuery';
import { SqliteDataBaseVersionConfig, SqliteDataBaseVersionManager } from './SqliteDatabaseVersion';

export namespace fastDb {
    export class DataBaseError extends SqliteDataBaseError {}
    export class Database extends SqliteDatabase {}
    export interface TableField extends DataTableField {}
    export interface TableRecord extends DataTableRecord {}
    export class Where extends QueryWhere {}
    export class UpdateWhere extends UpdateEntity {}
    export class DeleteWhere extends DeleteEntity {}
    export interface DataBaseVersionConfig extends SqliteDataBaseVersionConfig {}
    export class DataBaseVersionManager extends SqliteDataBaseVersionManager{}

    export interface TableDecoratorParameter extends DataTableDecoratorParameter{}
    export interface FieldDecoratorParameter extends DataFieldDecoratorParameter {}


}