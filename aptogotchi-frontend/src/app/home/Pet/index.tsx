import { usePet } from "@/context/PetContext";
import { PetImage } from "./PetImage";
import { PetDetails } from "./Details";
import { Summary } from "./Summary";
import { Dispatch, SetStateAction, useState } from "react";
import { Actions, PetAction } from "./Actions";
import { AptogotchiCollection } from "@/components/AptogotchiCollection";
import { Food } from "../Food";

export interface Pet{
    name: string;
    birthday: number;
    energy_points: number;
    parts: PetParts;
}
export interface PetParts {
    body: number;
    ear: number;
    face: number;
}
export const DEFAULT_PET = {
    name: "unknown",
    energy_points: 0,
    parts: {
        body: 0,
        ear: 0,
        face: 0
    }
}
interface AptogotchiProps{
  food: Food;
  setFood: Dispatch<SetStateAction<Food | undefined>>;
}
export function Pet({ food, setFood }: AptogotchiProps){
    const { pet, setPet } = usePet();
    const [selectedAction, setSelectedAction] = useState<PetAction>("play")
    return (
        <div className="flex flex-col self-center m-2 sm:m-10">
        <div className="flex flex-col sm:flex-row self-center gap-4 sm:gap-12">
          <div className="flex flex-col gap-2 sm:gap-4 sm:w-[360px] m-auto">
            <PetImage
              selectedAction={selectedAction}
              petParts={pet?.parts}
              avatarStyle
            />
            <PetDetails food={food} setFood={setFood}/>
          </div>
          <div className="flex flex-col gap-2 sm:gap-8 sm:w-[680px] h-full">
            <Actions
              selectedAction={selectedAction}
              setSelectedAction={setSelectedAction}
              setFood={setFood}
            />
            <Summary />
          </div>
        </div>
        <AptogotchiCollection />
      </div>
    )
}