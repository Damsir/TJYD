//
//  DistBatchRequestAgent.m
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistBatchRequestAgent.h"

@interface DistBatchRequestAgent()

@property (strong, nonatomic) NSMutableArray *requestArray;

@end

@implementation DistBatchRequestAgent

+ (DistBatchRequestAgent *)sharedInstance {
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
    
}


- (id)init {
    
    self = [super init];
    if (self) {
        
        _requestArray = [NSMutableArray array];
        
    }
    
    return self;
    
}

- (void)addBatchRequest:(DistBatchRequest *)request {
    
    @synchronized(self) {
        
        [_requestArray addObject:request];
        
    }
    
}


- (void)removeBatchRequest:(DistBatchRequest *)request {
    
    @synchronized(self) {
        
        [_requestArray removeObject:request];
        
    }
    
}

@end
