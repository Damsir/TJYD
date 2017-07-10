//
//  SendModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *wfactivityid;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *Override;
@property (nonatomic, copy) NSString *selected;
@property (nonatomic, copy) NSString *rolesend;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *multiselected;

@property (nonatomic,strong) NSMutableArray *children;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface SendListModel : NSObject

@property (nonatomic, copy) NSString *hasDeal;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *loginname;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *selected;/**< 是否选中 */
@property (nonatomic, copy) NSString *_parentId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

