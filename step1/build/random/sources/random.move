module random_address::random{

    use aptos_std::aptos_hash;
    use std::debug;

    const E_WTF_DUDE: u64 = 0;

    public fun get_random_number(hash: vector<u8>): u64{
        let a = aptos_hash::sip_hash(hash);
        debug::print(&a);
        a
    }
    public fun get_random_number_between(hash: vector<u8>, low: u64, high: u64): u64{
        assert!(high > low, E_WTF_DUDE);
        let range = high - low;
        let a = aptos_hash::sip_hash(hash);
        let b = low + (a % range);
        debug::print(&b);
        return low + (a % range)
    }
   
    #[test]
    public fun test(){
        get_random_number(aptos_hash::keccak256(b"This is seed"));
    }
}