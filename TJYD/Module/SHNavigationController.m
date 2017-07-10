//
//  SHNavigationController.m
//  TJYD
//
//  Created by 吴定如 on 17/3/29.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SHNavigationController.h"

@interface SHNavigationController ()

@end

@implementation SHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *image =[self imageWithColor:HOMEBLUECOLOR];
    // 设置视图导航控制器的背景图片
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 35);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
