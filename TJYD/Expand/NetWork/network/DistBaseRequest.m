//
//  DistBaseRequest.m
//  TJYD
//
//  Created by pengtao on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistBaseRequest.h"
#import "DistNetworkAgent.h"
#import "DistNetworkPrivate.h"
#import "RealReachability.h"

@implementation DistBaseRequest

/*---------子类可以重写这些方法---------*/
- (void)requestCompleteFilter {
    
}


- (void)requestFailedFilter {
    
}


- (NSString *)requestUrl {
    
    return @"";
    
}


- (NSString *)cdnUrl {
    
    return @"";
    
}


- (NSString *)baseUrl {
    
    return @"";
    
}

- (NSDictionary<NSString *,NSString *> *)queryArgument {
    
    return nil;
    
}


- (BOOL)useCDN {
    
    return NO;
    
}


- (NSTimeInterval)requestTimeoutInterval {
    
    return 60;
    
}


- (id)requestArgument {
    
    return nil;
    
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    
    return argument;
    
}


- (DistRequestMethod)requestMethod {
    
    return DistRequestMethodPost;
}


- (DistRequestSerializerType)requestSerializerType {
    
    return DistRequestSerializerTypeHTTP;
    
}


- (NSArray *)requestAuthorizationHeaderFieldArray {
    
    return nil;
    
}


- (NSDictionary *)requestHeaderFieldValueDictionary {
    
    return nil;
    
}

- (AFConstructingBlock)constructingBodyBlock {
    
    return nil;
    
}



- (NSString *)responseString {
    
    return [[NSString alloc] initWithData:_responseObject encoding:NSUTF8StringEncoding];
    
}


- (id)responseJSONObject {
    
    DLog(@"原始数据 = %@", self.responseString);
    NSString *string = [self replacingNewLineAndWhitespaceCharactersFromJson:self.responseString];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
}


//去掉换行符
- (NSString *)replacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr {
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    
    //换行符
    NSCharacterSet*newLineAndWhitespaceCharacters = [NSCharacterSet newlineCharacterSet];
    
    // 扫描
    while (![scanner isAtEnd]) {
        
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@""];
            
        }
        
    }
    
    return result;
}


/// append self to request queue
- (void)start {
    
    
    [self toggleAccessoriesWillStartCallBack];
    [[DistNetworkAgent sharedInstance] addRequest:self];
    
    //    if ([self isNetReachability]) {
    //
    //        [self toggleAccessoriesWillStartCallBack];
    //        [[DistNetworkAgent sharedInstance] addRequest:self];
    //
    //    } else {
    //
    //        DistAlertView *alert = [[DistAlertView alloc] initWithNewWindow];
    //        [alert showWarning:@"网络联接错误" subTitle:@"当前没有网络可用，请检查网络设置" closeButtonTitle:@"确定" duration:0.0f];
    //
    //    }
    
}


///判断当前的网络状态，有网络返回yes 无网络返回no
- (BOOL)isNetReachability {
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusViaWWAN || status == RealStatusViaWiFi) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}


/// remove self from request queue
- (void)stop {
    
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[DistNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
    
}


- (void)startWithCompletionBlockWithSuccess:(DistRequestCompletionBlock)success
                                    failure:(DistRequestFailureBlock)failure {
    
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
    
}


- (void)setCompletionBlockWithSuccess:(DistRequestCompletionBlock)success
                              failure:(DistRequestFailureBlock)failure {
    
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    
}


- (void)clearCompletionBlock {
    
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    
}


- (void)addAccessory:(id<DistRequestAccessory>)accessory {
    
    if (!self.requestAccessories) {
        
        self.requestAccessories = [NSMutableArray array];
        
    }
    
    [self.requestAccessories addObject:accessory];
    
}


@end
