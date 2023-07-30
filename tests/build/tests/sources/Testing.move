module my_addrx::Testing
{
    use std::debug::print;
    use std::string::{String,utf8};
    struct Foo<T> has copy, drop{
        value: T
    }
    struct Bar<T1, T2> has copy, drop{
        x: T1,
        y: T2
    }
    fun example<T>(num: u64): u64
    {
        num+1
    }
    fun example2(num:u64){
        let create_foo = Foo{ value: num };
        print(&create_foo);
    }
    fun example3(id: u64, name: String){
        let create_bar = Bar { x: id, y: name };
        print(&create_bar);
    }
    #[test]
    fun testing(){
        let example1 = example<u64>(10);
        print(&example1);
        example2(10);
        example3(1, utf8(b"ajay"));
    }
}