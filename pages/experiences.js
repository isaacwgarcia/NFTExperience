import React from "react";
import Image from "next/image";
import Button from "@mui/material/Button";
import Box from "@mui/material/Card";
import styles from "../styles/Home.module.css";
import LoadingButton from "@mui/material/Button";
import Navbar from "../components/Navbar";
import { useEffect, useState } from "react";
import { coinbaseWallet, hooks } from "../components/connectors/coinbaseWallet";

export default function Experiences({
  city = "Miami",
  duration = "3 months",
  price = "$250",
  photo,
  artist,
  title,
  ...rest
}) {
  const [isloading, setIsloading] = useState(null);
  useEffect(() => {}, []);

  return !isloading ? (
    <div>
      <Box
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          flexDirection: "column",
          marginTop: 5,
        }}
      >
        <h1>Discover, collect, and sell extraordinary NFTs</h1>
        <b>Tourista is the Miami&apos;s first tourist NFT marketplace</b>
        <Button
          size="large"
          style={{ marginTop: 10 }}
          variant="outlined"
          href="#text-buttons"
        >
          Explore
        </Button>
      </Box>

      <Box
        sx={{
          display: "flex",
          alignItems: "center",
          flexDirection: "row",
          paddingLeft: 15,
        }}
      >
        <Navbar />
        <div sm={10}>
          <h1> Unforgettable activities{<br />} hosted by locals</h1>
        </div>
        <div
          className={styles.section}
          onClick={() => {
            void coinbaseWallet.activate();
          }}
        >
          <h2 className={styles.centered}>Key Biscanye Bay NFT</h2>
          <div className={styles.grid}>
            <a href="#" className={styles.card}>
              <div>
                <Image
                  className={styles.image}
                  src="/Images/person1.jpeg"
                  alt="Picture of the author"
                  width={230}
                  height={300}
                  layout="responsive"
                />
              </div>
              <h2 style={{ marginRight: 50 }}>Kayak Through Biscayne Bay</h2>
              <p>
                Miami knights can get&apos; randomly generated and stylistically
                curated NFTs that exist on the Ethereum Blockchain. Miami Knight
                holders can participate in exclusive.
              </p>
              <div>
                {" "}
                <Button
                  style={{ marginTop: 10 }}
                  variant="contained"
                  href="#text-buttons"
                >
                  Buy
                </Button>
              </div>
            </a>
          </div>
        </div>
      </Box>
    </div>
  ) : (
    <>
      <LoadingButton loading loadingIndicator="Loading..." variant="outlined">
        Loading
      </LoadingButton>
    </>
  );
}
