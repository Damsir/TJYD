//
//  MyProjectDetailVC.h
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProjectModel.h"

@interface MyProjectDetailVC : UIViewController

@property (nonatomic,strong) UINavigationController *navi;

/** 项目列表模型 */
@property (nonatomic,strong) MyListModel *listModel;

@end