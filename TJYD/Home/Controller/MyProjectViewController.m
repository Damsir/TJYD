//
//  MyProjectViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "MyProjectViewController.h"
#import "MyProjectCell.h"
#import "MyProjectModel.h"
#import "MyProjectDetailVC.h"

static NSString *cellId = @"MyProjectCell";

@interface MyProjectViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *searchArray;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,assign) BOOL isSearch;//标记搜索状态

@end

@implementation MyProjectViewController

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

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBarTitle:@"我的项目"];
    
    _pageIndex = 1;
    _pageSize = 10;
    _dataArray = [NSMutableArray array];
    _searchArray = [NSMutableArray array];
    
    [self creatTableView];
//    [self loadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

- (void)loadData {
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 我的项目
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==tongjiProcess/getProjectOfMyList.do?queryFilter=&pageIndex=%ld&pageSize=%ld,%@",(long)_pageIndex,_pageSize,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProjectOfMyList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            MyProjectModel *model = [[MyProjectModel alloc] initWithDictionary:[JsonDic objectForKey:@"result"]];
            for (MyListModel *listModel in model.list) {
                [_dataArray addObject:listModel];
            }
            DLog(@"model:%@",_dataArray);
            [self.tableView reloadData];
            // 加载更多
            BOOL loadMore = [JsonDic[@"result"][@"count"] integerValue] > _pageIndex * _pageSize;
            [self setLoadMoreData:loadMore];
            
            // 暂无数据
            _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

#pragma mark -- 设置上拉加载更多
- (void)setLoadMoreData:(BOOL)loadMore {
    
    if (loadMore) {
        // 上拉加载更多
        [self.tableView.footer resetNoMoreData];
    } else {
        // 没有更多数据
        //self.tableView.footer = nil;
        [self.tableView.footer noticeNoMoreData];
    }
}

- (void)creatTableView {
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    //设置输入颜色
    searchBar.tintColor = HOMEBLUECOLOR;
    //UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    //[searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    //设置背景颜色
    [searchBar setBarTintColor:[UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1]];
    searchBar.placeholder = @"搜索";
    searchBar.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0  blue:206/255.0  alpha:1.0].CGColor;
    searchBar.layer.borderColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1].CGColor;
    searchBar.layer.borderWidth = 0.5;
    searchBar.delegate = self;
    searchBar.clearsContextBeforeDrawing = YES;
    //searchBar.showsCancelButton = NO;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.returnKeyType = UIReturnKeySearch;
    //[searchBar sizeToFit];
    _searchBar = searchBar;
    
    
//    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStylePlain];
//    [tableView registerNib:[UINib nibWithNibName:@"MyProjectCell" bundle:nil] forCellReuseIdentifier:@"MyProjectCell"];
//    tableView.delegate =self;
//    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tableView registerNib:[UINib nibWithNibName:@"MyProjectCell" bundle:nil] forCellReuseIdentifier:@"MyProjectCell"];
//    self.tableView = tableView;
//    
//    [self.view addSubview:tableView];
//    tableView.tableHeaderView = searchBar;
    
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = searchBar;
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_isSearch) {
            // 搜索
            [_searchArray removeAllObjects];
            _pageIndex = 1;
            [self loadSearchData];
        } else {
            // 正常
            [_dataArray removeAllObjects];
            _pageIndex = 1;
            [self loadData];
        }
    }];
    // 上拉加载更多
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        if (_isSearch) {
            // 搜索
            [self loadSearchData];
        } else {
            // 正常
            [self loadData];
        }
    }];
    
    // 刷新一次
    [self.tableView.header setAutoChangeAlpha:YES];
    [self.tableView.header beginRefreshing];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _isSearch ? _searchArray.count : _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyProjectCell *projectCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    if (_isSearch) {
        if (_searchArray.count > indexPath.row) {
            
            MyListModel *model = _searchArray[indexPath.row];
            projectCell.activityName.text = [model.ACTIVITY_NAME isEqualToString:@""] ? model.PROJECTACCEPTMODE :  [NSString stringWithFormat:@"%@ · %@",model.PROJECTACCEPTMODE,model.ACTIVITY_NAME];
            projectCell.userRole.text = model.userRole;
            // PROJECTACCEPTMODE(1.招投标 2.直接委托 3.投标转委托) 判断显示是项目名称(1->PROJECTNAME)还是合同名称(2||3 ->HTMC)
            if ([model.PROJECTACCEPTMODE isEqualToString:@"招投标"]) {
                projectCell.title.text = model.PROJECTNAME;
            } else if ([model.PROJECTACCEPTMODE isEqualToString:@"直接委托"] || [model.PROJECTACCEPTMODE isEqualToString:@"投标转委托"]) {
                projectCell.title.text = model.HTMC;
            }
        }
    } else {
        
        if (_dataArray.count > indexPath.row) {
            
            MyListModel *model = _dataArray[indexPath.row];
            projectCell.activityName.text = [model.ACTIVITY_NAME isEqualToString:@""] ? model.PROJECTACCEPTMODE :  [NSString stringWithFormat:@"%@ · %@",model.PROJECTACCEPTMODE,model.ACTIVITY_NAME];
            projectCell.userRole.text = model.userRole;
            // PROJECTACCEPTMODE(1.招投标 2.直接委托 3.投标转委托) 判断显示是项目名称(1->PROJECTNAME)还是合同名称(2||3 ->HTMC)
            if ([model.PROJECTACCEPTMODE isEqualToString:@"招投标"]) {
                projectCell.title.text = model.PROJECTNAME;
            } else if ([model.PROJECTACCEPTMODE isEqualToString:@"直接委托"] || [model.PROJECTACCEPTMODE isEqualToString:@"投标转委托"]) {
                projectCell.title.text = model.HTMC;
            }
        }
    }

    return projectCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyProjectDetailVC *detailVC = [[MyProjectDetailVC alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.navi = self.navigationController;
    if (_isSearch) {
        detailVC.listModel = _searchArray[indexPath.row];
    } else {
        detailVC.listModel = _dataArray[indexPath.row];
    }
    
    [self pushToViewControllerWithTransition:detailVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
}

#pragma mark -- 返回
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

#pragma mark -- 开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    
    // 判断是否有数据
    _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
    // 上拉加载更多(重置)
    [self.tableView.footer resetNoMoreData];
    // 当前处于未编辑状态
    _isSearch = NO;
    [self.tableView reloadData];
}

#pragma mark -- 点击键盘上的search按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    _isSearch = YES;
    
    [_searchArray removeAllObjects];
    [self loadSearchData];
}

- (void)loadSearchData {
    
    [MBProgressHUD showMessage:@"正在搜索" toView:self.view];
    // 我的项目
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==tongjiProcess/getProjectOfMyList.do?queryFilter=%@&pageIndex=%ld&pageSize=%ld,%@",_searchBar.text,_pageIndex,_pageSize,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProjectOfMyList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            MyProjectModel *model = [[MyProjectModel alloc] initWithDictionary:[JsonDic objectForKey:@"result"]];
            for (MyListModel *listModel in model.list) {
                [_searchArray addObject:listModel];
            }
            NSLog(@"model:%@",_searchArray);
            [self.tableView reloadData];
            // 加载更多
            BOOL loadMore = [JsonDic[@"result"][@"count"] integerValue] > _pageIndex * _pageSize;
            [self setLoadMoreData:loadMore];
            
            // 暂无数据
            _searchArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
