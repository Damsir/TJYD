//
//  SendPeopleSelectTableCell.h
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeNodeInfo.h"

@class KOTreeItem;
@class SendPeopleSelectTableCell;

typedef enum
{
    CellType_Department, // 目录
    CellType_Group       //细节、具体信息
}CellType;

@protocol SendPeopleTableCellDelegate <NSObject>

- (void)treeTableViewCell:(SendPeopleSelectTableCell *)cell tapIconWithTreeItem:(id)item WithInfo:(RATreeNodeInfo *)treeNodeInfo;

@end

@interface SendPeopleSelectTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;     /**<选择按钮*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;        /**<Cell标题*/
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;/**<右侧蓝色箭头*/
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (assign, nonatomic) BOOL select;
@property (strong, nonatomic) id item;                           /**<相当于cell的indexPath*/
@property (strong, nonatomic) RATreeNodeInfo *treeNodeInfo;      /**<树的节点信息*/
@property (assign, nonatomic) id <SendPeopleTableCellDelegate> delegate;

- (IBAction)selectPeople:(UIButton *)sender;//选人方法

// 约束 (选择按钮)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButton_left;

@end
