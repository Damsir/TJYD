//
//  TreeCell.h
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;/**< 项目关联标题 */
@property (weak, nonatomic) IBOutlet UIView *spot;/**< 圆点 */


@end
