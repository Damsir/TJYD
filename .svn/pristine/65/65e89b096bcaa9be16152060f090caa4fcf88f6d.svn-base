//
//  SendPeopleCellModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/27.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendPeopleCellModel : NSObject

@property (assign, nonatomic) NSInteger messageId;//主键id
@property (strong, nonatomic) NSArray *peoples;
@property (strong, nonatomic) NSDictionary *peopleDic;
@property (strong, nonatomic) NSArray *node;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobileID;
@property (assign, nonatomic) BOOL isCheck;

// users
@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *wfactivityid;//
@property (nonatomic, copy) NSString *loginName;//
@property (nonatomic, copy) NSString *Id;//
@property (nonatomic, copy) NSString *type;//


+ (SendPeopleCellModel *)sharedPeople;

+ (void)clear;

- (void)updateWithDictionary:(NSDictionary *)dict;

- (void)savePeoples;

/*
 {
 "override": 0,
 "type": "activity",
 "rolesend": false,
 "groupName": "",
 "selected": false,
 "multiselected": false,
 "children": [
 {
 "loginname": "wangying",
 "hasDeal": false,
 "type": "user",
 "name": "王颖",
 "id": "a_1201_u_405"
 }
 ],
 "id": "a_1201",
 "name": "合同委托代理人签字",
 "wfactivityid": "bpdid:5de07e9d8695ad71:39ba8763:1596c447b4e:-7f6d"
 }
 */

- (id)initWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type loginName:(NSString *)loginName wfactivityid:(NSString *)wfactivityid people:(NSArray *)people;

+ (id)dataObjectWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type loginName:(NSString *)loginName wfactivityid:(NSString *)wfactivityid children:(NSArray *)peoples;

@end
