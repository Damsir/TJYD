//
//  ProjectModel.h
//  TJYD
//
//  Created by 吴定如 on 17/3/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSString *count;
@property (nonatomic, strong) NSMutableArray *list;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *INFO;/**< 项目名称 */
@property (nonatomic, copy) NSString *CONTRACTAGENTNAME;/**< 合同名称 */
@property (nonatomic, copy) NSString *PROJECTACCEPTMODE;/**< 项目接收类型 */
@property (nonatomic, copy) NSString *BUSINESSNAME;/**< 流程名称 */
@property (nonatomic, copy) NSString *STAGE;
@property (nonatomic, copy) NSString *ACTIVITY_NAME;/**< 环节名称 */
@property (nonatomic, copy) NSString *RECEIVEDDATE;
@property (nonatomic, copy) NSString *PROJECTSTATE;

@property (nonatomic, copy) NSString *ISCONTRACTDIVIDE;
@property (nonatomic, copy) NSString *ISCHIEFENGINEER;
@property (nonatomic, copy) NSString *ISCONTRACTAGENT;

/**
 *  是否为第一个环节的项目(1:是  0:不是) -> 是的话,不能发送.
 */
@property (nonatomic, copy) NSString *isdelete;

/**
 *  backto(或者opinion)是否有值
 */
@property (nonatomic, copy) NSString *backto;
@property (nonatomic, copy) NSString *opinion;

@property (nonatomic, copy) NSString *isback;
@property (nonatomic, copy) NSString *READDATE;
@property (nonatomic, copy) NSString *BUSINESSID;
@property (nonatomic, copy) NSString *PRIORITY;
@property (nonatomic, copy) NSString *BUSINESSTYPE;
@property (nonatomic, copy) NSString *SUBJECT;
@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *PROCURATOR;
@property (nonatomic, copy) NSString *ASSIGNEDTOROLE;
@property (nonatomic, copy) NSString *TASK_DUEDATE;
@property (nonatomic, copy) NSString *STATUS;
@property (nonatomic, copy) NSString *CONTRACTDIVIDE;
@property (nonatomic, copy) NSString *ASSIGNEDTOUSERNAME;
@property (nonatomic, copy) NSString *TASK_ID;
@property (nonatomic, copy) NSString *BID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ASSIGNEDTOUSER;
@property (nonatomic, copy) NSString *MANAGETYPE;
@property (nonatomic, copy) NSString *INSTANCEID;
@property (nonatomic, copy) NSString *DESIGN_DEPARTMENT;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
