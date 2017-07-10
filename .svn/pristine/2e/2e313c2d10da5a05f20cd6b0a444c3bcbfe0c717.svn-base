//
//  FileVC.m
//  XAYD
//
//  Created by songdan Ye on 16/1/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "FileVC.h"

@interface FileVC ()

@end

@implementation FileVC
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize fileExt = _fileExt;
@synthesize isFromNetwork = _isFromNetwork;
@synthesize showDeleteButton = _showDeleteButton;
@synthesize showSaveButton = _showSaveButton;
@synthesize maySavePath = _maySavePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _fileViewer = [FileViewer createView];
    _fileViewer.frame = CGRectMake(0, 10,SCREEN_WIDTH, SCREEN_HEIGHT-10);

    _fileViewer.delegate = self.fileViewDelegate;
    [self.view addSubview:_fileViewer];
    
    _previousButton = [SysButton buttonWithType:UIButtonTypeCustom];
    _previousButton.frame = CGRectMake(-30, 350, 60, 60);
    _previousButton.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    _previousButton.defaultBackground = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    _previousButton.layer.cornerRadius = 30;
    [_previousButton setTitle:@"     <" forState:UIControlStateNormal];
    [_previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_previousButton addTarget:self action:@selector(previousFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_previousButton];
    
    _nextButton = [SysButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(994, 350, 60, 60);
    _nextButton.backgroundColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    _nextButton.defaultBackground = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
    _nextButton.layer.cornerRadius = 30;
    [_nextButton setTitle:@">     " forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    _nextButton.hidden = _previousButton.hidden = YES;
    _beOpen = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated{
    
    if (!_beOpen) {
        return;
    }
    
    
    //设置下载可点击
//    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
    [_fileViewer setDownloadButtonVisible:[self.showSaveButton isEqualToString:@"YES"]];

    [_fileViewer setDeleteButtonVisible:[self.showDeleteButton isEqualToString:@"YES"]];
    
    _nextButton.hidden = _previousButton.hidden = nil==self.files || self.files.count==0;
    
    //放在这里才会每次视图出现的时候都调用
    _fileViewer.isContent = self.isContent;
    
    [self openFile];
    
}

- (void)delayMethod
{
//    [_fileViewer setDownloadButtonVisible:[self.showSaveButton isEqualToString:@"YES"]];


}


- (void)openFile{
    _beOpen = NO;
    if ( nil!= self.filePath) {
        // 网络
        if ([self.isFromNetwork isEqualToString:@"YES"]) {
            [_fileViewer openFileFromNetwork:self.fileName url:self.filePath ext:self.fileExt searchKey:self.searchKey];
        }else{
            // 本地
            [_fileViewer openFileFromLocation:self.fileName filePath:self.filePath ext:self.fileExt];
        }
    }else{
        NSDictionary *fileInfo = [self.files objectAtIndex:self.fileIndex];
        _previousButton.hidden = self.fileIndex==0;
        _nextButton.hidden = self.fileIndex==self.files.count-1;
        NSString *path = [fileInfo objectForKey:@"path"];
        NSString *ext = [fileInfo objectForKey:@"ext"];
        NSString *name = [fileInfo objectForKey:@"name"];
        if ([self.isFromNetwork isEqualToString:@"YES"]) {
            [_fileViewer openFileFromNetwork:name url:path ext:ext searchKey:self.searchKey];
        }else{
            [_fileViewer openFileFromLocation:name filePath:path ext:ext];
        }
    }
    
   
}

- (void)previousFile{
    self.fileIndex = self.fileIndex-1;
    [self openFile];
}

- (void)nextFile{
    self.fileIndex = self.fileIndex+1;
    [self openFile];
}

- (void)setFiles:(NSArray *)files{
    _files = files;
    _beOpen = YES;
}

- (void)setFileName:(NSString *)fileName{
    _fileName = fileName;
    _beOpen = YES;
}



@end
