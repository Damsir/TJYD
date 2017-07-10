//
//  SHBaseViewController.h
//  TJYD
//
//  Created by 吴定如 on 17/3/29.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SHBaseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/** 网络状态 */
@property (nonatomic,assign) NetworkStatus status;
/** 公共表格 */
@property (nonatomic,strong) UITableView *tableView;
/** 无数据提示 */
- (void)showEmptyData;
/** 移除无数据提示 */
- (void)removeEmptyData;
/** 导航栏标题 */
- (void)initNavigationBarTitle:(NSString *)title;
/** 导航栏按钮(左侧) */
- (UIButton *)createNavigationLeftBarButtonTitle:(NSString *)title;
/** 导航栏按钮(右侧) */
- (UIButton *)createNavigationRightBarButtonTitle:(NSString *)title;
/** CustomButton */ 
- (UIButton *)createCustomButtonWithTitle:(NSString *)title;
/** 纯色图片 */
- (UIImage *)imageWithColor:(UIColor *)color;
/** 删除字典里的null */
- (NSDictionary *)deleteNullWithDictionary:(NSDictionary *)dic;
/** 计算UILabel文字高度 */
- (CGFloat)getCellHeightWithContent:(NSString *)content withFont:(UIFont *)font withWidth:(CGFloat)width;
/** 计算UILabel的高度(带有行间距的情况) */
- (CGFloat)getSpaceCellHeightWithContent:(NSString *)content withFont:(UIFont *)font withWidth:(CGFloat)width;
/** 给UILabel设置行间距和字间距(颜色等没有设置) */
- (void)setLabelSpace:(UILabel *)label withContent:(NSString *)content withFont:(UIFont *)font;
@end
