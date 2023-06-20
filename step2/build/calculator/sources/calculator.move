module 0x345::calculator{
    public fun add(a: u64, b: u64): u64{
        a + b
    }
    public fun sub(a: u64, b: u64): u64{
        a - b
    }
    public fun div(a: u64, b: u64): u64{
        a / b
    }
    public fun mul(a: u64, b: u64): u64{
        a * b
    }
    public fun rem(a: u64, b: u64): u64{
        a % b
    }
}