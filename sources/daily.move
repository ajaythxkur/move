module my_addrx::daily{
    use std::debug;
    use std::vector;
    public fun integers_in_move(){
        let vec = vector::singleton<u64>(0);
        let i: u64 = 1;
        while(i < 10){
            vector::push_back(&mut vec, i);
            i = i + 1;
        };
        debug::print(&vec);
        let remove_last_el = vector::pop_back(&mut vec);
        debug::print(&remove_last_el);
        let (is_index, index) = vector::index_of(&vec, &012);
        debug::print(&is_index);
        debug::print(&index);
    }
    #[test]
    public fun testing(){
        integers_in_move();
    }
}