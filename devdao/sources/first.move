module my_addrx::Example{
    struct Counter has key {
        value: u8,
    }

    public fun increment(a: address) acquires Counter {
        let c = borrow_global_mut<Counter>(a);
        c.value = c.value + 1;
    }

    spec increment {
        aborts_if !exists<Counter>(a);
        ensures global<Counter>(a).value == old(global<Counter>(a)).value + 1;
    }
}