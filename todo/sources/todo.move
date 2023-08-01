module my_addrx::Todo{
    use aptos_framework::event;
    use std::signer;
    use aptos_std::table::{Self,Table};
    use aptos_framework::account;
    use std::string::String;
    // use std::debug::print;   
    const E_NOT_INITIALIZED: u64 = 1;
    const ETASK_DOESNT_EXIST: u64 = 2;
    const ETASK_IS_COMPLETED: u64 = 3;

    struct TodoList has key{
        tasks: Table<u64, Task>,
        set_task_event: event::EventHandle<Task>,
        task_counter: u64
    }
    struct Task has drop, store, copy {
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
        //increment the counter
        let counter = todo_list.task_counter + 1;
        //creating incoming task
        let new_task = Task{
            task_id: counter,
            address: signer_address,
            content,
            completed: false
        };
        table::upsert(&mut todo_list.tasks, counter, new_task);
        todo_list.task_counter = counter;

        //borrowing the todolist once again 
        let update_todo_list = borrow_global<TodoList>(signer_address);
        let created_task = table::borrow(&update_todo_list.tasks, counter);
        event::emit_event<Task>(
            &mut borrow_global_mut<TodoList>(signer_address).set_task_event,
            created_task
        );
    }

    #[test_only]
    use std::string;
    use std::debug::print;
    #[test(admin = @my_addrx)]
    public entry fun test_flow(admin: signer) acquires TodoList{
        account::create_account_for_test(signer::address_of(&admin));
        create_list(&admin);

        //creating a task 
        create_task(&admin, string::utf8(b"new task"));
        let task_count = event::counter(&borrow_global<TodoList>(signer::address_of(&admin))).set_task_event;
        assert!(task_count == 1, 4);
        print!(&task_count);

    }
}