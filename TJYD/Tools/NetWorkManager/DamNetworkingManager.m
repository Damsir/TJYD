//
//  DamNetworkingManager.m
//  GZYD
//
//  Created by 吴定如 on 17/3/23.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DamNetworkingManager.h"

@implementation DamNetworkingManager

// 1.异步GET请求数据
+ (void)GETWithUrl:(NSString *)urlStr andHttpHeader:(NSDictionary *)headerDic andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock
{
    DamRequest *request = [[DamRequest alloc] init];
    request.url = urlStr;
    request.headerDic = headerDic;
    request.successReqBlock = successBlock;
    request.failReqBlock = failBlock;
    //开始请求网络数据GET
    [request startRequestData];
}
// 2.异步POST请求数据
+ (void)POSTWithUrl:(NSString *)urlStr andBodyDic:(NSDictionary *)bodyDic andBodyStr:(NSString *)bodyStr andHttpHeader:(NSDictionary *)headerDic andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock
{
    DamRequest *request = [[DamRequest alloc] init];
    request.url = urlStr;
    request.bodyDic = bodyDic;
    request.bodyStr = bodyStr;
    request.headerDic = headerDic;
    request.successReqBlock = successBlock;
    request.failReqBlock = failBlock;
    //开始请求网络数据POST
    [request startRequestDataWithPOST];
}

@end

@interface DamRequest () <NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
//在.m文件里面写interface和在外面写interface实际上没有太大的区别,
//唯一的区别:(.h文件)定义的外边可以访问到,已经看到,(.m文件)一般不用暴露给外边看到
{
    // 保存请求到的数据
    NSMutableData *netData;
    //请求类
    NSURLConnection *urlConnection;
    // NSURLResponse(返回)
    NSURLResponse *_response;
}

@end

@implementation DamRequest

// 1.异步GET请求数据
- (void)startRequestData
{
    //1.处理链接:对字符串进行UFT8编码,为了防止链接中出现汉字,最终导致请求失败
    self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //2.用外部传入的url 作为网络请求的url链接
    NSURL *requestUrl = [NSURL URLWithString:self.url];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:_headerDic];
    //    for (NSString *key in _headerDic.keyEnumerator) {
    //        [request setValue:_headerDic[key] forHTTPHeaderField:key];
    //    }
    //3.创建网络请求链接
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    netData = [NSMutableData data];
    //开始网络请求
    [urlConnection start];
    
}
// 2.异步POST请求数据
- (void)startRequestDataWithPOST
{
    //1.处理链接:对字符串进行UFT8编码,为了防止链接中出现汉字,最终导致请求失败
    self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //2.用外部传入的url 作为网络请求的url链接
    NSURL *requestUrl = [NSURL URLWithString:self.url];
    //POST和GET方法的区分点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:@"POST"];
    
    if (!_bodyStr && !_bodyDic) {
        
    }else if (!_bodyStr)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
    }else if(!_bodyDic)
    {
        //        NSData *data = [NSJSONSerialization dataWithJSONObject:_bodyStr options:NSJSONWritingPrettyPrinted error:nil];
        NSData *data = [_bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    
    [request setAllHTTPHeaderFields:_headerDic];
    //    for (NSString *key in _headerDic.keyEnumerator) {
    //        [request setValue:_headerDic[key] forHTTPHeaderField:key];
    //    }
    
    //3.创建网络请求链接
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    netData = [NSMutableData data];
    //开始网络请求
    [urlConnection start];
    
    /**
     *  方法1.
     */
    //    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    //    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //    }];
    //    [task resume];
}

#pragma mark -- NSURLConnectionDataDelegate

// 第一次得到服务器的回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = response;
    [netData setLength:0];
}
// 每一次请求到的数据流
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [netData appendData:data];
}
// 网络请求结束
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.successReqBlock)
    {
        self.successReqBlock(netData,_response);
    }
    
}
// 请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [netData setLength:0];
    //如果外面没有赋值,直接调用就会造成程序崩溃
    if (self.failReqBlock)
    {
        self.failReqBlock(error);
    }
}

// 方法1.
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
//
//    completionHandler(nil);
//}


// 方法2.
- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response
{
    _response = response;
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    
    //        NSLog(@"statusCode:%ld",urlResponse.statusCode);
    //        NSLog(@"allHeaderFields:%@",urlResponse.allHeaderFields);
    //
    //        NSDictionary *dic = urlResponse.allHeaderFields;
    //        NSLog(@"Location:%@",dic[@"Location"]);
    
    //当前重定向请求的url，包含了Code参数
    NSInteger code = urlResponse.statusCode;
    
    //得到Code，由于Code参数设置了属性观察器，所以当Code被赋值时，会自动去获取Token
    NSLog(@"code::%ld",code);
    if (code == 302) {
        //因为已经拿到Code了，所以拦截掉当前这个重定向请求，直接返回nil
        return nil;
    }else{
        return request;
    }
}

@end
