//
//  DigitMaterialViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/1/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DigitMaterialViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MBProgressHUD+MJ.h"
#import "BusinessCell.h"
#import "DigitMaterialModel.h"
#import "ResourceManagerAddressBar.h"
#import "FileTableViewContainerV.h"
#import "Global.h"
#import "UserInfo.h"

//#import "DejalActivityView.h"

@interface DigitMaterialViewController ()<UISearchBarDelegate,ResourceManagerAddressBarDelegate,FileItemThumbnailDelegate,FileViewerDelegate>

{
    BOOL _isOnlineRsource;
}

@end

@implementation DigitMaterialViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (id obj in self.navigationController.navigationBar.subviews) {
        if ([obj isKindOfClass:[UIButton class]]||[obj isKindOfClass:[UISearchBar class]]) {
            [obj setHidden:YES];
        }
        
    }
    [self.seaBarFile resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (id obj in self.navigationController.navigationBar.subviews) {
        if ([obj isKindOfClass:[UIButton class]]||[obj isKindOfClass:[UISearchBar class]]) {
            [obj setHidden:NO];
        }
        
    }
    
    self.tabBarController.tabBar.hidden = YES;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建资源显示View
    UIView *resourcesView =[[UIView alloc] initWithFrame:CGRectMake(0,40+42, SCREEN_WIDTH, SCREEN_HEIGHT-64-42-40)];
//    self.resourcesView.backgroundColor =[UIColor redColor];
    _resourcesView = resourcesView;
    [self.view addSubview:_resourcesView];
    //防止重复添加
    if (self.navigationController.navigationBar.subviews.count>3) {
            for (id obj in self.navigationController.navigationBar.subviews) {
                if ([obj isKindOfClass:[UIButton class]]||[obj isKindOfClass:[UISearchBar class]]) {
                    [obj removeFromSuperview];
                }
                
            }
    }
    //创建导航栏上的内容
    [self initSubViewStyle];
    //创建在线资源目录栏
    [self showOnlineResource];
    self.selecteds.selected = NO;
    self.selecteds.enabled= NO;
//    CGRect frame= _segC.frame;
//    [self.segC setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100)];
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segC setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    
    
    self.segC.segmentedControlStyle= UISegmentedControlStyleBar;//设置
    
    self.segC.tintColor=RGB(34.0, 152.0, 239.0);
    [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    [self.segC addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDigit) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changeDigit
{
    CGFloat y=CGRectGetMaxY(self.segC.frame)+10;
    CGFloat height=32;
    
    _localAddressBar.frame=CGRectMake(0, y, SCREEN_WIDTH, height);
    _onlineAddressBar.frame = CGRectMake(0, y, SCREEN_WIDTH, height);
    self.resourcesView.frame =CGRectMake(0,40+42, SCREEN_WIDTH, SCREEN_HEIGHT-64-40-42);

    self.rsView.frame=CGRectMake(0,15, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMinY(self.resourcesView.frame)-64-15);
    
    self.seaBarFile.frame=CGRectMake(25, 6,SCREEN_WIDTH-150, 32);
    _searchBtn.frame = CGRectMake( SCREEN_WIDTH-100, 5,50, 30);
    
    
    _selecteds.frame = CGRectMake( SCREEN_WIDTH-50, 5,50, 30);
    
    
}

//显示在线资源
- (void)showOnlineResource{
    //初始化工具上的seaBarFile
    _isOnlineRsource=YES;
    //创建目录条
    [self createOnlineAddressbar];
    _onlineAddressBar.hidden = NO;
    _localAddressBar.hidden = YES;
    _segC.selectedSegmentIndex=0;//默认选中项索引（计数是从0开始的)
    
    ////去加载指定的资源的内容------需要刷新tableView------封装的方法
    [self doLoad:[_onlineAddressBar currentPath] andKey:@""];
}

//显示本地资源
- (void)showLocalResource{
    _isOnlineRsource = NO;
    
    [self createLocalAddressbar];
    _onlineAddressBar.hidden = YES;
    _localAddressBar.hidden = NO;
    _segC.selectedSegmentIndex=1;//默认选中项索引
    [self doLoad:[_localAddressBar currentPath] andKey:@""];
}


//打开文件夹中的内容(为文件夹)------------设置按钮条
- (void)load:(NSString *)path andFileName:(NSString *)fileName{
    //_intSearched=0;
   ////加载指定的资源的内容------需要刷新tableView
    NSLog(@"打开path==%@",path);
    [self doLoad:path andKey:fileName];
    if (_isOnlineRsource) {
        [_onlineAddressBar go:self.path];
    }else{
        [_localAddressBar go:self.path];
    }
}

//加载指定的资源的内容--创建tableView--需要刷新tableView
- (void)doLoad:(NSString *)path andKey:(NSString *)key{
    //移除子视图
    for(UIView *view in self.resourcesView.subviews)
    {
        [view removeFromSuperview];
    }
    self.path=path;
    self.searchkey = key;
    _rsView = [[FileTableViewContainerV alloc] initWithFrame:CGRectMake(0,15, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMinY(self.resourcesView.frame)-64-15)];
    _rsView.backgroundColor =[UIColor whiteColor];
//    _rsView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置代理FileItemThumbnailDelegate(点击某个文件 执行代理方法)
    _rsView.resourceDelegate = self;
    
    //判断(非在线资源即本地资源)
    _rsView.isFromLocal = !_isOnlineRsource;//bool
    //在线资源
    if (_isOnlineRsource) {
        [_rsView load:path andKey:key];//(让tableView所在的view去加载指定数据//下载)
    }
    //本地资源
    else{
        //获取本地资源路径
        NSString *realPath = [[self resouceManagerDirectory] stringByAppendingPathComponent:path];
        [_rsView load:realPath andKey:key];
    }
    _rsView.owner=self;
    //添加资源view
    [self.resourcesView addSubview:_rsView];
}


//获取ResourceManagerDataSource路径
//获取存储的路径
- (NSString *)resouceManagerDirectory{
    NSString *pp=[[Global currentUser] userResourcePath];
    return pp;
}

//创建在线资源目录条
- (void) createOnlineAddressbar
{
    if (nil==_onlineAddressBar) {
        CGFloat y=CGRectGetMaxY(self.segC.frame)+10;
        CGFloat height=32;
        _onlineAddressBar = [[ResourceManagerAddressBar alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)];
        //设置根路径名字
        _onlineAddressBar.rootPathName = @"在线目录";
        _onlineAddressBar.delegate = self;
        [self.view addSubview:_onlineAddressBar];
        //前进
        [_onlineAddressBar go:@""];
        
  
    }
}

//创建本地目录条
- (void)createLocalAddressbar{
    if (nil==_localAddressBar) {
        CGFloat y=CGRectGetMaxY(self.segC.frame)+10;
        CGFloat height=32;
        
        _localAddressBar = [[ResourceManagerAddressBar alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, height)];
        _localAddressBar.rootPathName = @"本地资源目录";
        _localAddressBar.delegate = self;
        [self.view addSubview:_localAddressBar];
        [_localAddressBar go:@""];
        
    }
}

//初始化导航栏上的seaBarFile
- (void)initSubViewStyle{
    //创建搜索按钮
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn setTintColor:[UIColor blackColor]];
    searchBtn.frame = CGRectMake( SCREEN_WIDTH-100, 5,50, 30);
    [searchBtn addTarget:self action:@selector(openSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
    self.searchBtn.layer.cornerRadius=13.0;
    _searchBtn= searchBtn;
    //[self.navigationController.navigationBar addSubview:_searchBtn];
    
    //创建多选按钮
    UIButton *selecteds =[UIButton buttonWithType:UIButtonTypeCustom];
    [selecteds setTitle:@"删除" forState:UIControlStateNormal];
    [selecteds setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selecteds setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [selecteds setTintColor:[UIColor blackColor]];
        selecteds.frame = CGRectMake( SCREEN_WIDTH-50, 5,50, 30);
        [selecteds addTarget:self action:@selector(selectedMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         self.selecteds.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
        self.selecteds.layer.cornerRadius=13.0;
        _selecteds=selecteds;
    if (_isOnlineRsource) {
        
        self.selecteds.enabled= NO;
        [self.selecteds setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    else
    {
        self.selecteds.enabled = YES;
         [self.selecteds setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
   // [self.navigationController.navigationBar addSubview:_selecteds];

    
    if (nil!=_onlineAddressBar || nil!=_localAddressBar) {
        return;
    }
    UISearchBar *seaBarFile =[[UISearchBar alloc] initWithFrame:CGRectMake(160, 5,0, 30)];
    seaBarFile.backgroundColor = [UIColor whiteColor];
    seaBarFile.clipsToBounds = NO;
    seaBarFile.delegate=self;
    [seaBarFile setBarTintColor:[UIColor whiteColor]];
    _seaBarFile = seaBarFile;
    //[self.navigationController.navigationBar addSubview:_seaBarFile];
}
//点击搜索框
- (void)openSearchBtnClick:(UIButton *)sender {
    if ([self.searchBtn.titleLabel.text isEqualToString:@"搜索"]) {
        [UIView animateWithDuration:1 animations:^{
            self.seaBarFile.alpha=1;
           self.seaBarFile.delegate=self;

            self.seaBarFile.frame=CGRectMake(25, 6,SCREEN_WIDTH-150, 32);
            [self.seaBarFile becomeFirstResponder];
            [self.searchBtn setTitle:@"取消" forState:UIControlStateNormal];
        }];
    }
    else{
        [self.seaBarFile resignFirstResponder];
        [UIView animateWithDuration:1 animations:^{
            self.seaBarFile.alpha=0;
            self.seaBarFile.delegate=self;

            self.seaBarFile.frame=CGRectMake(160, 5,0, 30);

            [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        }];
    }
}


- (void)selectedMoreBtnClick:(UIButton *)sender {
    
    NSLog(@"删除");
    [_rsView editTableView];
    
}


//UISegmentedControl的点击方法
- (void)segmentedAction:(UISegmentedControl *)Seg
{
    NSInteger index=Seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            //创建在线资源目录条
            [self showOnlineResource];
            self.selecteds.enabled = NO;
            break;
        case 1:
            //创建本地资源目录条
            [self showLocalResource];
            self.selecteds.enabled = YES;
            break;
    }
    
}


#pragma  mark-FileItemThumbnailDelegate代理方法(打开选中文件)
//点击cell,获取对应数据
- (void)fileItemDidTap:(NSString *)name type:(NSString *)type path:(NSString *)path{
    
    NSLog(@"name=%@,type=%@,path=%@",name,type,path);
    //如果是extended是@""代表是文件夹 ==filetype
    if([type isEqualToString:@"floader"]){
        CATransition* transition = [CATransition animation];
        //只执行0.5-0.6之间的动画部分
        //    transition.startProgress = 0.5;
        //    transition.endProgress = 0.6;
        //动画持续时间
        transition.duration = 0.5;
        //进出减缓
        transition.timingFunction = UIViewAnimationCurveEaseInOut;
        //动画效果
        transition.type = @"suckUnEffect";
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.resourcesView.layer addAnimation:transition forKey:nil];
        //view之间的切换
        [self.resourcesView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        NSString *path=[self.path stringByAppendingFormat:@"//%@", name];
        //打开文件夹中的内容(为文件夹)
        [self load:path andFileName:name];
        
    }
    
    //是具体类型的文件时
    else{
        //如果是在线资源
        if (_isOnlineRsource) {
            NSString *filePath=self.path;
            if (_intSearched==1) {
                filePath=[path stringByAppendingString:filePath];
            }
            //61.153.29.236:8891/mobileService/service/gw/DownLoadFtpFile.ashx?path=&file=sasf.txt
            NSString *fileName = name;
            //NSString *fileName = [NSString stringWithFormat:@"%@//%@",filePath,name];
            filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *downloadPath= [NSString stringWithFormat:@"%@/service/gw/DownLoadFtpFile.ashx?path=%@&file=%@",[Global Url],filePath,name];
            
            NSString * fruits = name;
            NSArray  * array= [fruits componentsSeparatedByString:@"."];
            NSString *extension=array.lastObject;
            
            //self.fileDelegate的代理为ResourceViewController
            // [self.fileDelegate openFile:name path:p ext:extension isLocalFile:NO];
            
            
            
            [self openFile:fileName path:downloadPath ext:extension isLocalFile:NO];
            
        }
        //本地资源
        else{
            NSString *p=@"";
           // NSError *error;
            //取出路径下地内容
            //获取本地资源路径
            NSString *realPath = [[self resouceManagerDirectory] stringByAppendingPathComponent:path];
            
            NSLog(@"路径::%@",realPath);
            //根目录
            if ([path isEqualToString:@""]) {
                // ResourceManagerDataSourceDelegate代理获取本地路径
                //                p = [NSString stringWithFormat:@"%@/%@/%@",[self.managerDelegate  resouceManagerDirectory],self.path,name];
                p = [NSString stringWithFormat:@"%@/%@/%@",[self resouceManagerDirectory],self.path,name];
            }
            //非根目录
            else
            {
                p = realPath;
            
            }
            //            [self.fileDelegate openFile:name path:p ext:[name pathExtension] isLocalFile:YES];
            [self openFile:name path:p ext:[name pathExtension] isLocalFile:YES];
            
        }
    }
}

#pragma mark-ResourceManagerAddressBarDelegate 代理方法---
- (void)addressBar:(ResourceManagerAddressBar *)bar didChange:(NSString *)path{
    [self doLoad:path andKey:@""];
}


#pragma mark- UISearchBarDelegate
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *fileName = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    fileName = [fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![fileName isEqualToString:@""]) {
        _intSearched=1;
    }
    else{
        _intSearched=0;
    }
    //打开文件夹中的内容(为文件夹)
    [self load:self.path andFileName:fileName];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSString *fileName = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    fileName = [fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if (![fileName isEqualToString:@""]) {
        _intSearched=1;
    }else{
        _intSearched=0;
    }
    [self load:self.path andFileName:fileName];
}



#pragma mark-OpenFileDelegate代理方法(打开具体文件的内容)

- (void)openFile:(NSString *)name path:(NSString *)path ext:(NSString *)ext isLocalFile:(BOOL)isLocalFile{
    NSLog(@"test = name=%@,path=%@,ext=%@,isLocalFile=%d",name,path,ext,isLocalFile);
    
    if (nil == _fileViewController) {
        _fileViewController = [[FileVC alloc] init];
        
        //设置代理
        _fileViewController.fileViewDelegate = self;
        
    }
    _fileViewController.fileName = name;
    _fileViewController.filePath = path;
    _fileViewController.fileExt = ext;
    _fileViewController.isFromNetwork = isLocalFile?@"NO":@"YES";
    _fileViewController.showSaveButton = isLocalFile?@"NO":@"YES";
    //
    _fileViewController.maySavePath = [self resouceManagerDirectory];
    NSLog(@"可能保存的路径#####%@",[self resouceManagerDirectory]);
//    [self.navigationController pushViewController:_fileViewController animated:YES];
    [self presentViewController:_fileViewController animated:YES completion:nil];
}

#pragma  mark-ResourceManagerDataSourceDelegate代理方法;

- (void)resourceManagerShouldClose{
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.delegateShrinkage shrinkageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark-FileViewerDelegate代理方法

- (void)fileViewerDidClosed:(FileViewer *)sender{
    // [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=4;
}

- (void)fileViewerDidDeleted:(FileViewer *)sender name:(NSString *)name path:(NSString *)path{
    
}

- (void)fileViewerDidSaved:(FileViewer *)sender name:(NSString *)name path:(NSString *)path{
    
}

- (void)fileViewShouldOpen:(FileViewer *)sender name:(NSString *)name path:(NSString *)path{
    
}

- (NSString *)fileViewerShouldToSave:(FileViewer *)sender name:(NSString *)name path:(NSString *)path{
    
    NSString *p=[NSString stringWithFormat:@"%@/%@",[self resouceManagerDirectory],name];
    return p;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
