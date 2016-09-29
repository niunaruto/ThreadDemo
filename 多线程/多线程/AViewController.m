//
//  AViewController.m
//  多线程
//
//  Created by anlaiye on 16/9/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "AViewController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface AViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadQueue];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.queue cancelAllOperations];
}
- (void)dealloc{
    NSLog(@"dealloc");
}


//创建多个线程并且各个线程之前相互依赖 NSOperationQueue
- (void)loadQueue{
    
    
    WS(weakSelf);
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务_______1");
        weakSelf.queue.suspended = YES;
        [weakSelf success:^{
            NSLog(@"任务_______1___执行完成");
            weakSelf.queue.suspended = NO;
        } failed:^{
            NSLog(@"任务_______1___执行失败取消所有的Operations");
            weakSelf.queue.suspended = YES;
            [weakSelf.queue cancelAllOperations];
        }];
        
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务_______2");
        weakSelf.queue.suspended = YES;
        [weakSelf success:^{
            NSLog(@"任务_______2___执行完成");
            weakSelf.queue.suspended = NO;
        } failed:^{
            NSLog(@"任务_______2___执行失败取消所有的Operations");
            weakSelf.queue.suspended = YES;
            [weakSelf.queue cancelAllOperations];
        }];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务_______3");
        weakSelf.queue.suspended = YES;
        [weakSelf success:^{
            NSLog(@"任务_______3___执行完成");
            weakSelf.queue.suspended = NO;
        } failed:^{
            NSLog(@"任务_______3___执行失败取消所有的Operations");
            weakSelf.queue.suspended = YES;
            [weakSelf.queue cancelAllOperations];
        }];
    }];
    
    //设置各个线程之间的依赖
    [operation2 addDependency:operation1];//任务二的执行依赖任务一
    [operation3 addDependency:operation2]; //任务三的执行依赖任务二
    //创建队列并加入任务
    [self.queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
    
}


/**
 这个是模拟真实的网络请求
 */
- (void)success:(void (^)(void))success failed:(void (^)(void))failed{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        success();
        
    });
}





#pragma mark  - 赖加载
- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
        
    }
    return _queue;
}

@end
