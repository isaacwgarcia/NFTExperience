import Head from "next/head";
import Image from "next/image";
import { useEffect } from "react";
import styles from "../styles/Home.module.css";
import { coinbaseWallet, hooks } from "../components/connectors/coinbaseWallet";
import { useRouter } from "next/router";
import Navbar from "../components/Navbar";
const { useIsActive } = hooks;

export default function Home() {
  const router = useRouter();
  const isActive = useIsActive();
  useEffect(() => {
    void coinbaseWallet.connectEagerly();
  }, []);
  if (isActive) router.push("/dashboard");
  return (
    <div className={styles.container}>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Navbar />
      <main className={styles.main}>
        <div className={styles.section}>
          <h3 className={styles.centered}>
            Welcome to <a>NFTExperience!</a>
          </h3>
          <h1 className={styles.title}>
          Using dynamic NFTs to enhance experiences around the world.
          </h1>
        </div>
        <div className={styles.section}>
          <h2 className={styles.centered}>Featured Experiences</h2>
          <div className={styles.grid}>
          <a href="#" className={styles.card}>
            <h4>Miami</h4>
            <h2>Kayak Through Biscayne Bay</h2>
            <p>Learn about Miami's brand new city center in the financial district. After a bit of retail therapy we're going to swing over the world famous art district called Wynwood.</p>
            <p className={styles.buyLink}>Book this experience →</p>
          </a>

          <a href="#" className={styles.card}>
            <h4>Miami</h4>
            <h2>Brickell City Center &amp; Wynwood</h2>
            <p>Learn about Miami's brand new city center in the financial district. After a bit of retail therapy we're going to swing over the world famous art district called Wynwood.</p>
            <p className={styles.buyLink}>Book this experience →</p>
          </a>

          <a href="#" className={styles.card}>
            <h4>Miami</h4>
            <h2>Historic Calle Ocho</h2>
            <p>Learn about Miami's brand new city center in the financial district. After a bit of retail therapy we're going to swing over the world famous art district called Wynwood.</p>
            <p className={styles.buyLink}>Book this experience →</p>
          </a>

          <a href="#" className={styles.card}>
            <h4>Miami</h4>
            <h2>Coconut Grove Tour</h2>
            <p>Learn about Miami's brand new city center in the financial district. After a bit of retail therapy we're going to swing over the world famous art district called Wynwood.</p>
            <p className={styles.buyLink}>Book this experience →</p>
          </a>
        </div>
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
