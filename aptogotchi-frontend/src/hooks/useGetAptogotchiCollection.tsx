import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useCallback, useState } from "react";
import { getAptosClient } from "@/utils/aptosClient";
import { ABI } from "@/utils/abi";
import { padAddressIfNeeded } from "@/utils/address";
import { queryAptogotchiCollection } from "@/graphql/queryAptogotchiCollection";
const aptosClient = getAptosClient();
type Collection = {
    collection_id: string;
    collection_name: string;
    creator_address: string;
    uri: string;
    current_supply: any
}
type CollectionHolder = {
    owner_address: string;
};
type CollectionResponse = {
    current_collections_v2: Collection[],
    current_collection_ownership_v2_view: CollectionHolder[]
}
export function useGetAptogotchiCollection() {
    const { account } = useWallet();
    const [collection, setCollection] = useState<Collection>()
    const [firstFewAptogotchiName, setFirstFewAptogotchiName] = useState<string[]>()
    const [loading, setLoading] = useState(false)
    const fetchCollection = useCallback(async () => {
        if (!account?.address) return;
        try {
            setLoading(true);
            const aptogotchiCollectionAddressResponse = (await aptosClient.view({
                payload: {
                    function: `${ABI.address}::main::get_aptogotchi_collection_address`
                }
            })) as [`0x${string}`];
            const collectionAddress = padAddressIfNeeded(
                aptogotchiCollectionAddressResponse[0]
            );
            const collectionResponse: CollectionResponse = await aptosClient.queryIndexer({
                query:{
                    query: queryAptogotchiCollection,
                    variables: {
                        collection_id: collectionAddress
                    }
                }
            });
            const firstFewAptogotchi = await Promise.all(
                collectionResponse.current_collection_ownership_v2_view
                .filter((holder)=> holder.owner_address !== account.address)
                .slice(0, 3)
                .map((holder)=>
                    aptosClient.view({
                        payload:{
                            function: `${ABI.address}::main::get_aptogotchi`,
                            functionArguments: [holder.owner_address]
                        }
                    })
                )
            );
            setCollection(collectionResponse.current_collections_v2[0]);
            setFirstFewAptogotchiName(firstFewAptogotchi.map((x)=>x[0] as string));
        } catch (error) {
            console.error("Error fetching Aptogotchi collection:", error);

        } finally {
            setLoading(false)
        }


    }, [account?.address])
    return { collection, firstFewAptogotchiName, loading, fetchCollection };
}