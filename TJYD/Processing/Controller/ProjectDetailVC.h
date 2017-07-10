//
//  ProjectDetailVC.h
//  TJYD
//
//  Created by 吴定如 on 17/4/12.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface ProjectDetailVC : UIViewController

@property (nonatomic,strong) UINavigationController *navi;

/** 待办事项模型 */
@property (nonatomic,strong) ListModel *listModel;

- (void)reloadData;

@end
