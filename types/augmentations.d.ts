// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { Signers } from "./";
import { Greeter } from "../typechain/Greeter";
import { PictureToken } from "../typechain/PictureToken";
import { LicenseToken } from "../typechain/LicenseToken";
import { Pinture } from "../typechain/Pinture";

declare module "mocha" {
  export interface Context {
    greeter: Greeter;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
    pictureToken: PictureToken;
    licenseToken: LicenseToken;
    pinture: Pinture;
  }
}
