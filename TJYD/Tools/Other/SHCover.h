//
//  SHCover.h
//  distmeeting
//
//  Created by songdan Ye on 15/11/18.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHCover ;
@protocol SHCoverDelegate <NSObject>

@optional
// 点击蒙板的时候调用
- (void)coverDidClickCover:(SHCover *)cover;

@end

@interface SHCover : UIView

/**
 *  显示蒙板
 */
+ (instancetype)show;

// 设置浅灰色蒙板
@property (nonatomic, assign) BOOL dimBackground;

@property (nonatomic, weak) id<SHCoverDelegate> delegate;
@end
