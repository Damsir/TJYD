//
//  SHTabBarController.m
//  TJYD
//
//  Created by 吴定如 on 17/3/29.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SHTabBarController.h"
#import "SHNavigationController.h"
#import "HomeViewController.h"
#import "ProcessingViewController.h"
#import "ComprehensiveVC.h"
#import "MoreViewController.h"
#import "LoginViewController.h"

@interface SHTabBarController () <UITabBarControllerDelegate>

@property (nonatomic,strong) SHNavigationController *navi;
@property (nonatomic,assign) NSInteger indexFlag;
@property (nonatomic,strong) HomeViewController *homeVC;
@property (nonatomic,strong) ProcessingViewController *processingVC;
@property (nonatomic,strong) MoreViewController *moreVC;

@end

@implementation SHTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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

    self.tabBar.tintColor = HOMEBLUECOLOR;
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    //关闭自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.indexFlag = 0;
    
    [self loadViewControllers];
    
    // 退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {

}

#pragma mark -- 加载子视图

- (void)loadViewControllers
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildViewController:homeVC title:@"首页" normalImage:@"home_n" selectImage:@"home_s"];
    
    if (!_processingVC) {
        _processingVC = [[ProcessingViewController alloc] init];
    }
    [self addChildViewController:_processingVC title:@"待办事项" normalImage:@"processing_n" selectImage:@"processing_s"];
    
//    ComprehensiveVC *comVC = [[ComprehensiveVC alloc] init];
//    [self addChildViewController:comVC title:@"综合查询" normalImage:@"search_n" selectImage:@"search_s"];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self addChildViewController:moreVC title:@"更多" normalImage:@"more_n" selectImage:@"more_s"];
}

- (void)addChildViewController:(UIViewController *)childVC title:(NSString *)title normalImage:(NSString *)imageName selectImage:(NSString *)selectImage{
    
    childVC.title = title;
    [childVC.tabBarItem setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childVC.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SHNavigationController *navi = [[SHNavigationController alloc] initWithRootViewController:childVC];
    _navi = navi;
    //    navi.navigationBar.hidden = NO;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    //    nav.navigationBar.translucent = NO;
    
    [self addChildViewController:navi];
    
}

#pragma mark -- TabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
    
}
// 动画
- (void)animationWithIndex:(NSInteger)index
{
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.duration = 0.3;
    scale.repeatCount = 1;
    scale.autoreverses = YES;
    scale.fromValue = [NSNumber numberWithFloat:1.0];
    //scale.byValue = [NSNumber numberWithFloat:1.2];
    scale.toValue = [NSNumber numberWithFloat:1.3];
    
    //    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //    animation.values = @[@(1.0), @(1.2), @(1.3), @(1.2), @(1.0)];
    //    animation.duration = 0.5;
    //    animation.calculationMode = kCAAnimationCubic;
    
    [[tabbarbuttonArray[index] layer] addAnimation:scale forKey:nil];
    
    self.indexFlag = index;
}

#pragma mark -- 退出登录/注销
- (void)changeRootView:(NSNotification *)noty {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.70;
//    transition.type = @"rippleEffect";
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
