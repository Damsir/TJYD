//
//  UserInfo.m
//  zzzf
//
//  Created by zhangliang on 13-11-19.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize currentJobCode = _currentJobCode;
@synthesize directoryInfo = _directoryInfo;
@synthesize jobs = _jobs;
@synthesize password = _password;
@synthesize saveFiles = _saveFiles;
@synthesize userid = _userid;
@synthesize username = _username;
@synthesize org = _org;

- (void)save{
    
}

- (void)removeFromDisk{
    
}

//初始化保存路径
- (void)inititalizUser{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    _userPath = [NSString stringWithFormat:@"%@/users/%@",[paths objectAtIndex:0],_userid];
    
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //初始化用户目录
    _userWorkTempPath = [NSString stringWithFormat:@"%@/temp",_userPath];
    _userResourcePath = [NSString stringWithFormat:@"%@/resources",_userPath];
    
    _userWorkPath = [NSString stringWithFormat:@"%@/work",_userPath];
    _userLocalMapsPath = [_userPath stringByAppendingPathComponent:@"localMaps"];
    _userProjPakagePath=[_userPath stringByAppendingPathComponent:@"projectPakets"];
   
    NSString  *onemapPath = [_userPath stringByAppendingString:@"/map"];
    _mapFavoriteSavePath = [onemapPath stringByAppendingString:@"/favorite.archive"];
    
    BOOL isDir;
    if (![fm fileExistsAtPath:_userWorkTempPath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:_userWorkTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fm fileExistsAtPath:_userLocalMapsPath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:_userLocalMapsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fm fileExistsAtPath:_userProjPakagePath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:_userProjPakagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fm fileExistsAtPath:_userResourcePath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:_userResourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    

    if (![fm fileExistsAtPath:onemapPath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:onemapPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _mapFavorites = [NSMutableDictionary dictionaryWithContentsOfFile:_mapFavoriteSavePath];
    if (nil==_mapFavorites) {
        _mapFavorites = [NSMutableDictionary dictionaryWithCapacity:10];
    }
}

- (NSString *)userPath{
    return _userPath;
}

- (NSString *)userWorkTempPath{
    return _userWorkTempPath;
}

- (NSString *)userResourcePath{
    return _userResourcePath;
}

- (NSString *)userWorkPath{
    return _userWorkPath;
}

- (NSMutableDictionary *)mapFavorites{
    return _mapFavorites;
}

- (NSString *)userLocalMapsPath{
    return _userLocalMapsPath;
}
- (NSString *)userProjPakagePath{
    return _userProjPakagePath;
}
- (void)saveMapFavoriteToDisk{
    [_mapFavorites writeToFile:_mapFavoriteSavePath atomically:YES];
}


+(UserInfo *)userWithNameAndId:(NSString *)userName userId:(NSString *)userId{
    UserInfo *u = [[UserInfo alloc] init];
    u.username = userName;
    u.userid = userId;
    [u inititalizUser];
    return  u;
}

//- (NSString *)USER_DAILYJOB_STATUS_CHANGED{
//    return [NSString stringWithFormat:@"USER_DAILYJOB_NEW_%@",self.userid];
//}

@end
