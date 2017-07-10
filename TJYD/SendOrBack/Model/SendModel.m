//
//  SendModel.m
//  TJYD
//
//  Created by 吴定如 on 17/4/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SendModel.h"

@implementation SendModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.children = [NSMutableArray array];
            NSArray *children = [dic objectForKey:@"children"];
            for (NSDictionary *dic in children) {
                SendListModel *model = [[SendListModel alloc] initWithDictionary:dic];
                [self.children addObject:model];
            }
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation SendListModel

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
