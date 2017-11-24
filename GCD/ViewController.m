//
//  ViewController.m
//  GCD
//
//  Created by ZhangJun on 2016/10/31.
//  Copyright © 2016年 ang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self asyncConcurrent];
    
//    [self asyncSerial];
    
//    [self syncConcurrent];
    
//    [self syncSerial];
    
//    [self asyncMain];
    
//    [self syncMain];
    
//    [self syncGroup];
    
//    [self asyncGroup];
    
//    [self syncGroup1];
    
//    [self asyncGroup1];
    
//    [self semaphore];
    
//    [self source];
    
//    [self sourceWithTime];
    
    [self sourceWithCustom];
    // Do any additional setup after loading the view, typically from a nib.
}

//异步执行 + 并行队列
- (void)asyncConcurrent {
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"---start---");
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    
    NSLog(@"---end---");
}
/*
 异步执行意味着
 可以开启新的线程
 任务可以先绕过不执行，回头再来执行
 并行队列意味着
 任务之间不需要排队，且具有同时被执行的“权利”
 两者组合后的结果
 开了三个新线程
 函数在执行时，先打印了start和end，再回头执行这三个任务
 这三个任务是同时执行的，没有先后。
 */

//异步执行 + 串行队列
- (void)asyncSerial {
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"---start---");
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

/*
 异步执行意味着
 可以开启新的线程
 任务可以先绕过不执行，回头再来执行
 串行队列意味着
 任务必须按添加进队列的顺序挨个执行
 两者组合后的结果
 开了一个新的子线程
 函数在执行时，先打印了start和end，再回头执行这三个任务
 这三个任务是按顺序执行的，所以打印结果是“任务1-->任务2-->任务3”
 */

//同步执行 + 并行队列
- (void)syncConcurrent {
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"---start---");
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

/*
 同步执行执行意味着
 不能开启新的线程
 任务创建后必须执行完才能往下走
 并行队列意味着
 任务之间不需要排队，且具有同时被执行的“权利”
 两者组合后的结果
 所有任务都只能在主线程中执行
 函数在执行时，必须按照代码的书写顺序一行一行地执行完才能继续
 注意事项
 在这里即便是并行队列，任务可以同时执行，但是由于只存在一个主线程，所以没法把任务分发到不同的线程去同步处理，其结果就是只能在主线程里按顺序挨个挨个执行了
 */

//同步执行+ 串行队列
- (void)syncSerial{
    //创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("标识符", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"---start---");
    //使用异步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

/*
 这里的执行原理和步骤图跟“同步执行+并发队列”是一样的，只要是同步执行就没法开启新的线程，所以多个任务之间也一样只能按顺序来执行
 */

//异步执行+主队列
- (void)asyncMain {
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"---start---");
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

/*
 异步执行意味着
 可以开启新的线程
 任务可以先绕过不执行，回头再来执行
 主队列跟串行队列的区别
 队列中的任务一样要按顺序执行
 主队列中的任务必须在主线程中执行，不允许在子线程中执行
 以上条件组合后得出结果：
 所有任务都可以先跳过，之后再来“按顺序”执行
 */

//同步执行+主队列（死锁）
- (void)syncMain {
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"---start---");
    //使用同步函数封装三个任务
    dispatch_sync(queue, ^{
        NSLog(@"任务1---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务2---%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"任务3---%@", [NSThread currentThread]);
    });
    NSLog(@"---end---");
}

/*
 主队列中的任务必须按顺序挨个执行
 任务1要等主线程有空的时候（即主队列中的所有任务执行完）才能执行
 主线程要执行完“打印end”的任务后才有空
 “任务1”和“打印end”两个任务互相等待，造成死锁
 */

//同步执行+组队列
- (void)syncGroup {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个组队列
    dispatch_group_t group =  dispatch_group_create();
    
    NSLog(@"---start---");
    //将block任务添加到queue队列，并被group组管理
    dispatch_group_async(group, queue, ^{
        dispatch_sync(queue, ^{
            for (NSInteger i = 1; i <= 3; i ++) {
                NSLog(@"任务%ld---%@",i,[NSThread currentThread]);
            }
        });
    });
    /*
     dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
     等待上面所有的任务全部完成后，才会往下继续执行（会阻塞当前线程）
     timeout超时时间（可自己设置）
     DISPATCH_TIME_NOW      超时时间为0
     DISPATCH_TIME_FOREVER  超时时间为永远
     如果所有任务完成前超时了，该函数会返回一个非零值,可以对此返回值做条件判断以确定是否超出等待周期。
     */
    //
//    long time = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    NSLog(@"%ld",time);
    
    //等待上面所有的任务全部完成后，会收到通知执行block中的代码（不会阻塞线程）
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---end---");
    });
}
//异步执行+组队列
- (void)asyncGroup {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个组队列
    dispatch_group_t group =  dispatch_group_create();
    
    NSLog(@"---start---");
    //将block任务添加到queue队列，并被group组管理
    dispatch_group_async(group, queue, ^{
        dispatch_async(queue, ^{
            for (NSInteger i = 1; i <= 3; i ++) {
                NSLog(@"任务%ld---%@",i,[NSThread currentThread]);
            }
        });
    });
    /*
     dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
     等待上面所有的任务全部完成后，才会往下继续执行（会阻塞当前线程）
     timeout超时时间（可自己设置）
     DISPATCH_TIME_NOW      超时时间为0
     DISPATCH_TIME_FOREVER  超时时间为永远
     如果所有任务完成前超时了，该函数会返回一个非零值,可以对此返回值做条件判断以确定是否超出等待周期。
     */
    //
    //    long time = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    NSLog(@"%ld",time);
    
    //等待上面所有的任务全部完成后，会收到通知执行block中的代码（不会阻塞线程）
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---end---");
    });
}

//同步执行+组队列
- (void)syncGroup1 {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个组队列
    dispatch_group_t group =  dispatch_group_create();
    
    NSLog(@"---start---");
    dispatch_group_enter(group);
    dispatch_sync(queue, ^{
        for (NSInteger i = 1; i <= 3; i ++) {
            NSLog(@"任务%ld---%@",i,[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    /*
     dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
     等待上面所有的任务全部完成后，才会往下继续执行（会阻塞当前线程）
     timeout超时时间（可自己设置）
     DISPATCH_TIME_NOW      超时时间为0
     DISPATCH_TIME_FOREVER  超时时间为永远
     如果所有任务完成前超时了，该函数会返回一个非零值,可以对此返回值做条件判断以确定是否超出等待周期。
     */
    //
    //    long time = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    NSLog(@"%ld",time);
    
    //等待上面所有的任务全部完成后，会收到通知执行block中的代码（不会阻塞线程）
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---end---");
    });
}
//异步执行+组队列
- (void)asyncGroup1 {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个组队列
    dispatch_group_t group =  dispatch_group_create();
    
    NSLog(@"---start---");
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (NSInteger i = 1; i <= 3; i ++) {
            NSLog(@"任务%ld---%@",i,[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    /*
     dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
     等待上面所有的任务全部完成后，才会往下继续执行（会阻塞当前线程）
     timeout超时时间（可自己设置）
     DISPATCH_TIME_NOW      超时时间为0
     DISPATCH_TIME_FOREVER  超时时间为永远
     如果所有任务完成前超时了，该函数会返回一个非零值,可以对此返回值做条件判断以确定是否超出等待周期。
     */
    //
    //    long time = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //    NSLog(@"%ld",time);
    
    //等待上面所有的任务全部完成后，会收到通知执行block中的代码（不会阻塞线程）
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---end---");
    });
}

- (void)semaphore {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /*
     创建信号量
     传入的参数value必须大于或等于0，否则dispatch_semaphore_create会返回nil
     信号量的初始值设置为：1，即最多只能有一个线程
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSLog(@"---start---");
    __block long semaphoreTime = -100;
    /*
     dispatch_semaphore_signal(dispatch_semaphore_t dsema);
     信号量的值会加1
     当返回值为0时表示当前并没有线程等待其处理的信号量，其处理的信号量的值加1。当返回值不为0时，表示其当前有（一个或多个）线程等待其处理的信号量
     并且该函数唤醒了一个等待的线程（当线程有优先级时，唤醒优先级最高的线程，否则随机唤醒）。
     */
    /*
     dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);
     timeout超时时间（可自己设置）
     DISPATCH_TIME_NOW：超时时间为0，表示忽略信号量，直接运行
     DISPATCH_TIME_FOREVER：超时时间为永远，表示会一直等待信号量为正数，才会继续运行
     返回0：表示正常，在timeout之前，该函数所处的线程被成功唤醒。
     返回非0：表示等待时间超时，timeout发生。
     */
    dispatch_async(queue, ^{
        semaphoreTime = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务1wait-%ld",semaphoreTime);
        NSLog(@"任务1---%@", [NSThread currentThread]);
        semaphoreTime = dispatch_semaphore_signal(semaphore);
        NSLog(@"任务1signal-%ld",semaphoreTime);
    });
    dispatch_async(queue, ^{
        semaphoreTime = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务2wait-%ld",semaphoreTime);
        NSLog(@"任务2---%@", [NSThread currentThread]);
        semaphoreTime = dispatch_semaphore_signal(semaphore);
        NSLog(@"任务2signal-%ld",semaphoreTime);
    });
    dispatch_async(queue, ^{
        semaphoreTime = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务3wait-%ld",semaphoreTime);
        NSLog(@"任务3---%@", [NSThread currentThread]);
        semaphoreTime = dispatch_semaphore_signal(semaphore);
        NSLog(@"任务3signal-%ld",semaphoreTime);
    });
    NSLog(@"---end---");
}

- (void)source {
    //获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /*
     创建Dispatch Source
     dispatch_source_create(dispatch_source_type_t type,
     uintptr_t handle,
     unsigned long mask,
     dispatch_queue_t _Nullable queue);
     
     type：Dispatch Source要监听的事件类型
     handle：取决于要监听的事件类型，比如如果是监听Mach端口相关的事件，那么该参数就是mach_port_t类型的Mach端口号，如果是监听事件变量数据类型的事件就不需要该参数，直接设置为0。
     mask：取决于要监听的事件类型，比如如果是监听文件属性更改的事件，那么该参数就标识为DISPATCH_VNODE_RENAME。
     queue：设置回调函数所在的队列。
     */
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);
    /*
     设置事件处理器
     dispatch_source_set_event_handler(dispatch_source_t source,
     dispatch_block_t _Nullable handler);
     source：设置目标Dispatch Source
     handler：设置处理器
     */
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"Dispatch Source 事件处理器...");
    });
    /*
     dispatch_source_get_handle(dispatch_source_t source);
     用于获取在创建Dispatch Source时设置的第二个参数handle。
     
     如果是读写文件的Dispatch Source，返回的就是描述符。
     如果是信号类型的Dispatch Source，返回的是int类型的信号数。
     如果是进程类型的Dispatch Source，返回的是pid_t类型的进程id。
     如果是Mach端口类型的Dispatch Source，返回的是mach_port_t类型的Mach端口。
     */
    uintptr_t handle = dispatch_source_get_handle(source);
    /*
     dispatch_source_get_data(dispatch_source_t source);
     用于获取Dispatch Source监听到事件的相关数据。
     
     如果是读文件类型的Dispatch Source，返回的是读到文件内容的字节数。
     如果是写文件类型的Dispatch Source，返回的是文件是否可写的标识符，正数表示可写，负数表示不可写。
     如果是监听文件属性更改类型的Dispatch Source，返回的是监听到的有更改的文件属性，用常量表示，比如DISPATCH_VNODE_RENAME等。
     如果是进程类型的Dispatch Source，返回监听到的进程状态，用常量表示，比如DISPATCH_PROC_EXIT等。
     如果是Mach端口类型的Dispatch Source，返回Mach端口的状态，用常量表示，比如DISPATCH_MACH_SEND_DEAD等。
     如果是自定义事件类型的Dispatch Source，返回使用dispatch_source_merge_data函数设置的数据。
     */
    unsigned long data = dispatch_source_get_data(source);
    /*
     dispatch_source_get_mask(dispatch_source_t source);
     用于获取在创建Dispatch Source时设置的第三个参数mask。
     在进程类型，文件属性更改类型，Mach端口类型的Dispatch Source下返回的结果与dispatch_source_get_data一样。
     */
    unsigned long mask = dispatch_source_get_mask(source);
    /*
     dispatch_source_set_cancel_handler(dispatch_source_t source,
     dispatch_block_t _Nullable handler);
     第一个参数是目标Dispatch Source，第二个参数就是要进行后续处理事件。
     
     Cancellation Handler就是当Dispatch Source被释放时用来处理一些后续事情，
     比如关闭文件描述符或者释放Mach端口等。
     可以使用dispatch_source_set_cancel_handler函数或者dispatch_source_set_cancel_handler_f函数给Dispatch Source注册Cancellation Handler：
     */
    dispatch_source_set_cancel_handler(source, ^{
        NSLog(@"进行后续处理...");
    });
    
    /*
     dispatch_set_target_queue(dispatch_object_t object,
     dispatch_queue_t _Nullable queue);
     第一个参数是目标Dispatch Source，第二个参数就是设置回调函数所在的队列。
     用于更改队列，比如说想更改队列的优先级。
     
     如果在更改目标队列时，Dispatch Source已经监听到相关事件，并且回调函数已经在之前的队列中执行了，那么就不会转移到新的队列中去。
     */
    dispatch_set_target_queue(source, queue);
    
    /*
     dispatch_suspend(dispatch_object_t object);暂停
     dispatch_resume(dispatch_object_t object);恢复
     
     暂停或者恢复Dispatch Source与Dispatch Queue一样，都是dispatch_suspend和dispatch_resume函数。
     刚创建好的Dispatch Source是处于暂停状态的，所以使用时需要用dispatch_resume函数将其启动。
     */
    dispatch_suspend(source);
    dispatch_resume(source);
    
    /*
     dispatch_source_cancel(dispatch_source_t source);
     移除Dispatch Source
     */
    dispatch_source_cancel(source);
}

- (void)sourceWithTime {
    //倒计时时间
    __block NSInteger timeOut = 5;
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建dispatch_source
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /*
     每秒执行一次
     dispatch_source_set_timer(dispatch_source_t source,
     dispatch_time_t start,
     uint64_t interval,
     uint64_t leeway);
     用于给监听事件类型为DISPATCH_SOURCE_TYPE_TIMER的Dispatch Source设置相关属性。
     
     source：该参数为目标Dispatch Source，类型为dispatch_source_t.
     start：该参数为定时器的起始时间，类型为dispatch_time_t。
     interval：该参数为定时器的间隔时间，类型为UInt64，间隔时间的单位是纳秒。
     leeway：该参数为间隔时间的精度，类型为UInt64，时间单位也是纳秒。
     */
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    //设置事件处理器
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            //移除dispatch_source
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束处理
                NSLog(@"倒计时结束...");
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%2ld", (long)timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",timeStr);
            });
            timeOut--;
        }
    });
    //恢复，开启dispatch_source
    dispatch_resume(_timer);
}

- (void)sourceWithCustom {
    //倒计时时间
    __block NSInteger total = 0;
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建dispatch_source 模拟自定义事件
    dispatch_source_t custom = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);
    
    dispatch_source_set_event_handler(custom, ^{
        /*
         dispatch_source_get_data函数获取的变量值并不是累加值，
         而是每次调用dispatch_source_merge_data函数时设置的值。
         */
        unsigned long data = dispatch_source_get_data(custom);
        NSLog(@"data == %ld",data);
        total += (NSInteger)data;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"total == %ld",total);
        });
    });
    //恢复，开启dispatch_source
    dispatch_resume(custom);
    /*
     dispatch_apply(size_t iterations, dispatch_queue_t queue,
     DISPATCH_NOESCAPE void (^block)(size_t));
     在队列中循环执行任务
     
     开发中，经常会使用到for循环来处理一些没有先后顺序关联的任务，每个任务相对比较独立。
     我们可以用dispatch_apply或dispatch_apply_f函数让任务在队列中循环执行，并且是并发执行，
     相比for循环的串行执行要更加效率.
     */
    dispatch_apply(4, queue, ^(size_t i) {
//        NSLog(@"dispatch_apply i == %ld",i);
    });
    
    for (NSInteger i = 0; i < 4; i ++) {
        NSLog(@"i == %ld",i);
        /*
         dispatch_source_merge_data(dispatch_source_t source, unsigned long value);
         可以触发监听类型为DISPATCH_SOURCE_TYPE_DATA_ADD或者DISPATCH_SOURCE_TYPE_DATA_OR的Dispatch Source。
         
         第一个参数是目标Dispatch Source，第二个参数的类型是无符号长整型，用于向目标Dispatch Source中的对应变量追加指定的数。
         */
        dispatch_source_merge_data(custom, 1);
    }
}

@end
