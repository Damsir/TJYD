//
//  DistNetworkAgent.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DistBaseRequest.h"


@interface DistNetworkAgent : NSObject

/**
 *  单例
 *
 *  @return DistNetworkAgent对象
 */
+ (DistNetworkAgent *)sharedInstance;


/**
 *  添加请求
 *
 *  @param request DistBase请求
 */
- (void)addRequest:(DistBaseRequest *)request;


/**
 *  取消请求
 *
 *  @param request DistBase请求
 */
- (void)cancelRequest:(DistBaseRequest *)request;


/**
 *  取消所有的请求
 */
- (void)cancelAllRequests;


/**
 *  根据request和networkConfig构建url
 *
 *  @param request DistBase请求
 *
 *  @return 返回url
 */
- (NSString *)buildRequestUrl:(DistBaseRequest *)request;


@end
