//
//  ProcessingViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/3/29.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ProcessingViewController.h"
#import "DamSlideSegment.h"
#import "ProjectViewController.h"
#import "PersonnelViewController.h"
#import "RecaptionViewController.h"

@interface ProcessingViewController ()

@property (nonatomic,strong) ProjectViewController *projectVC;
@property (nonatomic,strong) PersonnelViewController *personnelVC;
@property (nonatomic,strong) DamSlideSegment *slideSegment;

@end

@implementation ProcessingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_projectVC viewWillAppear:animated];
//    [_personnelVC viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

//- (void)reloadData {
//    
//}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
    
//    [_projectVC removeFromParentViewController];
//    _projectVC = nil;
//    [_personnelVC removeFromParentViewController];
//    _personnelVC = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initNavigationBarTitle:@"待办事项"];
    [self createSlideSegment];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(searchOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goBack"] style:UIBarButtonItemStyleDone target:self action:@selector(getBackOnClick)];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _slideSegment.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-49-64) ;
    [_slideSegment screenRotationWithFrame:_slideSegment.frame];
}

#pragma mark -- 创建slideSegment

- (void)createSlideSegment {
    // 项目
    if (!_projectVC) {
        _projectVC = [[ProjectViewController alloc] init];
    }
    _projectVC.navi = self.navigationController;
    
    // 人事
    if (!_personnelVC) {
        _personnelVC = [[PersonnelViewController alloc] init];
    }
    
    NSArray *viewsArray = @[_projectVC.view,_personnelVC.view];
    NSArray *titlesArray = @[@"项目",@"人事"];
    
    if (!_slideSegment) {
        _slideSegment = [[DamSlideSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-49-64) WithControllerViewArray:viewsArray AndWithTitlesArray:titlesArray];
    }
    _slideSegment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_slideSegment];
    
    [_projectVC reloadData];
    [_personnelVC reloadData];
}

#pragma mark -- 表单可取回列表事件
- (void)getBackOnClick {
    
    RecaptionViewController *recaptionVC = [[RecaptionViewController alloc] init];
    recaptionVC.hidesBottomBarWhenPushed = YES;
    
    [self pushToViewControllerWithTransition:recaptionVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
