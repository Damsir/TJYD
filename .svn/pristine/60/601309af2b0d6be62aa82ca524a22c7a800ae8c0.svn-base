//
//  DistGestureLock.m
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistGestureLock.h"
#import "DistGestureView.h"


@interface DistGestureLock () <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property (nonatomic,strong) DistGestureView *gesView;
@property (nonatomic,strong) UIToolbar *toolbar;

@end

@implementation DistGestureLock {
    NSString *previousString;
    NSString *gesturePassWord;
    BOOL gestureOpen;
}

- (instancetype)initWithFrame:(CGRect)frame gestureType:(NSInteger)gestureType {
    
    self = [super initWithFrame:frame];
    if (self) {
        //蒙版(自己)
//        self.backgroundColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000];
//        self.backgroundColor = HOMETABLECOLOR;
//        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:247/255.0 alpha:1.000];
        _gestureType = gestureType;
        previousString = [NSString string];
        [self createDistGestureView];
        [self judgeResetOrVerify];
        
        // 监听登录成功移除手势界面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeGestureView:) name:@"loginSuccessfully" object:nil];
        
    }
    return self;
}

- (void)screenRotation {
    
    //    _toolbar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)createDistGestureView {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.clipsToBounds = YES;
    _toolbar = toolbar;
   [self addSubview:toolbar];

    
    
    //    // 创建需要的毛玻璃特效类型
    //    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    // 毛玻璃 视图
    //    UIVisualEffectView *toolbar = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //    //添加到要有毛玻璃特效的控件中
    //    toolbar.frame = CGRectMake(10, 0, self.frame.size.width - 20, 266);
    //    toolbar.layer.cornerRadius = 10;
    //    toolbar.clipsToBounds = YES;
    //    toolbar.alpha = 1.0;
    //    _toolbar = toolbar;
    //    [self addSubview:toolbar];
}

#pragma mark -- 判断重置手势密码还是验证手势密码
- (void)judgeResetOrVerify {
    
    gesturePassWord = [UserDefaults objectForKey:@"gesturePassWord"];
    if (gesturePassWord) {
        [self verify];
    } else {
        [self reset];
    }
}

- (void)showInView:(UIView *)superView animated:(BOOL)animated {
    [superView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

- (void)fadeIn {
    /**
     *  弹出动画
     */
    //    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //    self.alpha = 0.0;
    //    self.backgroundColor = [UIColor clearColor];
    //    _toolbar.frame = CGRectMake(10, self.frame.size.height, self.frame.size.width-20, 266);
    self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:.35 animations:^{
        //        self.alpha = 1.0;
        //        self.transform = CGAffineTransformMakeScale(1, 1);
        //        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        //        _toolbar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)fadeOut {
    /**
     *  消失动画
     */
    //    [UIView animateWithDuration:.45 animations:^{
    //        //        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //        //        self.alpha = 0.0;
    //        self.backgroundColor = [UIColor clearColor];
    //        _toolbar.frame = CGRectMake(10, self.frame.size.height, self.frame.size.width-20, 266);
    //    } completion:^(BOOL finished) {
    //        if (finished)
    //        {
    //            self.alpha = 1.0;
    //            [self removeFromSuperview];
    //        }
    //    }];
    [UIView animateWithDuration:.35 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma -- mark 验证手势密码
- (void)verify {
    
    _gesView = [[DistGestureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_gesView.touchView setVerificationDelegate:self];
    [_gesView.touchView setStyle:1];
    [_gesView setGesturePasswordDelegate:self];
    [_gesView.state setTextColor:[UIColor blackColor]];
    [_gesView.state setText:@"请输入手势密码"];
    [self addSubview:_gesView];
}

#pragma -- mark 重置手势密码
- (void)reset {
    
    _gesView = [[DistGestureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_gesView.touchView setResetDelegate:self];
    [_gesView.touchView setStyle:2];
    [_gesView setGesturePasswordDelegate:self];
    [_gesView.imgView setHidden:YES];
    [_gesView.welcome setHidden:YES];
    [_gesView.forgetButton setHidden:YES];
    [_gesView.changeButton setHidden:YES];
    [_gesView.state setTextColor:[UIColor blackColor]];
    [_gesView.state setText:@"请输入手势密码"];
    [self addSubview:_gesView];
}

#pragma mark --  改变手势密码
- (void)change {
}

#pragma mark --  重置手势密码
- (void)forget {
    if (_gesView) {
        // 密码验证成功,保存密码
        [UserDefaults setObject:nil forKey:@"gesturePassWord"];
        [UserDefaults synchronize];
        [_gesView removeFromSuperview];
    }
    _gestureType = 1;
    _gesView = [[DistGestureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_gesView.touchView setResetDelegate:self];
    [_gesView.touchView setStyle:2];
    [_gesView setGesturePasswordDelegate:self];
    [_gesView.imgView setHidden:YES];
    [_gesView.welcome setHidden:YES];
    [_gesView.forgetButton setHidden:YES];
    [_gesView.changeButton setHidden:YES];
    [_gesView.state setTextColor:[UIColor blackColor]];
    [_gesView.state setText:@"请输入手势密码"];
    [self addSubview:_gesView];
}

#pragma mark -- 退出手势界面
- (void)close {
    if (_gestureOpenBlock) {
        _gestureOpenBlock(YES);
    }
    [self fadeOut];
}

// 监听登录成功移除手势界面的通知
- (void)removeGestureView:(NSNotification *)noty {
    
    [self fadeOut];
}

#pragma mark -- 验证手势密码
- (BOOL)verification:(NSString *)result {
    
    if ([result isEqualToString:gesturePassWord]) {
        [_gesView.state setTextColor:HOMEGREENCOLOR];
        [_gesView.state setText:@"手势密码验证成功"];
        //[self presentViewController:(UIViewController) animated:YES completion:nil];
        if (_gestureOpenBlock) {
            _gestureOpenBlock(NO);
        }
        if (_gestureVerifyBlock) {
            _gestureVerifyBlock(YES);
        }
        self.userInteractionEnabled = NO;
        
        DLog(@"_gestureType:%ld",_gestureType);
        if (_gestureType == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = YES;
                [self fadeOut];
            });
        } else if (_gestureType == 2) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = YES;
//                [self fadeOut];
//            });
        }
        return YES;
    } else {
        if (_gestureOpenBlock) {
            _gestureOpenBlock(YES);
        }
        if (_gestureVerifyBlock) {
            _gestureVerifyBlock(NO);
        }
        [_gesView.state setTextColor:[UIColor redColor]];
        [_gesView.state setText:@"手势密码错误, 请重新输入"];
        return NO;
    }
}

#pragma mark -- 重置手势密码
- (BOOL)resetPassword:(NSString *)result {
    
    if ([previousString isEqualToString:@""]) {
        previousString = result;
        [_gesView.touchView enterArgin];
        [_gesView.state setTextColor:[UIColor blackColor]];
        [_gesView.state setText:@"请再次输入密码"];
        return YES;
    } else {
        if ([result isEqualToString:previousString]) {
            
            // 密码验证成功,保存密码
            [UserDefaults setObject:result forKey:@"gesturePassWord"];
            [UserDefaults synchronize];
            
            [_gesView.state setTextColor:HOMEGREENCOLOR];
            [_gesView.state setText:@"手势密码设置成功"];
            if (_gestureOpenBlock) {
                _gestureOpenBlock(YES);
            }
            self.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = YES;
                [self fadeOut];
            });
            return YES;
        } else {
            previousString = @"";
            [_gesView.state setTextColor:[UIColor redColor]];
            [_gesView.state setText:@"两次输入密码不一致, 请重新输入"];
            if (_gestureOpenBlock) {
                _gestureOpenBlock(NO);
            }
            return NO;
        }
    }
}

@end
