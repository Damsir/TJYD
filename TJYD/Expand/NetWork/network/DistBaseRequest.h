//
//  DistBaseRequest.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"


@class DistBaseRequest;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^DistRequestCompletionBlock)(__kindof DistBaseRequest *request);
typedef void (^DistRequestFailureBlock)(__kindof DistBaseRequest *request, NSError *error);
typedef void (^DistRequestProgressBlock)(NSProgress *progress);

/**
 *  请求方式
 */
typedef NS_ENUM(NSInteger, DistRequestMethod) {
    /**
     *  GET请求
     */
    DistRequestMethodGet = 0,
    /**
     *  Post请求
     */
    DistRequestMethodPost,
    /**
     *  Head请求
     */
    DistRequestMethodHead,
    /**
     *  Put请求
     */
    DistRequestMethodPut,
    /**
     *  Delete请求
     */
    DistRequestMethodDelete,
    /**
     *  Patch请求
     */
    DistRequestMethodPatch
};


/**
 *  请求序列化的类型
 */
typedef NS_ENUM(NSInteger, DistRequestSerializerType) {
    /**
     *  HTTP
     */
    DistRequestSerializerTypeHTTP = 0,
    /**
     *  JSON
     */
    DistRequestSerializerTypeJSON,
};


/**
 *  DistRequest的代理
 */
@protocol DistRequestDelegate <NSObject>

@optional

/**
 *  请求完成
 *
 *  @param request DistBase请求
 */
- (void)requestFinished:(DistBaseRequest *)request;

/**
 *  请求失败
 *
 *  @param request DistBase请求
 *  @param error   失败信息
 */
- (void)requestFailed:(DistBaseRequest *)request error:(NSError *)error;

/**
 *  请求进度
 *
 *  @param progress 请求进度
 */
- (void)requestProgress:(NSProgress *)progress;

/**
 *  清除请求
 */
- (void)clearRequest;

@end


/**
 *  请求附加
 */
@protocol DistRequestAccessory <NSObject>

@optional

/**
 *  请求将要开始
 *
 *  @param request 请求
 */
- (void)requestWillStart:(id)request;

/**
 *  请求将要停止
 *
 *  @param request 请求
 */
- (void)requestWillStop:(id)request;

/**
 *  请求已经停止
 *
 *  @param request 请求
 */
- (void)requestDidStop:(id)request;

@end


@interface DistBaseRequest : NSObject

/**
 *  每个请求的tag值
 */
@property (nonatomic) NSInteger tag;

/**
 *  请求的用户信息
 */
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSDictionary *requestHeaderFieldValueDictionary;


/**
 *  NSURLSessionDataTask
 */
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;

/**
 *  请求的代理对象
 */
@property (nonatomic, weak) id<DistRequestDelegate> delegate;

//@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

/**
 *  请求返回的数据对象
 */
@property (nonatomic, strong) id responseObject;

/**
 *  请求返回的字符串
 */
@property (nonatomic, strong, readonly) NSString *responseString;

/**
 *  请求返回的json对象
 */
@property (nonatomic, strong) id responseJSONObject;

/**
 *  成功请求的回调
 */
@property (nonatomic, copy) DistRequestCompletionBlock successCompletionBlock;

/**
 *  失败请求的回调
 */
@property (nonatomic, copy) DistRequestFailureBlock failureCompletionBlock;

/**
 *  请求进度的回调
 */
@property (nonatomic, copy) DistRequestProgressBlock progressBlock;

/**
 *  请求附加物（配件） 如 指示器 等
 */
@property (nonatomic, strong) NSMutableArray *requestAccessories;


/**
 *  用于 GET/POST 情况下，拼接参数请求，拼接在URL后面，而不是放在body里面
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *queryArgument;


/**
 *  开始请求 将请求加入到请求队列
 */
- (void)start;


/**
 *  取消请求 将请求移除请求队列
 */
- (void)stop;

//- (BOOL)isExecuting;

/**
 *  开始请求
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)startWithCompletionBlockWithSuccess:(DistRequestCompletionBlock)success
                                    failure:(DistRequestFailureBlock)failure;

- (void)setCompletionBlockWithSuccess:(DistRequestCompletionBlock)success
                              failure:(DistRequestFailureBlock)failure;

/**
 *  把block置nil来打破循环引用
 */
- (void)clearCompletionBlock;

/**
 *  Request Accessory，可以hook（链接到） Request的start和stop
 *
 *  @param accessory 附加配件
 */
- (void)addAccessory:(id<DistRequestAccessory>)accessory;


/*---------------------------以下方法由子类重写来覆盖默认值-------------------------------*/

/**
 *  请求成功的回调
 */
- (void)requestCompleteFilter;


/**
 *  请求失败的回调
 */
- (void)requestFailedFilter;


/**
 *  请求的URL接口
 *
 *  @return URL字符串
 */
- (NSString *)requestUrl;


/**
 *  请求的CdnURL
 *
 *  @return CdnURL字符串
 */
- (NSString *)cdnUrl;


/**
 *  请求的BaseURL
 *
 *  @return BaseURL字符串
 */
- (NSString *)baseUrl;


/**
 *  请求的连接超时时间，默认为60秒
 *
 *  @return 时长
 */
- (NSTimeInterval)requestTimeoutInterval;


/**
 *  请求的参数列表
 *
 *  @return 参数
 */
- (NSDictionary *)requestArgument;


/**
 *  用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
 *
 *  @param argument 参数
 *
 *  @return 缓存结果
 */
- (id)cacheFileNameFilterForRequestArgument:(id)argument;


/**
 *  Http请求的方法
 *
 *  @return DistRequestMethod
 */
- (DistRequestMethod)requestMethod;


/**
 *  请求的SerializerType
 *
 *  @return DistRequestSerializerType
 */
- (DistRequestSerializerType)requestSerializerType;


/**
 *  请求的Server用户名和密码
 *
 *  @return 存储Server用户名和密码
 */
- (NSArray *)requestAuthorizationHeaderFieldArray;


/**
 *  在HTTP报头添加的自定义参数
 *
 *  @return 自定义参数字典
 */
//- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
//- (NSURLRequest *)buildCustomUrlRequest;


/**
 *  是否使用CDN的host地址
 *
 *  @return 返回BOOL值
 */
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
//- (id)jsonValidator;

/// 用于检查Status Code是否正常的方法
//- (BOOL)statusCodeValidator;


/**
 *  当POST的内容带有文件等富文本时使用
 *
 *  @return AFConstructingBlock
 */
- (AFConstructingBlock)constructingBodyBlock;



@end
