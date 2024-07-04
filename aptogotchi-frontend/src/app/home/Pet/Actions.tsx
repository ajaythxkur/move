"use client";

import { usePet } from "@/context/PetContext";
import { ABI } from "@/utils/abi";
import { NEXT_PUBLIC_ENERGY_CAP, NEXT_PUBLIC_ENERGY_DECREASE, NEXT_PUBLIC_ENERGY_INCREASE } from "@/utils/env";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useState } from "react";
import { toast } from "sonner";
import { getAptosClient } from "@/utils/aptosClient";
export type PetAction = "feed" | "play"
export interface ActionProps {
    selectedAction: PetAction,
    setSelectedAction: (action: PetAction) => void
}
const aptosClient = getAptosClient()
export function Actions({ selectedAction, setSelectedAction }: ActionProps) {
    const { pet, setPet } = usePet();
    const [transactionInProgress, setTransactionInProgress] = useState(false);
    const feedDisabled = selectedAction === "feed" && pet?.energy_points === Number(NEXT_PUBLIC_ENERGY_CAP);
    const playDisabled = selectedAction === "play" && pet?.energy_points === Number(0);
    const { account, network, signAndSubmitTransaction } = useWallet()
    const handleStart = () => {
        switch (selectedAction) {
            case "feed":
                handleFeed();
                break;
            case "play":
                handlePlay();
                break;
        }
    }
    const handleFeed = async () => {
        if (!account || !network) return;
        setTransactionInProgress(true)
        try {
            const response = await signAndSubmitTransaction({
                sender: account.address,
                data: {
                    function: `${ABI.address}::main::feed`,
                    typeArguments: [],
                    functionArguments: [NEXT_PUBLIC_ENERGY_INCREASE]
                }
            })
            await aptosClient.waitForTransaction({
                transactionHash: response.hash
            })
            setPet((pet) => {
                if (!pet) return pet;
                if (Number(pet.energy_points) + Number(NEXT_PUBLIC_ENERGY_INCREASE) > Number(NEXT_PUBLIC_ENERGY_CAP)) {
                    return pet
                }
                return {
                    ...pet,
                    energy_points: Number(pet.energy_points) + Number(NEXT_PUBLIC_ENERGY_INCREASE)
                }
            })
        } catch (error) {
            console.error(error)
            toast.error("Failed to feed your pet. Please try again.");
        } finally {
            setTransactionInProgress(false)
            toast.success(`Thanks for feeding your pet, ${pet?.name}!`);
        }
    }

    const handlePlay = async () => {
        if (!account || !network) return;
        setTransactionInProgress(true)
        try {
            const response = await signAndSubmitTransaction({
                sender: account.address,
                data: {
                    function: `${ABI.address}::main::play`,
                    typeArguments: [],
                    functionArguments: [NEXT_PUBLIC_ENERGY_DECREASE]
                }
            });
            await aptosClient.waitForTransaction({
                transactionHash: response.hash
            })
            setPet((pet) => {
                if (!pet) return pet;
                if (Number(pet.energy_points) < Number(NEXT_PUBLIC_ENERGY_DECREASE)) {
                    return pet
                }
                return {
                    ...pet,
                    energy_points: Number(pet.energy_points) - Number(NEXT_PUBLIC_ENERGY_DECREASE),
                }
            })
        } catch (error) {
            console.error(error)
            toast.error("Failed to play with your pet. Please try again.")
        } finally {
            setTransactionInProgress(false)
            toast.success(`Thanks for playing with your pet, ${pet?.name}!`);
        }
    }
    console.log(pet);
    

    return (
        <div className="nes-container with-title flex-1 bg-white h-[320px]">
            <p className="title">Actions</p>
            <div className="flex flex-col gap-2 justify-between h-full">
                <div className="flex flex-col flex-shrink-0 gap-2 border-b border-gray-300">
                    <label>
                        <input
                            type="radio"
                            className="nes-radio"
                            name="action"
                            checked={selectedAction === "play"}
                            onChange={() => setSelectedAction("play")}
                        />
                        <span>Play</span>
                    </label>
                    <label>
                        <input
                            type="radio"
                            className="nes-radio"
                            name="action"
                            checked={selectedAction === "feed"}
                            onChange={() => setSelectedAction("feed")}
                        />
                        <span>Feed</span>
                    </label>
                </div>
                <div className="flex flex-col gap-4 justify-between">
                    <p>{actionDescriptions[selectedAction]}</p>
                    <button
                        type="button"
                        className={`nes-btn is-success ${feedDisabled || playDisabled ? "is-disabled" : ""
                            }`}
                        onClick={handleStart}
                        disabled={transactionInProgress || feedDisabled || playDisabled}
                    >
                        {transactionInProgress ? "Processing..." : "Start"}
                    </button>
                </div>
            </div>
        </div>
    )
}

const actionDescriptions: Record<PetAction, string> = {
    feed: "Feeding your pet will boost its Energy Points...",
    play: "Playing with your pet will make it happy and consume its Energy Points..."
}