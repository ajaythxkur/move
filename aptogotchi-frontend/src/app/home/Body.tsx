"use client"

import { useWallet } from "@aptos-labs/wallet-adapter-react"
import { NotConnected } from "./NotConnected";
import { Connected } from "./Connected";
export function Body(){
    const { connected } = useWallet();
    if(connected) return <Connected />;
    return <NotConnected />;
}