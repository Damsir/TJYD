//
//  SignViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/5/4.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SignViewController.h"
#import "FormSingleLogin.h"
#import "SendViewController.h"
#import "BackViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SingleWebView.h"

@protocol JSObjcDelegate <JSExport>

// 获取反馈状态(前端返回)
- (void)getStage:(NSString *)stageInfo;

// -- 处理发走多个表单的情况(缓存) --
// 注销(移除)表单
- (void)removeForm;

// 加载完整表单
- (void)loadWholeForm ;
// 加载意见表单
- (void)loadAdviceForm;

// 保存意见表单
- (void)saveAdviceForm;
// 保存完整表单
- (void)saveForm;

// 验证意见表单
- (void)validateAdviceForm;

/**
 *  发送完整表单(2步)
 */
- (void)sendAdviceForm;//结束移动端界面
- (void)closeAdviceForm;//发送完整表单(pc)

@end

@interface SignViewController () <UIWebViewDelegate,JSObjcDelegate>

@property (nonatomic,strong) UIView *sendView;
@property (nonatomic,strong) UIView *sendline;
@property (nonatomic,strong) UIButton *saveButton;//保存
@property (nonatomic,strong) UIButton *sendButton;//发送
@property (nonatomic,strong) UIWebView *web;
@property (nonatomic,strong) SendViewController *sendVC;
@property (nonatomic,strong) JSContext *jsContext;
@property (nonatomic,assign) int completeCount;
@property (nonatomic,assign) BOOL wholeFormLoadSuccess;

@end

@implementation SignViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)reloadData {
    
    _wholeFormLoadSuccess = NO;
    _completeCount = 0;
    [self loadWebForm];
    [self creatSendButton];
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
    
    DLog(@"SignDealloc--");
//    [_web stopLoading];
//    _web.delegate = nil;
    //清除webView的缓存
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationBarTitle:@"审核"];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    
    // 监听发送完整表单的通知(SendViewController发出)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSendUsersSuccess:) name:@"saveSendUsersSuccess" object:nil];
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    // 监听移除coach表单的通知(ProjectDetailVC<ProjectInfo>发出)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeForm:) name:@"removeForm" object:nil];
    
}

- (void)removeForm:(NSNotification *)noty {
    DLog(@"移除表单");
    //_web.delegate = nil;
    [self removeForm];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
}

#pragma mark -- 收到saveSendUsersSuccess的通知(SendViewController发出)
- (void)saveSendUsersSuccess:(NSNotification *)noty {
    
    DLog(@"---保存人员成功消息---")
    // 发送完整表单(pc) - 关闭大表单
    [self closeAdviceForm];
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60);
    //_sendView.frame = CGRectMake(0, CGRectGetMaxY(_web.frame), SCREEN_WIDTH, 60);
    _sendView.frame = CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 60);
    _sendline.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    // 保存,发送,回退
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    _saveButton.frame = CGRectMake(10, 10, btn_W, 40);
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_saveButton.frame)+10, _saveButton.frame.origin.y, btn_W, 40);
}

- (void)creatSendButton {
    
    UIView *sendView = [[UIView alloc] init];
    //sendView.frame = CGRectMake(0, CGRectGetMaxY(_web.frame), SCREEN_WIDTH, 60);
    sendView.frame = CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 60);
    sendView.backgroundColor = [UIColor whiteColor];
    _sendView = sendView;
    [self.view addSubview:sendView];
    
    UIView *sendline = [[UIView alloc] init];
    sendline.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    sendline.backgroundColor = GRAYCOLOR_MIDDLE;
    _sendline = sendline;
    [sendView addSubview:sendline];
    
    // 保存,发送
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    
    UIButton *saveButton = [self createCustomButtonWithTitle:@"暂存"];
    saveButton.frame = CGRectMake(10, 10, btn_W, 40);
    //    saveButton.enabled = NO;
    //    saveButton.backgroundColor = [UIColor lightGrayColor];
    [saveButton addTarget:self action:@selector(saveOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [sendView addSubview:saveButton];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"发送"];
    sendButton.frame = CGRectMake(CGRectGetMaxX(saveButton.frame)+10, saveButton.frame.origin.y, btn_W, 40);
//    sendButton.enabled = NO;
//    sendButton.backgroundColor = [UIColor lightGrayColor];
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    [sendView addSubview:sendButton];
}

#pragma mark -- 保存
- (void)saveOnClick:(UIButton *)button {
    
    [MBProgressHUD showSuccess:@"保存成功"];
    
//    [self saveForm];
    [self saveAdviceForm];
}

#pragma mark -- 发送
- (void)sendOnClick:(UIButton *)button {
    
//    [self saveForm];
    [self saveAdviceForm];
    // 定时1.5s,执行验证表单(刷新表单需要时间)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self validateAdviceForm];
    });
}

#pragma mark -- 加载网页表单
- (void)loadWebForm {
    
    if (!_web) {
        _web = [SingleWebView shareSingleWebView];
        _web.delegate = self;
        //web.opaque = NO; //不设置这个值 页面背景始终是白色
        _web.backgroundColor = [UIColor whiteColor];
        //_web.scalesPageToFit = YES;
        [_web sizeToFit];
        [self.view addSubview:_web];
        //[self.view bringSubviewToFront:_web];
    }
    
    //加载请求的时候忽略缓存
    //[_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.236.160.182:9083/AppCenter/dist/views/proxy.html"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];
    //[_web stopLoading];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Global BpmProxyApi]]]];
    //[_web loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"proxy" withExtension:@"html"]]];
    
    [MBProgressHUD showMessage:@"" toView:self.view];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //DefineWeakSelf(weakSelf);
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"Dist"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DLog(@"异常信息：%@", exceptionValue);
    };
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
    
    // 页面背景色
    //[_web stringByEvaluatingJavaScriptFromString:@"document.getElementsById('adviceForm').style.background='#000000'"];
    //***************
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //***************
}

#pragma mark - JSObjcDelegate
#pragma mark -- 状态回调
- (void)getStage:(NSString *)stageInfo {
    DLog(@"stageInfo:%@", stageInfo);
    // 分享成功回调js的方法shareCallback
    //    JSValue *shareCallback = self.jsContext[@"getStatus"];
    //    [shareCallback callWithArguments:nil];
    NSData *data = [stageInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //DLog(@"JsonDic:%@",[JsonDic objectForKey:@"stage"]);
    
    if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"外层页面加载完毕"]) {
        DLog(@"外层页面加载完毕");
        [self loadWholeForm];
        [self loadAdviceForm];
    } else if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"完整表单加载完毕"]) {
        DLog(@"完整表单加载完毕");
        _wholeFormLoadSuccess = YES;
    } else if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"意见表单加载完毕"]) {
        DLog(@"意见表单加载完毕");
        // WebThread
        //DefineWeakSelf(weakSelf);
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
//        });
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.view animated:NO];
        //});
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        });
    } else if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"意见表单保存成功"]) {
        DLog(@"意见表单保存成功");

    } else if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"意见表单验证通过"]) {
        //[MBProgressHUD hideHUDForView:_web animated:NO];
        // 意见表单验证结果true
        DLog(@"意见表单验证结果true");
        
        // WebThread
        //DefineWeakSelf(weakSelf);
        
        if (_wholeFormLoadSuccess) {
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //DLog(@"--PUSHSENDVC--");
            if (!_sendVC) {
                _sendVC = [[SendViewController alloc] init];
            }
            _sendVC.listModel = self.listModel;
            _sendVC.navi = self.navi;
            [_sendVC reloadData];
            [self pushToViewControllerWithTransition:_sendVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
        });
        
//            });
        }
        //[self pushToViewControllerWithTransition:sendVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
    } else if ([[JsonDic objectForKey:@"stage"] isEqualToString:@"发送成功"]) {
        DLog(@"完整表单发送成功");
        //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"onCompleted" object:nil userInfo:nil]];
        
        [self judgeOnCompletedType];
    } else if ([[JsonDic objectForKey:@"stage"] containsString:@"收到院长办公会意见环节消息"]) {
        NSString *xmxxId = [[JsonDic objectForKey:@"stage"] substringFromIndex:14];
        DLog(@"%@", xmxxId);
        [self requestCWTZ:xmxxId];
    } else if ([[JsonDic objectForKey:@"stage"] containsString:@"收到补充合同终审环节消息"]) {
        NSString *IdString = [[JsonDic objectForKey:@"stage"] substringFromIndex:13];
        DLog(@"%@", IdString);
        NSArray *IdArray = [IdString componentsSeparatedByString:@"-"];
        NSString *xmxxId = [IdArray firstObject];
        NSString *bchtxxId = [IdArray lastObject];
        [self requestChangeSupply:xmxxId bchtxxId:bchtxxId];
    }
}

// 收到院长办公会意见环节消息(财务台账)
- (void)requestCWTZ:(NSString *)xmxxId {
    
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==tongjiProcess/initWtProjectCwtz.do?xmxxId=%@,%@",xmxxId,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetStand requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        DLog(@"%@", error);
    }];
}

// 收到补充合同终审环节消息
- (void)requestChangeSupply:(NSString *)xmxxId bchtxxId:(NSString *)bchtxxId {
    
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==account/changeSupplyContract.do?xmxxId=%@&bchtxxId=%@,%@",xmxxId,bchtxxId,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetAccount requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)judgeOnCompletedType {
    
    DLog(@"---_completeCount:%d---",_completeCount);
    if (_completeCount == 0) {
        DLog(@"---调用发送---");
        [self sendAdviceForm];
    } else if (_completeCount == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"onCompleted" object:nil userInfo:nil]];
    }
    _completeCount++;
}

// ----------
// -- 处理发走多个表单的情况(缓存) --
// 注销(移除)表单
- (void)removeForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"removeForm"];
    [picCallback callWithArguments:nil];
}

// 加载完整表单
- (void)loadWholeForm {
    // 获取到验证之后,回调js的方法,picCallback把url传出去
    JSValue *picCallback = self.jsContext[@"loadWholeForm"];
    DLog(@"wholeForm:%@",[NSString stringWithFormat:@"%@/teamworks/fauxRedirect.lsw?zWorkflowState=1&coachDebugTrace=none&zResetContext=true&zTaskId=%@&iscontractagent=是",[Global BpmFormApi],_listModel.TASK_ID]);
    [picCallback callWithArguments:@[[NSString stringWithFormat:@"%@/teamworks/fauxRedirect.lsw?zWorkflowState=1&coachDebugTrace=none&zResetContext=true&zTaskId=%@&iscontractagent=是",[Global BpmFormApi],_listModel.TASK_ID]]];
}
// 加载意见表单
- (void)loadAdviceForm {
    // 获取到验证之后,回调js的方法,picCallback把url传出去
    JSValue *picCallback = self.jsContext[@"loadAdviceForm"];
    DLog(@"adviceForm:%@",[NSString stringWithFormat:@"%@/teamworks/executeServiceByName?processApp=TJYSOA1&serviceName=signature&tw.local.PIID=%@&tw.local.processName=%@&tw.local.activityName=%@&tw.local.loginName=%@",[Global BpmFormApi],_listModel.INSTANCEID,_listModel.BUSINESSNAME,_listModel.ACTIVITY_NAME,[UserDefaults objectForKey:@"userName"]]);
    [picCallback callWithArguments:@[[NSString stringWithFormat:@"%@/teamworks/executeServiceByName?processApp=TJYSOA1&serviceName=signature&tw.local.PIID=%@&tw.local.processName=%@&tw.local.activityName=%@&tw.local.loginName=%@",[Global BpmFormApi],_listModel.INSTANCEID,_listModel.BUSINESSNAME,_listModel.ACTIVITY_NAME,[UserDefaults objectForKey:@"userName"]]]];
}
// 保存意见表单
- (void)saveAdviceForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"saveAdviceForm"];
    [picCallback callWithArguments:nil];
}
// 保存完整表单
- (void)saveForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"saveForm"];
    [picCallback callWithArguments:nil];
}
// 验证意见表单
- (void)validateAdviceForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"validateAdviceForm"];
    [picCallback callWithArguments:nil];
}
/**
 *  发送完整表单(2步)
 */
// 结束移动端界面
- (void)sendAdviceForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"sendAdviceForm"];
    [picCallback callWithArguments:nil];
}
// 发送完整表单(pc)
- (void)closeAdviceForm {
    // 获取到验证之后,回调js的方法
    JSValue *picCallback = self.jsContext[@"closeAdviceForm"];
    [picCallback callWithArguments:nil];
}


#pragma mark -- 返回
- (void)backToLastViewController {
    //_web.delegate = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    });
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

#pragma mark -- CustomButton
- (UIButton *)createCustomButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = HOMEBLUECOLOR;
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:Font_PingFangSC_Regular size:16.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0;
    button.clipsToBounds = YES;
    // 按钮点击间隔
    button.eventTimeInterval = EventTimeInterval;
    
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
