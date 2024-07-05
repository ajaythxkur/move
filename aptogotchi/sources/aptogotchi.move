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

    struct Accessory has key{
        category: String,
        id: u64
    }
    const APP_OBJECT_SEED: vector<u8> = b"gotchi";
    const APTOGOTCHI_COLLECTION_DESCRIPTION: vector<u8> = b"Aptogotchi Gaming NFTs";
    const APTOGOTCHI_COLLECTION_NAME: vector<u8> = b"Aptogotchi";
    const APTOGOTCHI_COLLECTION_URI: vector<u8> = b"https://learn.aptoslabs.com/";

    const ACCESSORY_COLLECTION_NAME: vector<u8> = b"Aptogotchi Accessory Collection";
    const ACCESSORY_COLLECTION_DESCRIPTION: vector<u8> = b"Aptogotchi Accessories";
    const ACCESSORY_COLLECTION_URI: vector<u8> = b"https://otjbxblyfunmfblzdegw.supabase.co/storage/v1/object/public/aptogotchi/bowtie.png";
    const ACCESSORY_CATEGORY_BOWTIE: vector<u8> = b"bowtie";

    const NAME_UPPER_BOUND: u64 = 40;
    const ENERGY_UPPER_BOUND: u64 = 10;
    const BODY_MAX_VALUE: u8 = 4;
    const EAR_MAX_VALUE: u8 = 6;
    const FACE_MAX_VALUE: u8 = 3;

    /// aptogotchi not available
    const ENOT_AVAILABLE: u64 = 1;
    /// Accessory not available
    const E_ACCESSORY_NOT_AVAILABLE: u64 = 1;
    /// Name exceeds limit
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
        create_accessory_collection(app_signer);
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
    fun create_accessory_collection(creator: &signer){
        let description = string::utf8(ACCESSORY_COLLECTION_DESCRIPTION);
        let name = string::utf8(ACCESSORY_COLLECTION_NAME);
        let uri = string::utf8(ACCESSORY_COLLECTION_URI);

        collection::create_unlimited_collection(
            creator,
            description,
            name,
            option::none(),
            uri
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

    public entry fun set_name(owner: signer, name: String) acquires AptoGotchi{
        let owner_addr = signer::address_of(&owner);
        assert!(has_aptogotchi(owner_addr), error::unavailable(ENOT_AVAILABLE));
        assert!(string::length(&name) <= NAME_UPPER_BOUND, error::invalid_argument(ENAME_LIMIT));
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = borrow_global_mut<AptoGotchi>(token_address);
        gotchi.name = name;
    }

    public entry fun feed(owner: &signer, points: u64) acquires AptoGotchi{
        let owner_addr = signer::address_of(owner);
        assert!(has_aptogotchi(owner_addr), error::unavailable(ENOT_AVAILABLE));
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = borrow_global_mut<AptoGotchi>(token_address);
        gotchi.energy_points = if(gotchi.energy_points + points > ENERGY_UPPER_BOUND){
            ENERGY_UPPER_BOUND
        }else{
            gotchi.energy_points + points
        };
    }

    public entry fun play(owner: &signer, points: u64) acquires AptoGotchi{
        let owner_addr = signer::address_of(owner);
        assert!(has_aptogotchi(owner_addr), error::unavailable(ENOT_AVAILABLE));
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = borrow_global_mut<AptoGotchi>(token_address);
        gotchi.energy_points = if(gotchi.energy_points < points){
            0
        }else{
            gotchi.energy_points - points
        }
    }

    #[view]
    public fun get_aptogotchi_collection_address(): (address){
        let collection_name = string::utf8(APTOGOTCHI_COLLECTION_NAME);
        let creator_addr = get_app_signer_addr();
        collection::create_collection_address(&creator_addr, &collection_name)
    }

    public entry fun set_parts(owner: &signer, body: u8, ear: u8, face: u8) acquires AptoGotchi{
        let owner_addr = signer::address_of(owner);
        assert!(has_aptogotchi(owner_addr), error::unavailable(ENOT_AVAILABLE));
        assert!(body >= 0 && body <= BODY_MAX_VALUE, error::invalid_argument(EBODY_VALUE_INVALID));
        assert!(ear >= 0 && ear <= EAR_MAX_VALUE, error::invalid_argument(EEAR_VALUE_INVALID));
        assert!(face >= 0 && face <= FACE_MAX_VALUE, error::invalid_argument(EFACE_VALUE_INVALID));
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = borrow_global_mut<AptoGotchi>(token_address);
        gotchi.parts.body = body;
        gotchi.parts.ear = ear;
        gotchi.parts.face = face;
    }

    public entry fun create_accessory(user: &signer, category: String) acquires ObjectController{
        let uri = string::utf8(ACCESSORY_COLLECTION_URI);
        let description = string::utf8(ACCESSORY_COLLECTION_DESCRIPTION);

        let constructor_ref = token::create_named_token(
            &get_app_signer(),
            string::utf8(ACCESSORY_COLLECTION_NAME),
            description,
            get_accessory_token_name(address_of(user), category),
            option::none(),
            uri
        );
        let token_signer = object::generate_signer(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);
        let category = string::utf8(ACCESSORY_CATEGORY_BOWTIE);
        let id = 1;
        let accessory = Accessory{
            category,
            id,
        };
        move_to(&token_signer, accessory);
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
    }

    fun get_accessory_token_name(owner_addr: address, category: String): String{
        let token_name = category;
        string::append(&mut token_name, to_string(&owner_addr));
        token_name
    }

    public entry fun wear_accessory(owner: &signer, category: String) acquires ObjectController{
        let owner_addr = address_of(owner);
        let token_address = get_aptogotchi_address(owner_addr);
        let gotchi = object::address_to_object<AptoGotchi>(token_address);

        let accessory_address = get_accessory_address(owner_addr, category);
        let accessory = object::address_to_object<Accessory>(accessory_address);
        object::transfer_to_object(owner, accessory, gotchi);
    }

    fun get_accessory_address(creator_addr: address, category: String): (address) acquires ObjectController{
        let collection = string::utf8(ACCESSORY_COLLECTION_NAME);
        let creator = &get_app_signer();
        let token_address = token::create_token_address(
            &address_of(creator),
            &collection,
            &get_accessory_token_name(creator_addr, category)
        );
        token_address
    }

    public entry fun unwear_accessory(owner: &signer, category: String) acquires ObjectController{
        let owner_addr = address_of(owner);
        let accessory_address = get_accessory_address(owner_addr, category);
        let has_accessory = exists<Accessory>(accessory_address);
        assert!(has_accessory, error::unavailable(E_ACCESSORY_NOT_AVAILABLE));
        let accessory = object::address_to_object<Accessory>(accessory_address);
        object::transfer(owner, accessory, address_of(owner));
    }

}