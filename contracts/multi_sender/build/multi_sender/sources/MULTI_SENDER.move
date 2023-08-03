module my_addrx::MULTI_SENDER{
    use std::signer;
    use std::vector;
    // use std::debug::print;
    use std::coin;
    use std::aptos_coin::AptosCoin; 
    use std::aptos_account;
    struct Receiver has store, drop, copy {
        addr: address,
        amount: u64
    }

    struct VectorOfReceivers has store, drop, copy {
        vec: vector<Receiver>,
    }

    fun transfer(account: &signer, receivers: VectorOfReceivers) {
        let size:u64 = vector::length(&receivers.vec);
        let from_acc_balance:u64 = coin::balance<AptosCoin>(signer::address_of(account));
        let amount = 0;
        let i = 0; 
        while(i < size)
        {
            let rec = *vector::borrow(&receivers.vec,(i as u64));
            amount = amount + rec.amount;
            i=i+1;
        };
        assert!( amount <= from_acc_balance, 0);
        let x = 0;
        while(x < size)
        {
            let receive = *vector::borrow(&receivers.vec,(i as u64));
            aptos_account::transfer(account,receive.addr,receive.amount); 
            i=i+1;
        };
    }
    #[test_only]
    use std::account;

    #[test(admin = @my_addrx)]
    fun testing(admin: signer){
        account::create_account_for_test(signer::address_of(&admin));
        let r1 = Receiver{
            addr: @0x345,
            amount: 1
        };
        let r2 = Receiver{
            addr: @0x567,
            amount: 1
        };
        let receivers = VectorOfReceivers{
			vec: vector::empty<Receiver>()
		};
        vector::push_back(&mut receivers.vec, r1);
        vector::push_back(&mut receivers.vec, r2);
        transfer(&admin, receivers);
    }

}