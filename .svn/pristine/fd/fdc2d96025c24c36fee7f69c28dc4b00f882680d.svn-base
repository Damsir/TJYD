//
//  DistNetworkAgent.m
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistNetworkAgent.h"
#import "AFNetworking.h"
#import "DistNetworkConfig.h"
#import "DistNetworkPrivate.h"
#import "PublicHeader.h"

@interface DistNetworkAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *requestsRecord;
@property (nonatomic, strong) DistNetworkConfig *config;

@end

@implementation DistNetworkAgent


+ (DistNetworkAgent *)sharedInstance {
    
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
        
        _config = [DistNetworkConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager = [AFHTTPSessionManager manager];
        
        _manager.securityPolicy = _config.securityPolicy;
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        
    }
    
    return self;
}


- (NSString *)buildRequestUrl:(DistBaseRequest *)request {
    
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        
        return detailUrl;
        
    }
    
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<DistUrlFilterProtocol> f in filters) {
        
        detailUrl = [f filterUrl:detailUrl withRequest:request];
        
    }
    
    NSString *baseUrl;
    if ([request useCDN]) {
        
        if ([request cdnUrl].length > 0) {
            
            baseUrl = [request cdnUrl];
            
        } else {
            
            baseUrl = [_config cdnUrl];
            
        }
        
    } else {
        
        if ([request baseUrl].length > 0) {
            
            baseUrl = [request baseUrl];
            
        } else {
            
            baseUrl = [_config baseUrl];
            
        }
    }
    
    NSString *urlString = [baseUrl stringByAppendingString:detailUrl];
    
    ///看是否有要拼接在URL后面的参数 如果有 且 格式（字典）正确 就拼接
    if (request.queryArgument && [request.queryArgument isKindOfClass:[NSDictionary class]]) {
        
        
        //NSLog(@"请求的URL:%@",[urlString stringByAppendingString:[self urlStringForQuery:request]]);
        //        NSLog(@"请求的URL:%@",[DistNetworkPrivate urlStringWithOriginUrlString:urlString appendParameters:request.queryArgument]);
        
        return [DistNetworkPrivate urlStringWithOriginUrlString:urlString appendParameters:request.queryArgument];
        
        //return [urlString stringByAppendingString:[self urlStringForQuery:request]];
        
    } else {
        
        NSLog(@"请求的URL:%@",urlString);
        return urlString;
        
    }
    
}


///根据请求的用于拼接URL的参数得到拼接好的字符串(未用)
- (NSString *)urlStringForQuery:(DistBaseRequest *)request {
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:@"?"];
    
    [request.queryArgument enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        [urlString appendFormat:@"%@=%@&", key, obj];
        
    }];
    
    [urlString deleteCharactersInRange:NSMakeRange(urlString.length - 1, 1)];
    return [urlString copy];
}


///请求的核心方法
- (void)addRequest:(DistBaseRequest *)request {
    
    DistRequestMethod method = [request requestMethod];
    
    NSString *url = [self buildRequestUrl:request];
    
    
    DLog(@"url = %@", url);
    
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    _manager.responseSerializer = serializer;
    
    //NSMutableDictionary *param = (NSMutableDictionary *)request.requestArgument;
    
    //[param addEntriesFromDictionary:@{@"ver_version":@"1"}];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:request.requestArgument];
    
    
    DLog(@"%@",param);
    
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    
    if (request.requestSerializerType == DistRequestSerializerTypeHTTP) {
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    } else if (request.requestSerializerType == DistRequestSerializerTypeJSON) {
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
        
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    
    //NSDictionary *headerFieldValueDictionary = request.requestHeaderFieldValueDictionary;
    
    if (headerFieldValueDictionary != nil) {
        
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
                
            } else {
                
                //                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
                
            }
            
        }
        
    }
    
    if (method == DistRequestMethodGet) {
        
        request.sessionDataTask = [_manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
            ///处理请求进度
            [self handleRequestProgress:downloadProgress request:request];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            ///处理请求成功的结果
            request.responseObject = responseObject;
            [self handleRequestSuccess:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            ///处理请求失败的情况
            [self handleRequestFailure:task error:error];
            
        }];
        
    } else if (method == DistRequestMethodPost) {
        
        if (constructingBlock != nil) {
            
            request.sessionDataTask = [_manager POST:url parameters:param constructingBodyWithBlock:constructingBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                
                ///处理请求进度
                [self handleRequestProgress:uploadProgress request:request];
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                ///处理请求成功的结果
                request.responseObject = responseObject;
                [self handleRequestSuccess:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                ///处理请求失败的情况
                [self handleRequestFailure:task error:error];
                
            }];
            
        } else {
            
            request.sessionDataTask = [_manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
                
                ///处理请求进度
                [self handleRequestProgress:uploadProgress request:request];
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                ///处理请求成功的结果
                request.responseObject = responseObject;
                [self handleRequestSuccess:task];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                ///处理请求失败的情况
                [self handleRequestFailure:task error:error];
                
            }];
            
            
        }
        
    } else if (method == DistRequestMethodHead) {
        
        request.sessionDataTask = [_manager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
            
            [self handleRequestSuccess:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleRequestFailure:task error:error];
            
        }];
        
        
    } else if (method == DistRequestMethodPut) {
        
        request.sessionDataTask = [_manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            request.responseObject = responseObject;
            [self handleRequestSuccess:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleRequestFailure:task error:error];
            
        }];
        
        
    } else if (method == DistRequestMethodDelete) {
        
        request.sessionDataTask = [_manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            request.responseObject = responseObject;
            [self handleRequestSuccess:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleRequestFailure:task error:error];
            
        }];
        
    } else if (method == DistRequestMethodPatch) {
        
        request.sessionDataTask = [_manager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            request.responseObject = responseObject;
            [self handleRequestSuccess:task];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleRequestFailure:task error:error];
            
        }];
        
    } else {
        
        NSLog(@"Error, unsupport method type");
        return;
        
    }
    
    //    NSLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
    
}


///处理请求进度
- (void)handleRequestProgress:(NSProgress *)progress request:(DistBaseRequest *)request {
    
    if (request.delegate && [request.delegate respondsToSelector:@selector(requestProgress:)]) {
        
        [request.delegate requestProgress:progress];
        
    }
    
    if (request.progressBlock) {
        
        request.progressBlock(progress);
        
    }
    
}


///处理请求成功的情况
- (void)handleRequestSuccess:(NSURLSessionDataTask *)sessionDataTask {
    
    NSString *key = [self keyForRequest:sessionDataTask];
    DistBaseRequest *request = _requestsRecord[key];
    
    if (request) {
        
        [request toggleAccessoriesWillStopCallBack];
        [request requestCompleteFilter];
        
        if (request.delegate != nil) {
            
            [request.delegate requestFinished:request];
            
        }
        
        if (request.successCompletionBlock) {
            
            request.successCompletionBlock(request);
            
        }
        
        [request toggleAccessoriesDidStopCallBack];
        
    }
    
    [self removeOperation:sessionDataTask];
    [request clearCompletionBlock];
    
}


///处理请求失败的情况
- (void)handleRequestFailure:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error {
    
    NSString *key = [self keyForRequest:sessionDataTask];
    DistBaseRequest *request = _requestsRecord[key];
    
    if (request) {
        
        [request toggleAccessoriesWillStopCallBack];
        
        if (request.delegate != nil) {
            
            [request.delegate requestFailed:request error:error];
            
        }
        
        if (request.failureCompletionBlock) {
            
            NSMutableString *errorDescription = [[NSMutableString alloc] init];
            
            
            /**
             *  对请求失败的error分析 返回符合要求的错误信息
             */
            
            DLog(@"%ld",(long)error.code);
            
            DLog(@"%@",error.userInfo);
            
            if (error && error.userInfo) {
                
                NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];
                
                if (error.code == -1009) {
                    
                    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                        
                        //断网情况
                        errorDescription = [NSMutableString stringWithString:@"网络不给力"];
                        
                    } else {
                        
                        [errorDescription appendFormat:@"ErrorCode%ld", (long)error.code];
                    }
                    
                } else if (error.code == -1001) {
                    
                    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                        
                        errorDescription = [NSMutableString stringWithString:@"请求超时"];
                        
                    } else {
                        
                        [errorDescription appendFormat:@"ErrorCode%ld", (long)error.code];
                    }
                    
                } else if (error.code == -1004) {
                    
                    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                        
                        errorDescription = [NSMutableString stringWithString:@"连接不上服务器"];
                        
                    } else {
                        
                        [errorDescription appendFormat:@"ErrorCode%ld", (long)error.code];
                    }
                    
                } else if (error.code == -1011) {
                    
                    
                    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                        
                        errorDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                        
                    } else {
                        
                        [errorDescription appendFormat:@"ErrorCode%ld", (long)error.code];
                    }
                    
                } else {
                    
                    if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                        
                        errorDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                        
                    } else {
                        
                        [errorDescription appendFormat:@"ErrorCode%ld", (long)error.code];
                    }
                    
                    
                }
                
                DLog(@"=====newUserInfo:::%@",newUserInfo);
                
                [newUserInfo setValue:errorDescription forKey:@"NSLocalizedDescription"];
                
                
                DLog(@"=====newUserInfo:::%@",newUserInfo);
                
                
                
                NSError *newError = [NSError errorWithDomain:request.baseUrl code:error.code userInfo:newUserInfo];
                
                DLog(@"%@",newUserInfo);
                DLog(@"%@",errorDescription);
                
                request.failureCompletionBlock(request, newError);
            }
            
        } else {
            
            
            DLog(@"%@",error);
            
        }
        
        [request toggleAccessoriesDidStopCallBack];
    }
    
    [self removeOperation:sessionDataTask];
    [request clearCompletionBlock];
    
}


- (NSString *)keyForRequest:(NSURLSessionDataTask *)object {
    
    NSString *key = [@(object.taskIdentifier) stringValue];
    return key;
    
}


///添加请求任务
- (void)addOperation:(DistBaseRequest *)request {
    
    if (request.sessionDataTask != nil) {
        
        NSString *key = [self keyForRequest:request.sessionDataTask];
        
        @synchronized(self) {
            
            self.requestsRecord[key] = request;
            
        }
        
    }
    
}


///移除请求任务
- (void)removeOperation:(NSURLSessionDataTask *)operation {
    
    NSString *key = [self keyForRequest:operation];
    
    @synchronized(self) {
        
        [_requestsRecord removeObjectForKey:key];
        
    }
    
}


///停止请求
- (void)cancelRequest:(DistBaseRequest *)request {
    
    [request.sessionDataTask cancel];
    [self removeOperation:request.sessionDataTask];
    [request clearCompletionBlock];
    
}


///停止所有的请求
- (void)cancelAllRequests {
    
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        
        DistBaseRequest *request = copyRecord[key];
        [request stop];
        
    }
    
}


@end
