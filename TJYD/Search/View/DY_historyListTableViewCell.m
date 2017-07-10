//
//  DY_historyListTableViewCell.m
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DY_historyListTableViewCell.h"

@implementation DY_historyListTableViewCell

///**
// * 创建cell
// */
//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    NSString *indentify = @"meetingID";
//    
//    DY_historyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
//    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"DY_historyListTableViewCell" owner:nil options:nil] lastObject];
//    }
//    
//    return cell;
//}

//
//- (void)setMemsModel:(SHMembers *)memsModel
//{
//    
//    self.subNameL.layer.cornerRadius = self.subNameL.bounds.size.width/2;
//    self.subNameL.layer.masksToBounds = YES;
//    
//    _memsModel = memsModel;
//    NSLog(@"%@",memsModel.name);
//    
//    self.name.text =memsModel.name;
//    NSString *fullName = memsModel.name;
//    NSString *firstName =[fullName substringToIndex:1];
//    self.subNameL.text =firstName;
//    self.phoneNumber.text =memsModel.phoneNumber;
//    
//    
//}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame =CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.label =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-100, self.frame.size.height)];
        self.label.backgroundColor =[UIColor clearColor];
        self.label.textColor =[UIColor blackColor];
        self.label .font =[UIFont systemFontOfSize:15];
        [self addSubview:self.label];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        self.deleteButton.backgroundColor =[UIColor clearColor];
        [self addSubview:self.deleteButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(238.0, 238.0, 238.0);
        _lineView = lineView;
        [self addSubview:_lineView];
        
        
        
        
    }
    return self;

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.label.frame = CGRectMake(20, 0, self.frame.size.width-self.frame.size.height-30, self.frame.size.height);
    self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-self.frame.size.height-10, 0, self.frame.size.height, self.frame.size.height);
    
    
     self.lineView.frame = CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1);
    
    
}



@end
