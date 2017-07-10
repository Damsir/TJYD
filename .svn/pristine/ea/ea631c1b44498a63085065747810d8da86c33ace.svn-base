//
//  ReachStateWWAN.m
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import "ReachStateWWAN.h"

@implementation ReachStateWWAN

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    RRStateID resStateID = RRStateWWAN;
    
    NSNumber *eventID = event[kEventKeyID];
    
    switch ([eventID intValue])
    {
        case RREventUnLoad:
        {
            resStateID = RRStateUnloaded;
            break;
        }
        case RREventPingCallback:
        {
            NSNumber *eventParam = event[kEventKeyParam];
            resStateID = [FSMStateUtil RRStateFromPingFlag:[eventParam boolValue]];
            break;
        }
        case RREventLocalConnectionCallback:
        {
            resStateID = [FSMStateUtil RRStateFromValue:event[kEventKeyParam]];
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
