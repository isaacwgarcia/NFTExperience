import { ethers, providers } from "ethers";
import Web3Modal from "web3modal";
import { BigNumber } from "ethers";
import { create as ipfsHttpClient } from "ipfs-http-client";
//import NFTExp from "../config/NFTExp.json"; //JSON of the contract to interact with the frontend
const NFTEXPERIENCE_CONTRACT = ""; //CONTRACT DEPLOYED ON -
const RECIPIENT_ADDRESS = ""; //GRAB FROM WALLET COMPONENT -

const IPFS_CLIENT = ipfsHttpClient({
  host: "ipfs.infura.io",
  port: 5001,
  protocol: "https",
});

export async function uploadMetadata(item) {
  try {
    const added = await IPFS_CLIENT.add(Buffer.from(JSON.stringify(item)), {
      progress: (prog) => console.log(`received: ${prog}`),
    });
    const url = `https://ipfs.infura.io/ipfs/${added.path}`;
    console.log("URL> ", url);
    return url;
  } catch (error) {
    console.log("Error uploading file: ", error);
    return error;
  }
}
export async function initData() {
  try {
    const web3Modal = new Web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const account = provider.listAccounts();
    const signer = provider.getSigner(); //Verifies signer
    console.log("Accounts ", account);
    console.log(provider, signer);
    const uploadedMetadata = await uploadMetadata("JSON FILE"); //Upload Metadata to IPFS

    /*    let contract = new ethers.Contract(NFTEXPERIENCE_CONTRACT, NFTExp.abi, signer);
    let transaction = await contract.mint(RECIPIENT_ADDRESS, uploadedMetadata);
    let tx = await transaction.wait();
    let event = tx.events[0];
    console.log("mint ((((((())))))) EVENT", event);
    let value = event.args[2];
    console.log("mint ((((((())))))) VALUE", value);
    let mintedId = value.toNumber();
    console.log("mintedId", mintedId); */
  } catch (e) {
    console.log("e ", e);
    //return false;
  }
}

export async function handleMint(item) {
  console.log(">>>>>>>>>>>>> HANDLEMINT <<<<<<<<<<<");
  console.log("item", item);
  const uploadedMetadata = await uploadMetadata(item); //Upload Metadata to IPFS
  const web3Modal = new Web3Modal();
  const connection = await web3Modal.connect(); //Will open MetaMask
  console.log("Connection", connection);
  const provider = new ethers.providers.Web3Provider(connection);
  const accounts = await provider.listAccounts();
  console.log("Accounts >>", accounts);
  const signer = provider.getSigner(); //Verifies signer
  //NOW HERE I HAVE THE METADATA, AND THE RECIPIENT TO CALL SMART CONTRACT
  /* console.log("MetaData URI for the NFT", uploadedMetadata); //URI TO MINT
  console.log("Origin Address", RECIPIENT_ADDRESS);
  console.log("SIGNER> ", signer);
  let contract = new ethers.Contract(NFTEXPERIENCE_CONTRACT, NFTExp.abi, signer);
  let transaction = await contract.mint(RECIPIENT_ADDRESS, uploadedMetadata);
  let tx = await transaction.wait();
  let event = tx.events[0];
  console.log("mint ((((((())))))) EVENT", event);
  let value = event.args[2];
  console.log("mint ((((((())))))) VALUE", value);
  let mintedId = value.toNumber();
  console.log("mint ((((((())))))) mintedID", mintedId); */
}
