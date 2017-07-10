//
//  UITableView+ReloadExten.h
//  XAYD
//
//  Created by songdan Ye on 16/2/26.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,SHReloadAnimationDirectionType)
{
    SHReloadAnimationDirectionTop,
    SHReloadAnimationDirectionBottom,
    SHReloadAnimationDirectionLeft,
    SHReloadAnimationDirectionRight,
    
};

@interface UITableView (ReloadExten)
- (void)reloadDataWithDirectionType:(SHReloadAnimationDirectionType)direction AnimatrionWithTimeNum:(NSTimeInterval )animationTime interval:(NSTimeInterval)interval;


@end
