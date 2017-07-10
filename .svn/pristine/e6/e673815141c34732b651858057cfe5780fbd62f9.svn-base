//
//  DistRequest.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

//所有的网络请求类需要继承于 WTRequest 类，每一个WTRequest 类的子类代表一种专门的网络请求
//通过覆盖父类的一些方法来构造指定的网络请求


#import "DistBaseRequest.h"

@interface DistRequest : DistBaseRequest

@property (nonatomic) BOOL ignoreCache;

/**
 *  返回当前缓存的对象
 *
 *  @return 缓存的对象
 */
- (id)cacheJson;


/**
 *  是否当前的数据从缓存获得
 *
 *  @return 返回BOOL值
 */
- (BOOL)isDataFromCache;


/**
 *  是否当前缓存需要更新
 *
 *  @return 返回BOOL值
 */
- (BOOL)isCacheVersionExpired;


/**
 *  强制更新缓存
 */
- (void)startWithoutCache;


/**
 *  手动将其他请求的JsonResponse写入该请求的缓存
 *
 *  @param jsonResponse 待写入的json数据
 */
- (void)saveJsonResponseToCacheFile:(id)jsonResponse;



/*
 在实际开发中，有一些内容可能会加载很慢，我们想先显示上次的内容，等加载成功后，再用最新的内容替换上次的内容。也有时候，由于网络处于断开状态，为了更加友好，我们想显示上次缓存中的内容。这个时候，可以使用 DistReqeust 的直接加载缓存的高级用法。
 
 具体的方法是直接使用DistRequest的 - (id)cacheJson 方法，即可获得上次缓存的内容。当然，你需要把 - (NSInteger)cacheTimeInSeconds 覆盖，返回一个大于等于0的值，这样才能开启DistRequest的缓存功能，否则默认情况下，缓存功能是关闭的。
 */

/********以下方法提供给子类重写*************************************************************/

/**
 *  设置请求失效时间，在此时间段里并不会发送真正的请求而是用缓存的数据
 *
 *  @return 时长
 */
- (NSInteger)cacheTimeInSeconds;

/**
 *  缓存版本
 *
 *  @return 版本
 */
- (long long)cacheVersion;

/**
 *  缓存的活跃数据
 *
 *  @return 活跃数据
 */
- (id)cacheSensitiveData;

@end

