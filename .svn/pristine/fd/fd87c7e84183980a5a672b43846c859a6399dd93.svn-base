//
//  TreeViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/14.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeModel.h"
#import "TreeCell.h"

#define HeaderLineColor [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.2]

static NSString *cellId = @"TreeCell";

@interface TreeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源

@end

@implementation TreeViewController

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
    
    [self initNavigationBarTitle:@"项目关联"];
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
    // 判断 1.待办事项 2.我的项目
    NSString *utf8Str = @"";
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    if (_listModel) {
        utf8Str = [[NSString stringWithFormat:@"action==projectManage/getProjectRelation.do?mode=%@&xmxxId=%@,%@",_listModel.PROJECTACCEPTMODE,_listModel.BID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else if (_myListModel) {
        utf8Str = [[NSString stringWithFormat:@"action==projectManage/getProjectRelation.do?mode=%@&xmxxId=%@,%@",_myListModel.PROJECTACCEPTMODE,_myListModel.ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 项目关联
    NSString *des = [DES encryptUseDES:utf8Str key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProjectRelation requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSDictionary *result = [JsonDic objectForKey:@"result"];
            TreeModel *model = [[TreeModel alloc] initWithDictionary:result];
            for (RelationModel *relationModel in model.rows) {
                [_dataArray addObject:relationModel];
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TreeCell *treeCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    treeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > indexPath.row) {
        RelationModel *model = _dataArray[indexPath.row];
        treeCell.title.text = model.PROJECTNAME;
    }
    
    return treeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RelationModel *model = _dataArray[indexPath.row];
    CGFloat cellHeight = [self GetCellHeightWithContent:model.PROJECTNAME];
    
    return cellHeight >= 44.0 ? cellHeight : 44.0;
}

- (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return rect.size.height + 4.0;
}


#pragma mark -- 返回
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
