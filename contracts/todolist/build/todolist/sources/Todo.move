module my_addrx::Todo{
    use aptos_framework::event;
    use aptos_framework::account;
    use std::signer;
    use std::string::String;
    use aptos_std::table::{Table,Self};

    const E_NOT_INITIALIZED:u64 = 0;
    const E_TASK_DOESNT_EXIST:u64 = 1;
    const E_TASK_IS_COMPLETED: u64 = 3;

    struct TodoList has key {
        tasks: Table<u64,Task>,
        set_task_event: event::EventHandle<Task>,
        task_counter: u64
    }
    struct Task has copy, drop, store{
        task_id: u64,
        address: address,
        content: String,
        completed: bool
    }

    public entry fun create_list(account: &signer){
        let task_holder = TodoList{
            tasks: table::new(),
            set_task_event: account::new_event_handle<Task>(account),
            task_counter: 0
        };
        move_to(account, task_holder);
    }

    public entry fun create_task(account: &signer, content: String) acquires TodoList{
        let signer_address = signer::address_of(account);
        assert!(exists<TodoList>(signer_address), E_NOT_INITIALIZED);
        let todo_list = borrow_global_mut<TodoList>(signer_address);
        let counter = todo_list.task_counter + 1;
        let new_task = Task{
            task_id: counter,
            address: signer_address,
            content,
            completed: false
        };
        table::upsert(&mut todo_list.tasks, counter, new_task);
        todo_list.task_counter = counter;
        event::emit_event<Task>(
            &mut borrow_global_mut<TodoList>(signer_address).set_task_event,
            new_task
        );
    }

    public entry fun complete_task(account: &signer, task_id: u64) acquires TodoList{
        let signer_address = signer::address_of(account);
        assert!(exists<TodoList>(signer_address), E_NOT_INITIALIZED);
        let todo_list = borrow_global_mut<TodoList>(signer_address);
        assert!(table::contains(&todo_list.tasks, task_id), E_TASK_DOESNT_EXIST);
        let task_record = table::borrow_mut(&mut todo_list.tasks, task_id);
        assert!(task_record.completed == false, E_TASK_IS_COMPLETED);
        task_record.completed = true;
    }

    #[test_only]
    use std::string::utf8;
    #[test(admin = @my_addrx)]
    public entry fun testing(admin: signer) acquires TodoList{
        let admin_addr = signer::address_of(&admin);
        account::create_account_for_test(admin_addr);
        create_list(&admin);
        create_task(&admin, utf8(b"read aptos.dev"));
        let task_count = event::counter(&borrow_global<TodoList>(admin_addr).set_task_event);
        assert!(task_count == 1, 4);
        complete_task(&admin, 1);
    }
}