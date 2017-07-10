//
//  ProjectInfoModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/12.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "sessionState": "sessionExist",
    "state": "true",
    "result": [
               {
                   "list": [
                            {
                                "value": "bz_xmxx不在数据引擎中",
                                "label": "项目流水号"
                            },
                            {
                                "value": "bz_xmxx不在数据引擎中",
                                "label": "项目地点（省）"
                            }
                            ],
                   "formName": "项目基本信息"
               },
               {
                   "formName": "承接团队",
                   "list": [
                            {
                                "value": "bz_xmxx不在数据引擎中",
                                "label": "设计部门"
                            }
                            ]
               },
               {
                   "formName": "设计校审",
                   "list": [
                            {
                                "value": "bz_sjjs不在数据引擎中",
                                "label": "成果名称"
                            }
                            ]
               }
               ]
}
*/

@interface ProjectInfoModel : NSObject

@property (nonatomic, copy) NSString *name;/**< 表单名称 */
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, strong) NSMutableArray *list;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end


@interface ProjectListModel : NSObject

@property (nonatomic, copy) NSString *label;/**< 控件标题 */
@property (nonatomic, copy) NSString *value;/**< 控件的值 */
@property (nonatomic, copy) NSString *style;/**< 控件样式 */
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, copy) NSString *selectField;
@property (nonatomic, copy) NSString *bindField;
@property (nonatomic, copy) NSString *selectValue;
@property (nonatomic, copy) NSString *controlField;
@property (nonatomic, copy) NSString *controlValue;
@property (nonatomic, copy) NSString *controlTable;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

