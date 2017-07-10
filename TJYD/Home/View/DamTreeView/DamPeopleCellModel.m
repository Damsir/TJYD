//
//  DamPeopleCellModel.m
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamPeopleCellModel.h"

#define MKNAME      @"name"
#define MKNODE      @"node"

static DamPeopleCellModel  *_sharedPepple;

@implementation DamPeopleCellModel


+ (DamPeopleCellModel *)sharedPeople
{
    if (!_sharedPepple)
    {
        @synchronized (self)
        {
            if (!_sharedPepple)
            {
                _sharedPepple = [[DamPeopleCellModel alloc] init];
            }
        }
    }
    return _sharedPepple;
}

+ (DamPeopleCellModel *)uploadUser
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"people"];
    DamPeopleCellModel *people = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (!people)
    {
        people = [[DamPeopleCellModel alloc] init];
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
    _sharedPepple = [[DamPeopleCellModel alloc] init];
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

//

- (id)initWithNAME:(NSString *)NAME MOBILEPHONE:(NSString *)MOBILEPHONE FIXEDPHONE:(NSString *)FIXEDPHONE LOGINNAME:(NSString *)LOGINNAME ID:(NSString *)ID PARENTID:(NSString *)PARENTID SORTID:(NSString *)SORTID DATATYPE:(NSString *)DATATYPE people:(NSArray *)people;
{
    self = [super init];
    if (self) {
        self.peoples = people;
        self.name = NAME;
        self.mobilePhone = MOBILEPHONE;
        self.fixedPhone = FIXEDPHONE;
        self.loginName = LOGINNAME;
        self.Id = ID;
        self.parentId = PARENTID;
        self.sortId = SORTID;
        self.dataType = DATATYPE;
    }
    return self;
}

+ (id)dataObjectWithNAME:(NSString *)NAME MOBILEPHONE:(NSString *)MOBILEPHONE FIXEDPHONE:(NSString *)FIXEDPHONE LOGINNAME:(NSString *)LOGINNAME ID:(NSString *)ID PARENTID:(NSString *)PARENTID SORTID:(NSString *)SORTID DATATYPE:(NSString *)DATATYPE children:(NSArray *)peoples
{
    return [[self alloc] initWithNAME:NAME MOBILEPHONE:MOBILEPHONE FIXEDPHONE:FIXEDPHONE LOGINNAME:LOGINNAME ID:ID PARENTID:PARENTID SORTID:SORTID DATATYPE:DATATYPE people:peoples];
}

@end
