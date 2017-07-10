//
//  BusinessCell.m
//  iPortal
//
//  Created by xiao on 14-11-27.
//  Copyright (c) 2014年 sh. All rights reserved.
//

#import "BusinessCell.h"

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            ((UIView *)[subView.subviews firstObject]).backgroundColor = [UIColor colorWithRed:98.0/255 green:183.0/255.0 blue:254.0/255 alpha:1.0];
        }
    }
}

- (void)data:(NSDictionary *)data{
    self.lblGuysName.text = [data objectForKey:@"code"];
    self.lblTime.text = [data objectForKey:@"time"];
    self.lblBusinessName.text = [data objectForKey:@"title"];
}


/*          //以下是 ios6 的处理方法
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    NSLog(@"table view cell willTransitionToState ");
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
            NSLog(@"按钮的子视图的类名:%@", NSStringFromClass([subview class]));
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
            // 这里把出现的按钮的上级视图的底色，设置成这个cell的底色相同。不会像原来的这么突兀。
                NSLog(@"进来了");
                subview.superview.backgroundColor = self.contentView.backgroundColor ;
            }
            if ([NSStringFromClass([subview class]) isEqualToString:@"UIView"]) {
                
            }else{
                
            }
        }
    }
}*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
