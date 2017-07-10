//
//  ReachState.m
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import "ReachState.h"

@implementation ReachState

+ (id)state
{
    return [[self alloc] init];
}

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    return RRStateInvalid;
}

@end
