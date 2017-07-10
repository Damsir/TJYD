//
//  DistLoginValidate.h
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistLoginValidate : UIView

// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 加载/退出动画
- (void)fadeIn;
- (void)fadeOut;

- (void)screenRotation;

@end
