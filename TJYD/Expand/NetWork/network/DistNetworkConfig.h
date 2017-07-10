//
//  DistNetworkConfig.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistBaseRequest.h"


/**
 *  DistUrlFilter协议 用于实现对网络请求URL或参数的重写，例如可以统一为网络请求加上一些参数，或者修改一些路径。
 */
@protocol DistUrlFilterProtocol <NSObject>

/**
 *  协议生成新的url
 *
 *  @param originUrl 原始的url
 *  @param request   DistBase请求
 *
 *  @return 返回新的url
 */
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(DistBaseRequest *)request;

@end


/**
 *  缓存路径Filter协议
 */
@protocol DistCacheDirPathFilterProtocol <NSObject>

/**
 *  协议生成新的缓存路径
 *
 *  @param originPath 原始缓存路径
 *  @param request    DistBase请求
 *
 *  @return 返回新的路径
 */
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(DistBaseRequest *)request;

@end


@protocol DistResponseProcessProtocol <NSObject>

/**
 *  用于统一加工response，返回处理后response
 *
 *  @param response response
 *
 *  @return 处理后的response
 */
- (id)processResponseWithRequest:(id)response;

@end




@interface DistNetworkConfig : NSObject

/**
 *  baseUrl
 */
@property (strong, nonatomic) NSString *baseUrl;

/**
 *  cdnUrl
 */
@property (strong, nonatomic) NSString *cdnUrl;

/**
 *  url的过滤
 */
@property (strong, nonatomic, readonly) NSArray *urlFilters;

/**
 *  缓存路径的过滤
 */
@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;

/**
 *  请求安全协议
 */
@property (strong, nonatomic) AFSecurityPolicy *securityPolicy;


@property (nonatomic, strong) id <DistResponseProcessProtocol>responseProcessRule;


/**
 *  单例
 *
 *  @return 网络请求配置对象
 */
+ (DistNetworkConfig *)sharedInstance;


/**
 *  添加url过滤协议
 *
 *  @param filter url过滤协议
 */
- (void)addUrlFilter:(id<DistUrlFilterProtocol>)filter;


/**
 *  添加缓存路径过滤协议
 *
 *  @param filter 缓存路径过滤协议
 */
- (void)addCacheDirPathFilter:(id <DistCacheDirPathFilterProtocol>)filter;

@end
