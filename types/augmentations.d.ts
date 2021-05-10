// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { Signers } from "./";
import { Greeter } from "../typechain/Greeter";
import { PhotoToken } from "../typechain/PhotoToken";
import { UsageRightToken } from "../typechain/UsageRightToken";

declare module "mocha" {
  export interface Context {
    greeter: Greeter;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
    photoToken: PhotoToken;
    usageRightToken: UsageRightToken;
  }
}
