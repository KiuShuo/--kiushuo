//
//  ViewController.m
//  PATestGCD
//
//  Created by shuo on 2017/3/22.
//  Copyright © 2017年 shuo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testAsync02];
}

- (void)testAsync00 {
    NSLog(@"begin");
    // 1是在子线程中，所以和主线程中的3 end没有先后顺序之言
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    // 表示向串行队列中添加一个异步任务，无需立即执行任务即可算完成
    dispatch_async(queue1, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    for (int i = 0; i < 10; i++) {
        NSLog(@"3, %@", [NSThread currentThread]);
    }
    NSLog(@"end");
}

- (void)testAsync01 {
    // 执行顺序为begin->1->end
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin");
    // 表示向队列中添加一个同步任务，并且必须把任务执行完才能算完成
    dispatch_sync(queue1, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    NSLog(@"end");
}

- (void)testAsync02 {
    // 先往队列中添加了一个任务block1，因为是异步任务，所以不需要等待里面的任务执行完就可以执行下面的代码，而blcok1在子线程中，所以和center没有先后顺序。
    // center执行完之后又往队列中添加了一个同步任务block2，同步任务必须执行完里面的任务才能算完成，并且在主线程中 和后面的代码有先后顺序，所以end要等block2执行完才能执行。根据队列FIFO原则，block2要等block1执行完才能执行，所以整个的执行顺序为begin->(1/enter)->2->end
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"begin");
    dispatch_async(queue1, ^{ // block1
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    for (int i = 0; i < 10; i++) {
        NSLog(@"center");
    }
    dispatch_sync(queue1, ^{ // block2
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    NSLog(@"end");
}

- (void)testAsync10 {
    // 1 2 之间有先后顺序 按照FIFO原则，1在2之前先执行，所以打印顺序为1->3->2
    // 首先先往队列中添加一个async的任务block1，由于是block1在子线程中，所以并不会影响主线程中代码end的执行。
    // 执行block1时又往队列中添加了一个async任务block2（不需要立即执行里面的任务），然后执行3，block1即算执行完了，然后按照FIFO原则，执行block2
    NSLog(@"begin");
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{ // block1
        NSLog(@"1, %@", [NSThread currentThread]);
        dispatch_async(queue1, ^{ // block2
            NSLog(@"2, %@", [NSThread currentThread]);
        });
        for (int i = 0; i < 10; i++) {
            NSLog(@"3, %@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}

- (void)testAsync11 {
    NSLog(@"begin");
    // 死锁 首先往queue1里面添加了一个任务，这个任务在一个子线程中执行，所以并不影响当前线程的执行，即end还会执行。
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
        dispatch_sync(queue1, ^{
            NSLog(@"2, %@", [NSThread currentThread]);
        });
    });
    
    NSLog(@"end");
}

- (void)testAsync12 {
    NSLog(@"begin");
    // 1 2 之间有先后顺序 按照FIFO原则，1在2之前先执行，所以打印顺序为 1->3->2 ／ 1->3->4 2和4之间没有先后顺序可言
    // sync任务不开辟线程，里面的代码顺序执行，当执行到b模块的时候，由于是异步任务，所以可以直接当做异步任务return，继续执行后面的c模块。执行完c就可以认为sync任务执行完了。这时候按照FIFO原则，开始执行async任务。所以执行顺序为1->3->2
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue1, ^{
        // a
        NSLog(@"1, %@", [NSThread currentThread]);
        // b
        dispatch_async(queue1, ^{
            NSLog(@"2, %@", [NSThread currentThread]);
        });
        // c
        for (int i = 0; i < 100; i++) {
            NSLog(@"3, %@", [NSThread currentThread]);
        }
    });
    for (int i = 0; i < 100; i++) {
        NSLog(@"4, %@", [NSThread currentThread]);
    }
    
    NSLog(@"end");
}

- (void)testAsync13 {
    NSLog(@"begin");
    // 死锁
    dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue1, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
        dispatch_sync(queue1, ^{
            NSLog(@"2, %@", [NSThread currentThread]);
        });
        for (int i = 0; i < 100; i++) {
            NSLog(@"3, %@", [NSThread currentThread]);
        }
    });
    for (int i = 0; i < 100; i++) {
        NSLog(@"4, %@", [NSThread currentThread]);
    }
    
    NSLog(@"end");
}


- (void)test {
    // 同一队列服从先进先出原则
    /**
     执行顺序 begin->end->1->2->3
     当前有两个队列，'系统串行队列1' 和 自己创建的串行队列2
     系统队列中的任务按照顺序正常执行
     
     默认情况下，系统创建了一个串行队列0，在串行队列中添加了一个同步任务，所有写的代码都放在这个同步任务里面，
     所以所写的代码都是顺序执行的。
     
     A->B->C begin->B->
     
     执行到B时创建了一个串行队列queue1，在串行队列中添加了一个异步任务，此时对队列queue0来说，B模块已经执行完了，所以按照顺序执行C。
     
     在B模块中，首先添加了一个异步任务async1，由于是串行队列，所以只开辟一个线程并且顺序执行线程中的代码，在执行到b模块时，又往线程queue1中添加了一个异步任务sync2，由于是同一队列，所以要按照FIFO原则，sync2要等sync1执行完成后才能执行，所以先执行模块c，及B模块中的执行顺序为1->3->2
     */
    dispatch_queue_t queue0 = dispatch_queue_create("queue0", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue0, ^{
        // A
        NSLog(@"begin");
        // B
        dispatch_queue_t queue1 = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue1, ^{
            // a
            NSLog(@"1, %@", [NSThread currentThread]);
            // b
            dispatch_async(queue1, ^{
                NSLog(@"2, %@", [NSThread currentThread]);
            });
            // c
            NSLog(@"3, %@", [NSThread currentThread]);
        });
        // C
        NSLog(@"end");
        
    });
    
}

@end
