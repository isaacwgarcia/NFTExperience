import Head from "next/head";
import Image from "next/image";
import { useEffect } from "react";
import styles from "../styles/Home.module.css";
import { coinbaseWallet, hooks } from "../components/connectors/coinbaseWallet";
import { useRouter } from "next/router";
import Navbar from "../components/Navbar";
import Form from "../components/Form";
const { useIsActive } = hooks;

export default function Home() {
  //const [message, setMessage]= useState ("")
  const router = useRouter();
  const isActive = useIsActive();
  useEffect(() => {
    void coinbaseWallet.connectEagerly();
  }, []);

  return (
    <div className={styles.container}>
      <Head>
        <title>Mint an Experience</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Navbar />
      <main className={styles.main}>
        <div className={styles.section}>
          <h3 className={styles.centered}>
            Mint an <a>NFTExperience!</a>
          </h3>
          <h1 className={styles.title}>Mint an Experience!</h1>
          <p>Fill out the short form below to mint an NFT Experience.</p>
        </div>
        <div>
          <Form />
        </div>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{" "}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  );
}
