//
//  ProjectMaterialVC.m
//  TJYD
//
//  Created by 吴定如 on 17/4/13.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ProjectMaterialVC.h"
#import "ProjectMaterialCell.h"
#import "ProjectMaterialModel.h"
#import "FileViewController.h"

#define HeaderLineColor [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.2]

static NSString *cellId = @"ProjectMaterialCell";

@interface ProjectMaterialVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标

@end

@implementation ProjectMaterialVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)reloadData {
    
    [self loadData];
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    _markArray = [NSMutableArray array];
    _groupImgArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 项目附件(材料)
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==xmxx/material/tree.do?xmxxId=%@&applicationId=1&isFilter=1&pid=%@&isContractAgent=是,%@",_listModel.BID,_listModel.PID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetMaterial requestMethod:DistRequestMethodPost arguments:nil];
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
                ProjectMaterialModel *model = [[ProjectMaterialModel alloc] initWithDictionary:dic];
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
    return [mark isEqualToString:@"1"] ? [[_dataArray[section] children] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectMaterialCell *materialCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    MaterialChildrenModel *childrenModel = [_dataArray[indexPath.section] children][indexPath.row];
    
    [materialCell setMaterialCellWithModel:childrenModel];
    
    return materialCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MaterialChildrenModel *childrenModel = [_dataArray[indexPath.section] children][indexPath.row];
//    CGFloat cellHeight = [self GetCellHeightWithContent:[childrenModel name]];
//    
//    return cellHeight >= 44.0 ? cellHeight : 44.0;
    return 44.0;
}

- (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
//    return section == _dataArray.count-1 ? 0.0 : 10.0;
    return  0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ (%ld)",[_dataArray[section] name],[_dataArray[section] children].count];
}

// 尾部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    footView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
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
//    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    // 文件图标
    UIImageView *fileImage = [[UIImageView alloc] init];
    fileImage.frame = CGRectMake(15, 19/2.0, 25, 25);
    fileImage.image = [UIImage imageNamed:@"fileFolder"];
    [headView addSubview:fileImage];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fileImage.frame)+10, 0, SCREEN_WIDTH-95, 44)];
    title.font = [UIFont systemFontOfSize:15.0];
//    title.font = [UIFont boldSystemFontOfSize:15.0];
//    title.textColor = BLUECOLOR;
    [headView addSubview:title];
    
    // 打开,收缩图标
    UIImageView *groupImage = [[UIImageView alloc] init];
    groupImage.frame = CGRectMake(SCREEN_WIDTH-35, 29/2.0, 15, 15);
    groupImage.tag = section+1000;
    [headView addSubview:groupImage];
    
    title.text = [NSString stringWithFormat:@"%@ (%ld)",[_dataArray[section] name],[_dataArray[section] children].count];
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
    
    FileViewController *fileVC = [[FileViewController alloc] init];
    
    MaterialChildrenModel *model = [_dataArray[indexPath.section] children][indexPath.row];
    
    NSString *fileName = [NSString stringWithFormat:@"%@",model.name];
    NSString *ext = [NSString stringWithFormat:@"%@",model.type];
    
    // 附件(材料)下载
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==xmxx/material/download.do?mid=%@&xmxxId=%@&tid=%@,%@",model.realId,_listModel.BID,_listModel.TASK_ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    //NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==xmxx/material/download.do?mid=%@&xmxxId=%@&tid=%@,%@",model.realId,_listModel.BID,_listModel.TASK_ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    NSString *downloadUrl = [NSString stringWithFormat:@"%@MobileService/processingList/getDownload.do?params=%@",NetEnvironment,des];
    //NSString *downloadUrl = [NSString stringWithFormat:@"%@MobileService/processingList/getAnDownload.do?params=%@",NetEnvironment,des];
    DLog(@"downloadUrl:%@",downloadUrl);
    
    [fileVC openFile:fileName url:downloadUrl ext:ext fileSize:model.materialSize];
    
    [self.navi presentViewController:fileVC animated:YES completion:nil];
  //    [self pushToViewControllerWithTransition:fileVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
