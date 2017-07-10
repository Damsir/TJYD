//
//  FeedbackView.m
//  TJYD
//
//  Created by 吴定如 on 17/6/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FeedbackView.h"
#import "DeviceInfo.h"
#import "ValidateManager.h"

@interface FeedbackView () <UITextViewDelegate>

@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,strong) UITextView *adviceTextView;
@property (nonatomic,strong) UIButton *anonymityButton;/**< 匿名 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消 */
@property (nonatomic,strong) UIButton *sendButton;/**< 立即发送 */
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *footLine;
@property (nonatomic,assign) NSInteger anonymity;

@end

@implementation FeedbackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //蒙版(自己)
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _anonymity = 1;
        [self createFeedbackView];
        
        //键盘唤起和隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [self createNotification];
    }
    return self;
}

#pragma mark -- 屏幕旋转
- (void)createNotification {
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- 监听屏幕旋转
- (void)screenRotation {
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _toolbar.frame = CGRectMake(0, self.frame.size.height-220, self.frame.size.width, 220);
    _adviceTextView.frame = CGRectMake(10, 10, self.frame.size.width-20, 120);
    _anonymityButton.frame = CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(_adviceTextView.frame)+5, 70, 30);
    // 取消,立即反馈
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    _cancelButton.frame = CGRectMake(10, CGRectGetMaxY(_anonymityButton.frame)+5, btn_W, 40);
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame)+10, _cancelButton.frame.origin.y, btn_W, 40);
}

- (void)createFeedbackView {
    
    // 背景
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-220, self.frame.size.width, 220)];
    toolbar.barStyle = UIBarStyleDefault;
    //toolbar.alpha = 0.9;
    toolbar.clipsToBounds = YES;
    _toolbar = toolbar;
    [self addSubview:toolbar];
    
    //  --- Feedback ---
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    //footView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    footView.backgroundColor = [UIColor whiteColor];
    _footView = footView;
    //[self addSubview:footView];
    
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    footLine.backgroundColor = GRAYCOLOR_MIDDLE;
    _footLine = footLine;
    //[footView addSubview:footLine];
    
    // 意见框
    UITextView *adviceTextView = [[UITextView alloc] init];
    adviceTextView.frame = CGRectMake(10, 10, self.frame.size.width-20, 120);
    adviceTextView.text = @"请输入反馈内容";
    adviceTextView.font = [UIFont systemFontOfSize:16.0];
    if ([adviceTextView.text isEqualToString:@"请输入反馈内容"])
    {
        adviceTextView.textColor = [UIColor lightGrayColor];
    }
//    adviceTextView.layer.borderWidth = 0.5;
//    adviceTextView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    adviceTextView.layer.cornerRadius = 3;
    adviceTextView.clipsToBounds = YES;
    adviceTextView.returnKeyType = UIReturnKeyDone;
    adviceTextView.tintColor = HOMEBLUECOLOR;
    adviceTextView.delegate = self;
    _adviceTextView = adviceTextView;
    [toolbar addSubview:adviceTextView];
    
    // 匿名按钮
    UIButton *anonymityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor = [UIColor orangeColor];
    anonymityButton.frame = CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(adviceTextView.frame)+5, 70, 30);
    [anonymityButton setTitle:@"匿名" forState:UIControlStateNormal];
    [anonymityButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [anonymityButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 50)];
    //    [anonymityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];
    anonymityButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [anonymityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [anonymityButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    _anonymityButton = anonymityButton;
    [toolbar addSubview:anonymityButton];
    
    // 取消,立即反馈
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    
    UIButton *cancelButton = [self createCustomButtonWithTitle:@"取消"];
    cancelButton.frame = CGRectMake(10, CGRectGetMaxY(anonymityButton.frame)+5, btn_W, 40);
    [cancelButton addTarget:self action:@selector(cancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    [toolbar addSubview:cancelButton];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"立即反馈"];
    sendButton.frame = CGRectMake(CGRectGetMaxX(cancelButton.frame)+10, cancelButton.frame.origin.y, btn_W, 40);
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    self.sendButton.enabled = NO;
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
    [toolbar addSubview:sendButton];
}

#pragma mark -- 匿名勾选与否
- (void)buttonOnclick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        _anonymity = 0;
    } else {
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        _anonymity = 1;
    }
}

#pragma mark -- 取消
- (void)cancelOnClick:(UIButton *)button {
    [self fadeOut];
}

#pragma mark -- 立即反馈
- (void)sendOnClick:(UIButton *)button {
    
    [self endEditing:YES];
    if (_sendOnClickBlock) {
        _sendOnClickBlock(_adviceTextView.text, _anonymity);
        [self fadeOut];
    }
}

- (void)showInView:(UIView *)superView animated:(BOOL)animated {
    
    [superView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

- (void)fadeIn {
    /**
     *  弹出动画
     */
    //    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    //    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
    _toolbar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 220);
    //self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:.45 animations:^{
        //        self.alpha = 1.0;
        //        self.transform = CGAffineTransformMakeScale(1, 1);
        //        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        //        _toolbar.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _toolbar.frame = CGRectMake(0, self.frame.size.height - 220, self.frame.size.width, 220);
        //self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)fadeOut {
    /**
     *  消失动画
     */
    
    [UIView animateWithDuration:.45 animations:^{
        self.backgroundColor = [UIColor clearColor];
        _toolbar.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 220);
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.alpha = 1.0;
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UITextView Delegate Methods
//点击键盘右下角的键收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_adviceTextView.text.length == 0) {
            _adviceTextView.textColor =[UIColor lightGrayColor];
            _adviceTextView.text = @"请输入反馈内容";
        } else {
            _adviceTextView.textColor = [UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"请输入反馈内容"]) {
        
        _adviceTextView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        _adviceTextView.textColor =[UIColor lightGrayColor];
        _adviceTextView.text = @"请输入反馈内容";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    // 删除空格符
    //_adviceTextView.text = [_adviceTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self judgeAdviceEnable];
}

#pragma mark -- 判断输入内容是否有效
- (void)judgeAdviceEnable {
    
    if (![_adviceTextView.text isEqualToString:@"请输入反馈内容"] && ![_adviceTextView.text isEqualToString:@""]) {
        
        self.sendButton.enabled = YES;
        self.sendButton.backgroundColor = HOMEBLUECOLOR;
        
    } else {
        
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }
}

// 键盘升起/隐藏
- (void)keyboardWillShow:(NSNotification *)noti {
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    //    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"1=====%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    if (SCREEN_HEIGHT <= 1024) {
        
        [UIView animateWithDuration:durtion animations:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
            CGRect toolbarFrame = _toolbar.frame;
            toolbarFrame.origin.y = SCREEN_HEIGHT==480? SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height+45 : SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height;
            _toolbar.frame = toolbarFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
//    [self createNotification];
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"2=====%f",keyboard_h);
    [UIView animateWithDuration:durtion animations:^{
        
        CGRect toolbarFrame = _toolbar.frame;
        toolbarFrame.origin.y = self.frame.size.height-220;
        _toolbar.frame = toolbarFrame;
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self fadeOut];
    [self endEditing:YES];
}

#pragma mark -- CustomButton
- (UIButton *)createCustomButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = HOMEBLUECOLOR;
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:Font_PingFangSC_Regular size:16.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 2.0;
    button.clipsToBounds = YES;
    
    return button;
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    
}

@end
