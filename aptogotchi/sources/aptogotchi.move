module aptogotchi_addr::main{
    use aptos_framework::object;
    use std::string::{Self,String};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;
    use std::option;
    use std::error;
    use aptos_std::string_utils::{to_string};
    use aptos_framework::timestamp;
    use aptos_framework::event;
    use std::signer::{Self,address_of};

    struct AptoGotchi has key{
        name: String,
        birthday: u64,
        energy_points: u64,
        parts: AptogotchiParts,
        mutator_ref: token::MutatorRef,
        burn_ref: token::BurnRef,
    }

    struct AptogotchiParts has copy, drop, key, store {
        body: u8,
        ear: u8,
        face: u8
    }

    struct ObjectController has key{
        app_extend_ref: object::ExtendRef
    }

    #[event]
    struct MintAptogotchiEvent has drop, store{
        token_name: String,
        aptogotchi_name: String,
        parts: AptogotchiParts
    }

    const APP_OBJECT_SEED: vector<u8> = b"gotchi";
    const APTOGOTCHI_COLLECTION_DESCRIPTION: vector<u8> = b"Aptogotchi Gaming NFTs";
    const APTOGOTCHI_COLLECTION_NAME: vector<u8> = b"Aptogotchi";
    const APTOGOTCHI_COLLECTION_URI: vector<u8> = b"https://learn.aptoslabs.com/";

    const NAME_UPPER_BOUND: u64 = 40;
    const ENERGY_UPPER_BOUND: u64 = 10;
    const BODY_MAX_VALUE: u8 = 4;
    const EAR_MAX_VALUE: u8 = 6;
    const FACE_MAX_VALUE: u8 = 3;

    /// aptogotchi not available
    const ENOT_AVAILABLE: u64 = 1;
    /// name length exceeded limit
    const ENAME_LIMIT: u64 = 2;
    /// user already has aptogotchi
    const EUSER_ALREADY_HAS_APTOGOTCHI: u64 = 3;
    /// invalid body value
    const EBODY_VALUE_INVALID: u64 = 4;
    /// invalid ear value
    const EEAR_VALUE_INVALID: u64 = 5;
    /// invalid face value
    const EFACE_VALUE_INVALID: u64 = 6;

    fun init_module(account: &signer) {
        let constructor_ref = object::create_named_object(
            account,
            APP_OBJECT_SEED,
        );
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let app_signer = &object::generate_signer(&constructor_ref);

        move_to(app_signer, ObjectController {
            app_extend_ref: extend_ref,
        });

        create_aptogotchi_collection(app_signer);
    }

    fun create_aptogotchi_collection(creator: &signer) {
        let description = string::utf8(APTOGOTCHI_COLLECTION_DESCRIPTION);
        let name = string::utf8(APTOGOTCHI_COLLECTION_NAME);
        let uri = string::utf8(APTOGOTCHI_COLLECTION_URI);

        collection::create_unlimited_collection(
            creator,
            description,
            name,
            option::none(),
            uri,
        );
    }

    public entry fun create_aptogotchi(
        user: &signer,
        name: String,
        body: u8,
        ear: u8,
        face: u8
    ) acquires ObjectController{
        assert!(string::length(&name) <= NAME_UPPER_BOUND, error::invalid_argument(ENAME_LIMIT));
        assert!(body >= 0 && body <= BODY_MAX_VALUE, error::invalid_argument(EBODY_VALUE_INVALID));
        assert!(ear >= 0 && ear <= EAR_MAX_VALUE, error::invalid_argument(EEAR_VALUE_INVALID));
        assert!(face >= 0 && face <= FACE_MAX_VALUE, error::invalid_argument(EFACE_VALUE_INVALID));

        let uri = string::utf8(APTOGOTCHI_COLLECTION_URI);
        let description = string::utf8(APTOGOTCHI_COLLECTION_DESCRIPTION);
        let user_addr = signer::address_of(user);
        let token_name = to_string(&user_addr);
        let parts = AptogotchiParts {
            body,
            ear,
            face
        };
        
        assert!(!has_aptogotchi(user_addr), error::already_exists(EUSER_ALREADY_HAS_APTOGOTCHI));

        let constructor_ref = token::create_named_token(
            &get_app_signer(),
            string::utf8(APTOGOTCHI_COLLECTION_NAME),
            description,
            token_name,
            option::none(),
            uri
        );

        let token_signer = object::generate_signer(&constructor_ref);
        let mutator_ref = token::generate_mutator_ref(&constructor_ref);
        let burn_ref = token::generate_burn_ref(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);

        let gotchi = AptoGotchi{
            name,   
            birthday: timestamp::now_seconds(),
            energy_points: ENERGY_UPPER_BOUND,
            parts,
            mutator_ref,
            burn_ref
        };
        
        move_to(&token_signer, gotchi);
        event::emit<MintAptogotchiEvent>(
            MintAptogotchiEvent{
                token_name,
                aptogotchi_name: name,
                parts,
            },
        );
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user))
    }

    #[view]
    public fun has_aptogotchi(owner_addr: address): (bool){
        let token_address = get_aptogotchi_address(owner_addr);
        exists<AptoGotchi>(token_address)
    }

    #[view]
    public fun get_aptogotchi_address(creator_addr: address): (address){
        let collection = string::utf8(APTOGOTCHI_COLLECTION_NAME);
        let token_name = to_string(&creator_addr);
        let creator_addr = get_app_signer_addr();
        let token_address = token::create_token_address(
            &creator_addr,
            &collection,
            &token_name
        );

        token_address
    }

    fun get_app_signer_addr(): address{
        object::create_object_address(&@aptogotchi_addr, APP_OBJECT_SEED)
    }

    fun get_app_signer(): signer acquires ObjectController{
        object::generate_signer_for_extending(&borrow_global<ObjectController>(get_app_signer_addr()).app_extend_ref)
    }

    #[view]
    public fun get_aptogotchi(owner_addr: address): (String, u64, u64, AptogotchiParts) acquires AptoGotchi{
        assert!(has_aptogotchi(owner_addr), ENOT_AVAILABLE);
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = borrow_global<AptoGotchi>(token_address);
        (gotchi.name, gotchi.birthday, gotchi.energy_points, gotchi.parts)
    }

    // public entry fun set_name(user_addr: address, name: String) acquires Aptogotchi, CollectionCapability{

    // }
}