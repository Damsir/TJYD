//
//  SettingViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/3/30.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SettingViewController.h"
#import "DistGestureLock.h"
#import "DistTouchID.h"
#import "Masonry.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) DistGestureLock *gestureLock;/**< 手势解锁 */
@property(strong, nonatomic) NSMutableArray *array;/**< Array (switch) */
@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic,assign) CGFloat size;/**< 缓存数据大小 */


@end

//#ifndef __OPTIMIZE__
//#define DLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
//#endif

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // KVO(监听屏幕旋转)
    //[self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBarTitle:@"系统设置"];
    // 读取缓存数据
    [self readSystemDataSize];
    [self createTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];

    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);

}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    //分割线的颜色
    tableView.separatorColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark -- tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UIControlStateNormal;
    
    if (indexPath.section == 0) {
        UISwitch *switchs = [[UISwitch alloc] init];
        
        [self.array addObject:switchs];
        
        switchs.tag = (indexPath.row + 1) * 10;
        
        [switchs addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:switchs];
        
        [switchs mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(cell.mas_centerY);
            
            make.right.equalTo(cell.mas_right).offset(-15);
            
        }];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"手势登录";
            switchs.on = [[UserDefaults objectForKey:@"gesturePassWord"] boolValue];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"指纹登录";
            switchs.on = [UserDefaults boolForKey:@"TouchID"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"版本信息";
            // APP当前版本
            NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = appVersion;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"清除缓存";
            NSString *size = _size > 1 ? [NSString stringWithFormat:@"%.0f M", _size] : [NSString stringWithFormat:@"%.0f K", _size * 1024.0];
            cell.detailTextLabel.text = size;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        // 清理缓存
        [self putBufferBtnClicked];
    }
}

#pragma mark -- 手势密码开关,指纹解锁
- (void)switchClick:(UISwitch *)sender {
    
    // 手势登录
    if (sender.tag == 10) {
        DistGestureLock *gestureLock = [[DistGestureLock alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) gestureType:1];
        gestureLock.gestureType = 1;
        [gestureLock showInView:self.view.window.rootViewController.view animated:YES];
        // 关闭手势登录
        if (!sender.on) {
            DLog(@"取消手势登录")
            gestureLock.gestureOpenBlock = ^(BOOL isOpen){
                if (isOpen) {
                    // 取消失败
                    [self sender:sender.tag isOn:YES];
                } else {
                    // 取消成功
                    [UserDefaults setObject:nil forKey:@"gesturePassWord"];
                    [UserDefaults setObject:nil forKey:@"loginWay"];
                    [UserDefaults synchronize];
                    [self sender:sender.tag isOn:NO];
                }
            };
        // 开启手势登录
        } else {
            DLog(@"开启了手势登录");
            gestureLock.gestureOpenBlock = ^(BOOL isOpen){
                if (isOpen) {
                    // 开启成功
                    [self sender:sender.tag isOn:YES];
                } else {
                    // 开启失败
                    [self sender:sender.tag isOn:NO];
                }
            };
        }
    // 指纹登录
    } else if (sender.tag == 20) {
        // 关闭指纹登录
        if (!sender.on) {
            [DistTouchID Dist_initWithTouchIDPromptMsg:@"请验证您的指纹, 关闭指纹登录功能" cancelMsg:@"取消" otherMsg:nil enabled:YES otherClick:^(NSString *otherClick) {
                
                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                [self sender:sender.tag isOn:YES];
                
            } success:^(BOOL success) {
                
                [self sender:sender.tag isOn:NO];
                [UserDefaults setBool:NO forKey:@"TouchID"];
                [UserDefaults synchronize];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                DLog(@"取消指纹解锁")
                DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                
            } error:^(NSError *error) {
                
                [self sender:sender.tag isOn:YES];
                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                
            } errorMsg:^(NSString *errorMsg) {
                
                [self sender:sender.tag isOn:YES];
                
                DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                
            }];
        // 开启指纹登录
        } else {
            [DistTouchID Dist_initWithTouchIDPromptMsg:@"请验证您的指纹, 开启指纹登录功能" cancelMsg:@"取消" otherMsg:nil enabled:YES otherClick:^(NSString *otherClick) {
                
                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
                [self sender:sender.tag isOn:NO];
                
            } success:^(BOOL success) {
                
                [self sender:sender.tag isOn:YES];
                [UserDefaults setBool:YES forKey:@"TouchID"];
                [UserDefaults synchronize];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                DLog(@"开启了指纹解锁");
                DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
                
            } error:^(NSError *error) {
                
                [self sender:sender.tag isOn:NO];
                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
                
            } errorMsg:^(NSString *errorMsg) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Touch ID 不可用" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:nil];
                [self sender:sender.tag isOn:NO];
                DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
                
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
//    if (alertView.tag == 10) {
//
//        if (buttonIndex == 1) {
//
//            [DamTouchID Dam_initWithTouchIDPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" enabled:YES otherClick:^(NSString *otherClick) {
//                
//                DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
//                
//                [self sender:alertView.tag ison:NO];
//                
//            } success:^(BOOL success) {
//                
//                for (UISwitch *switchs in self.array) {
//                    
//                    if (switchs.tag == alertView.tag) {
//                        
//                        [self loadGesture:NO fing:NO];
//                        
//                    }else {
//                        
//                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fing"];
//                        
//                        switchs.on = NO;
//                        
//                    }
//                    
//                }
//                
//                DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
//                
//            } error:^(NSError *error) {
//                
//                [self sender:alertView.tag ison:NO];
//                DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
//                
//            } errorMsg:^(NSString *errorMsg) {
//                
//                [self sender:alertView.tag ison:NO];
//                DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
//                
//            }];
//            
//        }else {
//            
//            [self sender:alertView.tag ison:NO];
//            
//        }
//    }
//    
//    if(alertView.tag == 20) {
//        
//        if (buttonIndex == 1) {
//            
//            
//            [self loadGesture:NO fing:YES];
//            
//            
//        }else {
//            
//            [self sender:alertView.tag ison:NO];
//            
//        }
//        
//    }
    
}


- (void)loadGesture:(BOOL)remove fing:(BOOL)fing {
    
//    DamGestureLock *gestures = [[DamGestureLock alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    self.gesture = gestures;
//    
//    gestures.lineColor = [UIColor whiteColor];
//    
//    //    gestures.bgImage = [UIImage imageNamed:@"bg"];
//    
//    gestures.lineTimer = 0.85;
//    
//    [self.view.window.rootViewController.view addSubview:gestures];
//    
//    [gestures dw_passwordSuccess:^(BOOL success, NSString *password, NSString *userPassword) {
//        
//        DLog(@"%d--%@--%@", success, password, userPassword);
//        
//        DLog(@"%ld", (unsigned long)password.length);
//        
//        DLog(@"连续输入%ld次密码", (long)gestures.inputCount);
//        
//        if (fing) {
//            
//            if (success) {
//                
//                DLog(@"验证成功")
//                
//                [DamGestureLock dw_removePassword];
//                
//                [self.gesture removeFromSuperview];
//                
//                for (UISwitch *switchs in self.array) {
//                    
//                    if (switchs.tag == 10) {
//                        
//                        switchs.on = NO;
//                        
//                    }else {
//                        
//                        [DamTouchID Dam_initWithTouchIDPromptMsg:@"此操作需要认证您的身份" cancelMsg:@"取消" otherMsg:@"其它方式登录" enabled:YES otherClick:^(NSString *otherClick) {
//                            [self sender:20 ison:NO];
//                            DLog(@"选择了其它方式登录:%@---线程:%@", otherClick, [NSThread currentThread]);
//                            
//                        } success:^(BOOL success) {
//                            
//                            switchs.on = YES;
//                            
//                            DLog(@"认证成功---success:%d---线程:%@",success, [NSThread currentThread]);
//                            
//                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fing"];
//                            
//// 修复先开手势解锁,然后开指纹解锁,之后关了指纹解锁,再开手势解锁,无需验证直接打开的问题
//                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ges"];
//                            
//                            
//                        } error:^(NSError *error) {
//                            [self sender:20 ison:NO];
//                            DLog(@"认证失败---error:%@---线程:%@",error, [NSThread currentThread]);
//                            
//                        } errorMsg:^(NSString *errorMsg) {
//                            
//                            [self sender:20 ison:NO];
//                            DLog(@"错误信息中文:%@---线程:%@", errorMsg, [NSThread currentThread]);
//                            
//                        }];
//                        
//                    }
//                }
//                
//            }else {
//                
//                DLog(@"验证失败");
//            }
//            
//        }
//        
//        if (remove) {
//            
//            if (success) {
//                
//                [DamGestureLock dw_removePassword];
//                
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ges"];
//                
//                [self.gesture removeFromSuperview];
//                
////                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//                
//            } else {
//                DLog(@"验证失败");
//            }
//            
//        }
//        
//        if (!remove && !fing) {
//            
//            DLog(@"%@", userPassword);
//            
//            if (password.length >= 3) {
//                
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ges"];
//                
//                [self.gesture removeFromSuperview];
//                
//// 可设置截图
//                //                UIImageView *image = [[UIImageView alloc] initWithImage:gestures.passwordImage];
//                //
//                //                image.frame = CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height / 3 * 2);
//                //
//                //                [self.view addSubview:image];
//                
//                
//            } else {
//                DLog(@"手势密码过于简单");
//            }
//        }
//        
//    }];
    
}


- (NSMutableArray *)array {
    
    if (!_array) {
        
        _array = [NSMutableArray array];
        
    }
    
    return _array;
}

- (void)sender:(NSInteger)tag isOn:(BOOL)isOn {
    
    for (UISwitch *switchs in self.array) {
        
        if (switchs.tag == tag) {
            
            switchs.on = isOn;
            
        }
    }
}

#pragma mark -- 读取缓存数据大小
- (void)readSystemDataSize
{
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    _size = size;
}

#pragma mark -- 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            // 偏好设置不能清理(用户信息)
            if (![fileName isEqualToString:@"Preferences/com.dist.TJYD.plist"] && ![fileName isEqualToString:@"Preferences"]) {
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
            }
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}

#pragma mark -- 清理缓存提示

- (void)putBufferBtnClicked
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清除所有缓存?包括离线内容、图片等均会被清除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
        
        [MBProgressHUD showSuccess:@"清除成功"];
        [self readSystemDataSize];
        [_tableView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 偏好设置不能清理(用户信息)
            if (![fileName isEqualToString:@"Preferences/com.dist.TJYD.plist"] && ![fileName isEqualToString:@"Preferences"]) {
                // 拼接路径
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                // 将文件删除
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
}

#pragma mark -- 返回
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

@end
