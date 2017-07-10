//
//  ContactsViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/3/31.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ContactsViewController.h"
#import "DamTreeView.h"
#import "ContactsPickerView.h"
#import "DeviceInfo.h"
#import "DamPeopleSelectTableCell.h"

static NSString *cellId = @"DamPeopleSelectTableCell";

@interface ContactsViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,TreeDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isEditing;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property (nonatomic,strong) DamTreeView *DamtreeView;//树形表格

@end

@implementation ContactsViewController

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
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0  blue:206/255.0  alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    [self initNavigationBarTitle:@"通讯录"];
    
    [self createTableViewAndSearchBar];
    [self loadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    if (_isEditing) {
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_tableView reloadData];
//        _DamtreeView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//        [_DamtreeView screenRotation];
    } else {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//        _tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
        _DamtreeView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
        [_DamtreeView screenRotation];
    }
}

#pragma mark -- 创建 tableView && SearchBar
- (void)createTableViewAndSearchBar {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
//    tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    [self.view addSubview:tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    //设置输入颜色
    searchBar.tintColor = HOMEBLUECOLOR;
    //UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    //[searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    [searchBar setBackgroundImage:[UIImage new]];
    //设置背景颜色
    [searchBar setBarTintColor:[UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1]];
    searchBar.placeholder = @"搜索";
    searchBar.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0  blue:206/255.0  alpha:1.0].CGColor;
    searchBar.layer.borderColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1].CGColor;
    searchBar.layer.borderWidth = 0.5;
    searchBar.clipsToBounds = YES;
    searchBar.delegate = self;
    searchBar.clearsContextBeforeDrawing = YES;
    //searchBar.showsCancelButton = NO;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    //[searchBar sizeToFit];
    _searchBar = searchBar;
    
    [self.view addSubview:_searchBar];
    
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    _searchArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 获取通讯录
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==ApprpveMobile/getOrgAndUser.do,%@",ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetContacts requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *users = [JsonDic objectForKey:@"result"];
            DamTreeView *treeView = [[DamTreeView instanceView] initTreeWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) dataArray:users haveHiddenSelectBtn:NO haveHeadView:NO isEqualX:NO];
            treeView.delegate = self;
            treeView.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
            _DamtreeView = treeView;
            [self.view addSubview:treeView];
            
            // 解析,筛选数据人员列表
            [self filterUser:users];
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
}

#pragma mark -- DamTreeViewDelegate
- (void)itemSelectInfo:(DamPeopleCellModel *)item {
    
    DLog(@"DamPeopleCellModel::%@",item);
    DamPeopleCellModel *peopleModel = item;
    
    // 拨打电话
    [self callMobilePhoneWithModel:peopleModel];
}

- (void)itemSelectArray:(NSArray *)selectArray {
    
    NSLog(@"selectArray::%@",selectArray);
}

#pragma mark -- tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _isSearch ? _searchArray.count : _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DamPeopleSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lineView_up.hidden = YES;
    cell.arrowImageView.hidden = YES;
    
    DamPeopleCellModel *model;
    if (_isSearch) {
        model = _searchArray[indexPath.row];
    } else {
        model = _dataArray[indexPath.row];
    }
    cell.titleLabel.text = model.name;
    cell.mobilePhone.text = [NSString stringWithFormat:@"手机号: %@",model.mobilePhone];
    cell.fixedPhone.text = [model.fixedPhone isEqualToString:@""] ? @"": [NSString stringWithFormat:@"固话: %@",model.fixedPhone];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    // 拨打电话
    if (_isSearch) {
        [self callMobilePhoneWithModel:_searchArray[indexPath.row]];
    } else {
        [self callMobilePhoneWithModel:_dataArray[indexPath.row]];
    }
}

#pragma mark -- 拨打电话事件
- (void)callMobilePhoneWithModel:(DamPeopleCellModel *)peopleModel {
    
    // 提示：不要将webView添加到self.view，如果添加会遮挡原有的视图
    // 懒加载
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    
    // 判断设备能否打电话
    if(!([[DeviceInfo deviceModel] isEqualToString:@"iPod touch"]||[[DeviceInfo deviceModel] isEqualToString:@"iPad"]||[[DeviceInfo deviceModel] isEqualToString:@"iPhone Simulator"])){
        
        // 选择拨打手机号
        if (![peopleModel.mobilePhone isEqualToString:@""] && peopleModel.mobilePhone != nil) {
            
            ContactsPickerView *pickerView = [[ContactsPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withMobilePhone:peopleModel.mobilePhone];
            // 拨打电话
            pickerView.selectedBlock = ^(NSString *phoneNumber)
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                [_webView loadRequest:request];
            };
            
            [pickerView showInView:self.view.window.rootViewController.view animated:YES];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 先清空原来的搜索结果
    [_searchArray removeAllObjects];
    
    NSString *searchString = searchBar.text;
    //删除空格符
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    for (DamPeopleCellModel *model in _dataArray)
    {
        if ([model.name rangeOfString:searchString].location != NSNotFound || [model.mobilePhone rangeOfString:searchString].location != NSNotFound || [model.fixedPhone rangeOfString:searchString].location != NSNotFound || [model.loginName rangeOfString:searchString].location != NSNotFound)
        {
            [_searchArray addObject:model];
        }
    }
    if (searchText.length == 0) {
        _isSearch = NO;
    }else {
        _isSearch = YES;
    }
    [_tableView reloadData];
}

#pragma mark -- 开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // 当前处于编辑状态
    _isEditing = YES;
    _DamtreeView.hidden = YES;
    _tableView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        _searchBar.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _searchBar.showsCancelButton = YES;
        // 状态栏颜色
        [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleDefault;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        // 状态栏颜色
        [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
        self.navigationController.navigationBarHidden = NO;
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        _tableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
    }];
    
    // 当前处于未编辑状态
    _isEditing = NO;
    _DamtreeView.hidden = NO;
    _tableView.hidden = YES;
    
    [_tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
//    // 当前处于未编辑状态
//    _isEditing = NO;
//    
//    _DamtreeView.hidden = NO;
//    _tableView.hidden = YES;
}

#pragma mark -- 筛选人员列表
- (void)filterUser:(NSArray *)nodeArray {
    
    //根据自己的的数据源进行解析
    NSMutableArray *mutableOne = [[NSMutableArray alloc] init];
    for (int i = 0; i < nodeArray.count; i ++)
    {
        NSArray *modelOneArray = [[nodeArray objectAtIndex:i] valueForKey:@"children"];
        NSMutableArray *mutabletwo = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < modelOneArray.count; j ++)
        {
            NSArray *modelTwoArray = [[modelOneArray objectAtIndex:j] valueForKey:@"children"];
            NSMutableArray *mutableThree = [[NSMutableArray alloc] init];
            for (int k = 0; k < modelTwoArray.count; k ++)
            {
                NSArray *modelThreeArray = [[modelTwoArray objectAtIndex:k] valueForKey:@"children"];
                
                if (modelThreeArray.count == 0)
                {
                    DamPeopleCellModel *modelFour = [DamPeopleCellModel dataObjectWithNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"] MOBILEPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"LOGINNAME"] ID:[[modelTwoArray objectAtIndex:k] valueForKey:@"ID"] PARENTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"PARENTID"] SORTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"SORTID"] DATATYPE:[[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"] children:nil];
                    modelFour.Id = [[modelTwoArray objectAtIndex:k] valueForKey:@"ID"];
                    modelFour.name = [[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"];
                    modelFour.mobilePhone = [[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"];
                    modelFour.dataType = [[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"];
                    
                    [mutableThree addObject:modelFour];
                    //  筛选人员数据
                    if ([modelFour.dataType isEqualToString:@"user"]) {
                        [_dataArray addObject:modelFour];
                    }
                } else {
                    NSMutableArray *mutableFour = [[NSMutableArray alloc] init];
                    for (int l = 0; l < modelThreeArray.count; l ++)
                    {
                        DamPeopleCellModel *modelFour = [DamPeopleCellModel dataObjectWithNAME:[[modelThreeArray objectAtIndex:l] valueForKey:@"NAME"] MOBILEPHONE:[[modelThreeArray objectAtIndex:l] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelThreeArray objectAtIndex:l] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelThreeArray objectAtIndex:l] valueForKey:@"LOGINNAME"] ID:[[modelThreeArray objectAtIndex:l] valueForKey:@"ID"] PARENTID:[[modelThreeArray objectAtIndex:l] valueForKey:@"PARENTID"] SORTID:[[modelThreeArray objectAtIndex:l] valueForKey:@"SORTID"] DATATYPE:[[modelThreeArray objectAtIndex:l] valueForKey:@"DATATYPE"] children:nil];
                        modelFour.Id = [[modelThreeArray objectAtIndex:l] valueForKey:@"ID"];
                        modelFour.name = [[modelThreeArray objectAtIndex:l] valueForKey:@"NAME"];
                        modelFour.mobilePhone = [[modelThreeArray objectAtIndex:l] valueForKey:@"MOBILEPHONE"];
                        modelFour.dataType = [[modelThreeArray objectAtIndex:l] valueForKey:@"DATATYPE"];
                        [mutableFour addObject:modelFour];
                        // 筛选人员数据
                        if ([modelFour.dataType isEqualToString:@"user"]) {
                            [_dataArray addObject:modelFour];
                        }
                    }
                    DamPeopleCellModel *modelThree = [DamPeopleCellModel dataObjectWithNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"] MOBILEPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"LOGINNAME"] ID:[[modelTwoArray objectAtIndex:k] valueForKey:@"ID"] PARENTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"PARENTID"] SORTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"SORTID"] DATATYPE:[[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"] children:mutableFour];
                    [mutableThree addObject:modelThree];
                }
            }
            DamPeopleCellModel *modelTwo = [DamPeopleCellModel dataObjectWithNAME:[[modelOneArray objectAtIndex:j] valueForKey:@"NAME"] MOBILEPHONE:[[modelOneArray objectAtIndex:j] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelOneArray objectAtIndex:j] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelOneArray objectAtIndex:j] valueForKey:@"LOGINNAME"] ID:[[modelOneArray objectAtIndex:j] valueForKey:@"ID"] PARENTID:[[modelOneArray objectAtIndex:j] valueForKey:@"PARENTID"] SORTID:[[modelOneArray objectAtIndex:j] valueForKey:@"SORTID"] DATATYPE:[[modelOneArray objectAtIndex:j] valueForKey:@"DATATYPE"] children:mutableThree];
            [mutabletwo addObject:modelTwo];
        }
        DamPeopleCellModel *modelOne = [DamPeopleCellModel dataObjectWithNAME:[[nodeArray objectAtIndex:i] valueForKey:@"NAME"] MOBILEPHONE:[[nodeArray objectAtIndex:i] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[nodeArray objectAtIndex:i] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[nodeArray objectAtIndex:i] valueForKey:@"LOGINNAME"] ID:[[nodeArray objectAtIndex:i] valueForKey:@"ID"] PARENTID:[[nodeArray objectAtIndex:i] valueForKey:@"PARENTID"] SORTID:[[nodeArray objectAtIndex:i] valueForKey:@"SORTID"] DATATYPE:[[nodeArray objectAtIndex:i] valueForKey:@"DATATYPE"] children:mutabletwo];
        [mutableOne addObject:modelOne];
    }

}

#pragma mark -- 返回主页
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}


#pragma mark -- 防止搜索状态下tableView下面遮挡的问题
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == _tableView)
//    {
//        [self.view endEditing:YES];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end