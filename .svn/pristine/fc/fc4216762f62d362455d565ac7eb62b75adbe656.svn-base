//
//  FileTableViewContainerV.h
//  XAYD
//
//  Created by songdan Ye on 16/1/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceProvider.h"
#import "FileItemThumbnailView.h"
#import "SysButton.h"
#import "Global.h"
#import "DigitialMFileCell.h"
#import "FolderSelectorViewController.h"
@class FileModel;
@class ResourceManagerView;
@interface FileTableViewContainerV : UIView<ServiceCallbackDelegate,UITableViewDataSource,UITableViewDelegate,FolderMoveDelegate>{
    NSString *_path;
    NSString *_searchKey;
    UIScrollView *_thumibnailsContainer;
    NSFileManager *_fManager;
    NSMutableArray *_selectedArray;
    UIButton *_openGroupFileBtn;
}
@property (nonatomic,strong)UITableView *tableView;
@property ResourceManagerView *owner;
- (void) load:(NSString *)path andKey:(NSString *)key;
- (void) showThumbnails;
- (void) showDetails;
- (void) refersh;
- (void) editTableView;
- (void) deleteResource;
- (void) addFolder:(NSString *)folerName;
//处理删除
- (void)handleDelete:(id)sender;
//- (void)selectSomeFiles:(NSNotification *)noti;

@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) FileModel *mm;

@property (strong,nonatomic) NSMutableDictionary *deleteDic;
@property (strong,nonatomic) NSMutableDictionary *deleteDic1;



@property (nonatomic,retain) id<FileItemThumbnailDelegate> resourceDelegate;
@property int viewType;
@property BOOL isFromLocal;


@end
