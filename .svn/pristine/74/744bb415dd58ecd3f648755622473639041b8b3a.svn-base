//
//  ContactsPickerView.h
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsPickerView : UIView

// 日期选择后的回调
@property(nonatomic,strong) void(^selectedBlock)(NSString *content);

// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 退出/退出动画
- (void)fadeIn;
- (void)fadeOut;

@property (nonatomic,strong) NSString *mobilePhone;

- (instancetype)initWithFrame:(CGRect)frame withMobilePhone:(NSString *)mobilePhone;



//- (void)screenRotation;

@end
