//
//  PingHelper.h
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GPingHelper [PingHelper sharedInstance]

extern NSString *const kPingResultNotification;

@interface PingHelper : NSObject

/// You MUST have already set the host before your ping action.
/// Think about that: if you never set this, we don't know where to ping.
@property (nonatomic, copy) NSString *host;

+ (instancetype)sharedInstance;

/**
 *  trigger a ping action with a completion block
 *
 *  @param completion : Async completion block
 */
- (void)pingWithBlock:(void (^)(BOOL isSuccess))completion;

@end
