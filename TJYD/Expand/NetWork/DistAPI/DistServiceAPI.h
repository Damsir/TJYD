//
//  DistServiceAPI.h
//  TJYD
//
//  Created by 吴定如 on 17/4/6.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistRequest.h"

/** 请求接口区分 */
typedef NS_ENUM (NSInteger, DistServiceActionType){
    
    DistServiceActionTypeSingleLogin,/**< 单点登录 */
    DistServiceActionTypeGetUserInfo,/**< 用户信息 */
    DistServiceActionTypeGetContacts,/**< 通讯录 */
    DistServiceActionTypeSingleLoginOut,/**< 注销 */
    DistServiceActionTypeGetPasswordModify,/**< 修改密码 */
    DistServiceActionTypeGetAllNoticeList,/**< 院内新闻,通知公告,院发文件 */
    DistServiceActionTypeGetProcessingList,/**< 待办事项(项目) */
    DistServiceActionTypeGetForm,/**< 表单详情(待办事项) */
    DistServiceActionTypeGetMaterial,/**< 项目附件(材料) */
    DistServiceActionTypeGetDownloadMaterial,/**< 附件(材料)下载 */
    DistServiceActionTypeGetAnDownload,/**< 附件(材料)下载 */
    DistServiceActionTypeGetProjectRelation,/**< 项目关联 */
    DistServiceActionTypeGetProjectOperateLog,/**< 流转日志 */
    DistServiceActionTypeGetActivities,/**< 获取发送人员列表 */
    DistServiceActionTypeGetSaveSelectUsers,/**< 保存发送人员 */
    DistServiceActionTypeGetProjectOfMyList,/**< 我的项目 */
    DistServiceActionTypeGetProcessedForm,/**< 表单详情(我的项目) */
    DistServiceActionTypeGetRecapyionList,/**< 取回列表 */
    DistServiceActionTypeGetBackForm,/**< 取回表单 */
    DistServiceActionTypeGetUnProcessAssign,/**< 人事系统(待办事项) */
    DistServiceActionTypeGetStepList,/**< 获取回退人员列表 */
    DistServiceActionTypeGetRouteStep,/**< 表单回退 */
    DistServiceActionTypeGetSysResponseList,/**< 系统意见反馈列表 */
    DistServiceActionTypeSaveSysResponse,/**< 提交意见反馈 */
    DistServiceActionTypeDeleteSysResponse,/**< 删除系统意见反馈 */
    DistServiceActionTypeGetReceivedList,/**< 系统消息列表 */
    DistServiceActionTypeMessageDelete,/**< 删除系统消息 */
    
    DistServiceActionTypeGetStand,/**< 财务台账 */
    DistServiceActionTypeGetAccount,/**< 补充合同 */
};

@interface DistServiceAPI : DistRequest

/**
 *  数据请求
 *
 *  @param des        加密的参数
 *  @param actionType 请求的接口区分
 *
 */
- (instancetype)initWithDes:(NSString *)des DistServiceActionType:(DistServiceActionType)actionType requestMethod:(DistRequestMethod)requestMethod arguments:(NSDictionary *)arguments;

/** 请求成功与否的回调 */
@property(nonatomic,assign) DistServiceActionType actionType;


@end
