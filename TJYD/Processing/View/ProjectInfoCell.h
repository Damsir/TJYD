//
//  ProjectInfoCell.h
//  TJYD
//
//  Created by 吴定如 on 17/4/12.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;/**< 标题 */
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;/**< value */
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;/**< 勾选框 */

@end
