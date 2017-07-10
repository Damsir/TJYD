//
//  TreeCell.m
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "TreeCell.h"

@implementation TreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.spot.layer.cornerRadius = 5/2.0;
    self.spot.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
