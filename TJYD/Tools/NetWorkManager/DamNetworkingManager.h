//
//  DamNetworkingManager.h
//  GZYD
//
//  Created by 吴定如 on 17/3/23.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ successReqBlock)(NSData *data,NSURLResponse *response);
typedef void(^ failReqBlock)(NSError *error);
// typedef 定义的block 和属性直接定义的block区别在于:
// 直接定义属性的话,别的地方想要使用必须得重新定义,没法用.....
// #import "DamRequest.h"
@class DamRequest;

@interface DamNetworkingManager : NSObject

// 1.异步GET请求数据
+ (void)GETWithUrl:(NSString *)urlStr andHttpHeader:(NSDictionary *)headerDic andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock;
// 2.异步POST请求数据
+ (void)POSTWithUrl:(NSString *)urlStr andBodyDic:(NSDictionary *)bodyDic andBodyStr:(NSString *)bodyStr andHttpHeader:(NSDictionary *)headerDic andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock;


@end

@interface DamRequest : NSObject

// 定义外面可以访问的字符串URL
@property(nonatomic,strong) NSString *url;

// POST方式的bodyDic和bodyStr(二者二选其一即可)
@property(nonatomic,strong) NSDictionary *bodyDic;
@property(nonatomic,strong) NSString *bodyStr;
@property(nonatomic,strong) NSDictionary *headerDic;

// 请求成功的回调Block
@property(nonatomic,copy) successReqBlock successReqBlock;
// 请求失败的回调Block
@property(nonatomic,copy) failReqBlock failReqBlock;

// 1.异步GET请求数据
- (void)startRequestData;
// 2.异步POST请求数据
- (void)startRequestDataWithPOST;

@end
