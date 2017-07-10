//
//  DamPeopleSelectTableCell.m
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamPeopleSelectTableCell.h"

#define KOCOLOR_FILES_TITLE [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] /*#665b53*/
#define KOCOLOR_FILES_TITLE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_FILES_COUNTER [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1] /
#define KOCOLOR_FILES_COUNTER_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35] /*#ffffff*/
#define KOFONT_FILES_TITLE [UIFont fontWithName:@"HelveticaNeue" size:13.0f]
#define KOFONT_FILES_COUNTER [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f]

@implementation DamPeopleSelectTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineView.frame = CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y - 0.5, self.lineView.frame.size.width, 0.5);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //self.lineView.frame = CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y - 0.5, self.lineView.frame.size.width, 0.5);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)selectPeople:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(treeTableViewCell:tapIconWithTreeItem:WithInfo:)]) {
        [self.delegate treeTableViewCell:self tapIconWithTreeItem:self.item WithInfo:self.treeNodeInfo];
    }
}

- (void)setSelect:(BOOL)select
{
    _select = select;
    if (_select) {
        [self.chooseButton setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
    }
    else{
        [self.chooseButton setImage:[UIImage imageNamed:@"ico_circle"] forState:UIControlStateNormal];
    }
}


@end
