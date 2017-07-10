//
//  NewsCell.h
//  TJYD
//
//  Created by 吴定如 on 17/3/16.
//  Copyright © 2017年 吴定如. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;/**< 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *readCount;/**< 阅读次数 */
@property (weak, nonatomic) IBOutlet UILabel *date;/**< 发布时间 */

@end
