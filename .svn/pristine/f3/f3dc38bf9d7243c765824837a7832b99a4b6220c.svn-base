//
//  TreeModel.m
//  TJYD
//
//  Created by 吴定如 on 17/4/17.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "TreeModel.h"

@implementation TreeModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.rows = [NSMutableArray array];
            NSArray *rows = [dic objectForKey:@"rows"];
            for (NSDictionary *dic in rows) {
                RelationModel *model = [[RelationModel alloc] initWithDictionary:dic];
                [self.rows addObject:model];
            }
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation RelationModel

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
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
