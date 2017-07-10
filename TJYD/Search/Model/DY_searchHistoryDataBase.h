//
//  DY_searchHistoryDataBase.h
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_searchHistoryDataBase : NSObject

+ (id) shareDataBase;

- (NSMutableArray *)readLocalArray;

- (void)writeLocalWithDataArray:(NSMutableArray *)dataArray;

- (void)deleteLocalDataArray;



@end
