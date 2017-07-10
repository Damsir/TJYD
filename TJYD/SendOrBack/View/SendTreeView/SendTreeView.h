//
//  SendTreeView.h
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendPeopleSelectTableCell.h"
#import "SendPeopleCellModel.h"

typedef enum
{
    HaveSelectBtn,
    NoSelectBtn
} ChoseSelectBtn;

static NSString *headCellID = @"headCellID";
static NSString *rowCellID = @"rowCellID";

@class SendTreeView;

@protocol TreeDelegate <NSObject>

- (void)itemSelectInfo:(SendPeopleCellModel *)item;
- (void)itemSelectArray:(NSArray *)selectArray;

@end


@interface SendTreeView : UIView <SendPeopleTableCellDelegate>

@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger markNumber;
@property (nonatomic, assign) id<TreeDelegate> delegate;

@property (nonatomic, strong) NSDictionary       *peoplesDic;
@property (nonatomic, strong) KOTreeItem         *item0, *item1_1, *item1_1_1, *item1_1_1_1;
@property (nonatomic, strong) NSMutableArray     *treeItems;
@property (nonatomic, strong) NSMutableArray     *selectedTreeItems;
@property (nonatomic, strong) NSArray            *nodeArray;
@property (nonatomic, strong) NSMutableArray     *groups;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isClicked;

+ (SendTreeView *) instanceView;
- (SendTreeView *) initTreeWithFrame:(CGRect)rect dataArray:(NSArray *)nodeArray haveHiddenSelectBtn:(BOOL)isHidden haveHeadView:(BOOL)haveHeadView isEqualX:(BOOL)isEqualX isMultiSelect:(BOOL)isMultiSelect;

// 屏幕旋转
- (void)screenRotation;
@property (nonatomic,strong) NSMutableArray *oldModelArray;/**< 上一次选择的cell的model */

@end
