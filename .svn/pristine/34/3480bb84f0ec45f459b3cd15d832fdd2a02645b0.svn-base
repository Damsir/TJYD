//
//  DistChainRequest.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

/**
 *  用于管理有相互依赖的网络请求，它实际上最终可以用来管理多个拓扑排序后的网络请求。
 */

#import <Foundation/Foundation.h>
#import "DistBaseRequest.h"

@class DistChainRequest;

@protocol DistChainRequestDelegate <NSObject>

@optional

/**
 *  链式请求已经完成
 *
 *  @param chainRequest 链式请求
 */
- (void)chainRequestFinished:(DistChainRequest *)chainRequest;

/**
 *  链式请求失败
 *
 *  @param chainRequest 链式请求
 *  @param request      DistBase请求
 */
- (void)chainRequestFailed:(DistChainRequest *)chainRequest failedBaseRequest:(DistBaseRequest*)request;

@end

typedef void (^ChainCallback)(DistChainRequest *chainRequest, DistBaseRequest *baseRequest);

@interface DistChainRequest : NSObject

/**
 *  DistChainRequest代理
 */
@property (weak, nonatomic) id<DistChainRequestDelegate> delegate;


/**
 *  请求附加数组
 */
@property (nonatomic, strong) NSMutableArray *requestAccessories;


/**
 *  开始链式请求
 */
- (void)start;

/**
 *  停止链式请求
 */
- (void)stop;

/**
 *  在链式请求里添加请求
 *
 *  @param request  DistBase请求
 *  @param callback 请求回调
 */
- (void)addRequest:(DistBaseRequest *)request callback:(ChainCallback)callback;


/**
 *  存储请求的数组
 *
 *  @return 请求数组
 */
- (NSArray *)requestArray;


/**
 *  Request Accessory，可以hook Request的start和stop
 *
 *  @param accessory 请求附带
 */
- (void)addAccessory:(id<DistRequestAccessory>)accessory;

@end

