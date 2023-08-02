module my_addrx::MultiSender{
    // use 0x1::coin;
    // use 0x1::aptos_coin::AptosCoin;
    // use 0x1::aptos_account;
    use 0x1::vector;
    use 0x1::signer;
    use 0x1::account;
    use 0x1::debug::print;

    const E_NOT_ENOUGH_COINS: u64 = 101;

    struct Receiver has store, drop, copy{
        addr: address,
        amount: u64
    }
    
    public entry fun ms_trans(from: &signer, to: vector<Receiver>)
    {
        // let size: u64 = vector::length(&to);
        // let send_amt = 0;
        //  while(send_amt < size)
        // {
        //     let amount = *vector::borrow(& to, receiver as Receiver);
        //     send_amt=send_amt+amount;
        // };    
        print(&to);
    }

    #[test(admin = @my_addrx)]
    public entry fun testing(admin: signer) {
        account::create_account_for_test(signer::address_of(&admin));
        let receiver_1 = Receiver{
            addr: @0x235,
            amount: 1
        };
        let receiver_2 = Receiver{
            addr: @0x234,
            amount: 2
        };
        let list = vector::empty<Receiver>();
        vector::push_back(&mut list, receiver_1);
        vector::push_back(&mut list, receiver_2);
        ms_trans(&admin, list);
    }
}