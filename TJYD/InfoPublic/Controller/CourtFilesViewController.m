//
//  CourtFilesViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/14.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "CourtFilesViewController.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"

static NSString *cellId = @"NewsCell";

@interface CourtFilesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation CourtFilesViewController

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
    
    _pageSize = 10;
    _pageIndex = 1;
    _dataArray = [NSMutableArray array];

    [self creatTableView];
    //    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
}

- (void)loadData {
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 院发文件
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==noticeInfo/getAllNoticeList.do?noticeStyle=YFWJ&pageIndex=%ld&pageSize=%ld&queryFilter=,%@",_pageIndex,_pageSize,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetAllNoticeList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            NewsModel *model = [[NewsModel alloc] initWithDictionary:[JsonDic objectForKey:@"result"]];
            for (NewsListModel *listModel in model.list) {
                [_dataArray addObject:listModel];
            }
            NSLog(@"model:%@",_dataArray);
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
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-50);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _pageIndex = 1;
        [self loadData];
    }];
    // 上拉加载更多
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex ++;
        [self loadData];
    }];
    
    [self.tableView.header setAutoChangeAlpha:YES];
    [self.tableView.header beginRefreshing];
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (_dataArray.count > indexPath.row) {
        
        NewsListModel *model = _dataArray[indexPath.row];
        newsCell.title.text = model.GSBT;
        newsCell.readCount.text = model.PERSON;
        newsCell.date.text = model.FBSJ;
    }
    return newsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
    newsDetailVC.newsListModel = _dataArray[indexPath.row];
    
    [self pushToViewControllerWithTransition:newsDetailVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
