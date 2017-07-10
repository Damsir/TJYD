//
//  HomeViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MyProjectViewController.h"//我的项目
#import "NewsViewController.h"//院内新闻
#import "InfoPublicViewController.h"//信息公开
#import "ContactsViewController.h"//通讯录
#import "MessageViewController.h"//系统消息
#import "MessageModel.h"

#define Button_W 80.0

@interface HomeViewController ()

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UIButton *todoButton;//待办事项
@property (nonatomic,strong) UIButton *myProButton;//我的项目
@property (nonatomic,strong) UIButton *pubAdminButton;//院内新闻
@property (nonatomic,strong) UIButton *pubMessButton;//信息公开
@property (nonatomic,strong) UIButton *insMessButton;//即时通讯
@property (nonatomic,strong) UIButton *personalAdminButton;//人事管理
@property (nonatomic,strong) UIButton *sysMessButton;//系统消息
@property (nonatomic,assign) NSString *waitCount;//待办数量
@property (nonatomic,assign) NSString *sysCount;//系统消息角标
@property (nonatomic,strong) UILabel *waitAngle;//待办角标
@property (nonatomic,strong) UILabel *sysAngle;//系统消息角标
@property (nonatomic,strong) NSMutableArray *messageArray;//系统消息

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _waitCount = @"";
    _sysCount = @"";
    // 加载待办事项数量
    [self loadProcessingData];
    // 加载系统消息
    [self loadSystemMessageData];
    // 检测更新
    [self checkUpdated];
   
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBarTitle:@"TJUP微办公"];
    
    [self createHomePageButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-113)/2);
}

#pragma mark -- 加载待办事项数量
- (void)loadProcessingData {
    
    // 待办事项(项目)
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==ApprpveMobile/getProcessingList.do?queryFilter=&pageIndex=1&pageSize=1,%@",ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetProcessingList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            _waitCount = [[JsonDic objectForKey:@"result"] objectForKey:@"count"];
            [self updateAngleNumber];
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark -- 加载系统消息
- (void)loadSystemMessageData {
    
    _messageArray = [NSMutableArray array];
    // 系统消息
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==TJMessage/getReceivedList.do?pageIndex=1&pageSize=10,%@",ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetReceivedList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            _sysCount = [JsonDic[@"result"] objectForKey:@"noRead"];
            [self updateAngleNumber];
            for (NSDictionary *dic in JsonDic[@"result"][@"list"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:dic];
                [_messageArray addObject:model];
            }
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark -- 更新角标数量及显示
- (void)updateAngleNumber {
    
    _waitAngle.hidden = [_waitCount isEqualToString:@"0"]||[_waitCount isEqualToString:@""] ? YES : NO;
    _waitAngle.text = _waitCount;
    
    _sysAngle.hidden = [_sysCount isEqualToString:@"0"]||[_sysCount isEqualToString:@""] ? YES : NO;
    _sysAngle.text = _sysCount;
}

#pragma mark --  首页导航按钮
- (void)createHomePageButtons {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 290)];
    backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-113)/2);
//    backView.backgroundColor = [UIColor orangeColor];
    _backView = backView;
    [self.view addSubview:backView];
    
    
    CGFloat gap_h = (SCREEN_WIDTH-Button_W*3)/4;
    CGFloat gap_v = 25.0;
    
    // 待办事项
    UIButton *todoButton  = [self createButtonWithImage:@"gwbl" andTitle:@"待办事项" andFrame:CGRectMake(gap_h, 0, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:101];
    _todoButton = todoButton ;
    [backView addSubview:_todoButton];
    
    // 待办事项角标提示
    UILabel *waitAngle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
    waitAngle.backgroundColor = [UIColor redColor];
    waitAngle.layer.cornerRadius = waitAngle.bounds.size.width/2;
    waitAngle.clipsToBounds = YES;
    waitAngle.textColor = [UIColor whiteColor];
    waitAngle.font = [UIFont systemFontOfSize:12.0];
    waitAngle.textAlignment = NSTextAlignmentCenter;
    waitAngle.hidden = YES;
    _waitAngle = waitAngle;
    [_todoButton addSubview:waitAngle];
    
    // 我的项目
    UIButton *pubAdminButton = [self createButtonWithImage:@"wdxm" andTitle:@"我的项目" andFrame:CGRectMake(CGRectGetMaxX(_todoButton.frame)+gap_h, 0, Button_W, Button_W)andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:102];
    _pubAdminButton = pubAdminButton;
    [backView addSubview:_pubAdminButton];
    
    // 人事管理
    UIButton *pubMessButton = [self createButtonWithImage:@"rsgl" andTitle:@"人事管理" andFrame:CGRectMake(CGRectGetMaxX(_pubAdminButton.frame)+gap_h, 0, Button_W, Button_W)andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:103];
    _pubMessButton = pubMessButton;
    [backView addSubview:_pubMessButton];
    
    // 院内新闻
    // 行政管理
    UIButton *myproButton  = [self createButtonWithImage:@"ynxw" andTitle:@"院内新闻" andFrame:CGRectMake(gap_h, CGRectGetMaxY(_pubAdminButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:104];
    _myProButton = myproButton ;
    [backView addSubview:_myProButton];
   
    // 信息公开
    UIButton *personalAdminButton  = [self createButtonWithImage:@"hysap" andTitle:@"信息公开" andFrame:CGRectMake(CGRectGetMaxX(_myProButton.frame)+gap_h, CGRectGetMaxY(_pubAdminButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:105];
    _personalAdminButton = personalAdminButton ;
    [backView addSubview:_personalAdminButton];
    
    // 通讯录
    UIButton *insMessButton  = [self createButtonWithImage:@"txl" andTitle:@"通讯录" andFrame:CGRectMake(gap_h+CGRectGetMaxX(_personalAdminButton.frame), CGRectGetMaxY(_pubAdminButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:106];
    _insMessButton = insMessButton ;
    [backView addSubview:_insMessButton];
    
    // 系统消息
    UIButton *sysMessButton = [self createButtonWithImage:@"gg" andTitle:@"系统消息" andFrame:CGRectMake(gap_h, CGRectGetMaxY(personalAdminButton.frame)+gap_v, Button_W, Button_W) andTitleEdgeInsets:UIEdgeInsetsMake(70, -60, 0, 0) andTag:107];
    _sysMessButton = sysMessButton;
    [backView addSubview:_sysMessButton];
    // 系统信息角标提示
    // 待办事项角标提示
    UILabel *sysAngle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
    sysAngle.backgroundColor = [UIColor redColor];
    sysAngle.layer.cornerRadius = sysAngle.bounds.size.width/2;
    sysAngle.clipsToBounds = YES;
    sysAngle.textColor = [UIColor whiteColor];
    sysAngle.font = [UIFont systemFontOfSize:12.0];
    sysAngle.textAlignment = NSTextAlignmentCenter;
    sysAngle.hidden = YES;
    _sysAngle = sysAngle;
//    [_sysMessButton addSubview:sysAngle];

}

- (UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets andTag:(NSInteger)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor orangeColor];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];
    // 按钮对齐方式设置
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = tag;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonOnclick:(UIButton *)btn {
    
    // 待办事项
    if (btn.tag == 101) {
        self.tabBarController.selectedIndex = 1;
    }
    // 我的项目
    else if (btn.tag == 102) {
        MyProjectViewController *myProjectVC = [[MyProjectViewController alloc] init];
        myProjectVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:myProjectVC animated:YES];
        [self pushToViewControllerWithTransition:myProjectVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
    }
    // 人事管理
    else if (btn.tag == 103) {
        
    }
    // 院内新闻
    else if (btn.tag == 104) {
        NewsViewController *newsVC = [[NewsViewController alloc] init];
        newsVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:newsVC animated:YES];
        [self pushToViewControllerWithTransition:newsVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
    }
    // 信息公开
    else if (btn.tag == 105) {
        InfoPublicViewController *publicVC = [[InfoPublicViewController alloc] init];
        publicVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:publicVC animated:YES];
        [self pushToViewControllerWithTransition:publicVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
    }
    // 通讯录
    else if (btn.tag == 106) {
        ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
        contactsVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:contactsVC animated:YES];
        [self pushToViewControllerWithTransition:contactsVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
    }
    // 系统信息
    else if (btn.tag == 107) {
        MessageViewController *messageVC = [[MessageViewController alloc] init];
        messageVC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:contactsVC animated:YES];
        [self pushToViewControllerWithTransition:messageVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
