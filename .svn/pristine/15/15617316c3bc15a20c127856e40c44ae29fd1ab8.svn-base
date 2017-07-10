//
//  DistGestureLock.h
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistGestureLock : UIView

// 手势登录开启成功与否
@property(nonatomic,strong) void(^gestureOpenBlock)(BOOL isOpen);
// 手势登录验证成功与否
@property(nonatomic,strong) void(^gestureVerifyBlock)(BOOL isSuccess);

// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 加载/退出动画
- (void)fadeIn;
- (void)fadeOut;

// 手势的类型( 1:设置(更多)  2:验证(登录) )
@property (nonatomic,assign) NSInteger gestureType;

- (instancetype)initWithFrame:(CGRect)frame gestureType:(NSInteger)gestureType;
- (void)screenRotation;

@end
