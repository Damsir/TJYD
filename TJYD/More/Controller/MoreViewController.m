//
//  MoreViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "MoreViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"
#import "ChangePasswordVC.h"
#import "FormSingleLogin.h"

@interface MoreViewController () <UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *tableViewMore;
@property(nonatomic,strong) UIImageView *portaitI;
@property(nonatomic,strong) UIImage *image;

@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

    self.view.backgroundColor =[UIColor whiteColor];
    
    [self initNavigationBarTitle:@"更多"];
    [self creatTableView];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _tableViewMore.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [_tableViewMore reloadData];
}

- (void)creatTableView
{
    UITableView *tabLeMore = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    if (SCREEN_WIDTH > 414)
    {
        tabLeMore.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    _tableViewMore = tabLeMore;
    _tableViewMore.delegate = self;
    _tableViewMore.dataSource = self;
    _tableViewMore.bounces = NO;
    _tableViewMore.backgroundColor =[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    _tableViewMore.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:_tableViewMore];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
    {
        return 5;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (SCREEN_WIDTH < 414 && indexPath.section != 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    CGFloat marw = 0;
    if (SCREEN_WIDTH > 414) {
        marw = 10;
    }
    
    if (indexPath.section==0)
    {
//        cell.textLabel.text = @"李卫";
//        cell.detailTextLabel.text = @"正式员工";
        cell.textLabel.text = [Global userName];
//        cell.detailTextLabel.text =[[Global userInfo] objectForKey:@"py"];
    }
    else if(indexPath.section == 1)
    {
         if (indexPath.row == 0)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+marw, 10, 30, 30)];
            imageView.image=[UIImage imageNamed:@"more_opinion"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(55+marw, 10, 100, 30)];
            setting.text=@"系统反馈";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
            
        }
        else if (indexPath.row == 1)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+marw, 10, 30, 30)];
            imageView.image=[UIImage imageNamed:@"more_cancel"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(55+marw, 10, 100, 30)];
            setting.text=@"注销设备";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
            
        }
        else if (indexPath.row == 2)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+marw, 10, 30, 30)];
            imageView.image=[UIImage imageNamed:@"more_setting"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(55+marw, 10, 100, 30)];
            setting.text=@"系统设置";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 3)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+marw, 10, 30, 30)];
            imageView.image=[UIImage imageNamed:@"more_password"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(55+marw, 10, 100, 30)];
            setting.text=@"修改密码";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
        else if (indexPath.row == 4)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15+marw, 10, 30, 30)];
            imageView.image=[UIImage imageNamed:@"more_logout"];
            UILabel *setting=[[UILabel alloc]initWithFrame:CGRectMake(55+marw, 10, 100, 30)];
            setting.text=@"退出登录";
            setting.font=[UIFont systemFontOfSize:14];
            setting.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            [cell.contentView addSubview:setting];
            [cell.contentView addSubview:imageView];
        }
    }
    
    cell.contentView.backgroundColor =[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    CGFloat y = 0;
    CGFloat jtY = 0;
    if (SCREEN_WIDTH > 414) {
        if (indexPath.section==0) {
            y = 99;
            jtY = (100-20)*0.5;
        }
        else
        {
            y= 49;
            jtY = (50-20)*0.5;
            
        }
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
        if (indexPath.section == 1 &&indexPath.row==0) {
            UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            line.backgroundColor =RGB(238.0, 238.0, 238.0);
            [cell.contentView addSubview:line];
        }
        
        if (indexPath.section ==1) {
            UIImageView *jiantouI = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, jtY, 20,20 )];
            jiantouI.image =[UIImage imageNamed:@"jiant"];
            [cell.contentView addSubview:jiantouI];
        }
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 10.0;
            break;
        default:
            break;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 100;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
    } else if (indexPath.section==1) {
        
        if (indexPath.row == 0) {
            // 系统反馈
            FeedbackViewController *feedBackVC= [[FeedbackViewController alloc] init];
            feedBackVC.hidesBottomBarWhenPushed = YES;
            [self pushToViewControllerWithTransition:feedBackVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
            
        } else if (indexPath.row == 1) {
            

        } else if (indexPath.row == 2) {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self pushToViewControllerWithTransition:settingVC animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
        } else if (indexPath.row == 3) {
            ChangePasswordVC *changePassword =[[ChangePasswordVC alloc] init];
            changePassword.hidesBottomBarWhenPushed = YES;
            [self pushToViewControllerWithTransition:changePassword animationDirection:AnimationDirectionRight type:NO superNavi:self.navigationController];
        } else if (indexPath.row == 4) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登录后您将无法获取推送信息，确定退出当前账号吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [MBProgressHUD showMessage:@"正在退出" toView:self.view];
                // 退出登录
                NSString *ticket = [UserDefaults objectForKey:@"ticket"];
                NSString *des = [DES encryptUseDES:[ticket stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
                DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeSingleLoginOut requestMethod:DistRequestMethodPost arguments:nil];
                [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
                    
                    NSDictionary *JsonDic = request.responseJSONObject;
                    // 退出登录成功
                    if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
                        
                        // 退出单点登录(移动端需要退出表单(BPM)的单点登录,切换用户的时候就会需要重新单点登录了)
                        [FormSingleLogin singleLogoutAction];
                        
                        [MBProgressHUD showSuccess:@"退出成功"];
                        // 注销清除密码
                        [UserDefaults setObject:@"" forKey:@"password"];
                        // 手势登录,指纹登录设为NO
//                        [UserDefaults setBool:NO forKey:@"TouchID"];
//                        [UserDefaults setObject:nil forKey:@"gesturePassWord"];
//                        [UserDefaults setObject:nil forKey:@"loginWay"];
                        [UserDefaults synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:self userInfo:nil];
                        
                    } else {
                       [MBProgressHUD showError:@"退出失败"]; 
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                } failure:^(__kindof DistBaseRequest *request, NSError *error) {
                    [MBProgressHUD showError:@"退出失败"];
                    [MBProgressHUD hideHUDForView:self.view animated:NO];
                }];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    } else if (indexPath.section==2) {
        exit(0);
    }
}


- (void)exitLogin
{
    NSLog(@"退出登录");
    exit(0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
