//
//  DY_historyTableView.m
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DY_historyTableView.h"
#import "DY_searchHistoryDataBase.h"
#import "DY_historyListTableViewCell.h"
@implementation DY_historyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame: frame]) {
        self.historyArray =[NSMutableArray array];
        
        //从本地读取缓存的历史记录
        self.historyArray = [[DY_searchHistoryDataBase shareDataBase] readLocalArray];
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
        self.delegate =self;
        self.dataSource =self;
//        //隐藏tableView多余的线
//        [self setExtralCellLineHidden:self];
        [self reloadData];
    }
    return self;
    
}
////去掉tableView多余的分割线
//- (void)setExtralCellLineHidden:(UITableView *)tableView
//{
//    UIView  *view=[UIView alloc];
//    view.backgroundColor =[UIColor clearColor];
//    [tableView setTableFooterView:view];
//}


//添加一条历史记录
- (void)addHistoryWithString:(NSString *)string
{
    //先改变tableview的数据源
    if ([self.historyArray containsObject:string]){
        [self.historyArray removeObject:string];
        [self reloadData];
    }
    [self.historyArray insertObject:string atIndex:0];
    //界面插入单元格操作
    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    //存储新的数据源到本地,以保证下次打开程序有之前搜索的记录
    [[DY_searchHistoryDataBase shareDataBase] writeLocalWithDataArray:self.historyArray];
    [self reloadData];
    
}

//删除一条
- (void) deleteHistoryWithIndex:(NSInteger )index{
    if (index >=0 && index<self.historyArray.count) {
        [self.historyArray removeObjectAtIndex:index];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0] ]withRowAnimation:UITableViewRowAnimationLeft];
        [[DY_searchHistoryDataBase shareDataBase]writeLocalWithDataArray:self.historyArray];
        [self reloadData];
    }
    
    if (_deleteHistoryRecordBlock)
    {
        _deleteHistoryRecordBlock(YES);
    }
}
//删除全部
- (void)clearAllHistoryDatas
{
    
    [self.historyArray removeAllObjects];
    [[DY_searchHistoryDataBase shareDataBase]deleteLocalDataArray];
    [self reloadData];
    
    if (_deleteHistoryRecordBlock)
    {
        _deleteHistoryRecordBlock(YES);
    }
    
}


#pragma mark -tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *indentifierCell=@"identifier_history";

    DY_historyListTableViewCell *cell = [self dequeueReusableCellWithIdentifier:indentifierCell];
    if (cell == nil) {
        cell = [[DY_historyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierCell];
        [cell.deleteButton addTarget:self action:@selector(handleDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.deleteButton.tag = indexPath.row;
    
    if (indexPath.row>=0&&indexPath.row<self.historyArray.count) {
        cell.label.text = self.historyArray[indexPath.row];
    }

    
    return cell;  
    
}
//设置单元格的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//点击搜索记录并回调出去(选中某cell)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        DY_historyListTableViewCell *cell = (DY_historyListTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        
        if (self.selectHistoryCell) {
            self.selectHistoryCell(cell.label.text);
        }
    }
    
}

//设置分区header的title
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"历史记录";
//
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = GRAYCOLOR_LIGHT;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    lab.text = @"历史记录";
    [headView addSubview:lab];
    UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame)+5, 0, SCREEN_WIDTH-100-35, 30)];
    countLab.textColor =[UIColor darkGrayColor];
    countLab.font =[UIFont systemFontOfSize:12];
    countLab.textAlignment = NSTextAlignmentRight;
    countLab.text = [NSString stringWithFormat:@"共搜索到 %d 条结果",_searchResultCount];
    [headView addSubview:countLab];

    
    
    return headView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 7, SCREEN_WIDTH, 30);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearAllHistoryDatas) forControlEvents:UIControlEventTouchUpInside];
    if (self.historyArray.count!=0) {
        [btn setTitle:@"清空历史记录" forState:UIControlStateNormal];

        // 清空历史搜索按钮
//        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
        
//        UIButton *clearButton = [[UIButton alloc] init];
//        clearButton.frame = CGRectMake(60, 60, SCREEN_WIDTH- 120, 44);
//        [clearButton setTitle:@"清空历史搜索" forState:UIControlStateNormal];
//        [clearButton setTitleColor:[UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1] forState:UIControlStateNormal];
//        clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [clearButton addTarget:self action:@selector(clearAllHistoryDatas) forControlEvents:UIControlEventTouchDown];
//        clearButton.layer.cornerRadius = 3;
//        clearButton.layer.borderWidth = 0.5;
//        clearButton.layer.borderColor = [UIColor colorWithRed:242/256 green:242/256 blue:242/256 alpha:1].CGColor;
////        [footView addSubview:clearButton];
////        self.tabeleView.tableFooterView = footView;
//        return clearButton;
    }
    else
    {
        [btn setTitle:@"暂无历史记录" forState:UIControlStateNormal];
    }

    return btn;
   
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (self.historyArray.count == 0) {
//        return 0.0;
//    }
    return 44;
}

//点击删除按钮,删除历史记录
- (void)handleDeleteButton:(UIButton *)button
{
    [self deleteHistoryWithIndex:button.tag];
    
}

//开始拽tableview的时候隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.bgeinDraggingBlock)
    {//回调tableView滑动的回调
        self.bgeinDraggingBlock();
        
    }
}



@end
