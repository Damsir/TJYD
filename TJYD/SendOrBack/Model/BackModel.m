//
//  BackModel.m
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "BackModel.h"

@implementation BackModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.routeStepList = [NSMutableArray array];
            NSArray *list = [[dic objectForKey:@"routeStepList"] firstObject];
            for (NSDictionary *dic in list) {
                BackListModel *model = [[BackListModel alloc] initWithDictionary:dic];
                [self.routeStepList addObject:model];
            }
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation BackListModel

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
