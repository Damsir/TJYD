//
//  UIViewController+Animation.m
//  GZYD
//
//  Created by 吴定如 on 17/3/3.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "UIViewController+Animation.h"

static float AnimationTime = 0.5f;

@implementation UIViewController (Animation)

- (void)pushWebViewWithURL:(NSString *)URL {
    
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:viewCon.view.bounds];
    webView.backgroundColor = [UIColor redColor];
    [viewCon.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [webView loadRequest:request];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void)pushToViewControllerWithTransition:(UIViewController *)viewController animationDirection:(AnimationDirection)direction type:(BOOL)loginBool superNavi:(UINavigationController *)superNavi{
    
//    CATransition * animation = [CATransition animation];
//    if (loginBool) {
//        animation.type = @"oglFlip";
//    } else {
//        animation.type = kCATransitionReveal;
//    }
//    animation.duration = AnimationTime;
//    if ([direction isEqualToString:@"left"]) {
//        animation.subtype = kCATransitionFromLeft;
//    } else if ([direction isEqualToString:@"right"]) {
//        animation.subtype = kCATransitionFromRight;
//    } else if ([direction isEqualToString:@"top"]) {
//        animation.subtype = kCATransitionFromTop;
//        //animation.type = kCATransitionFromTop;
//    } else if ([direction isEqualToString:@"bottom"]) {
//        animation.subtype = kCATransitionFromBottom;
//        //animation.type = kCATransitionFromBottom;
//    }
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
////    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
////    [self.navigationController pushViewController:viewController animated:NO];
//    [superNavi.view.layer addAnimation:animation forKey:@"animation"];
//    [superNavi pushViewController:viewController animated:NO];

    CATransition * animation = [CATransition animation];
    if (loginBool) {
        animation.type = @"oglFlip";
    } else {
        animation.type = kCATransitionReveal;
    }
    animation.duration = AnimationTime;
    switch (direction) {
            /** 动画方向(左边) */
        case AnimationDirectionLeft:
            animation.subtype = kCATransitionFromLeft;
            break;
            /** 动画方向(右边) */
        case AnimationDirectionRight:
            animation.subtype = kCATransitionFromRight;
            break;
            /** 动画方向(顶部) */
        case AnimationDirectionTop:
            animation.subtype = kCATransitionFromTop;
            break;
            /** 动画方向(底部) */
        case AnimationDirectionBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [superNavi.view.layer addAnimation:animation forKey:@"123"];
    [superNavi pushViewController:viewController animated:NO];
}

- (void)popToViewControllerWithDirection:(AnimationDirection)direction type:(BOOL)loginBool superNavi:(UINavigationController *)superNavi{
    
//    CATransition * animation = [CATransition animation];
//    if (loginBool) {
//        /*
//         cube、rippleEffect、suckEffect、oglFlip、pageCurl、pageUnCurl、cameraIrisHollowOpen、cameraIrisHollowClose
//         */
//        animation.type = @"oglFlip";
//    } else {
//        animation.type = kCATransitionReveal;
//    }
//    animation.duration = AnimationTime;
//    if ([direction isEqualToString:@"left"]) {
//        animation.subtype = kCATransitionFromLeft;
//    } else if ([direction isEqualToString:@"right"]) {
//        animation.subtype = kCATransitionFromRight;
//    } else if ([direction isEqualToString:@"top"]) {
//        animation.subtype = kCATransitionFromTop;
//    } else if ([direction isEqualToString:@"bottom"]) {
//        animation.subtype = kCATransitionFromBottom;
//    }
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
////    [self.navigationController.view.layer addAnimation:animation forKey:@"123"];
////    [self.navigationController popViewControllerAnimated:NO];
//    [superNavi.view.layer addAnimation:animation forKey:@"animation"];
//    [superNavi popViewControllerAnimated:NO];
    
    CATransition * animation = [CATransition animation];
    if (loginBool) {
        /*
         cube、rippleEffect、suckEffect、oglFlip、pageCurl、pageUnCurl、cameraIrisHollowOpen、cameraIrisHollowClose
         */
        animation.type = @"oglFlip";
    } else {
        animation.type = kCATransitionReveal;
    }
    animation.duration = AnimationTime;
    switch (direction) {
            /** 动画方向(左边) */
        case AnimationDirectionLeft:
            animation.subtype = kCATransitionFromLeft;
            break;
            /** 动画方向(右边) */
        case AnimationDirectionRight:
            animation.subtype = kCATransitionFromRight;
            break;
            /** 动画方向(顶部) */
        case AnimationDirectionTop:
            animation.subtype = kCATransitionFromTop;
            break;
            /** 动画方向(底部) */
        case AnimationDirectionBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [superNavi.view.layer addAnimation:animation forKey:@"456"];
    [superNavi popViewControllerAnimated:NO];
}

@end
