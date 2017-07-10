//
//  ComprehensiveVC.h
//  XAYD
//
//  Created by songdan Ye on 16/2/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_newSearchBar.h"
#import "DY_historyTableView.h"

@interface ComprehensiveVC : SHBaseViewController <DY_newSearchBarDelegate>

//自定义搜索框
@property (nonatomic,strong)DY_newSearchBar *searchBar;
//显示搜索历史记录列表
@property (nonatomic,strong)DY_historyTableView *historyTabelView;


@property (nonatomic,assign) int mode;
//搜索结果显示的tableView
@property (nonatomic,strong)UITableView *searchResultTabelView;
//搜索历史tableView
//@property (nonatomic,strong)UITableView *historyTableView;
//
@property (nonatomic,strong)NSArray *sResult ;
////搜索框
//@property (nonatomic,strong)UITextField *textField;
//所有数据
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
//搜索结果数据
@property (nonatomic,strong)NSMutableArray *searchSource;


@property (nonatomic,strong)NSMutableArray *hisData;

//
@property (nonatomic,strong)UIButton *loadBtn;
@property (nonatomic,strong)UILabel *tipLable;


@end
