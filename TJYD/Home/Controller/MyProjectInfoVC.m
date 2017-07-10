//
//  MyProjectInfoVC.m
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "MyProjectInfoVC.h"
#import "ProjectInfoCell.h"
#import "ProjectInfoModel.h"

#define HeaderLineColor [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.2]

static NSString *cellId = @"ProjectInfoCell";

@interface MyProjectInfoVC() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *bottomImage;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标


@end

@implementation MyProjectInfoVC

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
    
    [self createTableView];
    [self createBottomView];
    [self loadData];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _bottomImage.frame = CGRectMake(0, SCREEN_HEIGHT-64-50-60, SCREEN_WIDTH, 60);
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    _backButton.frame = CGRectMake(10, 10, btn_W, 40);
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_backButton.frame)+10, _backButton.frame.origin.y, btn_W, 40);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    _markArray = [NSMutableArray array];
    _groupImgArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 表单详情
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    // UTF-8编码
    //    [ticket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==ApprpveMobile/getProcessedForm.do?xmxxId=%@,%@",_listModel.ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProcessedForm requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *result = [JsonDic objectForKey:@"result"];
            for (int i=0; i<result.count; i++)
            {
                NSString *mark = @"";
                NSString *image = @"";
                mark = i == 0 ? @"1" : @"0";
                image = @"shousuo";
                [_markArray addObject:mark];
                [_groupImgArray addObject:image];
            }
            
            for (NSDictionary *dic in result) {
                ProjectInfoModel *model = [[ProjectInfoModel alloc] initWithDictionary:dic];
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

#pragma mark -- 底部保存,发送视图

- (void)createBottomView {
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.frame = CGRectMake(0, SCREEN_HEIGHT-64-50-60, SCREEN_WIDTH, 60);
    bottomImage.image = [UIImage imageNamed:@"project_bottom"];
    bottomImage.userInteractionEnabled = YES;
    _bottomImage = bottomImage;
//    [self.view addSubview:bottomImage];
    
    // 保存,发送,回退
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    
    UIButton *backButton = [self createCustomButtonWithTitle:@"回退"];
    backButton.frame = CGRectMake(10, 10, btn_W, 40);
    [backButton addTarget:self action:@selector(backOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _backButton = backButton;
    [bottomImage addSubview:backButton];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"发送"];
    sendButton.frame = CGRectMake(CGRectGetMaxX(backButton.frame)+10, backButton.frame.origin.y, btn_W, 40);
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    [bottomImage addSubview:sendButton];
    
}

#pragma mark -- 回退

- (void)backOnClick:(UIButton *)saveButton
{
    
}

#pragma mark -- 发送

- (void)sendOnClick:(UIButton *)sendButton
{
    
}

- (void)createTableView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-50);
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
    ProjectInfoModel *infoModel = _dataArray[indexPath.section];
    ProjectListModel *listModel = infoModel.list[indexPath.row];
    infoCell.title.text = listModel.label;
    infoCell.detailTitle.text = listModel.value;
    // 选择框
    infoCell.selectImage.hidden = YES;
    
    return infoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectListModel *listModel = [_dataArray[indexPath.section] list][indexPath.row];
    CGFloat cellHeight = [self GetCellHeightWithContent:[listModel value]];
    
    return cellHeight >= 44.0 ? cellHeight : 44.0;
}

- (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0;
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
    
    title.text = [_dataArray[section] name];
    groupImage.image = [UIImage imageNamed:_groupImgArray[section]];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
