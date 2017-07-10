//
//  BackViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "BackViewController.h"
#import "SendPeopleSelectTableCell.h"
#import "BackModel.h"

static NSString *cellId = @"SendPeopleSelectTableCell";

@interface BackViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *footLine;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextView *adviceTextView;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *imageShowArray;
@property (nonatomic,strong) NSMutableArray *selectArray;

@end

@implementation BackViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBarTitle:@"回退给"];
    
    [self creatTableView];
    [self creatSendButton];
    [self loadData];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    
    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createNotification];
}

- (void)createNotification {
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _footView.frame = CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220);
    _footLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    _nameLabel.frame = CGRectMake(10, 10, 200, 20);
    _adviceTextView.frame = CGRectMake(10, 35, SCREEN_WIDTH-20, 120);
    _sendButton.frame = CGRectMake(10, CGRectGetMaxY(_adviceTextView.frame)+10, SCREEN_WIDTH-20, 40);
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-220);
}

- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    _imageShowArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 获取回退人员列表
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==tongjiProcess/routeStepList.do?instanceId=%@&onlyDeal=1&optType=0&taskId=%@&activity=%@&userName=&projectId=%@,%@",_listModel.INSTANCEID,_listModel.TASK_ID,_listModel.ACTIVITY_NAME,_listModel.PID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetStepList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *result = [JsonDic objectForKey:@"result"];
            
            if (result.count) {
                
                BackModel *model = [[BackModel alloc] initWithDictionary:[result firstObject]];
                [_dataArray addObject:model];
                DLog(@"SendModel:%@",_dataArray);
                [self.tableView reloadData];
            }
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

#pragma mark -- 判断选择人员是否为空
- (void)judgeSelectArray {
    
    if (_selectArray.count && ![_adviceTextView.text isEqualToString:@"回退意见..."] && ![_adviceTextView.text isEqualToString:@""]) {
        
        self.sendButton.enabled = YES;
        self.sendButton.backgroundColor = HOMEBLUECOLOR;
        
    } else {
        
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }
    NSLog(@"SendSelectArray::%@",_selectArray);
}

- (void)creatSendButton {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    //footView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    footView.backgroundColor = [UIColor whiteColor];
    _footView = footView;
    [self.view addSubview:footView];
    
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    footLine.backgroundColor = GRAYCOLOR_MIDDLE;
    _footLine = footLine;
    [footView addSubview:footLine];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.text = @"回退意见 (必填)";
    nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _nameLabel = nameLabel;
    [footView addSubview:nameLabel];
    
    UITextView *adviceTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-20, 120)];
    adviceTextView.text = @"回退意见...";
    adviceTextView.textColor = [UIColor blackColor];
    if ([adviceTextView.text isEqualToString:@"回退意见..."]) {
        adviceTextView.textColor = [UIColor lightGrayColor];
    }
    adviceTextView.backgroundColor = [UIColor whiteColor];
    adviceTextView.layer.borderWidth = 0.5;
    adviceTextView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    adviceTextView.font = [UIFont systemFontOfSize:16.0];
    adviceTextView.layer.cornerRadius = 3;
    adviceTextView.clipsToBounds = YES;
    adviceTextView.returnKeyType = UIReturnKeyDone;
    adviceTextView.delegate = self;
    _adviceTextView = adviceTextView;
    [footView addSubview:adviceTextView];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"完 成"];
    sendButton.frame = CGRectMake(10, CGRectGetMaxY(adviceTextView.frame)+10, SCREEN_WIDTH-20, 40);
    sendButton.enabled = NO;
    sendButton.backgroundColor = [UIColor lightGrayColor];
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    [footView addSubview:sendButton];
}

#pragma mark -- 回退
- (void)sendOnClick:(UIButton *)button {
    
    [self.view endEditing:YES];
    // 回退(保存人员)
    [MBProgressHUD showMessage:@"正在回退" toView:self.view];
    
    BackListModel *model = [_selectArray firstObject];
    
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *encryptDes = [NSString stringWithFormat:@"action==tongjiProcess/routeStep.do?instanceId=%@&targetStepId=%@&onlyDeal=1&taskId=%@&selectUser=%@&opinion=%@,%@",_listModel.INSTANCEID,model.bpdid,_listModel.TASK_ID,model.name,_adviceTextView.text,ticket];
    
    DLog(@"加密前:%@",encryptDes);
    //        NSUInteger bytes = [encryptDes lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *des = [DES encryptUseDES:[encryptDes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    //        NSString *des = [DES encryptUseDES:encryptDes key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetRouteStep requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"formBackSuccess" object:nil userInfo:nil]];
            
            DLog(@"saveUser::success");
            [MBProgressHUD showSuccess:@"回退成功"];
            [self.navi popToRootViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD showError:@"回退失败"];
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        // 加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"回退失败"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

#pragma mark -- 创建表格
- (void)creatTableView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-220);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- TableViewDelegate
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArray.count) {
        return [_dataArray[section] routeStepList].count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SendPeopleSelectTableCell *peopleCell = [tableView dequeueReusableCellWithIdentifier:@"SendPeopleSelectTableCell"];
    peopleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BackListModel *model = [_dataArray[indexPath.section] routeStepList][indexPath.row];
    peopleCell.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.activityName,model.name];
    peopleCell.titleLabel.textColor = BLUECOLOR;
    peopleCell.arrowImageView.hidden = YES;

    if ([_imageShowArray containsObject:@(indexPath.row)]) {
        peopleCell.titleLabel.textColor = [UIColor colorWithRed:233/255.0 green:129/255.0 blue:39/255.0 alpha:1.0];
        [peopleCell.chooseButton setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateNormal];
    }else{
        peopleCell.titleLabel.textColor = BLUECOLOR;
        [peopleCell.chooseButton setImage:[UIImage imageNamed:@"ico_circle"] forState:UIControlStateNormal];
    }
    
    peopleCell.chooseButton.tag = indexPath.row;
    [peopleCell.chooseButton addTarget:self action:@selector(chooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return peopleCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_imageShowArray containsObject:@(indexPath.row)]) {
        [_imageShowArray removeObject:@(indexPath.row)];
        [_selectArray removeAllObjects];
    } else if (![_imageShowArray containsObject:@(indexPath.row)] && _imageShowArray.count) {
        [_imageShowArray removeAllObjects];
        [_imageShowArray addObject:@(indexPath.row)];
        [_selectArray removeAllObjects];
        [_selectArray addObject:[[_dataArray firstObject] routeStepList][indexPath.row]];
    } else {
        [_imageShowArray addObject:@(indexPath.row)];
        [_selectArray addObject:[[_dataArray firstObject] routeStepList][indexPath.row]];
    }
    
    [self judgeSelectArray];
    
    [self.tableView reloadData];
}

- (void)chooseOnClick:(UIButton *)button {
    
    NSInteger index = button.tag;
    
    if ([_imageShowArray containsObject:@(index)]) {
        [_imageShowArray removeObject:@(index)];
        [_selectArray removeAllObjects];
    } else if (![_imageShowArray containsObject:@(index)] && _imageShowArray.count) {
        [_imageShowArray removeAllObjects];
        [_imageShowArray addObject:@(index)];
        [_selectArray removeAllObjects];
        [_selectArray addObject:[[_dataArray firstObject] routeStepList][index]];
    } else {
        [_imageShowArray addObject:@(index)];
        [_selectArray addObject:[[_dataArray firstObject] routeStepList][index]];
    }
    
    [self judgeSelectArray];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([_imageShowArray containsObject:@(indexPath.row)]) {
    //        [_imageShowArray removeObject:@(indexPath.row)];
    //    }
    //
    //    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

#pragma mark - UITextView Delegate Methods
//点击键盘右下角的键收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_adviceTextView.text.length == 0) {
            _adviceTextView.textColor =[UIColor lightGrayColor];
            _adviceTextView.text = @"回退意见...";
        } else {
            _adviceTextView.textColor = [UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"回退意见..."]) {
        
        _adviceTextView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        _adviceTextView.textColor =[UIColor lightGrayColor];
        _adviceTextView.text = @"回退意见...";
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    // 删除空格符
    //_adviceTextView.text = [_adviceTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self judgeSelectArray];
}

// 键盘升起/隐藏
- (void)keyboardWillShow:(NSNotification *)noti {
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    //    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"1=====%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    if (SCREEN_HEIGHT <= 1024) {
        
        [UIView animateWithDuration:durtion animations:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
            CGRect footerFrame = _footView.frame;
            
            footerFrame.origin.y = SCREEN_HEIGHT==480? SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64+45 : SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64;
            
            _footView.frame = footerFrame;
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)noti {
    [self createNotification];
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"2=====%f",keyboard_h);
    [UIView animateWithDuration:durtion animations:^{
        
        CGRect foorterFrame = _footView.frame;
        foorterFrame.origin.y = SCREEN_HEIGHT-220-64;
        _footView.frame = foorterFrame;
        
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_adviceTextView resignFirstResponder];
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
