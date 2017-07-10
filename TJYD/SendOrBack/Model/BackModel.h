//
//  BackModel.h
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackModel : NSObject

@property (nonatomic, copy) NSString *instanceId;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *onlyDeal;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *activity;
@property (nonatomic, copy) NSString *optType;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic,strong) NSMutableArray *routeStepList;/**< 人员列表 */

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface BackListModel : NSObject

@property (nonatomic, copy) NSString *name;/**< 姓名 */
@property (nonatomic, copy) NSString *activityName;/**< 环节 */
@property (nonatomic, copy) NSString *bpdid;/**< 环节ID */
@property (nonatomic, copy) NSString *unknowId;/**< unkownId */

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

