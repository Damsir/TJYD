//
//  ProjectInfoVC.m
//  TJYD
//
//  Created by 吴定如 on 17/4/12.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ProjectInfoVC.h"
#import "ProjectInfoCell.h"
#import "ProjectInfoModel.h"
#import "SignViewController.h"
#import "BackViewController.h"
#import "FormSingleLogin.h"

#define HeaderLineColor [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.2]

static NSString *cellId = @"ProjectInfoCell";

@interface ProjectInfoVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *bottomImage;
@property (nonatomic,strong) UIButton *signButton;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property (nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property (nonatomic,strong) SignViewController *signVC ;
@property (nonatomic,assign) NSInteger number;
@end

@implementation ProjectInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)reloadData {
    
    _dataArray = [NSMutableArray array];
    _markArray = [NSMutableArray array];
    _groupImgArray = [NSMutableArray array];
    
    self.tableView.hidden = YES;
    // 表单的单点登录
    [self singleLoginWebView];
    [self loadData];
    [self judgeButtonEnable];
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
    
//    [self.signVC removeFromParentViewController];
//    self.signVC = nil;
    DLog(@"销毁...11111");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
    [self createBottomView];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}


- (void)singleLoginWebView {
    
    //DefineWeakSelf(weakSelf);
    // 表单单点登录
    [FormSingleLogin singleLoginActionWithSuccess:^(BOOL success) {
        if (success) {
            
            DLog(@"BPM单点登录成功");
            if (!_signVC) {
                _signVC = [[SignViewController alloc] init];
            }
            _signVC.listModel = self.listModel;
            _signVC.navi = self.navi;
            //_signVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [_signVC reloadData];
            
            /*
            // 登录成功
            NSString *URL = [NSString stringWithFormat:@"http://116.236.160.182:9081/teamworks/fauxRedirect.lsw?zWorkflowState=1&coachDebugTrace=none&zResetContext=true&zTaskId=%@&iscontractagent=是",_listModel.TASK_ID];
            // 4.表单信息
            [DamNetworkingManager GETWithUrl:URL andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
                
               // NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSLog(@"responseString4:%@",responseString);
                //                NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
                //[_web loadRequest:[NSURLRequest requestWithURL:Response.URL]];
                //                [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.236.160.182:9083/AppCenter/dist/views/mobileForm.html"]]];
                //[_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.236.160.182:9083/AppCenter/dist/views/proxy.html"]]];
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                NSString *DateTime = [formatter stringFromDate:date];
        
            } andFailBlock:^(NSError *error) {
                
            }];
             */
            
        } else {
            DLog(@"BPM单点登录失败");
        }
    }];
}


#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _bottomImage.frame = CGRectMake(0, SCREEN_HEIGHT-64-50-60, SCREEN_WIDTH, 60);
    _signButton.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 40);
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    _backButton.frame = CGRectMake(10, 10, btn_W, 40);
    _signButton.frame = CGRectMake(CGRectGetMaxX(_backButton.frame)+10, 10, btn_W, 40);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50-60);
    
}

- (void)loadData {
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 表单详情
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    // UTF-8编码
    //    [ticket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==ApprpveMobile/getForm.do?pid=%@&instanceid=%@&activity_name=%@&businessname=%@,%@",_listModel.PID,_listModel.INSTANCEID,_listModel.ACTIVITY_NAME,_listModel.BUSINESSNAME,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetForm requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *result = [JsonDic objectForKey:@"result"];
            
            // 回退件,显示回退意见
            if (![_listModel.backto isEqualToString:@""] && _listModel.backto != nil) {
                ProjectInfoModel *model = [[ProjectInfoModel alloc] init];
                model.name = @"回退件";
                model.list = [NSMutableArray array];
                ProjectListModel *listModel = [[ProjectListModel alloc] init];
                listModel.label = @"回退意见:";
                listModel.value = _listModel.opinion;
                [model.list addObject:listModel];
                [_dataArray addObject:model];
            }
            
            for (NSDictionary *dic in result) {
                ProjectInfoModel *model = [[ProjectInfoModel alloc] initWithDictionary:dic];
                [_dataArray addObject:model];
            }
            
            for (int i=0; i<_dataArray.count; i++) {
                NSString *mark = @"";
                NSString *image = @"";
                // 区分是否有回退意见的情况
                _dataArray.count > result.count ? (mark = (i == 0 || i == 1) ? @"1" : @"0") : (mark = i == 0 ? @"1" : @"0");
                image = @"shousuo";
                [_markArray addObject:mark];
                [_groupImgArray addObject:image];
            }
            
            NSLog(@"model:%@",_dataArray);
            self.tableView.hidden = NO;
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

#pragma mark -- 底部保存,发送视图
- (void)createBottomView {
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.frame = CGRectMake(0, SCREEN_HEIGHT-64-50-60, SCREEN_WIDTH, 60);
    bottomImage.image = [UIImage imageNamed:@"project_bottom"];
    bottomImage.userInteractionEnabled = YES;
    _bottomImage = bottomImage;
    [self.view addSubview:bottomImage];
    
    
    // 回退,审核按钮
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    
    UIButton *backButton = [self createCustomButtonWithTitle:@"回退"];
    backButton.frame = CGRectMake(10, 10, btn_W, 40);
    [backButton addTarget:self action:@selector(backOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _backButton = backButton;
    [bottomImage addSubview:backButton];
    
    UIButton *signButton = [self createCustomButtonWithTitle:@"审核"];
    signButton.frame = CGRectMake(CGRectGetMaxX(backButton.frame)+10, 10, btn_W, 40);
    [signButton addTarget:self action:@selector(signOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _signButton = signButton;
    [bottomImage addSubview:signButton];
}

- (void)judgeButtonEnable {
    
    _backButton.backgroundColor = HOMEBLUECOLOR;
    _backButton.enabled = YES;
    _signButton.backgroundColor = HOMEBLUECOLOR;
    _signButton.enabled = YES;
    
    
    /**
     *  isdelete:是否为第一个环节的项目(1:是  0:不是) -> 是的话,不能发送,回退.
     */
    if ([_listModel.isdelete isEqualToString:@"1"]) {
        _backButton.backgroundColor = [UIColor lightGrayColor];
        _backButton.enabled = NO;
        _signButton.backgroundColor = [UIColor lightGrayColor];
        _signButton.enabled = NO;
    }
    /**
     *  ACTIVITY_NAME:校审单扫描件上传 , 不能发送.
     */
    if ([_listModel.ACTIVITY_NAME isEqualToString:@"校审单扫描件上传"]) {
        //        backButton.backgroundColor = [UIColor lightGrayColor];
        //        backButton.enabled = NO;
        _signButton.backgroundColor = [UIColor lightGrayColor];
        _signButton.enabled = NO;
    }
}

#pragma mark -- 回退
- (void)backOnClick:(UIButton *)backButton {
    
    BackViewController *backVC = [[BackViewController alloc] init];
    backVC.listModel = self.listModel;
    backVC.navi = self.navi;
    
    [self pushToViewControllerWithTransition:backVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
}

#pragma mark -- 签字
- (void)signOnClick:(UIButton *)signButton {
    
//        SignViewController *signVC = [[SignViewController alloc] init];
//        signVC.listModel = self.listModel;
//        signVC.navi = self.navi;
    
    if (_signVC) {
        [self pushToViewControllerWithTransition:_signVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
    }
}

- (void)createTableView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-50-60);
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1];
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
    return [mark isEqualToString:@"1"] ? [[_dataArray[section] list] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (_dataArray.count > indexPath.section) {
        ProjectInfoModel *infoModel = _dataArray[indexPath.section];
        ProjectListModel *listModel = infoModel.list[indexPath.row];
        infoCell.selectImage.hidden = YES;
        
        if ([listModel.style isEqualToString:@"1"]) {
            // 小表单样式
            infoCell.title.textColor = BLUECOLOR;
            infoCell.detailTitle.textColor = BLUECOLOR;
        } else if ([listModel.label isEqualToString:@"回退意见:"]) {
            // 回退意见
            infoCell.title.textColor = [UIColor redColor];
            infoCell.detailTitle.textColor = [UIColor redColor];
        } else {
            // 原始样式
            infoCell.title.textColor = [UIColor blackColor];
            infoCell.detailTitle.textColor = [UIColor blackColor];
        }
        // 勾选框
        if ([listModel.style isEqualToString:@"2"]) {
            infoCell.selectImage.hidden = NO;
        }
        
        infoCell.title.text = listModel.label;
        infoCell.detailTitle.text = listModel.value;
    }
    
    return infoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataArray.count > indexPath.section) {
        ProjectListModel *listModel = [_dataArray[indexPath.section] list][indexPath.row];
        CGFloat labelHeight = [self GetCellLabelHeightWithContent:[listModel label]];
        CGFloat valueHeight = [self GetCellValueHeightWithContent:[listModel value]];
        CGFloat cellHeight = (labelHeight > valueHeight) ? labelHeight : valueHeight;
        return cellHeight >= 44.0 ? cellHeight : 44.0;
    }
    
    return 44.0;
}

- (CGFloat)GetCellValueHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

- (CGFloat)GetCellLabelHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height + 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([_listModel.backto isEqualToString:@""] || _listModel.backto == nil) {
        return 44.0;
    } else {
        return section == 0 ? 0.0 : 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == _dataArray.count-1 ? 0.0 : 10.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataArray[section] name];
}

// 尾部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    footView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    footView.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1];
    
    return footView;
}

// 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    headView.tag = section;
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-60, 44)];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = BLUECOLOR;
    [headView addSubview:title];
    
    UIImageView *groupImage = [[UIImageView alloc] init];
    groupImage.frame = CGRectMake(CGRectGetMaxX(headView.frame)-35, 29/2.0, 15, 15);
    groupImage.tag = section+1000;
    [headView addSubview:groupImage];
    
    if (_dataArray.count > section) {
        title.text = [_dataArray[section] name];
        groupImage.image = [UIImage imageNamed:_groupImgArray[section]];
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
