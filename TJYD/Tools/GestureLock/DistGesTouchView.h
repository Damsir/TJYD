//
//  DistGesTouchView.h
//  GesturePassword
//
//  Created by 吴定如 on 17/4/11.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetDelegate <NSObject>

- (BOOL)resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

- (BOOL)verification:(NSString *)result;

@end

@protocol TouchBeginDelegate <NSObject>

- (void)gestureTouchBegin;

@end



@interface DistGesTouchView : UIView

@property (nonatomic,strong) NSArray * buttonArray;

@property (nonatomic,assign) id<VerificationDelegate> verificationDelegate;

@property (nonatomic,assign) id<ResetDelegate> resetDelegate;

@property (nonatomic,assign) id<TouchBeginDelegate> touchBeginDelegate;

/*
 1: Verify
 2: Reset
 */
@property (nonatomic,assign) NSInteger style;

- (void)enterArgin;

@end
