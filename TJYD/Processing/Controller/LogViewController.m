//
//  LogViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/14.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "LogViewController.h"
#import "LogCell.h"
#import "LogModel.h"

static NSString *cellId = @"LogCell";

@interface LogViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标

@end

@implementation LogViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self initNavigationBarTitle:@"流转日志"];
    [self createTableView];
    [self loadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    _markArray = [NSMutableArray array];
    _groupImgArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 判断 1.待办事项 2.我的项目
    NSString *utf8Str = @"";
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    if (_listModel) {
        utf8Str = [[NSString stringWithFormat:@"action==projectHead/getProjectOperateLog.do?isChiefengineer=%@&isContractAgent=%@&isContractDivide=%@&xmId=%@,%@",_listModel.ISCHIEFENGINEER,_listModel.ISCONTRACTAGENT,_listModel.ISCONTRACTDIVIDE,_listModel.BID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else if (_myListModel) {
        utf8Str = [[NSString stringWithFormat:@"action==projectHead/getProjectOperateLog.do?isChiefengineer=%@&isContractAgent=%@&isContractDivide=%@&xmId=%@,%@",_myListModel.ischiefengineer,_myListModel.ISCONTRACTAGENT,_myListModel.CONTRACTDIVIDE,_myListModel.ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    // 流转日志
    NSString *des = [DES encryptUseDES:utf8Str key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProjectOperateLog requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *result = [JsonDic objectForKey:@"result"];
            for (int i=0; i<result.count; i++)
            {
                NSString *mark = @"";
                NSString *image = @"";
                mark = @"1";
                image = @"zhankai";
                [_markArray addObject:mark];
                [_groupImgArray addObject:image];
            }
            
            for (NSDictionary *dic in result) {
                LogModel *model = [[LogModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            NSLog(@"model:%@",_dataArray);
            [self.tableView reloadData];
            
            // 暂无数据
            _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
}

- (void)createTableView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *mark = _markArray[section];
    return [mark isEqualToString:@"1"] ? [[_dataArray[section] logList] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LogCell *logCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    logCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > indexPath.section) {
        
        LogListModel *listModel = [_dataArray[indexPath.section] logList][indexPath.row];
        logCell.date.text = listModel.starttime;
        logCell.log.text = listModel.content;
        if (indexPath.section == _dataArray.count-1 && indexPath.row == [_dataArray[indexPath.section] logList].count-1) {
            logCell.spot.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f];
        } else {
            logCell.spot.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    return logCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LogListModel *listModel = [_dataArray[indexPath.section] logList][indexPath.row];
    CGFloat cellHeight = [self GetCellHeightWithContent:[listModel content]];
    
    return cellHeight >= 63.0 ? cellHeight : 63.0;
}

- (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return rect.size.height + 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@",[_dataArray[section] BUSINESSNAME]];
}

// 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    headView.tag = section;
    headView.backgroundColor = HOMETABLECOLOR;
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    //    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    // 文件图标
    UIImageView *fileImage = [[UIImageView alloc] init];
    fileImage.frame = CGRectMake(15, 24/2.0, 20, 20);
    fileImage.image = [UIImage imageNamed:@"log"];
    [headView addSubview:fileImage];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fileImage.frame)+10, 0, SCREEN_WIDTH-90, 44)];
    title.font = [UIFont systemFontOfSize:15.0];
    //    title.font = [UIFont boldSystemFontOfSize:15.0];
    //    title.textColor = BLUECOLOR;
    [headView addSubview:title];
    
    // 打开,收缩图标
    UIImageView *groupImage = [[UIImageView alloc] init];
    groupImage.frame = CGRectMake(SCREEN_WIDTH-35, 29/2.0, 15, 15);
    groupImage.tag = section+1000;
    [headView addSubview:groupImage];
    
    title.text = [NSString stringWithFormat:@"%@",[_dataArray[section] BUSINESSNAME]];;
    //    groupImage.image = [UIImage imageNamed:_groupImgArray[section]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}

- (void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    
    //    UIImageView *groupImage = (UIImageView *)[tapView viewWithTag:tapView.tag+1000];
    //    NSLog(@"tag: %ld, %@",(long)image.tag,btn);
    
    NSString *mark = _markArray[tapView.tag];
    if ([mark isEqualToString:@"0"]) {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
        [UIView animateWithDuration:0.35 animations:^{
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
        }];
    } else {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        [UIView animateWithDuration:0.35 animations:^{
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"shousuo"];
            
        }];
    }
    
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- 返回主页
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
