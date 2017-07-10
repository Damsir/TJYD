//
//  DigitMaterialViewController.h
//  XAYD
//
//  Created by songdan Ye on 16/1/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileVC.h"
//#import "baseViewController.h"
@class ResourceManagerAddressBar;
@class FileTableViewContainerV;
@interface DigitMaterialViewController : SHBaseViewController
@property (strong, nonatomic) UITableView *digitMTabV;
@property (nonatomic,strong)NSString *docProperty;

//搜索按钮
@property(nonatomic,strong)UIButton *searchBtn;
//多选按钮
@property(nonatomic,strong)UIButton *selecteds;
//搜索框
@property (strong, nonatomic)  UISearchBar *seaBarFile;

//UISegmentedControl
@property (weak, nonatomic) IBOutlet UISegmentedControl *segC;
//在线资源目录条
@property (nonatomic,strong)ResourceManagerAddressBar *onlineAddressBar;
//本地资源目录条
@property (nonatomic,strong)ResourceManagerAddressBar *localAddressBar;

//显示资源的view
@property (strong, nonatomic)  UIView *resourcesView;

//保存路径
@property (retain,nonatomic) NSString *path;
@property (retain,nonatomic) NSString *searchkey;
@property NSInteger intSearched;


//资源view
@property (strong,nonatomic)FileTableViewContainerV *rsView;

@property (strong,nonatomic) FileVC*fileViewController;


@end
