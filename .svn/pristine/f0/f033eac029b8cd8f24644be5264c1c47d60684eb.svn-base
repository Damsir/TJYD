//
//  ComprehensiveModel.m
//  XAYD
//
//  Created by songdan Ye on 16/4/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ComprehensiveModel.h"
#import "MJExtension.h"

@implementation ComprehensiveModel

//需要转义的模型关键字在前面
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"searchResultModel"};
}

@end

@implementation searchResultModel

//需要转义的字符串key在后面
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};

}

@end
