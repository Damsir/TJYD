//
//  RecaptionModel.m
//  TJYD
//
//  Created by 吴定如 on 17/4/24.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "RecaptionModel.h"

@implementation RecaptionModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.list = [NSMutableArray array];
            NSArray *list = [dic objectForKey:@"list"];
            for (NSDictionary *dic in list) {
                RecaptionListModel *model = [[RecaptionListModel alloc] initWithDictionary:dic];
                [self.list addObject:model];
            }
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation RecaptionListModel

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