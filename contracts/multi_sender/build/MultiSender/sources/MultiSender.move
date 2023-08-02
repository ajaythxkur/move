module my_addrx::MultiSender{
    // use 0x1::coin;
    // use 0x1::aptos_coin::AptosCoin;
    // use 0x1::aptos_account;
    // use 0x1::vector;
    // use 0x1::signer;
    // use 0x1::account;

    const E_NOT_ENOUGH_COINS: u64 = 101;

    struct ReceiverList has key {
        receivers_list: vector<Receiver>
    }

    struct Receiver has store{
        addr: address,
        amount: u64
    }
    
    // public entry fun ms_trans(from: &signer, to: )
    // {
    //     let size: u64 = vector::length(&to);
    //     let send_amt = 0;
    //      while(send_amt < size)
    //     {
    //         let amount = *vector::borrow(& to, receiver as Receiver);
    //         send_amt=send_amt+amount;
    //     };    
    //     print(&send_amt);
    // }

    // #[test(admin = @my_addrx)]
    // public entry fun testing(admin: signer) {
    //     account::create_account_for_test(signer::address_of(&admin));
    //     ms_trans()
    // }
}