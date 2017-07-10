//
//  MyProjectModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProjectModel : NSObject

@property (nonatomic, copy) NSString *count;
@property (nonatomic, strong) NSMutableArray *list;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface MyListModel : NSObject

@property (nonatomic, copy) NSString *PROJECTNAME;/**< 项目名称 */
@property (nonatomic, copy) NSString *HTMC;/**< 合同名称 */
@property (nonatomic, copy) NSString *PROJECTACCEPTMODE;/**< 项目接收类型 */
@property (nonatomic, copy) NSString *ACTIVITY_NAME;/**< 环节名称 */
@property (nonatomic, copy) NSString *userRole;/**< 用户角色 */

@property (nonatomic, copy) NSString *CONTRACTDIVIDE;
@property (nonatomic, copy) NSString *ISCONTRACTAGENT;
@property (nonatomic, copy) NSString *ischiefengineer;
@property (nonatomic, copy) NSString *ID;


@property (nonatomic, copy) NSString *ISCKFYXM;
@property (nonatomic, copy) NSString *PROJECTLEADERNAME;
@property (nonatomic, copy) NSString *CONTRACTAGENT;
@property (nonatomic, copy) NSString *SPECIALPROJECT;
@property (nonatomic, copy) NSString *TEAMCONTACTNAME;
@property (nonatomic, copy) NSString *PROJECTSCALEREMARK;
@property (nonatomic, copy) NSString *PROJECTNUM;
@property (nonatomic, copy) NSString *ZZCHID;
@property (nonatomic, copy) NSString *PROCESSINSTANCEID;
@property (nonatomic, copy) NSString *TEAMCOOPERATION;
@property (nonatomic, copy) NSString *RN;
@property (nonatomic, copy) NSString *P_LOCATIONCOUNTY;
@property (nonatomic, copy) NSString *PROJECTTYPE;
@property (nonatomic, copy) NSString *JDRYTZZZCHID;
@property (nonatomic, copy) NSString *MIGRATIONIDENTIFY;
@property (nonatomic, copy) NSString *CREATEDATE;
@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *PROJECTREVIEWERNAME;
@property (nonatomic, copy) NSString *TRANSFEREDID;
@property (nonatomic, copy) NSString *PROJECTSCALE;
@property (nonatomic, copy) NSString *PROJECTLEADER;
@property (nonatomic, copy) NSString *TASK_ID;
@property (nonatomic, copy) NSString *P_LOCATIONCITY;
@property (nonatomic, copy) NSString *MANAGETYPE;
@property (nonatomic, copy) NSString *PROJECTSOURCE;
@property (nonatomic, copy) NSString *RYTZZZCHID;
@property (nonatomic, copy) NSString *P_LOCATIONPROVINCE;
@property (nonatomic, copy) NSString *CHIEFENGINEER;
@property (nonatomic, copy) NSString *ISAPPROVAL;
@property (nonatomic, copy) NSString *PROJECTSEQNUM;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *LIFESTATE;
@property (nonatomic, copy) NSString *PROJECTSCALEUNIT;
@property (nonatomic, copy) NSString *PROJECTREVIEWER;
@property (nonatomic, copy) NSString *CONTRACTAGENTNAME;
@property (nonatomic, copy) NSString *EXPERTLEADER;
@property (nonatomic, copy) NSString *TEAMCONTACT;
@property (nonatomic, copy) NSString *DESIGNDEPARTMENT;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end