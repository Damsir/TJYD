//
//  BackTreeView.h
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendPeopleSelectTableCell.h"
#import "BackPeopleCellModel.h"

typedef enum
{
    HaveSelectBtn,
    NoSelectBtn
} ChoseSelectBtn;

static NSString *headCellID = @"headCellID";
static NSString *rowCellID = @"rowCellID";

@class BackTreeView;

@protocol TreeDelegate <NSObject>

- (void)itemSelectInfo:(BackPeopleCellModel *)item;
- (void)itemSelectArray:(NSArray *)selectArray;

@end


@interface BackTreeView : UIView <SendPeopleTableCellDelegate>

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

+ (BackTreeView *) instanceView;
- (BackTreeView *) initTreeWithFrame:(CGRect)rect dataArray:(NSArray *) nodeArray haveHiddenSelectBtn:(BOOL)isHidden haveHeadView:(BOOL)haveHeadView isEqualX:(BOOL)isEqualX;

// 屏幕旋转
- (void)screenRotation;

@end
