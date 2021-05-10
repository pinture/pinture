import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

async function getContract(){
    const address: string = "0x6C386595140AaC0E8325df1adFfC826ffE39f8E6";
    const PhotoToken: ContractFactory = await ethers.getContractFactory("PhotoToken");
    const photoToken: Contract = await PhotoToken.attach(address);

    return photoToken;
}

async function getSigners() {
    const [addr0, addr1, addr2] = await ethers.getSigners();
    // console.log(addr0.address, addr1.address, addr2.address );
    return { "addr0": addr0, "addr1": addr1, "addr2": addr2 }
}

export{
    getContract,
    getSigners
}