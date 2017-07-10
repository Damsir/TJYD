//
//  SHCover.m
//  distmeeting
//
//  Created by songdan Ye on 15/11/18.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SHCover.h"

@implementation SHCover

// 设置浅灰色蒙板
- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
        self.backgroundColor = [UIColor clearColor];
    }
}
// 显示蒙板
+ (instancetype)show
{
    SHCover *cover = [[SHCover alloc] initWithFrame:[UIScreen mainScreen].bounds];

    cover.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    cover.alpha = 0.5; 
    [KeyWindow addSubview:cover];
    
    return cover;
}
// 点击蒙板的时候做事情
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 移除蒙板
    [self removeFromSuperview];
    
    // 通知代理移除菜单
    if ([_delegate respondsToSelector:@selector(coverDidClickCover:)]) {
        
        [_delegate coverDidClickCover:self];
        
    }
    
}



@end
