//
//  PublicHeader.h
//  TJYD
//
//  Created by apple on 2017/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h

//debug开关
#define DistDebug 1

#define SCREEN_WIDTH1 ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT1 ([UIScreen mainScreen].bounds.size.height)

//Log输出
#if DistDebug
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif


/** 快速查询一段代码的执行时间 */
/** 用法
 TICK
 do your work here
 TOCK
 */

#define TICK NSDate *startTime = [NSDate date];
#define TOCK NSLog(@"======Time:======%f", -[startTime timeIntervalSinceNow]);




#endif /* PublicHeader_h */
