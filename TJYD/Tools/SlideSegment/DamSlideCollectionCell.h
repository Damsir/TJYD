//
//  DamSlideCollectionCell.h
//  GZYD
//
//  Created by 吴定如 on 17/2/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DamSlideCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title; /**< 标题 */

- (void)setFontScale:(BOOL)scale;//设置分类标题文字字体的缩放

@end
