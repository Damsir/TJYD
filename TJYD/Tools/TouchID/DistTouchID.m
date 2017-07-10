//
//  DistTouchID.m
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistTouchID.h"

@implementation DistTouchID


#pragma mark ---指纹解锁
+ (void)Dist_initWithTouchIDPromptMsg:(NSString *)promptMsg cancelMsg:(NSString *)cancelMsg otherMsg:(NSString *)otherMsg enabled:(BOOL)enabled otherClick:(void(^)(NSString *otherClick))otherClick  success:(void(^)(BOOL success))success error:(void(^)(NSError *error))error errorMsg:(void(^)(NSString *errorMsg))errorMsg {
    
    //初始化上下文对象
    LAContext *context = [[LAContext alloc] init];
    NSError *errors;
    context.localizedFallbackTitle = otherMsg;
    
    /**
     注意两者的区别，
     首先支持的版本不同、
     //LAPolicyDeviceOwnerAuthentication  iOS 9.0 以上
     //kLAPolicyDeviceOwnerAuthenticationWithBiometrics  iOS 8.0以上
     其次输入 密码次数有关
     用kLAPolicyDeviceOwnerAuthenticationWithBiometrics 就好拉
     
     最主要的是，前者  使用“context.localizedFallbackTitle = @"输入登陆密码";”
     上面这个属性的时候，不能按我们设定的要求走，它会直接弹出验证
     
     所以还是用后者，kLAPolicyDeviceOwnerAuthenticationWithBiometrics
     
     */
    NSInteger APolicy;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 9 ) {
        APolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
        
    } else {
        APolicy = LAPolicyDeviceOwnerAuthentication;
    }

    
    NSInteger Policy;
    if (enabled) {
        Policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    } else {
        Policy = LAPolicyDeviceOwnerAuthentication;
    }
    
    if ([context canEvaluatePolicy:APolicy error:&errors])
    {
        //支持指纹验证
        [context evaluatePolicy:Policy localizedReason:promptMsg reply:^(BOOL succe, NSError *err) {
            
            if (succe) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                
                    success(succe);
                });
                
                return ;
            } else {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                
                    error(err);
                    
                });
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您的Touch ID 设置有问题" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                switch (err.code) {
                    case LAErrorAuthenticationFailed:
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            errorMsg(@"身份验证不成功,因为用户未能提供有效身份证件--->Authentication was not successful, because user failed to provide valid credentials");
                            errorMsg(@"身份验证不成功,因为用户未能提供有效身份证件");
                        });
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
//                            errorMsg(@"身份验证被用户取消--->Authentication was canceled by user(e.g. tapped Cancel button)");
                            errorMsg(@"身份验证被用户取消");
                            
                        });
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        error(NULL);
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
//                            otherClick(@"(主线程)认证被取消了,因为用户利用回退按钮(选择其它认证方式)--->Authentication was canceled, because the user tapped the fallback button(Enter Password)");
                            otherClick(@"(主线程)认证被取消了,因为用户利用回退按钮(选择其它认证方式)");
                            
                        });
                    }
                        break;
                    case LAErrorSystemCancel:
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            errorMsg(@"身份验证被系统取消了--->Authentication was canceled by system(e.g. another application went to foreground)");
                            errorMsg(@"身份验证被系统取消了");
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
//                        alert.message = @"您还没有设置密码输入";
                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            errorMsg(@"身份验证无法启动,因为密码没有设置在设备上--->Authentication could not start, because passcode is not set on the device");
                            errorMsg(@"身份验证无法启动,因为密码没有设置在设备上");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    {
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            alert.message = @"您的设备不支持指纹输入，请切换其他登录方式";
//                            errorMsg(@"身份验证无法启动,因为触摸ID不可用在设备上--->Authentication could not start, because Touch ID is not available on the device");
                            errorMsg(@"您的设备不支持指纹输入，请切换其他登录方式");
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    {
//                        alert.message = @"您还没有进行指纹输入，请先设定指纹后打开";
                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            errorMsg(@"身份验证无法启动,因为没有登记的手指触摸Touch ID--->Authentication could not start, because Touch ID has no enrolled fingers");
                            errorMsg(@"您还没有进行指纹输入，请先设定指纹后打开");
                        });
                    }
                        break;
                    default:
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            otherClick(@"(主线程)未知情况");
                            
                            if (enabled) {
                                
                                [context evaluatePolicy:APolicy localizedReason:promptMsg reply:^(BOOL success, NSError * _Nullable error) {}];
                                
                            }
                            
                        });
                        break;
                }
//                [alert show];
            }
        }];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您的Touch ID 设置有问题" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        
//        switch (errors.code) {
//            case LAErrorTouchIDNotEnrolled:
//                alert.message = @"您还没有进行指纹输入，请先设定指纹后打开";
//                break;
//            case  LAErrorTouchIDNotAvailable:
//                alert.message = @"您的设备不支持指纹输入，请切换其他登录方式";
//                break;
//            case LAErrorPasscodeNotSet:
//                alert.message = @"您还没有设置密码输入";
//                break;
//            default:
//                break;
//        }
//        [alert show];
    }
    
    
    
    //    LAContext* context = [[LAContext alloc] init];
    //
    //    if (otherMsg.length != 0) {
    //
    //        context.localizedFallbackTitle = otherMsg;
    //
    //    }
    //
    //
    //    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 10 ) {
    //
    ////        context.localizedCancelTitle = cancelMsg;
    //
    //    }
    //
    //
    //    //错误对象
    //    NSError *erro = nil;
    //
    //    NSInteger APolicy;
    //
    //    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 9 ) {
    //
    //        APolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    //
    //
    //    }else {
    //
    //        APolicy = LAPolicyDeviceOwnerAuthentication;
    //
    //    }
    //
    //
    //    NSInteger Policy;
    //    if (enabled) {
    //
    //        Policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    //
    //    }else {
    //
    //        Policy = LAPolicyDeviceOwnerAuthentication;
    //
    //    }
    //
    //    //首先使用canEvaluatePolicy 判断设备支持状态
    //    if ([context canEvaluatePolicy:APolicy error:&erro]) {
    //
    //
    //
    //        //支持指纹验证
    //        [context evaluatePolicy:Policy localizedReason:promptMsg reply:^(BOOL succe, NSError *err) {
    //
    //            if (succe) {
    //
    //                dispatch_sync(dispatch_get_main_queue(), ^{
    //
    //                    success(succe);
    //
    //                });
    //
    //                return ;
    //            }else {
    //
    //                dispatch_sync(dispatch_get_main_queue(), ^{
    //
    //                    error(err);
    //
    //                });
    //
    //                switch (err.code) {
    //                    case LAErrorAuthenticationFailed:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            errorMsg(@"身份验证不成功,因为用户未能提供有效身份证件--->Authentication was not successful, because user failed to provide valid credentials");
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorUserCancel:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //
    //                            errorMsg(@"身份验证被用户取消--->Authentication was canceled by user(e.g. tapped Cancel button)");
    //
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorUserFallback:
    //                    {
    //                        error(NULL);
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //
    //                            otherClick(@"(主线程)认证被取消了,因为用户利用回退按钮(选择其它认证方式)--->Authentication was canceled, because the user tapped the fallback button(Enter Password)");
    //
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorSystemCancel:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            errorMsg(@"身份验证被系统取消了--->Authentication was canceled by system(e.g. another application went to foreground)");
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorPasscodeNotSet:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            errorMsg(@"身份验证无法启动,因为密码没有设置在设备上--->Authentication could not start, because passcode is not set on the device");
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorTouchIDNotAvailable:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            errorMsg(@"身份验证无法启动,因为触摸ID不可用在设备上--->Authentication could not start, because Touch ID is not available on the device");
    //                        });
    //                    }
    //                        break;
    //                    case LAErrorTouchIDNotEnrolled:
    //                    {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            errorMsg(@"身份验证无法启动,因为没有登记的手指触摸Touch ID--->Authentication could not start, because Touch ID has no enrolled fingers");
    //                        });
    //                    }
    //                        break;
    //                    default:
    //
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //
    //                            otherClick(@"(主线程)未知情况");
    //
    //                            if (enabled) {
    //
    //                                [context evaluatePolicy:APolicy localizedReason:promptMsg reply:^(BOOL success, NSError * _Nullable error) {}];
    //
    //                            }
    //
    //                        });
    //                        break;
    //                }
    //            }
    //        }];
    //
    //    }else {
    //
    //        errorMsg([NSString stringWithFormat:@"此设备不支持Touch ID--->设备操作系统:%@---设备系统版本号:%@---设备型号:%@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] systemName], [DeviceInfo deviceVersion]]);
    //
    //    }
    
    
    //    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
    //            localizedReason:NSLocalizedString(@"Home键验证已有手机指纹", nil)
    //                      reply:^(BOOL success, NSError *error)
    //     {
    //         if (success)
    //         {
    //             NSLog(@"验证通过");
    //         }
    //         else
    //         {
    //             switch (error.code)
    //             {
    //
    //                 case LAErrorUserCancel:
    //                     //认证被用户取消.例如点击了 cancel 按钮.
    //                     NSLog(@"密码取消");
    //                     break;
    //
    //                 case LAErrorAuthenticationFailed:
    //                     // 此处会自动消失，然后下一次弹出的时候，又需要验证数字
    //                     // 认证没有成功,因为用户没有成功的提供一个有效的认证资格
    //                     NSLog(@"连输三次后，密码失败");
    //                     break;
    //
    //                 case LAErrorPasscodeNotSet:
    //                     // 认证不能开始,因为此台设备没有设置密码.
    //                     NSLog(@"密码没有设置");
    //                     break;
    //                     
    //                 case LAErrorSystemCancel:
    //                     //认证被系统取消了(例如其他的应用程序到前台了)
    //                     NSLog(@"系统取消了验证");
    //                     break;
    //                     
    //                 case LAErrorUserFallback:
    //                     //当输入觉的会有问题的时候输入
    //                     NSLog(@"登陆");
    //                     break;
    //                 case LAErrorTouchIDNotAvailable:
    //                     //认证不能开始,因为 touch id 在此台设备尚是无效的.
    //                     NSLog(@"touch ID 无效");
    //                     
    //                 default:
    //                     NSLog(@"您不能访问私有内容");
    //                     break;
    //             }
    //         }
    //     }];
}

@end