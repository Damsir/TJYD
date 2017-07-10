//
//  DistNetworkPrivate.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistBatchRequest.h"
#import "DistChainRequest.h"

@interface DistNetworkPrivate : NSObject


/**
 *  判断数据是否是符合标准的json数据
 *
 *  @param json          json数据
 *  @param validatorJson 用于验证的标准json数据
 *
 *  @return 返回BOOL值
 */
+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson;


/**
 *  在原始的url后面添加参数生成新的url
 *
 *  @param originUrlString 原始的url字符串
 *  @param parameters      参数字典
 *
 *  @return 新的url字符串
 */
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

/**
 *  添加不备份的属性
 *
 *  @param path 路径
 */
+ (void)addDoNotBackupAttribute:(NSString *)path;


/**
 *  将字符串进行MD5加密
 *
 *  @param string 欲加密字符串
 *
 *  @return 加密好的字符串
 */
+ (NSString *)md5StringFromString:(NSString *)string;


/**
 *  获取APP的版本号字符串
 *
 *  @return APP的版本号字符串
 */
+ (NSString *)appVersionString;

@end


@interface DistBaseRequest (RequestAccessory)

/**
 *  将要开始回调时触发请求附加
 */
- (void)toggleAccessoriesWillStartCallBack;

/**
 *  将要停止回调时触发请求附加
 */
- (void)toggleAccessoriesWillStopCallBack;

/**
 *  已经停止回调时触发请求附加
 */
- (void)toggleAccessoriesDidStopCallBack;

@end


@interface DistBatchRequest (RequestAccessory)

/**
 *  将要开始回调时触发请求附加
 */
- (void)toggleAccessoriesWillStartCallBack;

/**
 *  将要停止回调时触发请求附加
 */
- (void)toggleAccessoriesWillStopCallBack;

/**
 *  已经停止回调时触发请求附加
 */
- (void)toggleAccessoriesDidStopCallBack;

@end


@interface DistChainRequest (RequestAccessory)

/**
 *  将要开始回调时触发请求附加
 */
- (void)toggleAccessoriesWillStartCallBack;

/**
 *  将要停止回调时触发请求附加
 */
- (void)toggleAccessoriesWillStopCallBack;

/**
 *  已经停止回调时触发请求附加
 */
- (void)toggleAccessoriesDidStopCallBack;



@end
