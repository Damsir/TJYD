//
//  SingleLogin.h
//  TJYD
//
//  Created by 吴定如 on 17/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  单点登录是否成功回调
 *
 *  @param success YES = 成功, NO = 失败
 */
typedef void(^ SuccessBlock)(BOOL success);

@interface SingleLogin : NSObject

/** 单点登录 */
+ (void)singleLoginActionWithSuccess:(SuccessBlock)successBlock;

/** 请求成功与否的回调 */
@property(nonatomic,copy) SuccessBlock successBlock;

@end
