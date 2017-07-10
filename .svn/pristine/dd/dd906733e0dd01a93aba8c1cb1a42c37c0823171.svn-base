//
//  BackPeopleCellModel.m
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "BackPeopleCellModel.h"

#define MKNAME      @"name"
#define MKNODE      @"node"

static BackPeopleCellModel  *_sharedPepple;

@implementation BackPeopleCellModel

+ (BackPeopleCellModel *)sharedPeople
{
    if (!_sharedPepple)
    {
        @synchronized (self)
        {
            if (!_sharedPepple)
            {
                _sharedPepple = [[BackPeopleCellModel alloc] init];
            }
        }
    }
    return _sharedPepple;
}

+ (BackPeopleCellModel *)uploadUser
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"people"];
    BackPeopleCellModel *people = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (!people)
    {
        people = [[BackPeopleCellModel alloc] init];
    }
    return people;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        //self.messageId = [value integerValue];
        self.Id = value;
    }
    else
    {
        NSLog(@"undefine key: %@,  value: %@", key, value);
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)updateWithDictionary:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
}

- (void)savePeoples
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"people"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clear
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"people"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _sharedPepple = [[BackPeopleCellModel alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.name  = [aDecoder decodeObjectForKey:MKNAME];
        self.node  = [aDecoder decodeObjectForKey:MKNODE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:MKNAME];
    [aCoder encodeObject:self.node forKey:MKNODE];
}

/** 模型方法 */
- (id)initWithName:(NSString *)name activityName:(NSString *)activityName bpdid:(NSString *)bpdid unkownId:(NSString *)unkownId people:(NSArray *)people {
    
    self = [super init];
    if (self) {
        self.peoples = people;
        self.name = name;
        self.unknowId = unkownId;
        self.bpdid = bpdid;
        self.activityName = activityName;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name activityName:(NSString *)activityName bpdid:(NSString *)bpdid unkownId:(NSString *)unkownId children:(NSArray *)peoples {
    
    return [[self alloc] initWithName:name activityName:activityName bpdid:bpdid unkownId:unkownId people:peoples];
}

@end
