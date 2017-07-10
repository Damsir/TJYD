//
//  FSMStateUtil.m
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import "FSMStateUtil.h"
#import "LocalConnection.h"

@implementation FSMStateUtil

+ (RRStateID)RRStateFromValue:(NSString *)LCEventValue
{
    if ([LCEventValue isEqualToString:kParamValueUnReachable])
    {
        return RRStateUnReachable;
    }
    else if ([LCEventValue isEqualToString:kParamValueWWAN])
    {
        return RRStateWWAN;
    }
    else if ([LCEventValue isEqualToString:kParamValueWIFI])
    {
        return RRStateWIFI;
    }
    else
    {
        NSLog(@"Error! no matching LCEventValue!");
        return RRStateInvalid;
    }
}

+ (RRStateID)RRStateFromPingFlag:(BOOL)isSuccess
{
    LocalConnectionStatus status = GLocalConnection.currentLocalConnectionStatus;
    
    if (!isSuccess)
    {
        return RRStateUnReachable;
    }
    else
    {
        switch (status)
        {
            case LC_UnReachable:
            {
                NSLog(@"MisMatch! RRStateFromPingFlag success, but LC_UnReachable!");
                return RRStateUnReachable;
            }
            case LC_WiFi:
            {
                return RRStateWIFI;
            }
            case LC_WWAN:
            {
                return RRStateWWAN;
            }
                
            default:
            {
                NSLog(@"RealReachability error! RRStateFromPingFlag not matched!");
                return RRStateWIFI;
            }
        }
    }
}

@end
