//
//  DistChainRequest.m
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistChainRequest.h"
#import "DistChainRequestAgent.h"
#import "DistNetworkPrivate.h"

@interface DistChainRequest()<DistRequestDelegate>

@property (strong, nonatomic) NSMutableArray *requestArray;
@property (strong, nonatomic) NSMutableArray *requestCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) ChainCallback emptyCallback;

@end

@implementation DistChainRequest

- (id)init {
    
    self = [super init];
    if (self) {
        
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(DistChainRequest *chainRequest, DistBaseRequest *baseRequest) {
            // do nothing
        };
        
    }
    
    return self;
    
}


- (void)start {
    
    if (_nextRequestIndex > 0) {
        
        NSLog(@"Error! Chain request has already started.");
        return;
        
    }
    
    if ([_requestArray count] > 0) {
        
        [self toggleAccessoriesWillStartCallBack];
        [self startNextRequest];
        [[DistChainRequestAgent sharedInstance] addChainRequest:self];
        
    } else {
        
        NSLog(@"Error! Chain request array is empty.");
        
    }
    
}


- (void)stop {
    
    [self toggleAccessoriesWillStopCallBack];
    [self clearRequest];
    [[DistChainRequestAgent sharedInstance] removeChainRequest:self];
    [self toggleAccessoriesDidStopCallBack];
    
}


- (void)addRequest:(DistBaseRequest *)request callback:(ChainCallback)callback {
    
    [_requestArray addObject:request];
    
    if (callback != nil) {
        
        [_requestCallbackArray addObject:callback];
        
    } else {
        
        [_requestCallbackArray addObject:_emptyCallback];
        
    }
    
}


- (NSArray *)requestArray {
    
    return _requestArray;
    
}


- (BOOL)startNextRequest {
    
    if (_nextRequestIndex < [_requestArray count]) {
        
        DistBaseRequest *request = _requestArray[_nextRequestIndex];
        
        _nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}


#pragma mark - Network Request Delegate

- (void)requestFinished:(DistBaseRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    ChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    
    if (![self startNextRequest]) {
        
        [self toggleAccessoriesWillStopCallBack];
        
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            
            [_delegate chainRequestFinished:self];
            [[DistChainRequestAgent sharedInstance] removeChainRequest:self];
            
        }
        
        [self toggleAccessoriesDidStopCallBack];
        
    }
    
}


- (void)requestFailed:(DistBaseRequest *)request {
    
    [self toggleAccessoriesWillStopCallBack];
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        
        [_delegate chainRequestFailed:self failedBaseRequest:request];
        [[DistChainRequestAgent sharedInstance] removeChainRequest:self];
        
    }
    
    [self toggleAccessoriesDidStopCallBack];
    
}


- (void)clearRequest {
    
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        
        DistBaseRequest *request = _requestArray[currentRequestIndex];
        [request stop];
        
    }
    
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
    
}


#pragma mark - Request Accessoies

- (void)addAccessory:(id<DistRequestAccessory>)accessory {
    
    if (!self.requestAccessories) {
        
        self.requestAccessories = [NSMutableArray array];
        
    }
    
    [self.requestAccessories addObject:accessory];
    
}

@end
