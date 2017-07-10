//
//  FSMEngine.h
//  WTNetworkTestDemo
//
//  Created by wutong on 16/3/10.
//  Copyright © 2016年 wutong_lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSMDefines.h"

@interface FSMEngine : NSObject

@property (nonatomic, readonly) RRStateID currentStateID;
@property (nonatomic, readonly) NSArray *allStates;

- (void)start;

/**
 *  trigger event
 *
 *  @param dic inputDic
 *
 *  @return -1 -> no state changed, 0 ->state changed
 */
- (NSInteger)receiveInput:(NSDictionary *)dic;

- (BOOL)isCurrentStateAvailable;
@end

