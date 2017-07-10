//
//  RealReachability.h
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GLobalRealReachability [RealReachability sharedInstance]

///This notification was called only when reachability really changed;
///We use FSM to promise this for you;
///We post self to this notification, then you can invoke currentReachabilityStatus method to fetch current status.
extern NSString *const kRealReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, ReachabilityStatus) {
    ///Direct match with Apple networkStatus, just a force type convert.
    RealStatusUnknown = -1,
    RealStatusNotReachable = 0,
    RealStatusViaWWAN = 1,
    RealStatusViaWiFi = 2
};

typedef NS_ENUM(NSInteger, WWANAccessType) {
    WWANTypeUnknown = -1, /// maybe iOS6
    WWANType4G = 0,
    WWANType3G = 1,
    WWANType2G = 3
};

@interface RealReachability : NSObject

/// Please make sure this host is available for pinging! default host:www.baidu.com
@property (nonatomic, copy) NSString *hostForPing;

/// Interval in minutes; default is 2.0f, suggest value from 0.3f to 60.0f;
/// If exceeded, the value will be reset to 0.3f or 60.0f (the closer one).
@property (nonatomic, assign) float autoCheckInterval;

+ (instancetype)sharedInstance;

- (void)startNotifier;

- (void)stopNotifier;

/**
 *  To get real reachability we need to do async request,
 *  then we use the block blow for invoker to handle business request(need real reachability).
 *
 *  @param asyncHandler async request handler, return in 2 seconds(max limit).
 */
- (void)reachabilityWithBlock:(void (^)(ReachabilityStatus status))asyncHandler;

/**
 *  Return current reachability immediately.
 *
 *  @return see enum LocalConnectionStatus
 */
- (ReachabilityStatus)currentReachabilityStatus;

/**
 *  Return previous reachability status.
 *
 *  @return see enum LocalConnectionStatus
 */
- (ReachabilityStatus)previousReachabilityStatus;

/**
 *  Return current WWAN type immediately.
 *
 *  @return unknown/4g/3g/2g.
 *
 *  This method can be used to improve app's further network performance
 *  (different strategies for different WWAN types).
 */
- (WWANAccessType)currentWWANtype;

@end
