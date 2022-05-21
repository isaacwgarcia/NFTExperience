import React from "react";
import { Box } from "@mui/material";
import { coinbaseWallet, hooks } from "../components/connectors/coinbaseWallet";
import { useRouter } from "next/router";
import { style } from "@mui/system";
import styles from "../styles/Home.module.css";
import Link from 'next/link';


const {
  useChainId,
  useAccounts,
  useError,
  useIsActivating,
  useIsActive,
  useProvider,
  useENSNames,
} = hooks;

const Navbar = () => {
  const router = useRouter();
  const isActive = useIsActive();
  const chainId = useChainId();
  const accounts = useAccounts();
  const error = useError();
  const isActivating = useIsActivating();

  const provider = useProvider();
  const ENSNames = useENSNames(provider);

  return (
    <>
      <Box
        sx={{
          position: "fixed",
          width: "100%",
          top: 0,
          left: 0,
          color: "white",
          background: "black",
          zIndex: "10",
          fontSize: "1.1rem",
          padding: "1rem",
          heigth: "30vh",
          display: "flex",
          justifyContent: "flex-end",
        }}
      >
        <Link href="/"><a className={styles.navlink}>Home</a></Link>
        <Link href="/mint"><a className={styles.navlink}>Mint</a></Link>
        <Link href="https://staging-global.transak.com/?apiKey=7963f84c-9937-4980-8afe-cc9826ae2182&amp;cryptoCurrencyCode=MATIC&amp;network=polygon"><a className={styles.navlink}>Add Matic</a></Link> 

        {isActive ? (
          <button
            onClick={() => {
              router.push("/");
              void coinbaseWallet.deactivate();
            }}
          >
            Logout
          </button>
        ) : (
          <button
            onClick={() => {
              void coinbaseWallet.activate();
            }}
          >
            Connect Wallet
          </button>
        )}
      </Box>
    </>
  );
};
export default Navbar;
