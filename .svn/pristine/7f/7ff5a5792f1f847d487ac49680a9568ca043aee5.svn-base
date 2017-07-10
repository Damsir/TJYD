//
//  DamPeopleCellModel.h
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DamPeopleCellModel : NSObject

@property (assign, nonatomic) NSInteger messageId;//主键id
@property (strong, nonatomic) NSArray *peoples;
@property (strong, nonatomic) NSDictionary *peopleDic;
@property (strong, nonatomic) NSArray *node;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobileID;
@property (assign, nonatomic) BOOL isCheck;

// users
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *fixedPhone;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *sortId;
@property (nonatomic, copy) NSString *dataType;


+ (DamPeopleCellModel *)sharedPeople;

+ (void)clear;

- (void)updateWithDictionary:(NSDictionary *)dict;

- (void)savePeoples;

/*
  {"SORTID": -1,"DATATYPE": "user","NAME": "周冀云","MOBILEPHONE": "13661862382","ID": "U_1453","FIXEDPHONE": null,"PARENTID": "O_218","LOGINNAME": "zhoujiyun"}
 */

- (id)initWithNAME:(NSString *)NAME MOBILEPHONE:(NSString *)MOBILEPHONE FIXEDPHONE:(NSString *)FIXEDPHONE LOGINNAME:(NSString *)LOGINNAME ID:(NSString *)ID PARENTID:(NSString *)PARENTID SORTID:(NSString *)SORTID DATATYPE:(NSString *)DATATYPE people:(NSArray *)people;

+ (id)dataObjectWithNAME:(NSString *)NAME MOBILEPHONE:(NSString *)MOBILEPHONE FIXEDPHONE:(NSString *)FIXEDPHONE LOGINNAME:(NSString *)LOGINNAME ID:(NSString *)ID PARENTID:(NSString *)PARENTID SORTID:(NSString *)SORTID DATATYPE:(NSString *)DATATYPE children:(NSArray *)peoples;

@end
