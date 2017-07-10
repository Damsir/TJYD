//
//  FeedbackModel.m
//  TJYD
//
//  Created by 吴定如 on 17/5/23.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FeedbackModel.h"

@implementation FeedbackModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.list = [NSMutableArray array];
            NSArray *list = [dic objectForKey:@"list"];
            for (NSDictionary *dic in list) {
                FeedbackListModel *model = [[FeedbackListModel alloc] initWithDictionary:dic];
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

@implementation FeedbackListModel

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
