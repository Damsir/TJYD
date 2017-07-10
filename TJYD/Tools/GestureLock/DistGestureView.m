//
//  DistGestureView.m
//  GesturePassword
//
//  Created by 吴定如 on 17/4/11.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistGestureView.h"
#import "DistGesButton.h"
#import "Global.h"

@implementation DistGestureView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGFloat ges_width = 270;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-270/2, frame.size.height/2-270/2+50, ges_width, ges_width)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = ges_width/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            DistGesButton *gesButton = [[DistGesButton alloc] initWithFrame:CGRectMake(col*distance+margin, margin+row*distance, size, size)];
            [gesButton setTag:i];
            [view addSubview:gesButton];
            [buttonArray addObject:gesButton];
        }
        frame.origin.y = 0;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        _touchView = [[DistGesTouchView alloc] initWithFrame:view.frame];
        [_touchView setButtonArray:buttonArray];
        [_touchView setTouchBeginDelegate:self];
        [self addSubview:_touchView];
        
        _welcome = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-50, 30, 100, 30)];
        [_welcome setTextColor:[UIColor whiteColor]];
        [_welcome setText:@"欢迎登录"];
        [_welcome setTextAlignment:NSTextAlignmentCenter];
        [_welcome setFont:[UIFont boldSystemFontOfSize:16.f]];
//        [self addSubview:_welcome];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-50, frame.size.height/2-ges_width/2-30-70, 100, 30)];
        //        _state.backgroundColor = [UIColor orangeColor];
        [_name setTextColor:[UIColor blackColor]];
        [_name setText:[UserDefaults objectForKey:@"name"]];
        [_name setTextAlignment:NSTextAlignmentCenter];
        [_name setFont:[UIFont boldSystemFontOfSize:18.f]];
        [self addSubview:_name];
        
        _state = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2-ges_width/2-30, frame.size.width, 30)];
//        _state.backgroundColor = [UIColor orangeColor];
        [_state setTextAlignment:NSTextAlignmentCenter];
        [_state setFont:[UIFont systemFontOfSize:16.f]];
        [self addSubview:_state];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-30, frame.size.height/2-ges_width/2-30-70, 60, 60)];
        [_imgView setBackgroundColor:[UIColor whiteColor]];
        [_imgView.layer setCornerRadius:35];
        [_imgView.layer setBorderColor:[UIColor grayColor].CGColor];
        [_imgView.layer setBorderWidth:3];
        [_imgView setImage:[UIImage imageNamed:@"logo"]];
//        [self addSubview:_imgView];
        
        _closebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        //    closebutton.backgroundColor = [UIColor orangeColor];
        _closebutton.frame = CGRectMake(frame.size.width/2, frame.size.height-60, frame.size.width/2, 30);
//        _closebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_closebutton setImage:[[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_closebutton setTitle:@"取消" forState:UIControlStateNormal];
        [_closebutton setTintColor:[UIColor blackColor]];
        [_closebutton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closebutton];
        
        _forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _forgetButton.frame = CGRectMake(0, frame.size.height-60, frame.size.width/2, 30);
//        _forgetButton.backgroundColor = [UIColor redColor];
//        _forgetButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_forgetButton setTitle:@"重置密码" forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_forgetButton];
        
        _changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeButton.frame = CGRectMake(frame.size.width-140, frame.size.height-60, 120, 30);
//        _changeButton.backgroundColor = [UIColor redColor];
        [_changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeButton setTitle:@"修改手势密码" forState:UIControlStateNormal];
        _changeButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:_changeButton];
        
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect {
//    // Drawing code 背景
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
//        3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(rgb);
//    CGContextDrawLinearGradient(context, gradient,CGPointMake(0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),kCGGradientDrawsBeforeStartLocation);
//}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

- (void)forget {
    [_gesturePasswordDelegate forget];
}

- (void)change {
    [_gesturePasswordDelegate change];
}

- (void)close {
    [_gesturePasswordDelegate close];
}

@end

