//
//  ContactsPickerView.m
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactsPickerView.h"

@interface ContactsPickerView ()

@property(nonatomic,strong) UIView *dateBackView;
@property(nonatomic,strong) UIButton *cornetButton;
@property(nonatomic,strong) UIButton *phoneButton;
@property(nonatomic,strong) UIButton *cancelButton;

@end

@implementation ContactsPickerView

- (instancetype)initWithFrame:(CGRect)frame withMobilePhone:(NSString *)mobilePhone {
    self = [super initWithFrame:frame];
    if (self) {
        
        //监听屏幕旋转的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
        //蒙版(自己)
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _mobilePhone = mobilePhone;
        [self createPikerView];
        
    }
    return self;
}

- (void)screenRotation
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _dateBackView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
}

- (void)createPikerView
{
    //大的背景view
    UIView *dateBackView = [[UIView alloc] init];
    dateBackView.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 135);
    dateBackView.backgroundColor = [UIColor whiteColor];
    _dateBackView = dateBackView;
    [self addSubview:dateBackView];
    
    CGFloat btn_w = SCREEN_WIDTH - 40;
//    // 短号
//    UIButton *cornetButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cornetButton.frame = CGRectMake(20,20,btn_w,30);
//    [cornetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cornetButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:199/255.0 blue:150/255.0 alpha:1.000];
//    cornetButton.layer.cornerRadius = 15;
//    cornetButton.clipsToBounds = YES;
//    [cornetButton setTitle:[NSString stringWithFormat:@"短号 %@", _model.dh] forState:UIControlStateNormal];
//    cornetButton.tag = 666;
//    [cornetButton addTarget:self action:@selector(selectedEvent:) forControlEvents:UIControlEventTouchUpInside];
//    _cornetButton = cornetButton;
//    [dateBackView addSubview:cornetButton];
    
    // 手机号
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(20, 20, btn_w, 40);;
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:199/255.0 blue:150/255.0 alpha:1.000];
    phoneButton.layer.cornerRadius = 20;
    phoneButton.clipsToBounds = YES;
    [phoneButton setTitle:[NSString stringWithFormat:@"手机号 %@", _mobilePhone] forState:UIControlStateNormal];
    phoneButton.tag = 777;
    [phoneButton addTarget:self action:@selector(selectedEvent:) forControlEvents:UIControlEventTouchUpInside];
    _phoneButton = phoneButton;
    [dateBackView addSubview:phoneButton];
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, CGRectGetMaxY(phoneButton.frame) + 15, btn_w, 40);
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:199/255.0 blue:150/255.0 alpha:1.000];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.clipsToBounds = YES;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    [dateBackView addSubview:cancelButton];
}

#pragma mark -- 确定选择事件

- (void)selectedEvent:(UIButton *)button
{
    if (_selectedBlock)
    {
        NSString *selectPhone = @"";
        switch (button.tag) {
            case 777:
                selectPhone = _mobilePhone;
                break;
            default:
                break;
        }
        _selectedBlock(selectPhone);
        [self fadeOut];
    }
    
}
 #pragma mark -- 取消选择事件

- (void)cancelSelect
{
    [self fadeOut];
}

- (void)showInView:(UIView *)superView animated:(BOOL)animated
{
    [superView addSubview:self];
    if (animated)
    {
        [self fadeIn];
    }
}

- (void)fadeIn
{
    /**
     *  弹出动画
     */
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)fadeOut
{
    /**
     *  消失动画
     */
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark -- touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [self fadeOut];
}


@end