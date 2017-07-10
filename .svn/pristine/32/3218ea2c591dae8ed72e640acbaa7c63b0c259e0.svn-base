//
//  SendPeopleCellModel.m
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "SendPeopleCellModel.h"

#define MKNAME      @"name"
#define MKNODE      @"node"

static SendPeopleCellModel  *_sharedPepple;

@implementation SendPeopleCellModel


+ (SendPeopleCellModel *)sharedPeople
{
    if (!_sharedPepple)
    {
        @synchronized (self)
        {
            if (!_sharedPepple)
            {
                _sharedPepple = [[SendPeopleCellModel alloc] init];
            }
        }
    }
    return _sharedPepple;
}

+ (SendPeopleCellModel *)uploadUser
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"people"];
    SendPeopleCellModel *people = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (!people)
    {
        people = [[SendPeopleCellModel alloc] init];
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
    _sharedPepple = [[SendPeopleCellModel alloc] init];
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
- (id)initWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type loginName:(NSString *)loginName wfactivityid:(NSString *)wfactivityid people:(NSArray *)people {
    self = [super init];
    if (self) {
        self.peoples = people;
        self.name = name;
        self.Id = Id;
        self.type = type;
        self.loginName = loginName;
        self.wfactivityid = wfactivityid;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type loginName:(NSString *)loginName wfactivityid:(NSString *)wfactivityid children:(NSArray *)peoples {
    
    return [[self alloc] initWithName:name Id:Id type:type loginName:loginName wfactivityid:wfactivityid people:peoples];
}

@end
