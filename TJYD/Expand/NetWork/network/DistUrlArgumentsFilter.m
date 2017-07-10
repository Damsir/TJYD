//
//  DistUrlArgumentsFilter.m
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistUrlArgumentsFilter.h"
#import "DistNetworkPrivate.h"

@implementation DistUrlArgumentsFilter {
    
    NSDictionary *_arguments;
    
}

+ (DistUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    
    return [[self alloc] initWithArguments:arguments];
    
}


- (id)initWithArguments:(NSDictionary *)arguments {
    
    self = [super init];
    if (self) {
        
        _arguments = arguments;
        
    }
    
    return self;
    
}


- (NSString *)filterUrl:(NSString *)originUrl withRequest:(DistBaseRequest *)request {
    
    return [DistNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
    
}



@end

