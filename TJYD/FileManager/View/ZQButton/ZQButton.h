//
//  ZQButton.h
//  ZQButton
//
//  Created by xiao on 14-6-26.
//  Copyright (c) 2014年 zhique. All rights reserved.
//
#import "NSString+FontAwesome.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ZQButton : UIButton

@property (nonatomic, strong) NSString *title;
@property (nonatomic) UIColor *clickFadeColor;
@property (nonatomic) BOOL isClicked;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *normalImage;

//
- (void)setbuttonTitle:(NSString *)title fontSize:(CGFloat)size fontStyle:(NSString *)style fontColor:(UIColor*)titleColor Alignment:(NSInteger)alignment;
- (void)buttonClickedAnimation:(BOOL)animation WithFadeColor:(UIColor *)fadeColor;

//layer
- (void)setButtonBorderWith:(CGFloat)borderWidth borderColor:(UIColor*)color cornerRadius:(CGFloat)radius;
- (void)setButtonShadow:(UIColor *)shadowColor shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opacity;

//
- (void)pretendClick;   //失败
//copy from Oskar Groth on 2013-09-29.

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
- (void)bootstrapStyle;
- (void)defaultStyle;
- (void)primaryStyle;
- (void)successStyle;
- (void)infoStyle;
- (void)warningStyle;
- (void)dangerStyle;
@end
