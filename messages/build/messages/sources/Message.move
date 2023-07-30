module my_addrx::Message{
    use std::string::{String, utf8};
    use std::signer;
    use aptos_framework::account;
    use std::debug::print;

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

    #[test(admin=@0x123)]
    public entry fun test_flow(admin: signer)acquires Message
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, utf8(b"This is ajay"));
        let first_msg = borrow_global<Message>(signer::address_of(&admin));
        print(&first_msg.my_message);
        create_message(&admin, utf8(b"Message changed"));
        let changed_msg = borrow_global<Message>(signer::address_of(&admin));
        print(&changed_msg.my_message);
        assert!(changed_msg.my_message == utf8(b"Message changed"), 0);
    }
}