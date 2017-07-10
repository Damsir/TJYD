//
//  LogModel.m
//  TJYD
//
//  Created by 吴定如 on 17/4/19.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "LogModel.h"

@implementation LogModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.logList = [NSMutableArray array];
            NSArray *list = [dic objectForKey:@"projectLog"];
            for (NSDictionary *dic in list) {
                LogListModel *model = [[LogListModel alloc] initWithDictionary:dic];
                [self.logList addObject:model];
            }
        }
    }
    return self;
}

/**< 忽略不需要的属性 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation LogListModel

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
