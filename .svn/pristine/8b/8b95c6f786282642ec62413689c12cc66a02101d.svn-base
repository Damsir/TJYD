//
//  DistUrlArgumentsFilter.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistNetworkConfig.h"
#import "DistBaseRequest.h"

@interface DistUrlArgumentsFilter : NSObject <DistUrlFilterProtocol>

/**
 *  根据参数生成过滤器
 *
 *  @param arguments 参数字典
 *
 *  @return url的参数过滤器对象
 */
+ (DistUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;


/**
 *  生成符合规则的url字符串
 *
 *  @param originUrl 原始url
 *  @param request   DistBase请求
 *
 *  @return 符合规则的url字符串
 */
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(DistBaseRequest *)request;

@end

