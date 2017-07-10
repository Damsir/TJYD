//
//  FileTableViewContainerAPI.m
//  TJYD
//
//  Created by pengtao on 2017/4/5.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FileTableViewContainerAPI.h"
#import "Global.h"
@implementation FileTableViewContainerAPI{
    
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
    NSString *url =[NSString stringWithFormat:@"%@service/gw/FtpDoc.ashx",[Global Url]];
    
    return url;
}

- (id)requestArgument{
    return _arguments;
}



@end
