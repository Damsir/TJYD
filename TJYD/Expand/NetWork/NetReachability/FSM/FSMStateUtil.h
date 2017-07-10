//
//  FSMStateUtil.h
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSMDefines.h"

@interface FSMStateUtil : NSObject

+ (RRStateID)RRStateFromValue:(NSString *)LCEventValue;

+ (RRStateID)RRStateFromPingFlag:(BOOL)isSuccess;

@end

