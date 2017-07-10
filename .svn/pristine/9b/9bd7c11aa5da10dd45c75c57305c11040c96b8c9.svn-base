//
//  FileViewController.m
//  zzzf
//  
//  Created by zhangliang on 13-11-22.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import "FileViewer.h"
#import "Global.h"
#import "AFNetworking.h"
//#import "SysWebViewController.h"
#import "TPF_ImageViewLoadLocalImage.h"
#import "TPF_ImageCache.h"
#import "TPF_loadLocalImage.h"
#import "JSDownloadView.h"

//by zx
#import "UIWebView+Highlight.h"

static id<FileViewerDelegate> _globalDelegate;
static NSMutableDictionary *CACHE_FILES;

@implementation FileViewer
UIAlertView *baseAlert;

@synthesize path=_path,fileName=_fileName,ext=_ext,fileSize = _fileSize,delegate=_delegate;

- (void)initData{
    
    if (nil==CACHE_FILES) {
        CACHE_FILES = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    if (nil==_galleryPhotoView) {
        [self lblFileNameTextSet:self.fileName];
        _galleryPhotoView = [[FGalleryPhotoView alloc] initWithFrame:CGRectZero];
        _galleryPhotoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _galleryPhotoView.autoresizesSubviews = YES;
        [self.photoScrollView addSubview:_galleryPhotoView];
    }
    
    _sizeRate = @"";
    // downloadAnimationView
    if (!self.downloadView) {
        JSDownloadView *downloadView = [[JSDownloadView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-50, CGRectGetHeight(self.frame)/2-50, 100, 100)];
        downloadView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
        downloadView.delegate = self;
        downloadView.progressWidth = 4;
        self.downloadView = downloadView;
        [self addSubview:downloadView];
        [self bringSubviewToFront:self.downloadView];
    }
    
}

//- (void)previousFile{
//    [self openTIFFromLocal:currentImage-1];
//}
//
//- (void)nextFile{
//    [self openTIFFromLocal:currentImage+1];
//}

- (void)initTifButton{
    //打开tif文件的翻页按钮
    if (!_tifnextButton) {
        _tifpreviousButton = [SysButton buttonWithType:UIButtonTypeCustom];
        _tifpreviousButton.frame = CGRectMake(-30, 350, 60, 60);
        _tifpreviousButton.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        _tifpreviousButton.defaultBackground = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        _tifpreviousButton.layer.cornerRadius = 30;
        [_tifpreviousButton setTitle:@"     <" forState:UIControlStateNormal];
        [_tifpreviousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tifpreviousButton addTarget:self action:@selector(previousFile) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tifpreviousButton];
    }
    
    if (!_tifnextButton) {
        _tifnextButton = [SysButton buttonWithType:UIButtonTypeCustom];
        _tifnextButton.frame = CGRectMake(994, 350, 60, 60);
        _tifnextButton.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        _tifnextButton.defaultBackground = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
        _tifnextButton.layer.cornerRadius = 30;
        [_tifnextButton setTitle:@">     " forState:UIControlStateNormal];
        [_tifnextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tifnextButton addTarget:self action:@selector(nextFile) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tifnextButton];
    }
    if (!pageIndicatorLabel) {
        pageIndicatorLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
        [self addSubview:pageIndicatorLabel];
    }
}

+(FileViewer *) createView{
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"FileViewer" owner:nil options:nil];
    FileViewer *theView= [nibView objectAtIndex:0];
    
    return theView;
}


+ (void)clearCache {
    [CACHE_FILES removeAllObjects];
}

- (void)setPagerMode:(int)fileCount currentCount:(int)curCount{
    if (fileCount>0) {
        _pageIndex = 0;
    }
    self.pagerView.delegate=self;
    self.pagerView.contentSize = CGSizeMake(fileCount*SCREEN_WIDTH, SCREEN_HEIGHT);
    self.pagerView.contentOffset = CGPointMake(SCREEN_WIDTH*[self getCurrentCount], 0);
    //不注释报错
    //self.fileWebView.frame = CGRectMake(curCount*1024, 0, 1024, 732);
    self.photoScrollView.frame = CGRectMake(curCount*SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
}

// 打开本地文件
- (void)openFileFromLocation:(NSString *)fileName filePath:(NSString *)filePath ext:(NSString *)ext{
    //
    self.downloadView.hidden = YES;
    
    [self initData];
    self.path = filePath;
    self.fileName = fileName;
    self.ext = ext;
    [self openFile:filePath];
    [self lblFileNameTextSet:fileName];
}
#pragma -mark ----打开文件
- (void)openFiles:(NSArray *)files at:(int)index
{
    
    _index=index;
    
    NSDictionary *itemDic=[files objectAtIndex:index];
    
    self.fileName=[itemDic objectForKey:@"name"];
    NSString *filePath=[itemDic objectForKey:@"path"];
    NSString *ext=[itemDic objectForKey:@"ext"];
    if (ext==nil||[ext isEqualToString:@""]) {
        ext=@"jpg";
    }
    [self setPagerMode:(int)files.count currentCount:index];
    _isNetwork=[itemDic objectForKey:@"uploaded"];
    
    BOOL isLocal = [[itemDic objectForKey:@"local"] isEqualToString:@"yes"];
    if (isLocal) {
        [self openFileFromLocation:self.fileName filePath:filePath ext:ext];
    }
    else if ([_isNetwork isEqualToString:@"YES"]||[_isNetwork isEqualToString:@"yes"]) {
        [self openFileFromNetwork:self.fileName url:filePath ext:ext searchKey:_searchKey];
    }else{
        [self openFileFromLocation:self.fileName filePath:filePath ext:ext];
    }
}
#pragma -mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"---%f-page:--%d",scrollView.contentOffset.x,(int)scrollView.contentOffset.x/1024);
    
    NSInteger index=0;
    CGFloat offsetX=scrollView.contentOffset.x;
    NSInteger intOffsetX=offsetX;
    int w=SCREEN_WIDTH;
    if (intOffsetX% w>(w*0.5)) {
        index=intOffsetX/SCREEN_WIDTH+1;
    }else{
        index=intOffsetX/SCREEN_WIDTH;
    }
    
    //    [self openTIFFromLocal:index];
    
    self.photoScrollView.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    turnRight=scrollView.contentOffset.x;
}

- (void)previousFile{
    
}
- (void)nextFile{
    
}
/*
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
 // NSLog(@"----decelerate:-%f-dddddddd---",scrollView.contentOffset.x);
 if (scrollView.contentOffset.x>scrollView.contentSize.width-1024) {
 self.pagerView.contentOffset = CGPointMake(1024*(_files.count-1), 0);
 }
 else if (scrollView.contentOffset.x<0)
 {
 self.pagerView.contentOffset = CGPointMake(0, 0);
 }
 int cur=(int)scrollView.contentOffset.x/1024;
 
 if (scrollView.contentOffset.x>turnRight) {
 cur=cur+1;
 if (cur>=_files.count) {
 cur=_files.count-1;
 }
 }
 _index=cur;
 NSDictionary *dic=[_files objectAtIndex:cur];
 
 if ([[dic objectForKey:@"local"]isEqualToString:@"yes"]) {
 NSString *fileName=[dic objectForKey:@"name"];
 NSString *filePath=[dic objectForKey:@"path"];
 NSString *fileExt=[dic objectForKey:@"ext"];
 if (fileExt==nil||[fileExt isEqualToString:@""]) {
 fileExt=@"jpg";
 }
 [self openFileFromLocation:fileName filePath:filePath ext:fileExt];
 }
 else if ([[dic objectForKey:@"uploaded"]isEqualToString:@"YES"]||[[dic objectForKey:@"uploaded"]isEqualToString:@"yes"]) {
 NSString *fileName=[dic objectForKey:@"name"];
 NSString *filePath=[dic objectForKey:@"path"];
 NSString *fileExt=[dic objectForKey:@"ext"];
 if (fileExt==nil||[fileExt isEqualToString:@""]) {
 fileExt=@"jpg";
 }
 [self openFileFromNetwork:fileName url:filePath ext:fileExt searchKey:self.searchKey];
 
 }
 else if ([[dic objectForKey:@"uploaded"]isEqualToString:@"NO"]||[[dic objectForKey:@"uploaded"]isEqualToString:@"no"]){
 NSString *fileName=[dic objectForKey:@"name"];
 NSString *filePath=[dic objectForKey:@"path"];
 NSString *fileExt=[dic objectForKey:@"ext"];
 if (fileExt==nil||[fileExt isEqualToString:@""]) {
 fileExt=@"jpg";
 }
 [self openFileFromLocation:fileName filePath:filePath ext:fileExt];
 }
 
 [self openTIFFromLocal:currentImage];
 
 self.fileWebView.frame = CGRectMake(cur*1024, 0, 1024, 732);
 self.photoScrollView.frame = CGRectMake(cur*1024, 0, 1024,732);
 
 NSString *text=[NSString stringWithFormat:@"%@    (%d/%d)",self.fileName,cur+1,_files.count];
 self.lblFIleName.text =text;//self.fileName;
 
 }
 */


- (int)getCurrentCount
{
    return _index;
}

#pragma mark -- 下载网络请求文件
- (void)openFileFromNetwork:(NSString *)fileName url:(NSString *)url ext:(NSString *)ext searchKey:(NSString *)sk{
    
    //
    self.downloadView.hidden = NO;
    
    self.searchKey = sk;
    
    [self initData];
    [self lblFileNameTextSet:fileName];
    self.path = url;
    self.ext = ext;
    self.fileName = fileName;
    _toSaveName = [fileName stringByDeletingPathExtension];
    // 原为yes
    self.pagerView.hidden = NO;
    //    self.btnRefersh.enabled = NO;
    NSString *cachePath = [CACHE_FILES objectForKey:url];
    if (nil != cachePath) {
        [self openFile:cachePath];
    }else{
        _currentDownload = [[FileDownload alloc] init];
        _currentDownload.delegate = self;
        //_currentDownload = downTask;
        NSString *fileId = [Global newUuid];
        NSString *savePath = [_currentDownload download:[self.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] fileId:fileId fileExt:self.ext];
        //原则上这个savePath永远是nil，但这个逻辑是有效的
        if (nil!=savePath) {
            [self openFile:savePath];
        }
    }
}
- (void)openFilesFromNetwork:(NSArray *)files{
    [self setPagerMode:(int)_files.count currentCount:[self getCurrentCount]];
    
}

- (void)setDownloadButtonVisible:(BOOL)visible{
    self.btnDownload.hidden = !visible;
    
    
}

- (void)setDeleteButtonVisible:(BOOL)visible{
    self.btnDelete.hidden = !visible;
}

- (IBAction)onBtnCloseTap:(id)sender {
    if (nil!=_currentDownload) {
        [_currentDownload cancel];
        _currentDownload = nil;
    }
    [self.delegate fileViewerDidClosed:self];
    [self clear];
    
    /*
     UIButton *btn=[[UIButton alloc] init];
     btn.tag=4;
     
     SysWebViewController *sysVC = (SysWebViewController *)[Global getGlobaltSysVC];
     [sysVC onMenuClick:btn];
     */
    //    SysWebViewController *sysVC=(SysWebViewController *)_delegate;
    //    UIButton *btn=[[UIButton alloc] init];
    //    btn.tag=4;
    //    [sysVC onMenuClick:btn];
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // appDelegate.globalSysVC
}

- (void)clear{
    
    NSURL * url = [NSURL fileURLWithPath:@"about:blank"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.fileWebView loadRequest: request];
    [_galleryPhotoView setZoomScale:1 animated:NO];
    _galleryPhotoView.imageView.image = nil;
    _galleryPhotoView.frame = CGRectMake(0, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height );
    
    _tifnextButton.hidden=_tifpreviousButton.hidden=pageIndicatorLabel.hidden=YES;
    
    _labelForDWG.hidden=YES;
}

- (IBAction)onBtnRefershTap:(id)sender {
    [self openFile:_currentOpenFilePath];
}

- (IBAction)onBtnDownload:(id)sender {
    _toSavePath = [self.delegate fileViewerShouldToSave:self name:[NSString stringWithFormat:@"%@.%@",_toSaveName,self.ext] path:_path];
    
    if (nil==_toSavePath) {
        UIAlertView *messageBox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法保存，找不到存储路径" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [messageBox show];
        return;
    }
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_toSavePath]) {
        UIAlertView *messageBox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存在该文件 " delegate:self cancelButtonTitle:@"不下载" otherButtonTitles: @"覆盖",@"重命名",nil];
        messageBox.tag = 10;
        [messageBox show];
        return;
    }else{
        [self saveToPath];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.pagerView.frame.size.width;
    _pageIndex = floor((self.pagerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}


- (void)saveToPath {
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSLog(@"%@,%@",_currentOpenFilePath,_toSavePath);
    [fileManager copyItemAtPath:_currentOpenFilePath toPath:_toSavePath error:&error];
    if (nil==error) {
        //[self.delegate FileViewerDidSaved:self name:_fileName path:_toSavePath];
        UIAlertView *successMessage = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已保存到本地" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [successMessage show];
        self.btnDownload.hidden = YES;
    }else{
        UIAlertView *errorMessageBox = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"保存到本地失败:%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [errorMessageBox show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if (buttonIndex==1) {
            [[NSFileManager defaultManager] removeItemAtPath:_toSavePath error:nil];
            [self saveToPath];
        }
        else if(buttonIndex==2){
            [self showRenameBox];
        }
    }else if(alertView.tag==1 && buttonIndex==1){
        [self deleteFile];
    }else if(alertView.tag==20 && buttonIndex==1){
        NSString *newName = [alertView textFieldAtIndex:0].text;
        if ([@"" isEqualToString:newName]) {
            [self showRenameBox];
        }else{
            _toSaveName = newName;
            [self onBtnDownload:self.btnDownload];
        }
    }
}

- (void)showRenameBox{
    UIAlertView *comfirm = [[UIAlertView alloc] initWithTitle:@"重命名" message:@"请输入新的名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    comfirm.alertViewStyle = UIAlertViewStylePlainTextInput;
    [comfirm textFieldAtIndex:0].text = [self.fileName stringByDeletingPathExtension];
    [comfirm textFieldAtIndex:0].placeholder = [self.fileName stringByDeletingPathExtension];
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
    [comfirm setTransform:myTransform];
    comfirm.tag = 20;
    [comfirm show];
}

- (void)deleteFile{
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:_currentOpenFilePath error:&error];
    if (nil==error) {
        [self.delegate fileViewerDidDeleted:self name:_fileName path:_currentOpenFilePath]; UIAlertView *successMessage = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据已移除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [successMessage show];
    }else{
        UIAlertView *errorMessageBox = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"移除数据失败:%@",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [errorMessageBox show];
    }
    
}

- (IBAction)onBtnDelete:(id)sender {
    
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认要删除该文件吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertview.tag=1;
    [alertview show];
    alertview = nil;
}

#pragma mark -- 下载完成
- (void)download:(FileDownload *)dowanlod onFileDownloaded:(NSString *)fileId filePath:(NSString *)filePath {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        self.downProgressView.hidden = YES;
        self.downProgressLabel.hidden = YES;
        // 此时已在主线程(下载成功)
        self.downloadView.isSuccess = YES;
        self.downloadView.progress  = 1.0;
        
        [self performSelector:@selector(delayOpenLocalFile:) withObject:filePath afterDelay:2.0];
        
        
        //根据网络URL缓存数据，以免再次下载
        [CACHE_FILES setValue:filePath forKey:self.path];
        //        [self openFile:filePath];
        _currentDownload = nil;
    });
    
}

- (void)delayOpenLocalFile:(NSString *)filePath{
    
    [self openFile:filePath];
}

#pragma mark -- 开始下载
- (void)download:(FileDownload *)dowanlod onFileStartDownload:(NSString *)fileId{
    NSLog(@"start download");
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [self.downProgressLabel setFont:[UIFont systemFontOfSize:18]];
        self.downProgressView.hidden = YES;
        self.downProgressLabel.hidden = YES;
        self.downProgressLabel.text = @"0%";
        // 重置初始状态
        self.downloadView.hidden = NO;
        [self.downloadView setUpOriginDownloadViewState];
        
    });
    
}
#pragma mark -- 下载失败
- (void)download:(FileDownload *)dowanlod onFileDownloadFaild:(NSString *)fileId{
    NSLog(@"download faild");
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [self.downProgressLabel setFont:[UIFont systemFontOfSize:18]];
        self.downProgressLabel.text = @"打开失败";
        self.downProgressView.hidden = YES;
        self.pagerView.hidden = YES;
        
        // 重置初始状态
        self.downloadView.hidden = YES;
        [self.downloadView setUpOriginDownloadViewState];
    });
    
}

#pragma mark -- 下载中
- (void)download:(FileDownload *)dowanlod updateProgress:(NSString *)fileId progress:(float)progressValue sizeRate:(NSString *)sizeRate{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        self.downProgressView.progress = progressValue;
        int downlaodRate = (int)(progressValue*100);
        self.downProgressLabel.text = [NSString stringWithFormat:@"%d%%    %@",downlaodRate,sizeRate];
        //
        self.downloadView.progress = progressValue;
        self.downloadView.downloadRate = sizeRate;
    });
    
}

#pragma mark -- 打开本地文件
- (void)openFile:(NSString *)localFilePath{
    //
    self.downloadView.hidden = YES;
    
    
    [self initTifButton];
    _tifpreviousButton.hidden=_tifnextButton.hidden= pageIndicatorLabel.hidden=YES;
    
    _currentOpenFilePath = localFilePath;
    //    self.btnRefersh.enabled = YES;
    self.pagerView.hidden = NO;
    NSString *fileExt = [localFilePath pathExtension];
    if ([fileExt isEqualToString:@"jpg"]|| [fileExt isEqualToString:@"png"]|| [fileExt isEqualToString:@"PNG"] || [fileExt isEqualToString:@"bmp"]||[fileExt isEqualToString:@"JPG"]||[fileExt isEqualToString:@"jpeg"]) {
        self.photoScrollView.hidden=NO;
        NSLog(@"%@",self.photoScrollView);
        self.fileWebView.hidden=YES;
        [self openImageFromLocal:localFilePath];
        //_galleryPhoto = [[FGalleryPhoto alloc] initWithThumbnailPath:nil fullsizePath:localFilePath delegate:self];
        //[_galleryPhoto loadFullsize];
        
        
    }
    //    else if([fileExt isEqualToString:@"tif"]){
    //    ///////
    ////        splitter = [[NSTiffSplitter alloc] initWithPathToImage:localFilePath];
    ////        //设置可以滚动看图片
    ////        //[self setPagerMode:splitter.countOfImages currentCount:0];
    ////        if (splitter.countOfImages>1) {
    ////            _tifpreviousButton.hidden=_tifnextButton.hidden=pageIndicatorLabel.hidden=NO;
    ////
    ////            /////
    ////        }
    //        currentImage=0;
    //        /////
    ////        pageIndicatorLabel.text = [NSString stringWithFormat:@"%d / %d", currentImage + 1, splitter.countOfImages];
    //        /////
    //        self.photoScrollView.hidden=NO;
    //        self.fileWebView.hidden=YES;
    ////        [self openTIFFromLocal:currentImage];
    //    }
    else if([fileExt isEqualToString:@"dwg"] || [fileExt isEqualToString:@"tif"] || [fileExt isEqualToString:@"zip"] || [fileExt isEqualToString:@"rar"])
    {
        //******zengxu 20150714
        documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:localFilePath]];
        
        //        documentController.delegate = self;
        //        documentController.UTI = @"com.autodesk.autocad.dwg";
        //        documentController.UTI = @"public.tiff";
        
        [documentController presentOpenInMenuFromRect:CGRectMake(455, 440, 100, 100) inView:self animated:YES];
        
        self.labelForDWG.text = @"若要打开文件，请单击“刷新”按钮。";
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"刷新" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(opendwg) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:RGB(34, 152, 239) forState:UIControlStateNormal];
        btn.frame = CGRectMake((SCREEN_WIDTH-50)/2.0, 100, 50, 44);
        [self addSubview:btn];
        
        
        self.labelForDWG.hidden = NO;
    }
    else{
        self.photoScrollView.hidden=YES;
        self.fileWebView.hidden = NO;
        NSURL * url = [NSURL fileURLWithPath:localFilePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.fileWebView loadRequest: request];
    }
}

- (void)opendwg
{
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_currentOpenFilePath]];
    
    [documentController presentOpenInMenuFromRect:CGRectMake(455, 440, 100, 100) inView:self animated:YES];
    
}

- (void)galleryPhoto:(FGalleryPhoto*)photo didLoadThumbnail:(UIImage*)image{
    
}
- (void)galleryPhoto:(FGalleryPhoto*)photo didLoadFullsize:(UIImage*)image{
    //NSLog(@"didLoadFullsize");
    
}

#pragma mark -- 打开本地图片
- (void)openImageFromLocal:(NSString *)path{
    
    [_galleryPhotoView setZoomScale:1 animated:NO];
    _galleryPhotoView.frame = CGRectMake(0, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height);
    
    [[TPF_LoadLocalImage sharedImageCache] loadLocalImageWithUrl:path callback:^(UIImage *image, NSString *url, BOOL finished){
        
        _galleryPhotoView.imageView.image = image;
        [_galleryPhotoView.imageView setNeedsLayout];
        
    }];
    
    //    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    //    _galleryPhotoView.imageView.image = img;
    //    _galleryPhotoView.frame = CGRectMake(0, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height );
    //    _galleryPhotoView.frame = CGRectMake(0, -100, SCREEN_WIDTH, self.photoScrollView.frame.size.height );
    //    _galleryPhotoView.frame = CGRectMake(0, -50, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height);
    //    img = nil;
}

//- (void)openTIFFromLocal:(NSInteger )current{
//    //splitter = [[NSTiffSplitter alloc] initWithPathToImage:path];
//    if (splitter != nil)
//    {
//        if (current>splitter.countOfImages-1) {
//            current=splitter.countOfImages-1;
//            return;
//        }
//
//        if (current<0) {
//            current=0;
//            return;
//        }
//
//        currentImage = current;
//
//        pageIndicatorLabel.text = [NSString stringWithFormat:@"%d / %d", currentImage + 1, splitter.countOfImages];
//
//        [_galleryPhotoView setZoomScale:1 animated:NO];
//        UIImage *img = [[UIImage alloc] initWithData:[splitter dataForImage:currentImage]];
//        _galleryPhotoView.imageView.image = img;
//        _galleryPhotoView.frame = CGRectMake(0, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height );
//        img = nil;
//    }
//
//}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.fileWaiting.hidden = YES;
    self.fileWebView.hidden = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.fileWaiting.hidden = NO;
    self.fileWebView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.fileWaiting.hidden = YES;
    self.fileWebView.hidden = NO;
    //NSLog(@"加载webview");
    
    //Zeng Xu,2015-07-21
    
    //NSLog(@"isContent = %i",self.isContent);
    
    if(self.isContent && (!(self.searchKey == nil || [self.searchKey isEqualToString:@""])))
    {
        //NSInteger found = [self.fileWebView highlightAllOccurencesOfString:self.searchKey];
        NSLog(@"高亮标记");
    }
}
- (void)lblFileNameTextSet:(NSString *)fileName {
    
    NSString *text=@"";
    if (_files!=nil) {
        text=[NSString stringWithFormat:@"%@    (%d/%lu)",fileName,[self getCurrentCount]+1,(unsigned long)_files.count];
    }
    else{
        text=fileName;
        self.lblFIleName.text =text;//self.fileName;
    }
}


- (void)openFileFromLocation:(NSString *)filePath{
    //
    self.downloadView.hidden = YES;
    
    [self initData];
    self.path = filePath;
    [self openFile:filePath];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int offsetX = turnRight-scrollView.contentOffset.x;
    if(abs(offsetX)<80)
        return;
    
    if (scrollView.contentOffset.x>scrollView.contentSize.width-SCREEN_WIDTH) {
        self.pagerView.contentOffset = CGPointMake(SCREEN_WIDTH*(_files.count-1), 0);
    }
    else if (scrollView.contentOffset.x<0)
    {
        self.pagerView.contentOffset = CGPointMake(0, 0);
    }
    int cur=(int)scrollView.contentOffset.x/SCREEN_WIDTH;
    
    if (scrollView.contentOffset.x>turnRight) {
        cur=cur+1;
        if (cur>=_files.count) {
            cur=(int)_files.count-1;
        }
    }
    
    _index=cur;
    
    NSDictionary *dic=[_files objectAtIndex:cur];
    
    if ([[dic objectForKey:@"local"]isEqualToString:@"yes"]) {
        NSString *filePath=[dic objectForKey:@"path"];
        [self openFileFromLocation:filePath];
    }
    else{
        NSString *fileId=[dic objectForKey:@"fileId"];
        NSString *filePath=[dic objectForKey:@"path"];
        NSString *fileExt=[dic objectForKey:@"ext"];
        if (fileExt==nil||[fileExt isEqualToString:@""]) {
            fileExt=@"jpg";
        }
        [self openFileFromNetwork:fileId url:filePath ext:fileExt fileSize:nil];
    }
    
    self.fileWebView.frame = CGRectMake(cur*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.photoScrollView.frame = CGRectMake(cur*SCREEN_WIDTH, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
}

#pragma mark -- 附件下载
- (void)openFileFromNetwork:(NSString *)fileName url:(NSString *)url ext:(NSString *)ext fileSize:(NSString *)fileSize {
    
    [self initData];
    [self lblFileNameTextSet:fileName];
    self.path = url;
    self.ext = ext;
    self.fileName = fileName;
    self.fileSize = fileSize;
    // (self.fileSize = 14346 KB)
    NSArray *sizeArray = [fileSize componentsSeparatedByString:@" "];
    self.fileSize = [sizeArray firstObject];
    
    //    self.pagerView.hidden = YES;
    
    // 重置初始状态
    self.downloadView.hidden = NO;
    [self.downloadView setUpOriginDownloadViewState];
    
    //
    NSMutableString *saveName = [NSMutableString stringWithFormat:@"%@",fileName];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *savePath = [path stringByAppendingPathComponent:saveName];
    NSLog(@"savePath:%@",savePath);
    
    
    // 读取下载文件夹目录(是否存在已经下载的文件)
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        
        if (childrenFiles.count) {
            for (int i=0; i<childrenFiles.count; i++) {
                NSString *fileName = childrenFiles[i];
                // 拼接路径
                NSString *filePath = [path stringByAppendingPathComponent:fileName];
                if ([savePath isEqualToString:filePath]) {
                    [self openFile:savePath];
                } else if (i == childrenFiles.count-1 && ![savePath isEqualToString:filePath]) {
                    // 新建下载
                    _currentDownloadPath = savePath;
                    [self downloadFile:url fileName:fileName ext:ext];
                }
            }
        } else {
            // 新建下载
            _currentDownloadPath = savePath;
            [self downloadFile:url fileName:fileName ext:ext];
        }
    }
    
    //    // 本次下载保存路径
    //    NSString *savePath = [self downloadFile:url fileName:fileName ext:ext];
    //    if (savePath != nil) {
    //        [self openFile:savePath];
    //    }
}

#pragma mark -- 新建下载附件
- (NSString *)downloadFile:(NSString *)url fileName:(NSString *)fileName ext:(NSString *)ext {
    
    [self.downProgressLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.downProgressView.hidden = YES;
    self.downProgressLabel.hidden = YES;
    self.downProgressLabel.text = @"0%";
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithURL:URL];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:_currentDownloadPath append:YES];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //operation.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"application/msword", nil];
    
    //下载进度控制
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        // self.fileSize(单位:KB) => 转为字节
        totalBytesExpectedToRead = [self.fileSize floatValue]*1024;
        _downloadRate = (float)totalBytesRead/totalBytesExpectedToRead;
        
        //
        CGFloat currentlySize = totalBytesRead/1024.0/1024.0;
        CGFloat totallySize = totalBytesExpectedToRead/1024.0/1024.0;
        _sizeRate = totallySize > 1 ? [NSString stringWithFormat:@"%.02f M/%.02f M", currentlySize,totallySize] : [NSString stringWithFormat:@"%.02f K/%.02f K", currentlySize * 1024.0,totallySize * 1024.0];
    }];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        ////////原注
        
        [self downloadCompleted:_currentDownloadPath];
        ///////
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    _downloadReateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateDownloadProcesss) userInfo:nil repeats:YES];
    [operation start];
    
    return nil;
}


//- (NSString *)downloadFile:(NSString *)url fileName:(NSString *)fileName ext:(NSString *)ext {
//
////    NSMutableString *saveName = [NSMutableString stringWithFormat:@"%@.%@",fileId,ext];
//    NSMutableString *saveName = [NSMutableString stringWithFormat:@"%@",fileName];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSString *savePath = [path stringByAppendingPathComponent:saveName];
//    NSLog(@"savePath:%@",savePath);
////    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //////////////////*原注
////        if([fileManager fileExistsAtPath:savePath]==YES){
////            return savePath;
////        }
//    ////////////////*
//
//    [self.downProgressLabel setFont:[UIFont systemFontOfSize:15.0]];
//    self.downProgressView.hidden = YES;
//    self.downProgressLabel.hidden = YES;
//    self.downProgressLabel.text = @"0%";
//    //url=@"http://172.16.128.12/fdgh/FileService/fileupload/LawRule/城市规划编办制法.doc";
//    NSURL *URL = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.inputStream   = [NSInputStream inputStreamWithURL:URL];
//    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:savePath append:YES];
//
//
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    //operation.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects:@"application/msword", nil];
//
//    _currentDownloadPath = savePath;
//
//    //下载进度控制
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//
//        // self.fileSize(单位:KB) => 转为字节
//        totalBytesExpectedToRead = [self.fileSize floatValue]*1024;
//        _downloadRate = (float)totalBytesRead/totalBytesExpectedToRead;
//
//        //
//        CGFloat currentlySize = totalBytesRead/1024.0/1024.0;
//        CGFloat totallySize = totalBytesExpectedToRead/1024.0/1024.0;
//        _sizeRate = totallySize > 1 ? [NSString stringWithFormat:@"%.02f M/%.02f M", currentlySize,totallySize] : [NSString stringWithFormat:@"%.02f K/%.02f K", currentlySize * 1024.0,totallySize * 1024.0];
//    }];
//
//    //已完成下载
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//        ////////原注
//
//        [self downloadCompleted:savePath];
//        ///////
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    _downloadReateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateDownloadProcesss) userInfo:nil repeats:YES];
//    [operation start];
//
//    return nil;
//}


- (NSString *)newUuid{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    return cfuuidString;
}

- (void)downloadCompleted:(NSString *)path{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //
        self.downloadView.isSuccess = YES;
        self.downloadView.progress  = 1.0;
        
        // 更UI
        self.downProgressView.hidden = YES;
        self.downProgressLabel.hidden = YES;
        
        [self performSelector:@selector(delayOpenLocalFile:) withObject:path afterDelay:2.0];
        //[self openFile:path];
        _currentDownload = nil;
        [_downloadReateTimer invalidate];
        _downloadReateTimer = nil;
    });
    
}

- (void)downloadFailure{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 重置初始状态
        self.downloadView.hidden = YES;
        [self.downloadView setUpOriginDownloadViewState];
        
        // 更UI
        [self.downProgressLabel setFont:[UIFont systemFontOfSize:18]];
        self.downProgressLabel.text = @"打开失败";
        self.downProgressView.hidden = YES;
        self.pagerView.hidden = YES;
        [_downloadReateTimer invalidate];
        _downloadReateTimer = nil;
    });
    
}

#pragma mark -- 下载中更新UI
- (void)updateDownloadProcesss{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        self.downProgressView.progress = _downloadRate;
        int downlaodRate = (int)(_downloadRate*100);
        self.downProgressLabel.text = [NSString stringWithFormat:@"%d%%",downlaodRate];
        //
        self.downloadView.progress = _downloadRate;
        self.downloadView.downloadRate = _sizeRate;
        if (_downloadRate == 1) {
            [self downloadCompleted:_currentDownloadPath];
        }
    });
    
}

@end

