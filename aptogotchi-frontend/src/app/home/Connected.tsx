"use client"
import { getAptosClient } from "@/utils/aptosClient";
import { useWallet } from "@aptos-labs/wallet-adapter-react"
import { useCallback, useEffect, useState } from "react";
import { ABI } from "@/utils/abi";
import { Mint } from "./Mint";
import { Modal } from "@/components/Modal";
import { usePet } from "@/context/PetContext";
import { Pet } from "./Pet";
const DEVNET_ID = "142";
const aptosClient = getAptosClient();
export function Connected() {
    const { account, network } = useWallet();
    const {pet, setPet} = usePet()
    const fetchPet = useCallback(async() => {
        if (!account?.address) return;
        const hasPet = await aptosClient.view({
            payload: {
                function: `${ABI.address}::main::has_aptogotchi`,
                functionArguments: [account.address]
            }
        })

        if (hasPet) {
            let response;
            try {
                response = await aptosClient.view({
                    payload: {
                        function: `${ABI.address}::main::get_aptogotchi`,
                        functionArguments: [account.address]
                    }
                });
                
                const [name, birthday, energyPoints, parts] = response;
                const typedParts = parts as { body: number, ear: number, face: number };
                setPet({
                    name: name as string,
                    birthday: birthday as number,
                    energy_points: energyPoints as number,
                    parts: typedParts,
                  });
            } catch (error) {
                console.error(error);
            }
        }
    }, [account?.address])
    useEffect(() => {
        if (!account?.address || !network) return;
        fetchPet()
    }, [account?.address, fetchPet, network])
    return (
        <div className="flex flex-col gap-3 p-3">
            {network?.chainId !== DEVNET_ID && <Modal />}
            {pet ? <Pet /> : <Mint fetchPet={fetchPet}/>}
        </div>
    )
}