//
//  MyProjectCell.h
//  TJYD
//
//  Created by 吴定如 on 17/4/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;/**< 项目名称 */
@property (weak, nonatomic) IBOutlet UILabel *activityName;/**< 流程名称,环节名称 */
@property (weak, nonatomic) IBOutlet UILabel *userRole;/**< 用户角色 */

@end
