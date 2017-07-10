//
//  FeedbackView.h
//  TJYD
//
//  Created by 吴定如 on 17/6/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackView : UIView

// 立即反馈按钮点击回调
@property(nonatomic,strong) void(^sendOnClickBlock)(NSString *content, NSInteger anonymity);
// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 加载/退出动画
- (void)fadeIn;
- (void)fadeOut;

- (void)screenRotation;

@end
