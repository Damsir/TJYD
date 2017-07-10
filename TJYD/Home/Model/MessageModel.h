//
//  MessageModel.h
//  TJYD
//
//  Created by 吴定如 on 17/5/24.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "PID": "1522",
 "RECEIVEUSERLOGINNAME": "",
 "RECEIVEUSERID": "",
 "MESSAGEID": "476",
 "PARENT": "",
 "EXTSTATE1": "",
 "STATE": "1",
 "SMSSTATE": "",
 "CHILDTYPE": "",
 "RXTSTATE": "",
 "WXSTATE": "",
 "ID": "477",
 "RECEIVEUSERNAME": "",
 "FILECODE": "",
 "CONTENT": "在【成果审定-分管院长签字环节】，【委托打印】最终结论总罚金为41234元",
 "SENDUSERID": "",
 "EXTSTATE2": "",
 "SENDUSER": "2",
 "SENDERUSERNAME1": "王新哲",
 "RECEIVEUSER": "405",
 "RECODEDATE": "2017-04-26",
 "SENDUSERNAME": "",
 "RECEIVEUSERNAME1": "王颖",
 "TITLE": "委托打印",
 "TYPE": "项目消息",
 "SENDUSERLOGINNAME": ""
 }
 */

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *TITLE;/**< 标题 */
@property (nonatomic, copy) NSString *CONTENT;/**< 原因 */
@property (nonatomic, copy) NSString *RECODEDATE;/**< 阅读日期 */
@property (nonatomic, copy) NSString *SENDERUSERNAME1;/**< 发送人 */
@property (nonatomic, copy) NSString *TYPE;/**< 消息类型 */
@property (nonatomic, copy) NSString *STATE;/**< 状态 */

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *FILECODE;
@property (nonatomic, copy) NSString *SENDUSERID;
@property (nonatomic, copy) NSString *PARENT;
@property (nonatomic, copy) NSString *RECEIVEUSERID;
@property (nonatomic, copy) NSString *RECEIVEUSERNAME;
@property (nonatomic, copy) NSString *RECEIVEUSER;
@property (nonatomic, copy) NSString *SENDUSERLOGINNAME;
@property (nonatomic, copy) NSString *RXTSTATE;
@property (nonatomic, copy) NSString *EXTSTATE2;
@property (nonatomic, copy) NSString *SENDUSER;
@property (nonatomic, copy) NSString *CHILDTYPE;
@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *MESSAGEID;
@property (nonatomic, copy) NSString *SMSSTATE;
@property (nonatomic, copy) NSString *RECEIVEUSERLOGINNAME;
@property (nonatomic, copy) NSString *EXTSTATE1;
@property (nonatomic, copy) NSString *RECEIVEUSERNAME1;
@property (nonatomic, copy) NSString *SENDUSERNAME;
@property (nonatomic, copy) NSString *WXSTATE;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
