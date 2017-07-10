//
//  RecaptionCell.m
//  TJYD
//
//  Created by 吴定如 on 17/4/24.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "RecaptionCell.h"

@implementation RecaptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sureRecaption.layer.cornerRadius = 2;
    self.sureRecaption.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
