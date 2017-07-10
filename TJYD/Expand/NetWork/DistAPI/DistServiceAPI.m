//
//  DistServiceAPI.m
//  TJYD
//
//  Created by 吴定如 on 17/4/6.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistServiceAPI.h"

@implementation DistServiceAPI {
    
    NSString          * _des;
    NSDictionary      * _arguments;
    DistRequestMethod   _requestMethod;
    
}

- (instancetype)initWithDes:(NSString *)des DistServiceActionType:(DistServiceActionType)actionType requestMethod:(DistRequestMethod)requestMethod arguments:(NSDictionary *)arguments{
    self = [super init];
    if (self) {
        _des           = des;
        _actionType    = actionType;
        _requestMethod = requestMethod;
        _arguments     = arguments;
    }
    return self;
}

- (DistRequestMethod)requestMethod {
    
    return _requestMethod;
}

- (NSString *)requestUrl {
    
    switch (_actionType) {
        
            /** 单点登录 */
        case DistServiceActionTypeSingleLogin:
            return [NSString stringWithFormat:@"MobileService/single/signOn.do?params=%@",_des];
            break;
            /** 用户信息 */
        case DistServiceActionTypeGetUserInfo:
            return [NSString stringWithFormat:@"MobileService/userInfo/getUserInfo.do?params=%@",_des];
            break;
            /** 通讯录 */
        case DistServiceActionTypeGetContacts:
            return [NSString stringWithFormat:@"MobileService/userInfo/getOrgAndUser.do?params=%@",_des];
            break;
            /** 注销 */
        case DistServiceActionTypeSingleLoginOut:
            return [NSString stringWithFormat:@"MobileService/single/signOut.do?params=%@",_des];
            break;
            /** 修改密码 */
        case DistServiceActionTypeGetPasswordModify:
            return [NSString stringWithFormat:@"MobileService/userInfo/getPasswordModify.do?params=%@",_des];
            break;
            /** 院内新闻,通知公告,院发文件 */
        case DistServiceActionTypeGetAllNoticeList:
            return [NSString stringWithFormat:@"MobileService/allNoticeList/getAllNoticeList.do?params=%@",_des];
            break;
            /** 待办事项(项目) */
        case DistServiceActionTypeGetProcessingList:
            return [NSString stringWithFormat:@"MobileService/processingList/getProcessingList.do?params=%@",_des];
            break;
            /** 表单详情(待办事项) */
        case DistServiceActionTypeGetForm:
            return [NSString stringWithFormat:@"MobileService/form/getForm.do?params=%@",_des];
            break;
            /** 项目附件(材料) */
        case DistServiceActionTypeGetMaterial:
            return [NSString stringWithFormat:@"MobileService/processingList/getMaterial.do?params=%@",_des];
            break;
            /** 附件(材料)下载 */
        case DistServiceActionTypeGetDownloadMaterial:
            return [NSString stringWithFormat:@"MobileService/processingList/getDownload.do?params=%@",_des];
            break;
            /** 附件(材料)下载 */
        case DistServiceActionTypeGetAnDownload:
            return [NSString stringWithFormat:@"MobileService/processingList/getAnDownload.do?params=%@",_des];
            break;
            /** 项目关联 */
        case DistServiceActionTypeGetProjectRelation:
            return [NSString stringWithFormat:@"MobileService/userInfo/getProjectRelation.do?params=%@",_des];
            break;
            /** 流转日志 */
        case DistServiceActionTypeGetProjectOperateLog:
            return [NSString stringWithFormat:@"MobileService/form/getProjectOperateLog.do?params=%@",_des];
            break;
            /** 获取发送人员列表 */
        case DistServiceActionTypeGetActivities:
            return [NSString stringWithFormat:@"MobileService/userInfo/getActivities.do?params=%@",_des];
            break;
            /** 保存发送人员 */
        case DistServiceActionTypeGetSaveSelectUsers:
            return [NSString stringWithFormat:@"MobileService/userInfo/getSaveSelectUsers.do?params=%@",_des];
            break;
            /** 我的项目 */
        case DistServiceActionTypeGetProjectOfMyList:
            return [NSString stringWithFormat:@"MobileService/userInfo/getProjectOfMyList.do?params=%@",_des];
            break;
            /** 表单详情(我的项目) */
        case DistServiceActionTypeGetProcessedForm:
            return [NSString stringWithFormat:@"MobileService/userInfo/getProcessedForm.do?params=%@",_des];
            break;
            /** 取回列表 */
        case DistServiceActionTypeGetRecapyionList:
            return [NSString stringWithFormat:@"MobileService/processingList/getTokenList.do?params=%@",_des];
            break;
            /** 取回表单 */
        case DistServiceActionTypeGetBackForm:
            return [NSString stringWithFormat:@"MobileService/processingList/getBack.do?params=%@",_des];
            break;
            /** 人事系统(待办事项) */
        case DistServiceActionTypeGetUnProcessAssign:
            return [NSString stringWithFormat:@"MobileService/userInfo/getUnProcessAssign.do?params=%@",_des];
            break;
            /** 获取回退人员列表 */
        case DistServiceActionTypeGetStepList:
            return [NSString stringWithFormat:@"MobileService/userInfo/getStepList.do?params=%@",_des];
            break;
            /** 表单回退 */
        case DistServiceActionTypeGetRouteStep:
            return [NSString stringWithFormat:@"MobileService/userInfo/getRouteStep.do?params=%@",_des];
            break;
            /** 系统意见反馈列表 */
        case DistServiceActionTypeGetSysResponseList:
            return [NSString stringWithFormat:@"MobileService/noticeInfo/getSysResponseList.do?params=%@",_des];
            break;
            /** 提交意见反馈 */
        case DistServiceActionTypeSaveSysResponse:
            return [NSString stringWithFormat:@"MobileService/noticeInfo/saveSysResponse.do?params=%@",_des];
            break;
            /** 系统消息列表 */
        case DistServiceActionTypeGetReceivedList:
            return [NSString stringWithFormat:@"MobileService/noticeInfo/getReceivedList.do?params=%@",_des];
            break;
            /** 删除系统消息 */
        case DistServiceActionTypeMessageDelete:
            return [NSString stringWithFormat:@"MobileService/noticeInfo/delete.do?params=%@",_des];
            break;
            /** 删除系统意见反馈 */
        case DistServiceActionTypeDeleteSysResponse:
            return [NSString stringWithFormat:@"MobileService/noticeInfo/deleteSysResponse.do?params=%@",_des];
            break;
            /**< 财务台账 */
        case DistServiceActionTypeGetStand:
            return [NSString stringWithFormat:@"MobileService/stand/getStand.do?params=%@",_des];
            break;
            /**< 补充合同 */
        case DistServiceActionTypeGetAccount:
            return [NSString stringWithFormat:@"MobileService/stand/getAccount.do?params=%@",_des];
            break;
        default:
            break;
    }
}

- (NSDictionary *)requestArgument {
    
    return _arguments;
}


@end
