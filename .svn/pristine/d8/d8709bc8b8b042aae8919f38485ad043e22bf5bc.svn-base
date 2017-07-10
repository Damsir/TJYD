//
//  BackPeopleCellModel.h
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackPeopleCellModel : NSObject

@property (assign, nonatomic) NSInteger messageId;//主键id
@property (strong, nonatomic) NSArray *peoples;
@property (strong, nonatomic) NSDictionary *peopleDic;
@property (strong, nonatomic) NSArray *node;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobileID;
@property (assign, nonatomic) BOOL isCheck;

// users
@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *activityName;//
@property (nonatomic, copy) NSString *bpdid;//
@property (nonatomic, copy) NSString *unknowId;//
@property (nonatomic, copy) NSString *type;//
@property (nonatomic, copy) NSString *Id;

+ (BackPeopleCellModel *)sharedPeople;

+ (void)clear;

- (void)updateWithDictionary:(NSDictionary *)dict;

- (void)savePeoples;

/*
 "routeStepList": [
 [
 "项目负责人签字",
 "bpdid:7159dfffc2f13886:-718f245c:15967454a17:-7fb0",
 "0",
 "张金波"
 ],
 [
 "合同委托代理人签字",
 "bpdid:7159dfffc2f13886:-718f245c:15967454a17:-7f96",
 "0",
 "王颖"
 ],
 [
 "投标信息登记",
 "bpdid:e99aee855e97bb76:-1702248:1542ecb63b4:-73cb",
 "0",
 "王颖"
 ]
 ]
 */

- (id)initWithName:(NSString *)name activityName:(NSString *)activityName bpdid:(NSString *)bpdid unkownId:(NSString *)unkownId people:(NSArray *)people;

+ (id)dataObjectWithName:(NSString *)name activityName:(NSString *)activityName bpdid:(NSString *)bpdid unkownId:(NSString *)unkownId children:(NSArray *)peoples;

@end
