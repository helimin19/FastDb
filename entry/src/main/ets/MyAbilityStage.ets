import { AbilityStage } from "@kit.AbilityKit";
import { fastDb } from "fast";
import { DbConfig } from "./config/DbConfig";

export class MyAbilityStage extends AbilityStage {

  onCreate(): void {
    fastDb.DataBaseConfigManager.initConfig(new DbConfig());
  }

}