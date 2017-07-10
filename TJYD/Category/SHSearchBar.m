//
//  SHSearchBar.m
//  XAYD
//
//  Created by songdan Ye on 16/2/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SHSearchBar.h"
#import "UIImage+Image.h"

@implementation SHSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 设置字体
        self.font = [UIFont systemFontOfSize:13];
        
        // 设置背景
        self.background = [UIImage imageWithStretchableName:@"searchbar_textfield_background"];
        
        // 设置左边的view
        [self setLeftView];
        
        // 设置右边的录音按钮
//        [self setRightView];
        
    }
    
    return self;
}

- (instancetype)init {
    // 设置frame
    CGFloat width = SCREEN_WIDTH - 60;
    CGFloat height = 30;
    CGFloat X = (SCREEN_WIDTH - width) * 0.5*0.5;
    CGFloat Y = 7;
    CGRect frame = CGRectMake(X, Y, width, height);
    
    return [self initWithFrame:frame];
}

// 设置左边的view
- (void)setLeftView {
    
    // initWithImage:默认UIImageView的尺寸跟图片一样
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    
    
    self.leftView = leftImageView;
    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
    self.leftViewMode = UITextFieldViewModeAlways;
}

// 设置右边的view
- (void)setRightView {
    // 创建按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"audio_nav_icon"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    // 将imageView宽度
//    rightButton.frame.size.width += 10;
    //居中
    rightButton.contentMode = UIViewContentModeCenter;
    
    
    self.rightView = rightButton;
    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
    self.rightViewMode = UITextFieldViewModeAlways;}



@end
