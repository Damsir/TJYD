//
//  DY_historyTableView.h
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击历史记录cell, 回调该条历史记录
typedef void(^SelectHistoryCell)(NSString *string);
//回调滑动tableView的实际,用户弹回键盘并看到更多内容
typedef void(^BegainDraggingBlock)() ;
@interface DY_historyTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
//数据源
@property (nonatomic,strong)NSMutableArray *historyArray;


@property (nonatomic,copy) SelectHistoryCell selectHistoryCell;

@property (nonatomic,copy) BegainDraggingBlock bgeinDraggingBlock;

//添加一条历史记录
- (void)addHistoryWithString:(NSString *)string;
// 搜索到的结果数量
@property(nonatomic,assign) NSInteger searchResultCount;


@property(nonatomic,strong) void(^deleteHistoryRecordBlock)(BOOL isDeleteHistory);

@end
