//
//  ViewController.m
//  TouchIDSimpleDemoOne
//
//  Created by yulingsong on 16/8/5.
//  Copyright © 2016年 yulingsong. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TouchIDSimpleDemoOne";
    
    LAContext *context = [[LAContext alloc]init];
    NSError *error;
    NSString *result = @"需要你身份验证呢";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error)
        {
            if (success)
            {
                //验证成功，主线程处理UI
                //这个地方呢就是写一些验证成功之后需要做些什么事情的代码。
                NSLog(@"验证成功");
            }
            else
            {
                //以下是一些验证失败的原因啥的
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"切换到其他APP，系统取消验证Touch ID");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户选择输入密码");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        NSLog(@"LAErrorAuthenticationFailed，授权失败");
                        //授权失败
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"系统未设置密码");
                break;
            }
            case LAErrorTouchIDNotAvailable:
            {
                NSLog(@"设备Touch ID不可用，例如未打开");
                break;
            }
            default:
            {
                NSLog(@"系统未设置密码");
                break;
            }
        }
        NSLog(@"%@",error.localizedDescription);
    }
}



@end
