//
//  LoginViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/12/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SHTabBarController.h"
#import <AudioToolbox/AudioToolbox.h> // 震动
#import "DeviceInfo.h"
#import "TFHpple.h"
#import "DistTouchID.h"//指纹
#import "DistGestureLock.h"//手势
#import "DistLoginValidate.h"//设备验证

static NSString *keyPath_CicrleAnimation = @"clickCicrleAnimation";
static NSString *keyPath_CicrleAnimationGroup = @"clickCicrleAnimationGroup";

@interface LoginViewController () <UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSString *deviceUUID;
@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;
@property (nonatomic,strong) NSString *lt;//页面截取字段
@property (nonatomic,strong) NSString *execution;//页面截取字段
@property (nonatomic,strong) DistLoginValidate *distLoginValidate;//设备登录验证
@property (nonatomic,strong) DistGestureLock *distGestureLock;//手势登录
@property (nonatomic,strong) SHTabBarController *SHTabBar;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
    // 这个是苹果自带的屏幕左侧向右滑动 == 返回效果
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 版本更新请求
    [self checkUpdated];
    //    [self checkUpdated];
    // 背景动画
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollAnimation) userInfo:nil repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 停止
    [_timer invalidate];
    _timer = nil;
    [_clickCicrleLayer removeFromSuperlayer];
    
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    NSString *key = @"com.app.keychain.uuid";
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
    [keychainItem resetKeychainItem];
    
    // 设置登录初始状态
    [self setLoginViewOriginalState];
    // 背景动画
    [self createBackAnimationView];
    // 默认登录方式判断
    [self judgeLoginWay];
    // 设备首次登录验证
//    [self loginValidate];
    
    // 1.监听屏幕旋转
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // 2.KVO(监听屏幕旋转)
    //[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    [_distGestureLock screenRotation];
    [_distLoginValidate screenRotation];
    
    [self screenRotation];
}

- (void)screenRotation {
    
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 150, SCREEN_HEIGHT);
    _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH + 150, SCREEN_HEIGHT);
    
    // iPhone
    if (SCREEN_WIDTH < 768)
    {
        self.loginButton_bottom.constant = 35;
        if (SCREEN_HEIGHT < 667)
        {
            self.loginBackView_top.constant = 100;
            self.loginBackView_left.constant = self.loginBackView_right.constant = 10;
        }
        if (SCREEN_HEIGHT < 568)
        {
            self.loginBackView_top.constant = 50;
        }
    }
    // ipad
    if (SCREEN_WIDTH > 414)
    {
        self.loginBackViewHight.constant = 400;
        self.loginBackView_left.constant = self.loginBackView_right.constant = (SCREEN_WIDTH-400)/2.0;
        self.loginButton_bottom.constant = 50;
        if (SCREEN_WIDTH < SCREEN_HEIGHT)
        {
            self.loginBackView_top.constant = 270;
        }
        else
        {
            self.loginBackView_top.constant = 170;
        }
    }
    // 4s,5s
    if (SCREEN_WIDTH == 320)
    {
        self.userLine_left.constant = self.userLine_right.constant = 20;
        self.loginButton_left.constant = self.loginButton_right.constant = 20;
        self.passWordLine_left.constant = self.passWordLine_right.constant = 20;
        self.userIcon_left.constant = self.passWordIcon_left.constant = 25;
    }
}

#pragma mark -- 设置登录界面初始状态

- (void)setLoginViewOriginalState {
    
    // 忘记密码功能屏蔽
    self.forgetPwButton.hidden = YES;
    
    self.userName.delegate=self;
    self.passWord.delegate=self;
    self.passWord.secureTextEntry = YES;
    self.loginBackView.layer.cornerRadius= 6;
    self.loginBackView.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.layer.masksToBounds = YES;
    // 按钮点击间隔
    //self.loginButton.eventTimeInterval = EventTimeInterval;
    // iPhone
    if (SCREEN_WIDTH < 768)
    {
        self.loginButton_bottom.constant = 35;
        if (SCREEN_HEIGHT < 667)
        {
            self.loginBackView_top.constant = 100;
            self.loginBackView_left.constant = self.loginBackView_right.constant = 10;
        }
        if (SCREEN_HEIGHT < 568)
        {
            self.loginBackView_top.constant = 50;
        }
    }
    // ipad
    if (SCREEN_WIDTH > 414)
    {
        self.loginBackViewHight.constant = 400;
        self.loginBackView_left.constant = self.loginBackView_right.constant = (SCREEN_WIDTH-400)/2.0;
        self.loginButton_bottom.constant = 50;
        if (SCREEN_WIDTH < SCREEN_HEIGHT)
        {
            self.loginBackView_top.constant = 270;
        }
        else
        {
            self.loginBackView_top.constant = 170;
        }
        
    }
    // 4s,5s
    if (SCREEN_WIDTH == 320)
    {
        self.userLine_left.constant = self.userLine_right.constant = 20;
        self.loginButton_left.constant = self.loginButton_right.constant = 20;
        self.passWordLine_left.constant = self.passWordLine_right.constant = 20;
        self.userIcon_left.constant = self.passWordIcon_left.constant = 25;
    }
    
    //读取本地存储的用户信息
    self.userName.text = [UserDefaults objectForKey:@"userName"];
    
}

- (void)checkVersion
{
    NSError *error;
    NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dist.com.cn/App/wz/wzyd/version.txt"] encoding:NSUTF8StringEncoding error:&error];
    //NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dist.com.cn/App/wz/wzydtest/version.txt"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"newVersion=%@",newVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"currentVersion=%@",currentVersion);
    
    
    if(newVersion != nil && ![newVersion isEqualToString:@""] && ![newVersion isEqualToString:currentVersion])
    {
        if (![newVersion isEqualToString:currentVersion]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"新版本已发布" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去更新", nil];
            
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *url=[NSURL URLWithString:@"http://dist.com.cn/app/wz/wzyd"];
        //NSURL *url=[NSURL URLWithString:@"http://dist.com.cn/app/wz/wzydtest"];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -- 检测版本更新

//- (void)checkUpdated{

    //    [DamUpdateManager compareVersionWithPlist:^(BOOL isNewVersion) {
    //
    //        if(isNewVersion){
    //            // 当前是最新版本
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //            });
    //            return ;
    //
    //        }else{
    //            // 提示更新
    //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"新版本已发布" preferredStyle:UIAlertControllerStyleAlert];
    //
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            }];
    //            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:App_DownloadUrl]];
    //            }];
    //
    //            [alert addAction:cancelAction];
    //            [alert addAction:sureAction];
    //            [self presentViewController:alert animated:YES completion:nil];
    //        }
    //    }];
    
    //    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //    // 系统更新方法
    //    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    //    // 自定义更新方法
    //    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
//}
//
///**
// *  检查更新回调
// *
// *  @param response 检查更新的返回结果
// */
//- (void)updateMethod:(NSDictionary *)response
//{
//    if (response[@"downloadURL"]) {
//
//        NSString *message = response[@"releaseNote"];
//        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本,是否前往更新?" message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
//        //        [alertView show];
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本,是否前往更新?" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
//            //  调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，本地存储的Build号被更新后，SDK会将本地版本视为最新。对当前版本调用检查更新方法将不再回传更新信息。
//            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
//
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alert addAction:updateAction];
//        //[alert addAction:cancelAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alert animated:YES completion:nil];
//
//    }
//
//}

- (void)keyboardWillChange:(NSNotification  *)note
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (frame.origin.y == SCREEN_HEIGHT) { // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            
            self.view.transform =  CGAffineTransformIdentity;
        }];
    }else{ // 弹出键盘
        // 工具条往上移动258
        [UIView animateWithDuration:durtion animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0,-frame.size.height+self.tabBarController.tabBar.frame.size.height);
        }];
    }
    
}

// 画圆
- (UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
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

#pragma mark -- 登录
- (IBAction)loginButtonOnClick:(id)sender {
    
    UIButton *loginButton = (UIButton *)sender;
    //点击出现白色圆形
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    _clickCicrleLayer = clickCicrleLayer;
    
    clickCicrleLayer.frame = CGRectMake(loginButton.bounds.size.width/2, loginButton.bounds.size.height/2, 5, 5);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:5].CGPath;
    [loginButton.layer addSublayer:clickCicrleLayer];
    
    //放大变色圆形
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation2.duration = 0.5;
    basicAnimation2.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(loginButton.bounds.size.height - 10*2)/2].CGPath);
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
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(loginButton.bounds.size.height - 10*2)].CGPath);
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
    //退去软键盘
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];

    
    NSString *userName = self.userName.text;
//    NSString *passWord = self.passWord.text;
    
    
    // 请求地址
//    [Global setUrl:@"http://192.168.1.76:8080/sso/login?service=http://116.236.160.182:9083/AppCenter/"];
    
    // 账号输入为空时提醒
    if (userName == nil || [userName isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [message show];
    } else {
        // 保存用户名和密码,生成的Des加密字段
        [UserDefaults setValue:self.userName.text forKey:@"userName"];
        [UserDefaults setValue:self.passWord.text forKey:@"passWord"];
        [UserDefaults synchronize];
        
        [MBProgressHUD showMessage:@"正在登录" toView:self.view];
        // 单点登录,获取用户信息
        [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            if (success) {
                // 登录成功
                [self loginSuccessfully];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            } else {
                // 登录失败
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [message show];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            }
        }];
        
        
//        [self loginSuccessfully];
        
        
        
//        // 1.
//        NSDictionary *headerDic = @{@"Cookie":@""};
//        NSString *url = @"http://116.236.160.182:9083/sso/login?service=http://116.236.160.182:9083/AppCenter/system/views/index.jsp";
//        [MBProgressHUD showMessage:@"正在登录" toView:self.view];
//        
//        
//        
//        
//        [DamNetworkingManager GETWithUrl:url andHttpHeader:headerDic andSuccess:^(NSData *data,NSURLResponse *response) {
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            //        NSLog(@"responseString1:%@",responseString);
//            
//            TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
//            NSArray *array =[Hpple searchWithXPathQuery:@"//input"];
//            for (TFHppleElement *hppleElement in array) {
//                if ([hppleElement.raw.description containsString:@"lt"]) {
//                    NSArray *arr = [hppleElement.raw.description componentsSeparatedByString:@"\""];
//                    NSString *lt = arr[arr.count - 2];
//                    _lt = lt;
//                    NSLog(@"lt::%@",arr[arr.count - 2]);
//                } else if ([hppleElement.raw.description containsString:@"execution"]) {
//                    NSArray *arr2 = [hppleElement.raw.description componentsSeparatedByString:@"\""];
//                    NSString *execution = arr2[arr2.count - 2];
//                    _execution = execution;
//                    NSLog(@"execution::%@",arr2[arr2.count - 2]);
//                }
//            }
//            
//            // 2.
//            NSHTTPURLResponse *Response = (NSHTTPURLResponse *)response;
//            NSDictionary *dic = [Response allHeaderFields];
//            NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
//            NSString *Cookie = [cookieArr firstObject];
//            NSLog(@"Cookie1::%@",Cookie);
//            
//            NSDictionary *parameters = @{@"username":@"wangying",@"password":@"1",@"lt":_lt,@"execution":_execution,@"_eventId":@"submit",@"submit":@"登录"};
//            NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie};
//            NSString *paraStr = [NSString stringWithFormat: @"username=wangying&password=1&lt=%@&execution=%@&_eventId=submit&submit=登录",_lt,_execution];
//            
//            [DamNetworkingManager POSTWithUrl:url andBodyDic:nil andBodyStr:paraStr andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"responseString2:%@",responseString);
//                NSLog(@"response2::%@",response);
//                
//                NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
//                NSLog(@"Location2:%@",dic[@"Location"]);
//                //                NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie};
//                NSDictionary *headerDic = @{@"Connection":@"keep-alive"};
//                // 3.
//                [DamNetworkingManager GETWithUrl:dic[@"Location"] andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"responseString3:%@",responseString);
//                    
//                    //                    NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
//                    //                    NSDictionary *dic = [Response allHeaderFields];
//                    //                    NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
//                    //                    NSString *Cookie = [cookieArr firstObject];
//                    //                    NSLog(@"Cookie3::%@",Cookie);
//                    //                    NSDictionary *headerDic = @{@"Cookie":Cookie};
//                    [Global setCookie:Cookie];
//                    
//                    // 获取用户信息
//                    NSString *URL = @"http://116.236.160.182:9083/AppCenter/ApprpveMobile/getUserInfo.do";
//                    NSDictionary *headerDic = @{@"Connection":@"keep-alive"};
//                    
//                    // 4.用户信息
//                    [DamNetworkingManager GETWithUrl:URL andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//                        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                        NSLog(@"responseString4:%@",responseString);
//                        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                        userInfo = [self deleteNullWithDictionary:userInfo];
//                        [Global initializeSystem:[Global Url] deviceUUID:nil Cookie:[Global Cookie] user:userInfo];
//                        [Global setUserId:[userInfo objectForKey:@"id"]];
//                        //初始化用户信息
//                        [Global initializeUserInfo:self.userName.text userId:[userInfo objectForKey:@"id"] org:@""];
//                        
//                        
//                        [self loginSuccessfully];
//                        [MBProgressHUD hideHUDForView:self.view animated:NO];
//                        
//                    } andFailBlock:^(NSError *error) {
//                        [MBProgressHUD hideHUDForView:self.view animated:NO];
//                    }];
//                } andFailBlock:^(NSError *error) {
//                }];
//            } andFailBlock:^(NSError *error) {
//            }];
//        } andFailBlock:^(NSError *error) {
//        }];
        
        
//        [self loginSuccessfully];
        
        //        [MBProgressHUD showMessage:@"正在登录" toView:self.view];
        //
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        //申明返回的结果是json类型
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //
        //
        //        //传入的参数
        //        NSString *token = [Global token];
        //        if (nil==token) {
        //            token = @"";
        //        }
        //        //NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"login",@"name":name,@"pwd":pwd};
        //        NSDictionary *parameters = @{@"un":name,@"pwd":pwd};
        //
        //
        //        // 接口地址
        //        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/Login.ashx"];
        //        // url = @"http://61.153.29.236:8891/mobileService/service/Login.ashx?un=lw&pwd=";
        //
        //        NSMutableString *requestAddress=[NSMutableString stringWithFormat:@"%@",url];
        //        [requestAddress appendString:@"?"];
        //
        //        if (nil!=parameters) {
        //            for (NSString *key in parameters.keyEnumerator) {
        //                NSString *val = [parameters objectForKey:key];
        //                [requestAddress appendFormat:@"&%@=%@",key,val];
        //            }
        //        }
        //
        //        NSLog(@"登录%@",requestAddress);
        //        [self loginSuccessfully];
        //
        //        //发送请求
        //        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //            NSDictionary *rs = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        //            // 密码错误
        //            if (rs == nil)
        //            {
        //                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //
        //                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //                [message show];
        //            }
        //            else
        //            {
        //                // NSDictionary *rs = (NSDictionary *)responseObject;
        //                NSLog(@"rs::%@",rs);
        //                // NSLog(@"userId::%@",rs);
        //                //            if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
        //
        //                // 设备uuid
        //                NSString *deviceUUID = [defaults objectForKey:@"deviceUUID"];
        //                if ([deviceUUID isEqualToString:@""] || deviceUUID == nil) {
        //                    [Global setDeviceUUID:_deviceUUID];
        //                }else
        //                {
        //                    [Global setDeviceUUID:deviceUUID];
        //                }
        //
        //
        //                [Global initializeSystem:[Global Url] deviceUUID:[Global deviceUUID] user:[[rs objectForKey:@"data"] firstObject]];
        //                [Global setUserId:[[[rs objectForKey:@"data"] firstObject] objectForKey:@"id"]];
        //
        //                //初始化用户信息
        //                [Global initializeUserInfo:self.userName.text userId:[[[rs objectForKey:@"data"] firstObject]objectForKey:@"id"] org:@""];
        //                [self loginSuccessfully];
        //
        //            }
        //
        //
        //            [MBProgressHUD hideHUDForView:self.view animated:NO];
        //
        //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        //            [MBProgressHUD hideHUDForView:self.view animated:NO];
        //
        //            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //            [message show];
        //        }];
    }
    //
}

#pragma mark -- 登录成功
- (void)loginSuccessfully {
    
    self.loginButton.enabled = NO;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.8;
    transition.type = @"rippleEffect";
    //transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    [_scrollView.layer addAnimation:transition forKey:nil];
    // 定时
    [self performSelector:@selector(push:) withObject:nil afterDelay:1.5];
    
}

#pragma mark -- push
- (void)push:(id)sender {

    self.loginButton.enabled = YES;
    self.passWord.text = @"";
    
    _SHTabBar = [[SHTabBarController alloc] init];
    [self pushToViewControllerWithTransition:_SHTabBar animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
    
    // 登录成功发出移除手势界面
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginSuccessfully" object:nil userInfo:nil]];
}

#pragma mark -- 默认登录方式切换
- (void)judgeLoginWay {
    
    // 判断手势登录,指纹登录是否可用
    BOOL TouchID = [UserDefaults boolForKey:@"TouchID"];
    NSString *gesturePassWord = [UserDefaults objectForKey:@"gesturePassWord"];
    NSString *loginWay = [UserDefaults objectForKey:@"loginWay"];
    if (TouchID && [loginWay isEqualToString:@"TouchID"]) {
        // 指纹登录
        [self TouchIDLoginAction];
    } else if (gesturePassWord && [loginWay isEqualToString:@"gesture"]) {
        // 手势登录
        [self gestureLoginAction];
    } else {
        // 密码登录
    }
}

#pragma mark -- 切换登录方式
- (IBAction)OtherLoginWay:(id)sender {
    
    // 判断手势登录,指纹登录是否可用
    BOOL TouchID = [UserDefaults boolForKey:@"TouchID"];
    NSString *gesturePassWord = [UserDefaults objectForKey:@"gesturePassWord"];
    if (TouchID && !gesturePassWord) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择登录方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *TouchIDAction = [UIAlertAction actionWithTitle:@"指纹登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [UserDefaults setObject:@"TouchID" forKey:@"loginWay"];
            [UserDefaults synchronize];
            [self TouchIDLoginAction];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:TouchIDAction];
        [alert addAction:cancelAction];
        // Ipad crash
        alert.popoverPresentationController.sourceView = self.loginStyleButton;
        alert.popoverPresentationController.sourceRect = self.loginStyleButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (gesturePassWord && !TouchID) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择登录方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *GesAction = [UIAlertAction actionWithTitle:@"手势登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [UserDefaults setObject:@"gesture" forKey:@"loginWay"];
            [UserDefaults synchronize];
            [self gestureLoginAction];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:GesAction];
        [alert addAction:cancelAction];
        // Ipad crash
        // Ipad crash
        alert.popoverPresentationController.sourceView = self.loginStyleButton;
        alert.popoverPresentationController.sourceRect = self.loginStyleButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    } else if (TouchID && gesturePassWord) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择登录方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *TouchIDAction = [UIAlertAction actionWithTitle:@"指纹登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [UserDefaults setObject:@"TouchID" forKey:@"loginWay"];
            [UserDefaults synchronize];
            [self TouchIDLoginAction];
        }];
        UIAlertAction *GesAction = [UIAlertAction actionWithTitle:@"手势登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [UserDefaults setObject:@"gesture" forKey:@"loginWay"];
            [UserDefaults synchronize];
            [self gestureLoginAction];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:TouchIDAction];
        [alert addAction:GesAction];
        [alert addAction:cancelAction];
        // Ipad crash
        alert.popoverPresentationController.sourceView = self.loginStyleButton;
        alert.popoverPresentationController.sourceRect = self.loginStyleButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未设置其他登录方式, 请使用密码登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sureAction];
        // Ipad crash
        alert.popoverPresentationController.sourceView = self.loginStyleButton;
        alert.popoverPresentationController.sourceRect = self.loginStyleButton.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -- 指纹登录
- (void)TouchIDLoginAction {
    
    [DistTouchID Dist_initWithTouchIDPromptMsg:@"请验证您的指纹, 登录TJUP微办公" cancelMsg:@"取消" otherMsg:nil enabled:YES otherClick:^(NSString *otherClick) {
        
        DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
        
    } success:^(BOOL success) {
        
        [MBProgressHUD showMessage:@"正在登录" toView:self.view];
        // 单点登录,获取用户信息
        [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            if (success) {
                // 登录成功
                [self loginSuccessfully];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            } else {
                // 登录失败
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [message show];
                
                [MBProgressHUD hideHUDForView:self.view animated:NO];
            }
        }];
        DLog(@"指纹解锁成功");
        DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
        
    } error:^(NSError *error) {
        
        DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
        
    } errorMsg:^(NSString *errorMsg) {
        
        DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
    }];
}

#pragma mark -- 手势登录
- (void)gestureLoginAction {
    
    DistGestureLock *gestureLock = [[DistGestureLock alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) gestureType:2];
    _distGestureLock = gestureLock;
    [gestureLock showInView:self.view animated:YES];
    
    gestureLock.gestureVerifyBlock = ^(BOOL isSuccess){
    
        if (isSuccess) {
            // 验证成功
            [MBProgressHUD showMessage:@"正在登录" toView:self.view];
            // 单点登录,获取用户信息
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
                if (success) {
                    // 登录成功
                    [self loginSuccessfully];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                } else {
                    // 登录失败
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [message show];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                }
            }];
        } else {
            // 验证失败
            DLog(@"验证失败");
        }
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**
     *  Description
     */
    //self.loginPanelViewHeight.constant = self.loginPanelHeight;
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /**
     *  Description
     */
    //self.loginPanelViewHeight.constant=self.loginPanelHeight;
    
    [textField resignFirstResponder];
    return  YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag ==100)
    {
        if (SCREEN_WIDTH==320)
        {
            self.loginBackView_top.constant = 0;
        }
    }
    return  YES;
}

#pragma mark -- 背景动画
- (void)createBackAnimationView
{
    if (!_scrollView) {
        UIImage *backImage = [UIImage imageNamed:@"loginImage.jpg"];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH + 150, SCREEN_HEIGHT);
        scroll.contentOffset = CGPointMake(0, 0);
        scroll.bounces = NO;
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.userInteractionEnabled = NO;
        _scrollView = scroll;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 150, SCREEN_HEIGHT)];
        imageView.image = backImage;
        _imageView = imageView;
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scroll addSubview:imageView];
        [self.view addSubview:scroll];
        [self.view bringSubviewToFront:self.forgetPwButton];
        [self.view bringSubviewToFront:self.loginStyleButton];
        [self.view bringSubviewToFront:self.loginBackView];
    }
}

- (void)scrollAnimation
{
    static BOOL isLeft = YES;
    if (isLeft)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + 4.0, _scrollView.contentOffset.y) animated:YES];
        if (_scrollView.contentOffset.x >= _scrollView.contentSize.width - SCREEN_WIDTH - 10.0)
        {
            isLeft = NO;
        }
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x - 4.0, _scrollView.contentOffset.y) animated:YES];
        if (_scrollView.contentOffset.x <= 10.0)
        {
            isLeft = YES;
        }
    }
}

#pragma mark -- 检测更新
- (void)checkUpdated
{
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

/**
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    if (response[@"downloadURL"]) {
        
        NSString *message = response[@"releaseNote"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本,请前往更新" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            // 调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，如果有更新的话，在调用了此方法后再次调用将不提示更新信息。
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            
        }];
        //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        }];
        [alert addAction:updateAction];
        //[alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -- 设备首次登录验证(短信)
- (void)loginValidate {
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.dist.TJYD.deviceValidate" accessGroup:nil];
    NSString *deviceValidate = [keychainItem objectForKey:(__bridge id)kSecValueData];
    if ([deviceValidate isEqualToString:@"true"]) {
        DLog(@"通过验证");
    } else {
        DLog(@"未通过验证");
        DistLoginValidate *distLoginValidate = [[DistLoginValidate alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _distLoginValidate = distLoginValidate;
        [distLoginValidate showInView:self.view animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
