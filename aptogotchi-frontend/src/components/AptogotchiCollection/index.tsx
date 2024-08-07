import { useGetAptogotchiCollection } from "@/hooks/useGetAptogotchiCollection"
import { useWallet } from "@aptos-labs/wallet-adapter-react"
import { useEffect } from "react";

export function AptogotchiCollection() {
    const { account, network } = useWallet()
    const { collection, firstFewAptogotchiName, loading, fetchCollection } = useGetAptogotchiCollection();
    useEffect(()=>{
        if(!account?.address || !network) return;
        fetchCollection()
    },[account?.address, fetchCollection, network])
    if(loading || !collection) return null;
    return (
        <div className="nes-container with-title sm:h-[100px]">
            <p>{`There are a total of ${collection.current_supply} Aptogotchis in existence.`}</p>
            <p>{`Meet your fellow Aptogotchis: ${firstFewAptogotchiName?.join(", ")}${(firstFewAptogotchiName?.length || 0) < collection.current_supply
                    ? "..."
                    : ""
                }`}</p>
        </div>
    )
}