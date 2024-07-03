"use client"

import { useState } from "react";
import { DEFAULT_PET } from "./Pet";
import { ShufflePetImage } from "./Pet/ShufflePetImage";

export function NotConnected() {
    const [petParts, setPetParts] = useState(DEFAULT_PET.parts)
    const text = `Welcome to Aptogotchi! Once you connect your wallet, you'll be able to mint your new on-chain pet. Once minted, you'll be able to feed, play with, and customize your new best friend!`;
    return (
        <div className="flex flex-col gap-6 p-6">
            <ShufflePetImage petParts={petParts} setPetParts={setPetParts} />
            <div className="nes-container is-dark with-title text-sm sm:text-base">
                <p className="title">Welcome</p>
                <p>{text}</p>
            </div>
        </div>
    )
}