//
//  UserInfo.h
//  zzzf
//
//  Created by zhangliang on 13-11-19.
//  Copyright (c) 2013年 dist. All rights reserved.
//  用户信息

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject{
    //存储位置
    NSString *_userPath;
    NSString *_userWorkTempPath;
    NSString *_userResourcePath;
    NSString *_userWorkPath;
    NSString *_userLocalMapsPath;
    NSString *_userProjPakagePath;
  
    NSString *_mapFavoriteSavePath;
    
    NSMutableDictionary *_mapFavorites;
}

//用户名
@property (nonatomic, retain) NSString *username;

//用户ID
@property (nonatomic, retain) NSString *userid;

@property (nonatomic,retain) NSString *org;

//密码（加密后的）
@property (nonatomic, retain) NSString *password;

//下载的文件
@property (nonatomic, retain) NSMutableDictionary *saveFiles;

//本地目录信息
@property (nonatomic, retain) NSMutableDictionary *directoryInfo;

//办理的作业
@property (nonatomic, retain) NSMutableDictionary *jobs;

//当前作业代码
@property (nonatomic, retain) NSString *currentJobCode;


- (void) save;
- (void) removeFromDisk;
- (void) inititalizUser;
- (NSString *)userPath;
- (NSString *)userWorkTempPath;
- (NSString *)userResourcePath;
- (NSString *)userWorkPath;
- (NSString *)userLocalMapsPath;
- (NSString *)userProjPakagePath;

- (void)saveMapFavoriteToDisk;


- (NSMutableDictionary *)mapFavorites;

+(UserInfo *) userWithNameAndId:(NSString *)userName userId:(NSString *)userId;

//- (NSString *)USER_DAILYJOB_STATUS_CHANGED;

@end
