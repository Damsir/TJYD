//
//  SingleLogin.m
//  TJYD
//
//  Created by 吴定如 on 17/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SingleLogin.h"

@implementation SingleLogin

/** 单点登录 */
+ (void)singleLoginActionWithSuccess:(SuccessBlock)successBlock {
    
    NSString *userName = [UserDefaults objectForKey:@"userName"];
    NSString *passWord = [UserDefaults objectForKey:@"passWord"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"username=%@,password=%@",userName,passWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    
    // 单点登录
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeSingleLogin requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            // 将ticket保存起来,后面请求数据都需要用
            NSString *ticket = [JsonDic objectForKey:@"ticket"];
            // 对ticket进行处理,拼接等号(JSESSIONID==0000Th8tyEFjbTtkm3hAkSyqpAT:-1)
            NSArray *ticketArr = [ticket componentsSeparatedByString:@"="];
            ticket = [NSString stringWithFormat:@"%@==%@",ticketArr[0],ticketArr[1]];
            
            [UserDefaults setValue:ticket forKey:@"ticket"];
            [UserDefaults synchronize];
            
            NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==ApprpveMobile/getUserInfo.do,%@",ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
            // 获取用户信息
            DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetUserInfo requestMethod:DistRequestMethodPost arguments:nil];
            [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
                
                NSDictionary *userInfo = request.responseJSONObject;
                if ([[userInfo objectForKey:@"state"] isEqualToString:@"true"]) {
                    userInfo = [SingleLogin deleteNullWithDictionary:userInfo];
                    
                    [Global initializeSystem:[Global Url] deviceUUID:nil Cookie:nil user:userInfo];
                    [Global setUserId:[userInfo objectForKey:@"id"]];
                    //初始化用户信息
                    [Global initializeUserInfo:userName userId:[userInfo objectForKey:@"id"] org:@""];
                    
                    if (successBlock) {
                        successBlock(YES);
                    }
                } else {
                    if (successBlock) {
                        successBlock(NO);
                    }
                }
            } failure:^(__kindof DistBaseRequest *request, NSError *error) {
                if (successBlock) {
                    successBlock(NO);
                }
                DLog(@"error:%@",error);
            }];
        } else {
            if (successBlock) {
                successBlock(NO);
            }
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        if (successBlock) {
            successBlock(NO);
        }
        DLog(@"error:%@",error);
    }];
}

#pragma mark -- 对字典做删除null处理

+ (NSDictionary *)deleteNullWithDictionary:(NSDictionary *)dic{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic.allKeys) {
        
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:key];
        }else{
            [mutableDic setObject:[dic objectForKey:key] forKey:key];
        }
    }
    return mutableDic;
}

@end