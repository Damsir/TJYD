//
//  ProjectMaterialModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/13.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMaterialModel : NSObject

@property (nonatomic, copy) NSString *name;/**< 文件名称 */
@property (nonatomic, copy) NSString *type;/**< 文件类型 */
@property (nonatomic, copy) NSString *materialSize;
@property (nonatomic, copy) NSString *uploadUser;
@property (nonatomic, copy) NSString *contained;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *required;
@property (nonatomic, copy) NSString *rootId;
@property (nonatomic, copy) NSString *requirenum;
@property (nonatomic, copy) NSString *realId;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *containnum;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *nodetype;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *isOriginalMaterial;
@property (nonatomic, copy) NSString *uploadDate;
@property (nonatomic, copy) NSString *isArchive;
@property (nonatomic, copy) NSString *isCopyMaterial;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic,strong) NSMutableArray *children;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface MaterialChildrenModel : NSObject

@property (nonatomic, copy) NSString *name;/**< 文件名称 */
@property (nonatomic, copy) NSString *type;/**< 文件类型 */
@property (nonatomic, copy) NSString *materialSize;
@property (nonatomic, copy) NSString *uploadUser;
@property (nonatomic, copy) NSString *contained;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *required;
@property (nonatomic, copy) NSString *rootId;
@property (nonatomic, copy) NSString *requirenum;
@property (nonatomic, copy) NSString *realId;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *containnum;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *nodetype;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *isOriginalMaterial;
@property (nonatomic, copy) NSString *uploadDate;
@property (nonatomic, copy) NSString *isArchive;
@property (nonatomic, copy) NSString *isCopyMaterial;
@property (nonatomic, copy) NSString *userId;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

