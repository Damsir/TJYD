//
//  PersonnelViewController.m
//  TJYD
//
//  Created by 吴定如 on 2017/3/13.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "PersonnelViewController.h"
#import "ProjectCell.h"
#import "PersonnelModel.h"
#import "ProjectDetailVC.h"//项目详情

static NSString *cellId = @"ProjectCell";

@interface PersonnelViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation PersonnelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //    [self.tableView.header setAutoChangeAlpha:YES];
    //    [self.tableView.header beginRefreshing];
}

- (void)reloadData {
    [self loadData];
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

#pragma mark -- 取回表单成功
- (void)goBackFormSuccess:(NSNotification *)noty {
    
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatTableView];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-50);
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 待办事项(项目)
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==KingdeeDocking/getUnProcessAssign.do,%@",ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetUnProcessAssign requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            for (NSDictionary *dic in [JsonDic objectForKey:@"result"]) {
                PersonnelModel *model = [[PersonnelModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            DLog(@"model:%@",_dataArray);
            // 暂无数据
            _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
                
            }];
        }
        [self.tableView reloadData];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

#pragma mark -- 创建表格和搜索框
- (void)creatTableView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-49-50);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCell *projectCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (_dataArray.count > indexPath.row) {
        
        PersonnelModel *model = _dataArray[indexPath.row];
        projectCell.title.text = model.subject;
        projectCell.businessName.text = model.sender;
        projectCell.date.text = model.createdTime;
        projectCell.image.image = [UIImage imageNamed:@"personnel"];
    }
    
    return projectCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
