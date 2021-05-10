import { Contract, ContractFactory } from "@ethersproject/contracts";
import {ethers} from "hardhat";

async function main() {
    const contractAddr = "0x216b2407936c4A17F8cba937272DE1A8Ba2F2ADe";

    const GreeterFac:ContractFactory = await ethers.getContractFactory("Greeter");
    const greeter:Contract = await GreeterFac.attach(contractAddr);

    console.log(await greeter.greet());
}


main()
    .then(()=>process.exit(0))
    .catch((error:Error) => {
        console.error(error);
        process.exit(1);
    })