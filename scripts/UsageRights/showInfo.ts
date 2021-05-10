// const {ethers, upgrades} = require("hardhat");
import * as util from './util';

/**
 * ! DONE
 * balanceOf()
    onwerOf()
 */

async function showInfo() {

    const photoToken = await util.getContract();

    console.log(photoToken.address);
    const name = await photoToken.name();
    const symbol = await photoToken.symbol();
    console.log("name:", name);
    console.log("symbol:", symbol);

    const addrs = await util.getSigners();

    const addr = addrs.addr1.address.slice(2);
    const balance = await photoToken.balanceOf(addr); 
    console.log("balance:", balance);

    const ownerOf = await photoToken.ownerOf(1); 
    console.log("ownerOf: ", ownerOf);

    const tokenURI = await photoToken.tokenURI(1);
    console.log("tokenURI:", tokenURI);
}

showInfo()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });