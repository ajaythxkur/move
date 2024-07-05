module aptogotchi_addr::nft_marketplace{
    use aptos_framework::object::{Self,Object,ObjectCore,ExtendRef,DeleteRef};
    use aptos_std::smart_vector::{Self,SmartVector};
    use std::signer::address_of;
    use std::error;
    use aptos_framework::coin;
    use aptos_framework::aptos_account;

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Listing has key{
        object: Object<ObjectCore>,
        seller: address,
        extend_ref: ExtendRef,
        delete_ref: DeleteRef
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct FixedPriceListing<phantom CoinType> has key{
        price: u64
    }

    struct MarketplaceSigner has key{
        extend_ref: ExtendRef
    }

    struct Sellers has key{
        addresses: SmartVector<address>
    }

    struct SellerListings has key{
        listings: SmartVector<address>
    }
    const ENO_LISTING: u64 = 1;
    const ENO_SELLER: u64 = 2;
    const APP_OBJECT_SEED: vector<u8> = b"MARKETPLACE";
    fun init_module(deployer: &signer){
        let constructor_ref = object::create_named_object(
            deployer,
            APP_OBJECT_SEED,
        );
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let marketplace_signer = object::generate_signer(&constructor_ref);

        move_to(&marketplace_signer, MarketplaceSigner{
            extend_ref,
        });
    }

    public fun get_marketplace_signer_addr(): address{
        object::create_object_address(&@aptogotchi_addr, APP_OBJECT_SEED)
    }

    public fun get_marketplace_signer(marketplace_signer_addr: address): signer acquires MarketplaceSigner{
        object::generate_signer_for_extending(&borrow_global<MarketplaceSigner>(marketplace_signer_addr).extend_ref)
    }
    public entry fun list_with_fixed_price<CoinType>(
        seller: &signer,
        object: Object<ObjectCore>,
        price: u64
    ) acquires SellerListings, Sellers, MarketplaceSigner{
        list_with_fixed_price_internal<CoinType>(seller, object, price);
    }
    public(friend) fun list_with_fixed_price_internal<CoinType>(
        seller: &signer,
        object: Object<ObjectCore>,
        price: u64
    ): Object<Listing> acquires SellerListings, Sellers, MarketplaceSigner{
        let constructor_ref = object::create_object(address_of(seller));
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);
        object::disable_ungated_transfer(&transfer_ref);
        let listing_signer = object::generate_signer(&constructor_ref);

        let listing = Listing{
            object,
            seller: address_of(seller),
            delete_ref: object::generate_delete_ref(&constructor_ref),
            extend_ref: object::generate_extend_ref(&constructor_ref),
        };

        let fixed_price_listing = FixedPriceListing<CoinType>{
            price
        };

        move_to(&listing_signer, listing);
        move_to(&listing_signer, fixed_price_listing);
        object::transfer(seller, object, address_of(&listing_signer));

        let listing = object::object_from_constructor_ref(&constructor_ref);

        if(exists<SellerListings>(address_of(seller))){
            let seller_listings = borrow_global_mut<SellerListings>(address_of(seller));
            smart_vector::push_back(&mut seller_listings.listings, object::object_address(&listing));
        }else{
            let seller_listings = SellerListings{
                listings: smart_vector::new()
            };
            smart_vector::push_back(&mut seller_listings.listings, object::object_address(&listing));
            move_to(seller, seller_listings)
        };

        if(exists<Sellers>(get_marketplace_signer_addr())){
            let sellers = borrow_global_mut<Sellers>(get_marketplace_signer_addr());
            if(!smart_vector::contains(&sellers.addresses, &address_of(seller))){
                smart_vector::push_back(&mut sellers.addresses, address_of(seller));
            }
        }else{
            let sellers = Sellers {
                addresses: smart_vector::new()
            };
            smart_vector::push_back(&mut sellers.addresses, address_of(seller));
            move_to(&get_marketplace_signer(get_marketplace_signer_addr()), sellers)
        };
        listing
    }

    public entry fun purchase<CoinType>(
        purchaser: &signer,
        object: Object<ObjectCore>
    ) acquires FixedPriceListing, Listing, SellerListings, Sellers{
        let listing_addr = object::object_address(&object);

        assert!(exists<Listing>(listing_addr), error::not_found(ENO_LISTING));
        assert!(exists<FixedPriceListing<CoinType>>(listing_addr), error::not_found(ENO_LISTING));

        let FixedPriceListing {
            price
        } = move_from<FixedPriceListing<CoinType>>(listing_addr);

        let coins = coin::withdraw<CoinType>(purchaser, price);
        let Listing {
            object,
            seller,
            extend_ref,
            delete_ref
        } = move_from<Listing>(listing_addr);

        let obj_signer = object::generate_signer_for_extending(&extend_ref);
        object::transfer(&obj_signer, object, address_of(purchaser));
        object::delete(delete_ref);

        let seller_listings = borrow_global_mut<SellerListings>(seller);
        let (exist, idx) = smart_vector::index_of(&seller_listings.listings, &listing_addr);
        assert!(exist, error::not_found(ENO_LISTING));
        smart_vector::remove(&mut seller_listings.listings, idx);

        if(smart_vector::length(&seller_listings.listings) == 0){
            let sellers = borrow_global_mut<Sellers>(get_marketplace_signer_addr());
            let (exist, idx) = smart_vector::index_of(&sellers.addresses, &seller);
            assert!(exist, error::not_found(ENO_SELLER));
            smart_vector::remove(&mut sellers.addresses, idx);
        };
        aptos_account::deposit_coins(seller, coins);
    } 
}
