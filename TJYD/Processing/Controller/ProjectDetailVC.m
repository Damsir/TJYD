//
//  ProjectDetailVC.m
//  TJYD
//
//  Created by 吴定如 on 17/4/12.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ProjectDetailVC.h"
#import "SHCover.h"
#import "DamSlideSegment.h"
#import "ProjectInfoVC.h"
#import "ProjectMaterialVC.h"
#import "LogViewController.h"
#import "TreeViewController.h"


@interface ProjectDetailVC () <SHCoverDelegate>

@property (nonatomic,strong) ProjectInfoVC *infoVC;
@property (nonatomic,strong) ProjectMaterialVC *materialVC;
@property (nonatomic,strong) DamSlideSegment *slideSegment;
@property (nonatomic,strong) UIView *popView;//选择视图
@property (nonatomic,strong) UIView *cover;//蒙版
@property (nonatomic,strong) NSArray *btnImageArray;//按钮图片数组
@property (nonatomic,strong) NSArray *btnTitleArray;//按钮标题数组

@end

@implementation ProjectDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_infoVC viewWillAppear:animated];
//    [_materialVC viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)reloadData {
    
    [self createSlideSegment];
}


- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
    DLog(@"销毁...");
//    [_infoVC removeFromParentViewController];
//    _infoVC = nil;
//    [_materialVC removeFromParentViewController];
//    _materialVC = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavigationBarTitle:@"项目详情"];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreOnClick)];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _slideSegment.frame= CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT - 64);
    [_slideSegment screenRotationWithFrame:_slideSegment.frame];
    _popView.frame = CGRectMake(SCREEN_WIDTH-135, 64, 120, 80);
    _cover.frame = [UIScreen mainScreen].bounds;
}

#pragma mark -- 创建slideSegment

- (void)createSlideSegment {
    // 项目信息
    if (!_infoVC) {
        _infoVC = [[ProjectInfoVC alloc] init];
    }
    _infoVC.listModel = _listModel;
    _infoVC.navi = self.navi;
    
    
    // 项目附件
    if (!_materialVC) {
        _materialVC = [[ProjectMaterialVC alloc] init];
    }
    _materialVC.listModel = _listModel;
    _materialVC.navi = self.navi;
    
    
    NSArray *viewsArray = @[_infoVC.view,_materialVC.view];
    NSArray *titlesArray = @[@"项目信息",@"项目附件"];
    
    if (!_slideSegment) {
        _slideSegment = [[DamSlideSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT - 64) WithControllerViewArray:viewsArray AndWithTitlesArray:titlesArray];
    }
    _slideSegment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_slideSegment];
    
    [_infoVC reloadData];
    [_materialVC reloadData];
}

#pragma mark -- 更多(流转日志,项目关联)
- (void)moreOnClick {
    
    _btnImageArray = @[@"spot",@"spot"];
    _btnTitleArray = @[@"流转日志",@"项目关联"];
    //弹出选择框
    SHCover *cover = [SHCover show];
    _cover = cover;
    cover.userInteractionEnabled = YES;
    cover.delegate = self;
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 64, 120, 80)];
    popView.backgroundColor = [UIColor whiteColor];
    _popView = popView;
    [KeyWindow addSubview:_popView];
    
    [self creatMoreBtn];
}

- (void)creatMoreBtn {
    
    long count = [self.btnTitleArray count];
    for ( int i = 0; i<count; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:_btnImageArray[i]] forState:UIControlStateNormal];
        [btn setTitle:_btnTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 90)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        btn.frame = CGRectMake(0, _popView.frame.size.height*i/2.0, _popView.frame.size.width, _popView.frame.size.height/2.0);
        btn.tag = 150+i;
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, _popView.frame.size.height/2.0, _popView.frame.size.width, 0.5)];
        line.backgroundColor = GRAYCOLOR_MIDDLE;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:btn];
        [btn addSubview:line];
    }
}

- (void)btnClick:(UIButton *)btn {
    
    NSInteger btntag = btn.tag-150;
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    switch (btntag) {
        case 0:
        {
            LogViewController *logVC = [[LogViewController alloc] init];
            logVC.listModel = _listModel;
            [self pushToViewControllerWithTransition:logVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
        }
            break;
        case 1:
        {
            TreeViewController *treeVC = [[TreeViewController alloc] init];
            treeVC.listModel = _listModel;
            [self pushToViewControllerWithTransition:treeVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navi];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 点击蒙板的时候调用(SHCoverDelegate)
- (void)coverDidClickCover:(SHCover *)cover {
    // 隐藏pop菜单
    [_popView removeFromSuperview];
}

#pragma mark -- 返回
- (void)backToLastViewController {
    
    // 发出移除coach表单的通知(给SignViewController)
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"removeForm" object:nil userInfo:nil]];
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
