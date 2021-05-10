import * as util from "./util";
import * as ethers from "ethers";

async function mine(): Promise<void> {
    const photo:ethers.Contract = await util.getContract();
    const result = await photo.safeMint("0x3710Be5a27675cf79EF415f8967454C618729a98",3 );

    console.log(result);
}

mine()
    .then(()=>process.exit(0))
    .catch((error:Error)=>{
        console.error(error);
        process.exit(1);
    })