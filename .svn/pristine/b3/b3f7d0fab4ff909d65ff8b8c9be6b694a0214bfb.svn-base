//
//  MobileSingleLogin.m
//  TJYD
//
//  Created by 吴定如 on 17/5/3.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "MobileSingleLogin.h"

@implementation MobileSingleLogin

/** 单点登录 */
+ (void)singleLoginActionWithSuccess:(SuccessBlock)successBlock {
    
    NSString *userName = [UserDefaults objectForKey:@"userName"];
    NSString *passWord = [UserDefaults objectForKey:@"passWord"];
    
    // 1.
    NSString *url = @"http://116.236.160.182:9083/sso/login?service=http://116.236.160.182:9083/AppCenter/system/views/index.jsp";
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
            NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie1};
            NSString *paraStr = [NSString stringWithFormat: @"username=%@&password=%@&lt=%@&execution=%@&_eventId=submit&submit=登录",userName,passWord,lt,execution];
            
            [DamNetworkingManager POSTWithUrl:url andBodyDic:nil andBodyStr:paraStr andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"responseString2:%@",responseString);
                NSLog(@"response2::%@",response);
                
                NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
                NSLog(@"Location2:%@",dic[@"Location"]);
               
                NSString *CASTGC = dic[@"Set-Cookie"];

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
            [DamNetworkingManager GETWithUrl:headerDic[@"Location"] andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
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
    
    
    
    
//    [DamNetworkingManager requestWithUrl:url andHttpHeader:nil andSuccess:^(NSData *data,NSURLResponse *response) {
//        
//        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //        NSLog(@"responseString1:%@",responseString);
//        
//        TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
//        NSArray *array1 =[Hpple searchWithXPathQuery:@"//input"];
//        TFHppleElement *hppleElement = array1[2];
//        NSArray *arr = [hppleElement.raw.description componentsSeparatedByString:@"\""];
//        NSString *lt = arr[arr.count - 2];
//        NSLog(@"lt::%@",arr[arr.count - 2]);
//        TFHppleElement *hppleElement2 = array1[3];
//        NSArray *arr2 = [hppleElement2.raw.description componentsSeparatedByString:@"\""];
//        NSString *execution = arr2[arr2.count - 2];
//        NSLog(@"execution::%@",arr2[arr2.count - 2]);
//        
//        // 2.
//        NSHTTPURLResponse *Response  = (NSHTTPURLResponse *)response;
//        NSDictionary *dic = [Response allHeaderFields];
//        NSArray *cookieArr = [[dic objectForKey:@"Set-Cookie"] componentsSeparatedByString:@";"];
//        NSString *Cookie = [cookieArr firstObject];
//        NSLog(@"Cookie1::%@",Cookie);
//        
//        NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie};
//        NSString *paraStr = [NSString stringWithFormat: @"username=liukuang&password=1&lt=%@&execution=%@&_eventId=submit&submit=登录",lt,execution];
//        
//        [MyRequestManager requestWithUrl:url andBodyDic:nil andBodyStr:paraStr andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//            
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            //            NSLog(@"responseString2:%@",responseString);
//            
//            NSLog(@"response2::%@",response);
//            
//            NSDictionary *dic = [(NSHTTPURLResponse *)response allHeaderFields];
//            NSLog(@"Location2:%@",dic[@"Location"]);
//            //            NSDictionary *headerDic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"Connection":@"keep-alive",@"Cookie":Cookie};
//            NSDictionary *headerDic = @{@"Connection":@"keep-alive"};
//            // 3.
//            [MyRequestManager requestWithUrl:dic[@"Location"] andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"responseString3:%@",responseString);
//                
//                //                // 4.
//                //                [MyRequestManager requestWithUrl:@"http://192.168.1.76:8080/official/organization/GetAllOrgs.do" andHttpHeader:headerDic andSuccess:^(NSData *data, NSURLResponse *response) {
//                //
//                //                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                //                    NSLog(@"responseString4:%@",responseString);
//                //
//                //                } andFailBlock:^(NSError *error) {
//                //
//                //                }];
//                
//                //                // 5.
//                //                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                //                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                //                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//                //
//                //                [manager.requestSerializer setValue:Cookie forHTTPHeaderField:@"Cookie"];
//                //                [manager GET:@"http://192.168.1.76:8080/official/organization/GetAllOrgs.do" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                //
//                //                    NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//                //                    NSLog(@"json:%@",JsonDic);
//                //
//                //                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                //
//                //                }];
//                
//                
//                
//                // 6.
//                ContactViewController *contactVC = [[ContactViewController alloc] init];
//                contactVC.Cookie = Cookie;
//                [self presentViewController:contactVC animated:YES completion:nil];
//                
//                
//            } andFailBlock:^(NSError *error) {
//                
//            }];
//            
//            
//        } andFailBlock:^(NSError *error) {
//            
//        }];
//        
//        
//    } andFailBlock:^(NSError *error) {
//        
//    }];
}

@end
