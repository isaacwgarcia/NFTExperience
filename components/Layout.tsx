import React from "react";
import Navbar from "../components/Navbar";
import { Box, Grid } from "@mui/material";
import { hooks } from "../components/connectors/coinbaseWallet";
import { Accounts } from "./Accounts";
const { useChainId, useAccounts, useIsActive, useProvider } = hooks;

import { CHAINS } from "./chains";

export default function Layout({ children }) {
  const accounts = useAccounts();
  const isActive = useIsActive();
  const chainId = useChainId();
  const provider = useProvider();

  return (
    <>
      <Navbar />
      <br />
      <br />
      <br />
      <br />
      <Grid container spacing={3} width="auto" height="100vh" padding="1vw">
        <Grid item xs={12} sm={12} md={3} lg={3} xl={3}>
          <Box
            border={1}
            borderRadius={3}
            justifyContent="space-around"
            width="90%"
          >
            <Box padding={2} overflow="true" fontSize="0.6rem">
              NFTExperience is in beta phase. <br />{" "}
            </Box>
          </Box>
          <Box border={1} borderRadius={3} mt={2} width="90%">
            <Box padding={2} overflow="true" fontSize="0.6rem">
              {accounts}
              <br />
              <Accounts accounts={accounts} provider={provider} />
              {}
              <br />
              {isActive ? "Connected to: " + CHAINS[chainId]!.name : ""}
            </Box>
          </Box>
          <Box mt={2} display="flex" justifyContent="center" width="90%"></Box>
        </Grid>

        <Grid item xs={12} sm={12} md={9} lg={9} xl={9}>
          {children}
        </Grid>
      </Grid>

      <Box
        padding={2}
        overflow="true"
        fontSize="0.6rem"
        display="flex"
        justifyContent="center"
        alignContent="center"
      >
        POWERED BY
      </Box>
    </>
  );
}
