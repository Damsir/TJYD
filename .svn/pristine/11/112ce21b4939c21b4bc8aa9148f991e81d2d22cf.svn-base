//
//  DistGestureView.h
//  GesturePassword
//
//  Created by 吴定如 on 17/4/11.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistGesTouchView.h"

@protocol GesturePasswordDelegate <NSObject>

- (void)forget;
- (void)change;
- (void)close;

@end

@interface DistGestureView : UIView <TouchBeginDelegate>

@property (nonatomic,strong) DistGesTouchView *touchView;

@property (nonatomic,strong) UILabel *state;

@property (nonatomic,assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *name;/**< 登录人 */
@property (nonatomic,strong) UILabel *welcome;/**< 欢迎回来 */
@property (nonatomic,strong) UIButton *forgetButton;/**< 忘记密码 */
@property (nonatomic,strong) UIButton *changeButton;/**< 修改密码 */
@property (nonatomic,strong) UIButton *closebutton;/**< 关闭手势 */

@end
