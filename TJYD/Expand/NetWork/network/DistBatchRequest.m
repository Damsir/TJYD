//
//  DistBatchRequest.m
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistBatchRequest.h"
#import "DistNetworkPrivate.h"
#import "DistBatchRequestAgent.h"

@interface DistBatchRequest () <DistRequestDelegate>

@property (nonatomic) NSInteger finishedCount;

@end

@implementation DistBatchRequest

- (id)initWithRequestArray:(NSArray *)requestArray {
    
    self = [super init];
    if (self) {
        
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (DistRequest * req in _requestArray) {
            
            if (![req isKindOfClass:[DistRequest class]]) {
                
                NSLog(@"Error, request item must be YTKRequest instance.");
                return nil;
                
            }
            
        }
        
    }
    
    return self;
    
}


- (void)start {
    
    if (_finishedCount > 0) {
        
        NSLog(@"Error! Batch request has already started.");
        return;
        
    }
    
    [[DistBatchRequestAgent sharedInstance] addBatchRequest:self];
    [self toggleAccessoriesWillStartCallBack];
    
    for (DistRequest * req in _requestArray) {
        
        req.delegate = self;
        [req start];
        
    }
    
}


- (void)stop {
    
    [self toggleAccessoriesWillStopCallBack];
    _delegate = nil;
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    [[DistBatchRequestAgent sharedInstance] removeBatchRequest:self];
    
}


- (void)startWithCompletionBlockWithSuccess:(void (^)(DistBatchRequest *batchRequest))success
                                    failure:(void (^)(DistBatchRequest *batchRequest))failure {
    
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
    
}


- (void)setCompletionBlockWithSuccess:(void (^)(DistBatchRequest *batchRequest))success
                              failure:(void (^)(DistBatchRequest *batchRequest))failure {
    
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    
}


- (void)clearCompletionBlock {
    
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    
}


- (BOOL)isDataFromCache {
    
    BOOL result = YES;
    for (DistRequest *request in _requestArray) {
        
        if (!request.isDataFromCache) {
            
            result = NO;
            
        }
        
    }
    
    return result;
    
}


- (void)dealloc {
    
    [self clearRequest];
    
}


#pragma mark - Network Request Delegate

- (void)requestFinished:(DistRequest *)request {
    
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        [self toggleAccessoriesWillStopCallBack];
        
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            
            [_delegate batchRequestFinished:self];
            
        }
        
        if (_successCompletionBlock) {
            
            _successCompletionBlock(self);
            
        }
        
        [self clearCompletionBlock];
        [self toggleAccessoriesDidStopCallBack];
        [[DistBatchRequestAgent sharedInstance] removeBatchRequest:self];
        
    }
    
}


- (void)requestFailed:(DistRequest *)request {
    
    [self toggleAccessoriesWillStopCallBack];
    
    // Stop
    for (DistRequest *req in _requestArray) {
        
        [req stop];
        
    }
    
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        
        [_delegate batchRequestFailed:self];
        
    }
    
    if (_failureCompletionBlock) {
        
        _failureCompletionBlock(self);
        
    }
    
    // Clear
    [self clearCompletionBlock];
    
    [self toggleAccessoriesDidStopCallBack];
    [[DistBatchRequestAgent sharedInstance] removeBatchRequest:self];
    
}


- (void)clearRequest {
    
    for (DistRequest * req in _requestArray) {
        
        [req stop];
        
    }
    
    [self clearCompletionBlock];
    
}


#pragma mark - Request Accessoies

- (void)addAccessory:(id<DistRequestAccessory>)accessory {
    
    if (!self.requestAccessories) {
        
        self.requestAccessories = [NSMutableArray array];
        
    }
    
    [self.requestAccessories addObject:accessory];
    
}

@end
