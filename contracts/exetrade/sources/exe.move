module my_addrx::hello_blockchain{
    use std::string::{String,utf8};
    use std::signer;
    use std::account;
    struct Message has key{
        my_message: String
    }

    public entry fun create_msg(account: &signer, msg: String) acquires Message{
        let signer_address = signer::address_of(account);
        if(exists<Message>(signer_address)){
            let message = &mut borrow_global_mut<Message>(signer_address).my_message;
            *message = msg
        }else{
            let fresh_msg = Message{
                my_message: msg
            };
            move_to(account, fresh_msg)
        }
    }

    #[test(admin = @my_addrx)]
    public entry fun testing(admin: signer) acquires Message{
        account::create_account_for_test(signer::address_of(&admin));
        create_msg(&admin, utf8(b"hi"));
    }
}