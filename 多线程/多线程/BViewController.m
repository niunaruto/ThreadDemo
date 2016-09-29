//
//  BViewController.m
//  多线程
//
//  Created by anlaiye on 16/9/29.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "BViewController.h"

/**
 GCD用法
 */
@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGCD];
}

- (void)loadGCD{
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        
        //线程一
        
        dispatch_group_enter(group);
        
        [self success:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSLog(@"==1=");
                
                dispatch_group_leave(group);
                
            });
            
        }];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        
        // 线程二
        
        dispatch_group_enter(group);
        
        [self success:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSLog(@"==2=");
                
                dispatch_group_leave(group);
                
            });
            
        }];
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        
        //汇总
        
        NSLog(@"==all=");
        
    });
    
}

- (void)success:(void (^)(void))success{
    
    success();
    
}

@end
