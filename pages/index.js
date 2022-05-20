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
        <h1 className={styles.title}>
          Welcome to <a>NFTExperience!</a>
        </h1>
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
