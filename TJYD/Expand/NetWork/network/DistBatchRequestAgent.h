//
//  DistBatchRequestAgent.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistBatchRequest.h"

@interface DistBatchRequestAgent : NSObject

/**
 *  单例
 *
 *  @return DistBatchRequestAgent对象
 */
+ (DistBatchRequestAgent *)sharedInstance;

/**
 *  添加DistBatchRequest
 *
 *  @param request DistBatch请求
 */
- (void)addBatchRequest:(DistBatchRequest *)request;


/**
 *  移除DistBatchRequest
 *
 *  @param request DistBatch请求
 */
- (void)removeBatchRequest:(DistBatchRequest *)request;

@end
