//
//  FormSingleLogin.m
//  TJYD
//
//  Created by 吴定如 on 17/4/24.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FormSingleLogin.h"

static NSString *locationUrl;

@implementation FormSingleLogin

/** 单点登录 */
+ (void)singleLoginActionWithSuccess:(SuccessBlock)successBlock {
    
    NSString *userName = [UserDefaults objectForKey:@"userName"];
    NSString *passWord = [UserDefaults objectForKey:@"passWord"];
    
    // 1.
    NSString *url = [NSString stringWithFormat:@"%@/sso/login?service=%@/teamworks/fauxRedirect.lsw",[Global BpmSSOApi],[Global BpmFormApi]];
    [DamNetworkingManager GETWithUrl:url andHttpHeader:nil andSuccess:^(NSData *data,NSURLResponse *response) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"responseString1:%@",responseString);
        
        if (![responseString isEqualToString:@""]) {
            // 未登录
            TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
            NSArray *array1 =[Hpple searchWithXPathQuery:@"//input"];
            TFHppleElement *hppleElement = array1[2];
            NSArray *arr = [hppleElement.raw.description componentsSeparatedByString:@"\""];
            NSString *lt = arr[arr.count - 2];
            NSLog(@"lt::%@",arr[arr.count - 2]);
            TFHppleElement *hppleElement2 = array1[3];
            NSArray *arr2 = [hppleElement2.raw.description componentsSeparatedByString:@"\""];
            NSString *execution = arr2[arr2.count - 2];
            NSLog(@"execution::%@",arr2[arr2.count - 2]);
            
            // 2.
            NSHTTPURLResponse *Response = (NSHTTPURLResponse *)response;
            NSDictionary *dic = [Response allHeaderFields];
            NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
            NSString *Cookie1 = [cookieArr firstObject];
            NSLog(@"Cookie1::%@",Cookie1);
            
            //            NSDictionary *parameters = @{@"username":userName,@"password":passWord,@"lt":lt,@"execution":execution,@"_eventId":@"submit",@"submit":@"登录"};
            //NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie1};
            NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive"};
            NSString *paraStr = [NSString stringWithFormat: @"username=%@&password=%@&lt=%@&execution=%@&_eventId=submit&submit=登录",userName,passWord,lt,execution];
            
            [DamNetworkingManager POSTWithUrl:url andBodyDic:nil andBodyStr:paraStr andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"responseString2:%@",responseString);
                NSLog(@"response2::%@",response);
                
                NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
                NSLog(@"Location2:%@",dic[@"Location"]);
                
                locationUrl = dic[@"Location"];
                
                NSString *CASTGC = dic[@"Set-Cookie"];
                //                NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie};
                NSDictionary *headerDic = @{@"Connection":@"keep-alive"};
                // 3.
                [DamNetworkingManager GETWithUrl:dic[@"Location"] andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
                    
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"responseString3:%@",responseString);
                    
                    NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
                    NSDictionary *dic = [Response allHeaderFields];
                    NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
                    NSString *Cookie = [cookieArr firstObject];
                    NSLog(@"Cookie3::%@",Cookie);
                    NSString *Cookies = [NSString stringWithFormat:@"%@;%@",[dic objectForKey:@"Set-Cookie"],CASTGC];
                    NSDictionary *headerDic = @{@"Cookie":[dic objectForKey:@"Set-Cookie"]};
                    headerDic = @{@"Cookie":Cookies,@"Connection":@"keep-alive"};
                    
                    //                    NSString *URL = @"http://116.236.160.182:9081/teamworks/fauxRedirect.lsw?zWorkflowState=1&coachDebugTrace=none&zResetContext=true&zTaskId=2405&iscontractagent=是";
                    //                    // URL = [NSString stringWithFormat:@"http://116.236.160.182:9081/teamworks/fauxRedirect.lsw?zWorkflowState=1&coachDebugTrace=none&zResetContext=true&zTaskId=%@&iscontractagent=是",_listModel.TASK_ID];
                    //
                    //                    // 4.表单信息
                    //                    [DamNetworkingManager GETWithUrl:URL andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
                    //
                    //                        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    //                        NSLog(@"responseString4:%@",responseString);
                    //                        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    //                        NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
                    //                        //                      [_web loadRequest:[NSURLRequest requestWithURL:Response.URL]];
                    //                        //                    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.236.160.182:9083/AppCenter/dist/views/mobileForm.html"]]];
                    //                        //                    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://116.236.160.182:9083/AppCenter/dist/views/mobileForm.html"]]];
                    //
                    //                    } andFailBlock:^(NSError *error) {
                    //
                    //                    }];
                    
                    if (successBlock) {
                        successBlock(YES);
                    }
                } andFailBlock:^(NSError *error) {
                    if (successBlock) {
                        successBlock(NO);
                    }
                }];
            } andFailBlock:^(NSError *error) {
                if (successBlock) {
                    successBlock(NO);
                }
            }];
            
        } else {
            // 已登录
            NSDictionary *headerDic = [(NSHTTPURLResponse *)response allHeaderFields];
            // 3.
            [DamNetworkingManager GETWithUrl:headerDic[@"Location"] andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"responseString3:%@",responseString);
                
                NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
                NSDictionary *dic = [Response allHeaderFields];
                NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
                NSString *Cookie = [cookieArr firstObject];
                NSLog(@"Cookie3::%@",Cookie);
                
                if (successBlock) {
                    successBlock(YES);
                }
            } andFailBlock:^(NSError *error) {
                if (successBlock) {
                    successBlock(NO);
                }
            }];
        }
        
    } andFailBlock:^(NSError *error) {
        if (successBlock) {
            successBlock(NO);
        }
    }];
}

+ (void)singleLogoutAction {
    
    // 清除所有缓存方法
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // 清空HTTP请求的Cookie
    //    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    //    DLog(@"_tmpArray:%@",_tmpArray);
    //    for (id obj in _tmpArray) {
    //        [cookieJar deleteCookie:obj];
    //    }
    //
    
    // 2.BPM
    [DamNetworkingManager GETWithUrl:[NSString stringWithFormat: @"%@/teamworks/ibm_security_logout?logout=Logout",[Global BpmFormApi]] andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"BPM_Logout:%@",responseString);
        
        //        NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
        //        NSDictionary *dic = [Response allHeaderFields];
        //        NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
        //        NSString *Cookie = [cookieArr firstObject];
        //        NSLog(@"Cookie3::%@",Cookie);
        
        //        if (successBlock) {
        //            successBlock(YES);
        //        }
    } andFailBlock:^(NSError *error) {
        //        if (successBlock) {
        //            successBlock(NO);
        //        }
    }];
    
    // 1.时间戳
    //获取系统当前的时间戳
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a];//转为字符型
    NSString *timeUrl = [NSString stringWithFormat:@"%@/sso/logout?ts=%@",[Global BpmSSOApi],timeString];
    [DamNetworkingManager GETWithUrl:timeUrl andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Logout:%@",responseString);
        
        //        NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
        //        NSDictionary *dic = [Response allHeaderFields];
        //        NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
        //        NSString *Cookie = [cookieArr firstObject];
        //        NSLog(@"Cookie3::%@",Cookie);
        
        //        if (successBlock) {
        //            successBlock(YES);
        //        }
    } andFailBlock:^(NSError *error) {
        //        if (successBlock) {
        //            successBlock(NO);
        //        }
    }];
    
    
    // 3.注销用户
    NSString *changeUrl = [NSString stringWithFormat:@"%@/AppCenter/changeUser.do",[Global BpmSSOApi]];
    [DamNetworkingManager GETWithUrl:changeUrl andHttpHeader:nil andSuccess:^(NSData *data, NSURLResponse *response) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"changeUser:%@",responseString);
        
        //        NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
        //        NSDictionary *dic = [Response allHeaderFields];
        //        NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
        //        NSString *Cookie = [cookieArr firstObject];
        //        NSLog(@"Cookie3::%@",Cookie);
        
        //        if (successBlock) {
        //            successBlock(YES);
        //        }
    } andFailBlock:^(NSError *error) {
        //        if (successBlock) {
        //            successBlock(NO);
        //        }
    }];
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end