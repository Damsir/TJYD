//
//  NewsModel.h
//  TJYD
//
//  Created by 吴定如 on 17/4/19.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *count;
@property (nonatomic,strong) NSMutableArray *list;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface NewsListModel : NSObject

@property (nonatomic, copy) NSString *GSBT;/**< 新闻标题 */
@property (nonatomic, copy) NSString *FBBM;/**< 部门 */
@property (nonatomic, copy) NSString *FBRXM;/**< 发布人 */
@property (nonatomic, copy) NSString *GSNR;/**< 新闻详情 */
@property (nonatomic, copy) NSString *FBSJ;/**< 发布时间 */
@property (nonatomic, copy) NSString *PERSON;/**< 阅读次数 */
@property (nonatomic, copy) NSString *XWZY;
@property (nonatomic, copy) NSString *TZLX;
@property (nonatomic, copy) NSString *TZID;
@property (nonatomic, copy) NSString *LLL;
@property (nonatomic, copy) NSString *TSZT;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end