//
//  UIView+Message.m
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "UIView+Message.h"

@implementation UIView (Message)

+ (void)showMessage:(NSString *)message {
    
    CGFloat width = [self GetCellHeightWithContent:message];
    CGFloat message_w = width > 150 ? width : 150;
    message_w = message_w < SCREEN_WIDTH-40 ? message_w : SCREEN_WIDTH-40;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, message_w, 40)];
    toolbar.center = [UIApplication sharedApplication].keyWindow.center;
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.layer.cornerRadius = 3;
    toolbar.alpha = 1.0;
    toolbar.clipsToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:toolbar];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, message_w, 40)];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont fontWithName:Font_PingFangSC_Regular size:16.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = message;
    [toolbar addSubview:messageLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            toolbar.alpha = 0.0;
        } completion:^(BOOL finished) {
            [toolbar removeFromSuperview];
            [messageLabel removeFromSuperview];
        }];
    });
}

+ (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 40.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    return rect.size.width + 20;
}

@end
