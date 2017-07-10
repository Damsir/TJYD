//
//  DamTreeView.h
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DamPeopleSelectTableCell.h"
#import "DamPeopleCellModel.h"


typedef enum
{
    HaveSelectBtn,
    NoSelectBtn
}ChoseSelectBtn;

static NSString *headCellID = @"headCellID";
static NSString *rowCellID = @"rowCellID";

@class DamTreeView;

@protocol TreeDelegate <NSObject>

- (void)itemSelectInfo:(DamPeopleCellModel *)item;
- (void)itemSelectArray:(NSArray *)selectArray;

@end


@interface DamTreeView : UIView <DamPeopleTableCellDelegate>

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
@property (nonatomic, assign) BOOL   isSelect;
@property (nonatomic, assign) BOOL isClicked;

+ (DamTreeView *) instanceView;
- (DamTreeView *) initTreeWithFrame:(CGRect)rect dataArray:(NSArray *) nodeArray haveHiddenSelectBtn:(BOOL)isHidden haveHeadView:(BOOL)haveHeadView isEqualX:(BOOL)isEqualX;

// 屏幕旋转
- (void)screenRotation;

@end
