//
//  DistBatchRequest.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistRequest.h"

@class DistBatchRequest;
@protocol DistBatchRequestDelegate <NSObject>

@optional//可选

/**
 *  请求已经结束
 *
 *  @param batchRequest batch请求
 */
- (void)batchRequestFinished:(DistBatchRequest *)batchRequest;

/**
 *  请求已经失败
 *
 *  @param batchRequest batch请求
 */
- (void)batchRequestFailed:(DistBatchRequest *)batchRequest;

@end


@interface DistBatchRequest : NSObject

/**
 *  存放请求的数组
 */
@property (strong, nonatomic, readonly) NSArray *requestArray;

/**
 *  DistBatchRequest的代理
 */
@property (weak, nonatomic) id<DistBatchRequestDelegate> delegate;

/**
 *  成功回调
 */
@property (nonatomic, copy) void (^successCompletionBlock)(DistBatchRequest *);

/**
 *  失败回调
 */
@property (nonatomic, copy) void (^failureCompletionBlock)(DistBatchRequest *);

/**
 *  请求的标志
 */
@property (nonatomic) NSInteger tag;

/**
 *  请求的附加
 */
@property (nonatomic, strong) NSMutableArray *requestAccessories;

/**
 *  初始化
 *
 *  @param requestArray 存放请求的数组
 *
 *  @return DistBatchRequest对象
 */
- (id)initWithRequestArray:(NSArray *)requestArray;


/**
 *  开始
 */
- (void)start;


/**
 *  停止
 */
- (void)stop;


/**
 *  block回调
 *
 *  @param success 成功
 *  @param failure 失败
 */
- (void)startWithCompletionBlockWithSuccess:(void (^)(DistBatchRequest *batchRequest))success
                                    failure:(void (^)(DistBatchRequest *batchRequest))failure;


- (void)setCompletionBlockWithSuccess:(void (^)(DistBatchRequest *batchRequest))success
                              failure:(void (^)(DistBatchRequest *batchRequest))failure;

/**
 *  把block置nil来打破循环引用
 */
- (void)clearCompletionBlock;


/**
 *  Request Accessory，可以hook Request的start和stop
 *
 *  @param accessory 请求附带
 */
- (void)addAccessory:(id<DistRequestAccessory>)accessory;


/**
 *  是否当前的数据从缓存获得
 *
 *  @return 返回BOOL值
 */
- (BOOL)isDataFromCache;

@end
