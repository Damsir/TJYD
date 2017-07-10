//
//  ReachStateUnloaded.m
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import "ReachStateUnloaded.h"

@implementation ReachStateUnloaded

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    RRStateID resStateID = RRStateUnloaded;
    
    NSNumber *eventID = event[kEventKeyID];
    
    switch ([eventID intValue])
    {
        case RREventLoad:
        {
            resStateID = RRStateLoading;
            break;
        }
        default:
        {
            if (error != NULL)
            {
                *error = [NSError errorWithDomain:@"FSM" code:kFSMErrorNotAccept userInfo:nil];
            }
            break;
        }
    }
    return resStateID;
}

@end
