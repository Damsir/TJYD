//
//  SingleWebView.m
//  TJYD
//
//  Created by 吴定如 on 17/6/29.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SingleWebView.h"

@implementation SingleWebView

+ (SingleWebView *)shareSingleWebView {
    
    static SingleWebView *wkWebView = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        wkWebView = [[SingleWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60)];
    });
    
    return wkWebView;
}

@end
