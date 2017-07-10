//
//  UIViewController+Animation.h
//  GZYD
//
//  Created by 吴定如 on 17/3/3.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 请求接口区分 */
typedef NS_ENUM (NSInteger, AnimationDirection){
    
    AnimationDirectionLeft ,/** 动画方向(左边) */
    AnimationDirectionRight ,/** 动画方向(右边) */
    AnimationDirectionTop,/** 动画方向(顶部) */
    AnimationDirectionBottom ,/** 动画方向(底部) */
};

@interface UIViewController (Animation)

- (void)pushWebViewWithURL:(NSString *)URL;/**< 网页push动画效果 */
- (void)pushToViewControllerWithTransition:(UIViewController *)viewController animationDirection:(AnimationDirection)direction type:(BOOL)loginBool superNavi:(UINavigationController *)superNavi; /**< 控制器push动画效果 */
- (void)popToViewControllerWithDirection:(AnimationDirection)direction type:(BOOL)loginBool superNavi:(UINavigationController *)superNavi; /**< 控制器pop动画效果 */

@end
