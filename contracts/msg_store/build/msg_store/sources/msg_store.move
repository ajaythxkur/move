module my_addrx::msg_store{
    use std::string::String;
    use std::signer;
    
    const E_NOT_INITIALIZED:u64 = 1;

    struct Message has key
    {
        my_message: String
    }

    public entry fun create_message(account: &signer, msg: String) acquires Message 
    {
        let signer_address = signer::address_of(account);
        if(!exists<Message>(signer_address)){
            let message = Message{
                my_message: msg
            };
            move_to(account, message);
        }
        else
        {
            let message = borrow_global_mut<Message>(signer_address);
            message.my_message = msg;
        }
    }
    #[view]
    public fun get_message(account: &signer):String acquires Message{
        let signer_address = signer::address_of(account);
        assert!(exists<Message>(signer_address), E_NOT_INITIALIZED);
        borrow_global<Message>(signer_address).my_message
    }

    #[test_only]
    use aptos_framework::account;
    use std::string::utf8;

    #[test(admin=@0x123)]
    public entry fun test_flow(admin: signer)acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, utf8(b"This is ajay"));
        let first_msg = borrow_global<Message>(signer::address_of(&admin));
        assert!(first_msg.my_message == utf8(b"This is ajay"), 2);
        create_message(&admin, utf8(b"Hola! It's Ajay"));
        let changed_msg = borrow_global<Message>(signer::address_of(&admin));
        assert!(changed_msg.my_message == utf8(b"Hola! It's Ajay"), 0);
        let view_msg = get_message(&admin);
        assert!(view_msg == utf8(b"Hola! It's Ajay"), 3);
    }
}