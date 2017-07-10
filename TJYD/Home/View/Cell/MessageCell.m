//
//  MessageCell.m
//  TJYD
//
//  Created by 吴定如 on 17/5/23.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.Line.backgroundColor = GRAYCOLOR;
    // Configure the view for the selected state
}

@end
