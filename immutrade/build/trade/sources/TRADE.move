module my_addrx::TRADE{
    use std::simple_map;
    use std::simple_map::SimpleMap;
    use std::string::{String,utf8};
    use std::signer;
    use std::account;
    use std::debug;
    
    struct Users has key, drop{
        list_of_users: SimpleMap<address,User>
    }
    struct User has copy, drop, store{
        name: String    
    }
    public fun assert_is_owner(addr: address){
        assert!(addr==@my_addrx, 0);
    }

    public fun assert_is_initialized(addr: address){
        assert!(exists<Users>(addr), 1);
    }

    public fun assert_uninititalized(addr: address){
        assert!(!exists<Users>(addr), 2);
    }

    public fun initialize(acc: &signer, newUser: User) acquires Users{
        let signer_address = signer::address_of(acc);
        assert_is_owner(signer_address);
        assert_uninititalized(signer_address);
        let new_users = Users{
            list_of_users: simple_map::create()
        };
        move_to(acc, new_users);
        let users = borrow_global_mut<Users>(signer_address);
        simple_map::add(&mut users.list_of_users, signer_address, newUser);
    }
    public fun get_users(acc: &signer) acquires Users{
        let signer_address = signer::address_of(acc);
        assert_is_owner(signer_address);
        let users = borrow_global<Users>(signer_address);
        debug::print(&users.list_of_users);
    }

    #[test(admin = @my_addrx)]
    public fun testing(admin: signer) acquires Users{
        let acc = account::create_account_for_test(signer::address_of(&admin));
        let user = User{
            name: utf8(b"strong")
        };
        initialize(&acc, user);
        get_users(&acc);
        // debug::print(&check_users);
    }
}