// import { deployContract } from "ethereum-waffle";
import hre from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { Artifact } from "hardhat/types";
import { PictureToken } from "../typechain/PictureToken";
import { Signers } from "../types";
import { BigNumber } from "ethers";
import { expect } from "chai";
import { LicenseToken } from "../typechain/LicenseToken";

const { deployContract } = hre.waffle;

describe("Deploy contract and mint a token",function () {
    beforeEach(async function () {
        this.signers = {} as Signers;
    
        const signers: SignerWithAddress[] = await hre.ethers.getSigners();
        this.signers.admin = signers[0];
        this.signers.photographer = signers[1];
        this.signers.user = signers[2];
      });

    describe("Workflow unit test", function () {
    
        it("deploy photo token", async function () {
            const pictureTokenArtifact:Artifact = await hre.artifacts.readArtifact("PictureToken");
            this.pictureToken = <PictureToken>await deployContract(this.signers.admin, pictureTokenArtifact);

        }); 
    
        it("Mint 1 photo token to photographer", async function () {
            const imageHash = "QmNYwRFaQTYzN1FxvTkjMVPHiTvAw53EmziLjLDa921u23"
            const photographer:string = await this.signers.photographer.getAddress();
            await this.pictureToken.connect(this.signers.admin).safeMint(photographer,1,imageHash);
            const balanceOf:BigNumber = await this.pictureToken.connect(this.signers.admin)["balanceOf(address)"](photographer);
            const uri:string = await this.pictureToken.connect(this.signers.admin)["tokenURI(uint256)"](1);

            expect(balanceOf).to.equal(BigNumber.from("0x1"));
            expect(uri).to.equal(`ipfs://${imageHash}`);
        });

        it("deploy license token", async function () {
            const licenseTokenArtifact: Artifact = await hre.artifacts.readArtifact("LicenseToken");
            this.licenseToken = <LicenseToken>await deployContract(this.signers.admin, licenseTokenArtifact, [this.pictureToken.address]);
        }); 

        it("check if the photo token address is matching the address in usage token", async function () {
            expect(await this.licenseToken.connect(this.signers.admin).getPictureTokenAddress()).to.equal(this.pictureToken.address)
        })
    
        it("Mint 1 usage token of photo token to photographer", async function () {
            const imageHash = "QmPXX1FFHHVYMexKAXLauDSA13XTFGnxe7wT6xsqWRcLy5";
            const photographer:string = await this.signers.photographer.getAddress();
            const mintRes = await this.licenseToken.connect(this.signers.admin).safeMint(photographer,1,100,1619678773,1619678973,100,imageHash);
            const balanceOf:BigNumber = await this.licenseToken.connect(this.signers.admin)["balanceOf(address)"](photographer);
            const uri:string = await this.licenseToken.connect(this.signers.admin)["tokenURI(uint256)"](100);

            expect(balanceOf).to.equal(BigNumber.from("0x1"));
            expect(uri).to.equal(`ipfs://${imageHash}`);
        });

        it("get all license token from account", async function () {
            const photographer:string = await this.signers.photographer.getAddress();
            const tokenOfOwnerByIndex: BigNumber = await this.licenseToken.connect(this.signers.admin).tokenOfOwnerByIndex(photographer, 0);
            const totalSup: BigNumber = await this.licenseToken.connect(this.signers.admin).totalSupply();
            const tokenByIx: BigNumber = await this.licenseToken.connect(this.signers.admin).tokenByIndex(0);

            expect(tokenOfOwnerByIndex).to.equal(BigNumber.from(100));
            expect(totalSup).to.equal(BigNumber.from(1));
            expect(tokenByIx).to.equal(BigNumber.from(100));
        })
    })

})

