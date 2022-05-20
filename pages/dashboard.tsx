import React from "react";
import { hooks } from "../components/connectors/coinbaseWallet";
import { useRouter } from "next/router";
const { useIsActive } = hooks;

export default function Dashboard() {
  const router = useRouter();
  const isActive = useIsActive();

  React.useEffect(() => {
    if (!isActive) router.push("/");
  }, []);

  return <div>DashBoard</div>;
}

Dashboard.layout = true;
