// import { deployContract } from "ethereum-waffle";
import hre from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { Artifact } from "hardhat/types";
import { PhotoToken } from "../typechain/PhotoToken";
import { Signers } from "../types";
import { BigNumber } from "ethers";
import { expect } from "chai";
import { UsageRightToken } from "../typechain";

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
            const photoTokenArtifact:Artifact = await hre.artifacts.readArtifact("PhotoToken");
            this.photoToken = <PhotoToken>await deployContract(this.signers.admin, photoTokenArtifact);

        }); 
    
        it("Mint 1 photo token to photographer", async function () {
            const imageHash = "QmNYwRFaQTYzN1FxvTkjMVPHiTvAw53EmziLjLDa921u23"
            const photographer:string = await this.signers.photographer.getAddress();
            await this.photoToken.connect(this.signers.admin).safeMint(photographer,1,imageHash);
            const balanceOf:BigNumber = await this.photoToken.connect(this.signers.admin)["balanceOf(address)"](photographer);
            const uri:string = await this.photoToken.connect(this.signers.admin)["tokenURI(uint256)"](1);

            expect(balanceOf).to.equal(BigNumber.from("0x1"));
            expect(uri).to.equal(`ipfs://${imageHash}`);
        });

        it("deploy usage token", async function () {
            const usageRightTokenArtifact: Artifact = await hre.artifacts.readArtifact("UsageRightToken");
            this.usageRightToken = <UsageRightToken>await deployContract(this.signers.admin, usageRightTokenArtifact, [this.photoToken.address]);
        }); 

        it("check if the photo token address is matching the address in usage token", async function () {
            expect(await this.usageRightToken.connect(this.signers.admin).getPhotoTokenAddress()).to.equal(this.photoToken.address)
        })
    
        it("Mint 1 usage token of photo token to photographer", async function () {
            const imageHash = "QmPXX1FFHHVYMexKAXLauDSA13XTFGnxe7wT6xsqWRcLy5";
            const photographer:string = await this.signers.photographer.getAddress();
            const mintRes = await this.usageRightToken.connect(this.signers.admin).safeMint(photographer,1,1,1619678773,1619678973,100,imageHash);
            const balanceOf:BigNumber = await this.usageRightToken.connect(this.signers.admin)["balanceOf(address)"](photographer);
            const uri:string = await this.usageRightToken.connect(this.signers.admin)["tokenURI(uint256)"](1);

            expect(balanceOf).to.equal(BigNumber.from("0x1"));
            expect(uri).to.equal(`ipfs://${imageHash}`);
        });
    })

})

