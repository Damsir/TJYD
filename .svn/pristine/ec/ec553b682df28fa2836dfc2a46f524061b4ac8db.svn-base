//
//  ChangePasswordAPI.m
//  TJYD
//
//  Created by pengtao on 2017/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ChangePasswordAPI.h"

@implementation ChangePasswordAPI{
    
    NSDictionary *_arguments;
}

- (instancetype)initWithArguments:(NSDictionary *)arguments{
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}


- (DistRequestMethod)requestMethod{
    
    return DistRequestMethodPost;
}

- (NSString *)requestUrl {
    
    return @"service/ModifyPwd.ashx";
}

- (id)requestArgument{
    return _arguments;
}

@end
