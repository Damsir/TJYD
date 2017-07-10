//
//  DamSlideSegment.h
//  GZYD
//
//  Created by 吴定如 on 17/2/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DamSlideSegment : UIView

- (void)screenRotationWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame WithControllerViewArray:(NSArray *)ViewsArray AndWithTitlesArray:(NSArray *)titlesArray;

@end
