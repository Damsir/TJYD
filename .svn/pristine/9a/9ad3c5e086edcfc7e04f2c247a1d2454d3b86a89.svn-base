//
//  FileVC.h
//  XAYD
//
//  Created by songdan Ye on 16/1/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewer.h"
#import "SysButton.h"
@interface FileVC : UIViewController
{
    FileViewer *_fileViewer;
    SysButton *_previousButton;
    SysButton *_nextButton;
    BOOL _beOpen;
}

@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,retain) NSString *fileExt;
@property (nonatomic,retain) NSString *isFromNetwork;
@property (nonatomic,retain) NSString *showSaveButton;
@property (nonatomic,retain) NSString *showDeleteButton;
@property (nonatomic,retain) NSString *maySavePath;
@property (nonatomic,strong) id<FileViewerDelegate> fileViewDelegate;

@property (nonatomic,retain) NSArray *files;
@property int fileIndex;


//Zeng Xu,2015-07-21
@property (weak,nonatomic) NSString *searchKey;
//@property (weak,nonatomic) FileViewer *fileViewer;
@property (nonatomic) BOOL isContent;

@end
