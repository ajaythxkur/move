"use client"
import { getAptosClient } from "@/utils/aptosClient";
import { useWallet } from "@aptos-labs/wallet-adapter-react"
import { useCallback, useEffect, useState } from "react";
import { ABI } from "@/utils/abi";
import { Mint } from "./Mint";
import { Modal } from "@/components/Modal";
import { usePet } from "@/context/PetContext";
import { Pet } from "./Pet";
import { Food } from "./Food";
const TESTNET_ID = "2";
const aptosClient = getAptosClient();
export function Connected() {
    const { account, network } = useWallet();
    const {pet, setPet} = usePet()
    const [food, setFood] = useState<Food>()
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

    const fetchFood = useCallback(async()=>{
        if(!account?.address) return;
        const response = await aptosClient.view({
            payload:{
                function: `${ABI.address}::food::get_food_balance`,
                functionArguments: [account.address]
            }
        });
        const noFood = ["", "0", "0", "0x"];
        if(JSON.stringify(response) !== JSON.stringify(noFood)){
            setFood({
                number: parseInt(response[0] as unknown as string)
            })
        }
    }, [account?.address])
    useEffect(() => {
        if (!account?.address || !network) return;
        fetchPet()
        fetchFood()
    }, [account?.address, fetchPet, fetchFood, network])
    
    return (
        <div className="flex flex-col gap-3 p-3">
            {network?.chainId !== TESTNET_ID && <Modal />}
            {pet && food ? <Pet food={food} setFood={setFood}/> : <Mint fetchPet={fetchPet}/>}
        </div>
    )
}