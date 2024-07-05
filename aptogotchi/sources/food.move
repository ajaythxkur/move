module aptogotchi_addr::food{
    use aptos_framework::object::{Self,ExtendRef};
    use aptos_framework::primary_fungible_store;
    use aptos_framework::fungible_asset::{Self,MintRef,BurnRef};
    use std::string::Self;
    use std::option;
    use std::signer::address_of;

    const APP_OBJECT_SEED: vector<u8> = b"APTOGOTCHI FOOD";
    const FOOD_NAME: vector<u8> = b"Food";
    const FOOD_SYMBOL: vector<u8> = b"FOOD";
    const FOOD_URI: vector<u8> = b"https://otjbxblyfunmfblzdegw.supabase.co/storage/v1/object/public/aptogotchi/food.png";
    const PROJECT_URI: vector<u8> = b"https://github.com/ajaythxkur";

    struct ObjectController has key {
        app_extend_ref: ExtendRef
    }

    struct FoodController has key{
        fungible_asset_mint_ref: MintRef,
        fungible_asset_burn_ref: BurnRef,
    }

    fun init_module(account: &signer){
        let constructor_ref = object::create_named_object(account, APP_OBJECT_SEED);
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let app_signer = object::generate_signer(&constructor_ref);

        move_to(&app_signer, ObjectController{
            app_extend_ref: extend_ref
        });

        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &constructor_ref,
            option::none(),
            string::utf8(FOOD_NAME),
            string::utf8(FOOD_SYMBOL),
            0,
            string::utf8(FOOD_URI),
            string::utf8(PROJECT_URI),
        );
        
        let fungible_asset_mint_ref = fungible_asset::generate_mint_ref(&constructor_ref);
        let fungible_asset_burn_ref = fungible_asset::generate_burn_ref(&constructor_ref);

        move_to(&app_signer, FoodController{
            fungible_asset_mint_ref,
            fungible_asset_burn_ref
        });
    }   

    fun get_app_signer_addr(): address {
        object::create_object_address(&@aptogotchi_addr, APP_OBJECT_SEED)
    }

    public (friend) fun mint_food(user: &signer, amount: u64) acquires FoodController{
        let food_controller = borrow_global<FoodController>(get_app_signer_addr());
        let fungible_asset_mint_ref = &food_controller.fungible_asset_mint_ref;
        primary_fungible_store::deposit(
            address_of(user),
            fungible_asset::mint(fungible_asset_mint_ref, amount),
        );
    }

    public (friend) fun burn_food(user: &signer, amount: u64) acquires FoodController{
        let food_controller = borrow_global<FoodController>(get_app_signer_addr());
        primary_fungible_store::burn(&food_controller.fungible_asset_burn_ref, address_of(user), amount);
    }

    #[view]
    public fun get_food_balance(owner_addr: address): u64{
        let food_controller = object::address_to_object<FoodController>(get_app_signer_addr());
        primary_fungible_store::balance(owner_addr, food_controller)
    }
}