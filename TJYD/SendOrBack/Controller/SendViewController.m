//
//  SendViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SendViewController.h"
#import "SendTreeView.h"
#import "SendPeopleCellModel.h"
#import "SendModel.h"
#import "FormSingleLogin.h"
#import "MobileSingleLogin.h"

static NSString *keyPath_CicrleAnimation = @"clickCicrleAnimation";
static NSString *keyPath_CicrleAnimationGroup = @"clickCicrleAnimationGroup";

@interface SendViewController () <TreeDelegate,UIWebViewDelegate>

@property (nonatomic,strong) SendTreeView *sendTreeView;
@property (nonatomic,strong) UIView *sendView;
@property (nonatomic,strong) UIView *sendline;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSArray *selectArray;//选择人员数据源
@property (nonatomic,strong) NSArray *dictUserArray;
@property (nonatomic,strong) UIWebView *web;
@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;
@property (nonatomic,assign) BOOL saveUserSuccess;//保存人员成功
@property (nonatomic,assign) BOOL sendSuccess;//发送成功
@property (nonatomic,assign) BOOL activitySuccess;//发送按钮过一秒可以点击


@end

@implementation SendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)reloadData {
    
    _saveUserSuccess = NO;
    _sendSuccess = NO;
    _activitySuccess = NO;
    
    [self creatSendButton];
    [self loadData];
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationBarTitle:@"发送给"];
    

//    [self creatSendButton];
//    [self loadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    // 监听表单发送成功的通知(SignViewController发出)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCompleted:) name:@"onCompleted" object:nil];
}

#pragma mark -- 收到表单发送成功的通知(关闭当前页面,返回待办列表)
- (void)onCompleted:(NSNotification *)noty {
    
    DLog(@"收到发送成功onCompleted的消息");
//    static int i = 0;
//    if (!_saveUserSuccess) {
//        // 大表单onCompleted
//        // 设置发送按钮状态
//        [_activity removeFromSuperview];
//        _activity = nil;
//        self.sendButton.enabled = YES;
//        self.sendButton.backgroundColor = HOMEBLUECOLOR;
//    }
    if (_saveUserSuccess) {
        
        // 发出移除coach表单的通知(给SignViewController)
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"removeForm" object:nil userInfo:nil]];
        
        // 加载提示框
        _sendSuccess = YES;
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [MBProgressHUD showSuccess:@"发送成功"];
        //});
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showSuccess:@"发送成功"];
            [self.navi popToRootViewControllerAnimated:YES];
            [_sendTreeView removeFromSuperview];
            _sendTreeView = nil;
        });
        
        //[self.navi popViewControllerAnimated:YES];
    }
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _sendView.frame = CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 60);
    _sendline.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    _sendButton.frame = CGRectMake(_sendView.frame.size.width/2-250/2, 10, 250, 40);
    _activity.center = CGPointMake(_sendButton.frame.size.width/2, _sendButton.frame.size.height/2);
    _sendTreeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60);
    [_sendTreeView screenRotation];
}

/*
  multiselected: 1.true(多选)  2.false(单选)
 */
- (void)loadData {
    
    _dataArray = [NSMutableArray array];
    
    DLog(@"_listModel:::%@",_listModel.TASK_ID);
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 获取发送人员列表
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==tjsend/getActivities.do?projectId=%@&taskId=%@,%@",_listModel.PID,_listModel.TASK_ID,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetActivities requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        DLog(@"userJsonDic:%@",JsonDic);
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *children = [[JsonDic objectForKey:@"result"] objectForKey:@"children"];
            // 多选,单选
            BOOL isMultiSelect = [[[children firstObject] objectForKey:@"multiselected"] isEqualToString:@"false"] ? NO : YES;
            
            if (children.count) {
                
                SendTreeView *treeView = [[SendTreeView instanceView] initTreeWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60) dataArray:children haveHiddenSelectBtn:NO haveHeadView:NO isEqualX:NO isMultiSelect:isMultiSelect];
                treeView.delegate = self;
                treeView.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
                treeView.backgroundColor = [UIColor whiteColor];
                _sendTreeView = treeView;
                [self.view addSubview:treeView];
                
                
                for (NSDictionary *dic in children) {
                    SendModel *sendModel = [[SendModel alloc] initWithDictionary:dic];
                    [_dataArray addObject:sendModel];
                }
                DLog(@"SendModel:%@",_dataArray);

            }
            
            // Model array -> JSON array
//            NSArray *dictUserArray = [SendModel mj_keyValuesArrayWithObjectArray:_dataArray];
//            NSString *string = [dictUserArray componentsJoinedByString:@";"];//为分隔符
//            DLog(@"dictArray:%@", dictUserArray);
//            DLog(@"string:%@", string);
            
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

#pragma mark -- SendTreeViewDelegate
- (void)itemSelectInfo:(SendPeopleCellModel *)item {
    
    DLog(@"DamPeopleCellModel::%@",item);
//    SendPeopleCellModel *peopleModel = item;
}

- (void)itemSelectArray:(NSArray *)selectArray {
    
    if (selectArray.count) {
        // 选择人员数据源
        _selectArray = selectArray;
        if (_activitySuccess) {
            self.sendButton.enabled = YES;
            self.sendButton.backgroundColor = HOMEBLUECOLOR;
        }
        
    } else {
        
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }
    NSLog(@"SendSelectArray::%@",selectArray);
}

- (void)creatSendButton {
    
    UIView *sendView = [[UIView alloc] init];
    sendView.frame = CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 60);
    sendView.backgroundColor = [UIColor whiteColor];
    _sendView = sendView;
    [self.view addSubview:sendView];
    
    UIView *sendline = [[UIView alloc] init];
    sendline.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    sendline.backgroundColor = GRAYCOLOR_MIDDLE;
    _sendline = sendline;
    [sendView addSubview:sendline];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"完 成"];
    sendButton.frame = CGRectMake(sendView.frame.size.width/2-250/2, 10, 250, 40);
    sendButton.enabled = NO;
    sendButton.backgroundColor = [UIColor lightGrayColor];
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    [sendView addSubview:sendButton];
    
    // 菊花
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
    activity.center = CGPointMake(sendButton.frame.size.width/2, sendButton.frame.size.height/2);
    _activity = activity;
    [activity startAnimating];
    [sendButton addSubview:activity];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 执行事件
        _activitySuccess = YES;
        [activity removeFromSuperview];
        // 验证按钮
        [self itemSelectArray:_selectArray];
    });
}

// 画圆
-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    /**
     *  center: 弧线中心点的坐标
     radius: 弧线所在圆的半径
     startAngle: 弧线开始的角度值
     endAngle: 弧线结束的角度值
     clockwise: 是否顺时针画弧线
     *
     */
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}

#pragma mark -- 发送
- (void)sendOnClick:(UIButton *)button {
    
    //点击出现白色圆形
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    _clickCicrleLayer = clickCicrleLayer;
    
    clickCicrleLayer.frame = CGRectMake(_sendButton.bounds.size.width/2, _sendButton.bounds.size.height/2, 5, 5);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:5].CGPath;
    [_sendButton.layer addSublayer:clickCicrleLayer];
    
    //放大变色圆形
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation2.duration = 0.5;
    basicAnimation2.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(_sendButton.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation2.removedOnCompletion = NO;
    basicAnimation2.fillMode = kCAFillModeForwards;
    
    [clickCicrleLayer addAnimation:basicAnimation2 forKey:keyPath_CicrleAnimation];
    
    //圆形变圆弧
    clickCicrleLayer.fillColor = [UIColor clearColor].CGColor;
    clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.lineWidth = 10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    //圆弧变大
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.5;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(_sendButton.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    //变透明
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.5;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [clickCicrleLayer addAnimation:animationGroup forKey:keyPath_CicrleAnimationGroup];
    
    [self sendSelectUsers];
}

#pragma mark -- 发送保存人员
- (void)sendSelectUsers {
    // 发送(保存人员)
    [MBProgressHUD showMessage:@"正在发送" toView:self.view];
    
    // 数据源(遍历筛选存储)
    for (NSInteger i=0; i<_selectArray.count; i++) {
        
        // 选择人员的Id
        NSString *Id = [_selectArray[i] objectForKey:@"id"];
        
        for (NSInteger j=0; j<self.dataArray.count; j++) {
            SendModel *sendModel = self.dataArray[j];
            for (SendListModel *sendListModel in sendModel.children) {
                if ([sendListModel.Id isEqualToString:Id]) {
                    sendListModel.selected = @"true";
                    sendListModel._parentId = sendModel.Id;
                    sendModel.selected = @"true";
                }
            }
        }
    }
    
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        
        SendModel *sendModel = self.dataArray[i];
        
        for (NSInteger j=sendModel.children.count-1; j>=0; j--) {
            SendListModel *sendListModel = sendModel.children[j];
            if (![sendListModel.selected isEqualToString:@"true"]) {
                [sendModel.children removeObject:sendListModel];
            }
        }
    }
    DLog(@"SiftArr%@",self.dataArray);
    
    // Model array -> JSON array
    NSArray *dictUserArray = [SendModel mj_keyValuesArrayWithObjectArray:self.dataArray];
    DLog(@"dictArray:%@", dictUserArray);
    _dictUserArray = dictUserArray;
    
    //        NSString *userString = [NSString stringWithFormat:@"%@",_dictUserArray];
    //        userString = [userString stringByReplacingOccurrencesOfString:@"Id" withString:@"id"];
    //        userString = [userString stringByReplacingOccurrencesOfString:@"Override" withString:@"override"];
    
    // ---------------------
    // 移动端单点登录
    //        [MobileSingleLogin singleLoginActionWithSuccess:^(BOOL success) {
    //            if (success) {
    //                // 登录成功
    //                NSString *url = [NSString stringWithFormat: @"http://116.236.160.182:9083/AppCenter/send/saveSelectUsers.do?projectId=%@&taskId=%@&activityName=%@&selectData=%@",_listModel.PID,_listModel.TASK_ID,_listModel.ACTIVITY_NAME,_dictUserArray];
    //                DLog(@"保存意见接口:%@",url);
    //
    //                [DamNetworkingManager POSTWithUrl:url andBodyDic:nil andBodyStr:nil andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
    //
    //                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //                    NSLog(@"responseString4:%@",responseString);
    //                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //                    NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
    //
    //
    //                } andFailBlock:^(NSError *error) {
    //                    DLog(@"%@",error);
    //                }];
    //
    //            } else {
    //                // 登录失败
    //                DLog(@"登录失败");
    //            }
    //        }];
    
    
    // ----------
    
    
    /**
     *  submit
     */
    //        [self submit];
    
    //        userString = [userString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //        userString = [userString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //        userString = [userString stringByReplacingOccurrencesOfString:@";" withString:@","];
    
    
    // 选择人员数组(拼接好格式)
    NSMutableArray *selectDataArray = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        
        SendModel *sendModel = self.dataArray[i];
        
        NSMutableArray *selectId = [NSMutableArray array];
        for (NSInteger j=0; j<sendModel.children.count; j++) {
            SendListModel *listModel = sendModel.children[j];
            [selectId addObject:listModel.Id];
        }
        NSString *user = [selectId componentsJoinedByString:@":"];
        user = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",sendModel.Id,user];
        [selectDataArray addObject:user];
    }
    DLog(@"selectDataArray::%@",selectDataArray);
    
    NSString *selectData = [selectDataArray componentsJoinedByString:@"*"];
    
    
    
    //        SendModel *sendModel = [self.dataArray firstObject];
    //        SendListModel *listModel = [sendModel.children firstObject];
    //        NSString *user1 = @"{\"1\":\"111:222:333\"}";
    //        user1 = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",sendModel.Id,listModel.Id];
    //        DLog(@"user1:%@",user1);
    
    
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *encryptDes = [NSString stringWithFormat:@"action==tjsend/saveTJSelectUsers.do?instanceId=%@&activityName=%@&projectId=%@&taskId=%@&selectData=%@,%@",_listModel.INSTANCEID,_listModel.ACTIVITY_NAME,_listModel.PID,_listModel.TASK_ID,selectData,ticket];
    
    DLog(@"加密前:%@",encryptDes);
    //        NSUInteger bytes = [encryptDes lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *des = [DES encryptUseDES:[encryptDes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    //        NSString *des = [DES encryptUseDES:encryptDes key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetSaveSelectUsers requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"saveSendUsersSuccess" object:nil userInfo:nil]];
            
            _saveUserSuccess = YES;
            DLog(@"saveUser::success");
            //[MBProgressHUD showSuccess:@"发送成功"];
            //[self.navi popToRootViewControllerAnimated:YES];
            //[self.navi popViewControllerAnimated:YES];
            
            // 定时(延迟)
            // 每次执行方法之前，先把之前的延迟取消掉，这样，如果在上一次延迟还没走完的情况下，再一次执行这个方法的时候，就不会像之前那样继续上次的延迟时间了。
            // 先取消上次的delay
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showSendFailure) object:nil];
            [self performSelector:@selector(showSendFailure) withObject:nil afterDelay:30];
            
        } else {
            [MBProgressHUD showError:@"发送失败"];
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        // 加载提示框
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

// 定时10s,发送失败
- (void)showSendFailure {
    
    if (!_sendSuccess) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showError:@"发送超时"];
    }
}

#pragma mark -- 返回
- (void)backToLastViewController {
    [_sendTreeView removeFromSuperview];
    _sendTreeView = nil;
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

+ (SendViewController *)shareSingleSendVC {
    
    static SendViewController *signVC = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        signVC = [[SendViewController alloc] init];
        
    });
    
    return signVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
