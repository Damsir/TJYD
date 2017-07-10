//
//  MessageModel.m
//  TJYD
//
//  Created by 吴定如 on 17/5/24.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end