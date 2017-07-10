//
//  FileTableViewContainerV.m
//  XAYD
//
//  Created by songdan Ye on 16/1/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "FileTableViewContainerV.h"
#import "ServiceProvider.h"
#import "FileModel.h"
#import "MZFormSheetController.h"
#import "AFNetworking.h"
#import "DejalActivityView.h"
#import "MBProgressHUD+MJ.h"
#import "FileTableViewContainerAPI.h"

@implementation FileTableViewContainerV
MZFormSheetController *formSheet;
@synthesize dataSource,isFromLocal = _isFromLocal,deleteDic;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        self.dataSource=[[NSMutableArray alloc] init];
    }
    return self;
}

//list加载数据
- (void)load:(NSString *)path andKey:(NSString *)key{
    _fManager=[NSFileManager defaultManager];
    _path = path;
    NSLog(@"#######3%@---key=%@",_path,key);
    _searchKey = key;
    //本地资源
    if (self.isFromLocal) {
        //[self getFilesFromLocal:path];
        self.dataSource = [self getFilesFromLocal:path key:key];
        //创建tableView等子视图
        [self createFileSubViews];
    }
    //在线资源
    else{
//        self.dataSource=[[NSMutableArray alloc] init];
        ServiceProvider *sp=[ServiceProvider initWithDelegate:self];
        NSString *type=@"floader";
        NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithCapacity:1];
        
        //有无搜索内容时设置@"action"
        if (nil == key || [key isEqualToString:@""]) {
            [mutableDic setObject:@"getFiles" forKey:@"action"];
        }else{
            [mutableDic setObject:@"searchFiles" forKey:@"action"];
        }
        [mutableDic setObject:path forKey:@"pathName"];
        [mutableDic setObject:key forKey:@"fileName"];
        [mutableDic setObject:type forKey:@"type"];
        
        
        
       
        //[sp getData:type parameters:mutableDic]; 旧的请求网络方式，容易闪退
        
        
//        NSString *url=@"http://60.12.211.13:10091/servicestest/ServiceProvider.ashx";
//                [Global serviceUrl];
//        NSLog(@"%@?action=%@&pathName=%@&fileName=%@&type=resource2",url,[mutableDic objectForKey:@"action"],path,key);
        
        //NSDictionary *parameters = @{@"userId":[[Global currentUser] userid]};
        //http://60.12.211.13:10091/servicestest/ServiceProvider.ashx?action=getFiles&pathName=&fileName=&type=resource2
        
        
//        http://58.246.138.178:8040/gzServices/ServiceProvider.ashx?type=resource2&action=getfiles&pathName=
        

        // 路径: [mutableDic objectForKey:@"pathName"]
       // 61.153.29.234:8888/mobileService/service/gw/FtpDoc.ashx?dir=

//        NSString *url =[NSString stringWithFormat:@"%@service/gw/FtpDoc.ashx",[Global Url]];
//         NSDictionary *parameters = @{@"dir":[mutableDic objectForKey:@"pathName"]};
//        
//       
//        
//        NSLog(@"%@?action=%@&pathName=%@&fileName=%@&type=%@",url,[mutableDic objectForKey:@"action"],[mutableDic objectForKey:@"pathName"],[mutableDic objectForKey:@"fileName"],[mutableDic objectForKey:@"type"]);
        
        //***********
        //添加蒙板
        // [DejalBezelActivityView activityViewForView:self withLabel:@"加载数据"];
        [MBProgressHUD showMessage:@"正在加载" toView:self];
        
        FileTableViewContainerAPI *api = [[FileTableViewContainerAPI alloc]initWithArguments:mutableDic];
        [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
            [MBProgressHUD hideHUDForView:self];
            
            NSDictionary *data = request.responseObject;
            if ([data objectForKey:@"success"]) {
                NSArray *rs=[data objectForKey:@"result"];
                for (NSDictionary *item in rs) {
                    
                    //                    [self setImgFile:theImgFile];//type
                    //                    [self setFileName:theFileName];//name
                    //                    [self setFileLength:theFileLength];//length
                    //                    [self setFileDate:theFileDate];//createTime
                    //                    [self setFileType:theFileType];//extension
                    //FileModel *fModel=[[FileModel alloc] initWithFile:[item objectForKey:@"type"] fileName:[item objectForKey:@"name"] fileLength:[item objectForKey:@"length"] fileDate:[item objectForKey:@"creationTime"] fileType:[item objectForKey:@"extension"]];
                    FileModel *model = [[FileModel alloc] initWithFileType:[item objectForKey:@"fileType"] fileName:[item objectForKey:@"name"]];
                    //   NSString *f=[item objectForKey:@"filePath"];
                    NSString *f=[item objectForKey:@"name"];
                    
                    model.filePath = f;
                    //fModel.byName = [item objectForKey:@"byname"];
                    
                    //保存数据
                    [self.dataSource addObject:model];
                    [self.tableView reloadData];
                    
                    
                }
            }
            //创建tableview等子视图
            [self createFileSubViews];
            

        } failure:^(__kindof DistBaseRequest *request, NSError *error) {
            [MBProgressHUD hideHUDForView:self];

        }];
        
        /*
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self];
            
            NSDictionary *data = (NSDictionary *)responseObject;
            if ([data objectForKey:@"success"]) {
                NSArray *rs=[data objectForKey:@"result"];
                for (NSDictionary *item in rs) {
                    
                    //                    [self setImgFile:theImgFile];//type
                    //                    [self setFileName:theFileName];//name
                    //                    [self setFileLength:theFileLength];//length
                    //                    [self setFileDate:theFileDate];//createTime
                    //                    [self setFileType:theFileType];//extension
                    //FileModel *fModel=[[FileModel alloc] initWithFile:[item objectForKey:@"type"] fileName:[item objectForKey:@"name"] fileLength:[item objectForKey:@"length"] fileDate:[item objectForKey:@"creationTime"] fileType:[item objectForKey:@"extension"]];
                    FileModel *model = [[FileModel alloc] initWithFileType:[item objectForKey:@"fileType"] fileName:[item objectForKey:@"name"]];
                    //   NSString *f=[item objectForKey:@"filePath"];
                    NSString *f=[item objectForKey:@"name"];
                    
                    model.filePath = f;
                    //fModel.byName = [item objectForKey:@"byname"];
                    
                    //保存数据
                    [self.dataSource addObject:model];
                    [self.tableView reloadData];
                    
                    
                }
            }
            //创建tableview等子视图
            [self createFileSubViews];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self];

            NSLog(@"FileTableViewContainerV has error:serviceCallback");
        }];
   */
    }
}
//刷新方法
- (void)refersh{
    [self load:_path andKey:_searchKey];
}

//获取本地资源搜索
- (NSMutableArray *)getFilesFromLocal:(NSString *)path key:(NSString *)key{
    
    
    
    NSError *error;
    //取出路径下地内容
    NSArray *contents = [_fManager contentsOfDirectoryAtPath:path error:&error];
    
    NSLog(@"本地路径%@,%@",path,contents);

    //有搜索内容时
    if (![key isEqualToString:@""]) {
        NSEnumerator *childFilesEnumerator = [[_fManager subpathsAtPath:path] objectEnumerator];
        contents=[childFilesEnumerator allObjects];
    }
    if (nil!=error) {//有error
        return [NSMutableArray arrayWithObjects: nil];
    }
    NSMutableArray *directories = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:10];
    BOOL isDir = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dataSource=[[NSMutableArray alloc] init];
    
    for (NSString *item in contents) {
        
        //有需要搜索的内容时
        if (![key isEqualToString:@""]){
            NSRange range=[item rangeOfString:key];
            if (range.length==0)
                continue;
        }
        //拼接路径
        NSString *fp = [path stringByAppendingPathComponent:item];
        NSArray *ar=[item componentsSeparatedByString:@"/"];
        NSString *name=ar.lastObject;
        //
        [_fManager fileExistsAtPath:fp isDirectory:(&isDir)];
        NSDictionary *fileAttributes = [_fManager attributesOfItemAtPath:fp error:nil];
        NSString *dateString = [formatter stringFromDate:[fileAttributes objectForKey:@"NSFileModificationDate"]];
        
        FileModel *fModel=nil;
        
        if (isDir) {
            fModel = [[FileModel alloc] initWithFile:@"directory" fileName:name fileLength:@"" fileDate:dateString fileType:@""];
            fModel.filePath=fp;
            if ([key isEqualToString:@""]) {
                [directories addObject:fModel];//搜索模式，不需要文件夹
            }
        }else{
            long fileSize = [[fileAttributes objectForKey:@"NSFileSize"] longValue];
            NSString *sizeString = @"";
            long kb=fileSize/1024;
            if (kb>1024) {
                long mb = kb/1024;
                sizeString = [NSString stringWithFormat:@"%ldMB",mb];
            }else{
                sizeString = [NSString stringWithFormat:@"%ldKB",kb];
            }
            //fModel = [[FileModel alloc] initWithFile:@"file" fileName:name fileLength:sizeString fileDate:dateString fileType:[fp pathExtension]];
            fModel = [[FileModel alloc] initWithFileType:@"" fileName:name];
            //   NSString *f=[item objectForKey:@"filePath"];
            //NSString *f=[item objectForKey:@"name"];
            fModel.filePath=fp;
            [files addObject:fModel];
        }
        isDir = NO;
    }
    [directories addObjectsFromArray:files];
    return directories;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib=nil;
            nib = [UINib nibWithNibName:@"DigitialMFileCell" bundle:nil];
               [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    DigitialMFileCell *cell=[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    NSUInteger row=[indexPath row];
    FileModel *fModel=[self.dataSource objectAtIndex:row];
   // cell.strImgFileName=[fModel name];//根据extension设置cell的图片为文件夹还是具体等
    cell.fileName=[fModel name];
    cell.fileModel = fModel;//根据模型设置cell的图片为文件夹还是具体文件等
    
    //cell.fileLength=[fModel fileLength];
    //cell.fileDate=[fModel fileDate];
    //cell.byName = [fModel byName];
    cell.acBtn.hidden = YES;
    //本地资源添加移动和删除操作
    if(self.isFromLocal){
        cell.acBtn.hidden =NO;
        [cell.acBtn setImage:[UIImage imageNamed:@"op.png"] forState:UIControlStateNormal];
        
        [cell.acBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        cell.acBtn.layer.cornerRadius = 3;
        [cell.acBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.acBtn setBackgroundColor:[UIColor clearColor]];
        
        cell.acBtn.tag = indexPath.row;
        //添加点击按的方法
        [cell.acBtn addTarget:self action:@selector(deletedRow:)forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.filesizeRC.constant =9-cell.acBtn.frame.size.width+5;
    }
    
    
    return cell;
    
}
//删除某行数据
- (void)deletedRow:(UIButton *)btn
{
    UITableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.1) {
        cell =(UITableViewCell *)[[[btn superview] superview] superview];
    }
    else
    {
     cell=(UITableViewCell *)[[btn superview] superview];//获取cell
    }
    NSIndexPath *indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的index
    
    
    
    
    _deleteDic1=[NSMutableDictionary dictionaryWithCapacity:10];
    [_deleteDic1 setObject:[dataSource objectAtIndex:btn.tag] forKey:indexPathAll];
    if ([btn.titleLabel.text isEqualToString:@"删除"]) {
        [self deleteData:btn.tag];
    }
    else
    {
        //获取要移除的数据
        _mm=(FileModel *)[dataSource objectAtIndex:indexPathAll.row];
        [btn setImage:nil forState:UIControlStateNormal];
        
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize:14]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
}

- (void)deleteData:(NSInteger)index
{
    [dataSource removeObjectAtIndex:index];

    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[_deleteDic1 allKeys]] withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"fileName=%@",_mm.name);
//    NSError *error;
//    //取出路径下地内容
//    NSArray *contents = [_fManager contentsOfDirectoryAtPath:_path error:&error];
//    
//    NSLog(@"本地路径%@,%@",_path,contents);
    [_tableView reloadData];
    
    //移除路径下的内容
    if (![_fManager removeItemAtPath:[_path stringByAppendingPathComponent:_mm.name] error:nil]) {
        NSLog(@"remove_error_%@",[_path stringByAppendingPathComponent:_mm.name]);
    }
    
    [_deleteDic1 removeAllObjects];
    
}

//手机上cell的长按手势执行方法
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:self];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:location];
        NSLog(@"%d",[indexPath row]);
        if (!_tableView.editing) {
            deleteDic=[NSMutableDictionary dictionaryWithCapacity:10];
            [deleteDic setObject:[dataSource objectAtIndex:[indexPath row]] forKey:indexPath];
        }
            DigitialMFileCell *cell=(DigitialMFileCell *)recognizer.view;
            [cell becomeFirstResponder];
            UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"移到" action:@selector(handleMove:)];
            UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDelete:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
            [menu setTargetRect:cell.frame inView:self];
            [menu setMenuVisible:YES animated:YES];
    }
}


//处理移动的方法
- (void)handleMove:(id)sender{
    NSArray *fileList=[[NSArray alloc] init];
    fileList=[_fManager contentsOfDirectoryAtPath:[[Global currentUser] userResourcePath] error:nil];
    NSMutableArray *folderList=[[NSMutableArray alloc] init];
    BOOL isDir=NO;
    for (NSString *file in fileList) {
        NSString *path=[[[Global currentUser] userResourcePath] stringByAppendingPathComponent:file];
        [_fManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [folderList addObject:file];
        }
        isDir=NO;
    }
    FolderSelectorViewController *folderSelectorController = [[FolderSelectorViewController alloc] initWithNibName:@"FolderSelectorViewController" bundle:nil];
    folderSelectorController.delegate=self;
    formSheet = [[MZFormSheetController alloc] initWithViewController:folderSelectorController];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    //formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    formSheet.cornerRadius = 8.0;
    formSheet.portraitTopInset = 6.0;
    formSheet.landscapeTopInset = 150;
    formSheet.presentedFormSheetSize = CGSizeMake(300, 400);
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
}

//处理删除的方法
- (void)handleDelete:(id)sender{
    NSArray *deleteArray=[deleteDic allValues];
    [dataSource removeObjectsInArray:deleteArray];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[deleteDic allKeys]] withRowAnimation:UITableViewRowAnimationFade];
    
    for (int i=0; i<deleteArray.count; i++) {
        FileModel *f=[deleteArray objectAtIndex:i];
        if (![_fManager removeItemAtPath:[_path stringByAppendingPathComponent:f.name] error:nil]) {
            NSLog(@"remove_error_%@",[_path stringByAppendingPathComponent:f.name]);
        }
    }
    [deleteDic removeAllObjects];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    FileModel *fModel = [self.dataSource objectAtIndex:row];
   
    NSLog(@"fModel=%@",fModel);
    if (_tableView.editing) {
        [deleteDic setObject:fModel forKey:indexPath];
    }else{
        
        
        //                    [ImgFile];//type
        //                    [FileName];//name
        //                    [Length];//length
        //                    [FileDate];//createTime
        //                    [FileType];//extension
        //                    [filePath];//filePath
        //                    [byName];//byname
        
        //FileItemThumbnailDelegate
        [self.resourceDelegate fileItemDidTap:fModel.name type:fModel.fileType path:fModel.name];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteDic removeObjectForKey:[dataSource objectAtIndex:[indexPath row]]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void) serviceCallback:(ServiceProvider *)provider didFinishReciveStringData:(NSString *)data{
    
}
- (void) serviceCallback:(ServiceProvider *)provider didFinishReciveJsonData:(NSDictionary *)data{
    if ([data objectForKey:@"sucess"]) {
        NSArray *rs=[data objectForKey:@"result"];
        for (NSDictionary *item in rs) {
            //FileModel *fModel=[[FileModel alloc] initWithFile:[item objectForKey:@"type"] fileName:[item objectForKey:@"name"] fileLength:[item objectForKey:@"length"] fileDate:[item objectForKey:@"creationTime"] fileType:[item objectForKey:@"extension"]];
            FileModel *model = [[FileModel alloc] initWithFileType:[item objectForKey:@"fileType"] fileName:[item objectForKey:@"name"]];
            NSString *f=[item objectForKey:@"name"];
            model.filePath=[f stringByReplacingOccurrencesOfString:@">>" withString:@"//"];
            //fModel.byName = [item objectForKey:@"byname"];
            [self.dataSource addObject:model];
        }
    }
    [self createFileSubViews];
}

//创建tableView
- (void)createFileSubViews{
    double xNum=0,yNum=0,xSize=100,ySize=140;
    int i=0;
    int gap = 10;
    
    
    FileItemThumbnailView  *resView=nil;
    if (nil!=_thumibnailsContainer) {
        [_thumibnailsContainer removeFromSuperview];
        _thumibnailsContainer = nil;
    }
    _thumibnailsContainer=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _thumibnailsContainer.backgroundColor =[UIColor greenColor];
    
    int columnCount = (int)self.bounds.size.width/(xSize+gap);
    for(FileModel *f in self.dataSource){
        xNum=i%columnCount;
        yNum=i/columnCount;
        resView=[[FileItemThumbnailView alloc] initWithFrame:CGRectMake(xNum*xSize+gap*xNum+gap
                                                                        , yNum*ySize+yNum*gap, xSize, ySize)];
        
        
        
        
        resView.backgroundColor =[UIColor brownColor];
        resView.delegate = self.resourceDelegate;
        [resView load:f.name andType:f.fileType andFile:f.filePath];
        //[self addSubview:resView];
        [_thumibnailsContainer addSubview:resView];
        i++;
    }
    
    _thumibnailsContainer.contentSize=CGSizeMake(self.frame.size.width, (yNum+1)*ySize+yNum*gap);
    
    //self.contentSize=CGSizeMake(480, (yNum+1)*ySize);
    
    if (nil==_tableView) {
        // _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self addSubview:_tableView];
    }else{
        [_tableView reloadData];
    }
    
//    [self addSubview:_thumibnailsContainer];
    
    //tableViewFile.hidden=self.owner.intStyle==0?true:false;
    //view1.hidden=self.owner.intStyle==0?false:true;
    if (self.viewType==1) {
        [self showThumbnails];
    }else{
        [self showDetails];
    }
    _openGroupFileBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    _openGroupFileBtn.frame=CGRectMake(90, 160, 140, 30);
    [_openGroupFileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _openGroupFileBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_openGroupFileBtn setTitle:@"打开选中的文件" forState:UIControlStateNormal];
    _openGroupFileBtn.backgroundColor=[UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:0.5];
    _openGroupFileBtn.layer.cornerRadius=5.0;
    _openGroupFileBtn.layer.shadowColor=[[UIColor lightGrayColor]CGColor];
    _openGroupFileBtn.layer.shadowOffset=CGSizeMake(2,2);
    _openGroupFileBtn.layer.shadowOpacity=1.0;
    _openGroupFileBtn.alpha=0;
    [_openGroupFileBtn addTarget:self action:@selector(openGroupeFileBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_openGroupFileBtn];
    [self bringSubviewToFront:_openGroupFileBtn];
}


- (void) serviceCallback:(ServiceProvider *)provider requestFaild:(NSError *)error{
    NSLog(@"FileTableViewContainerV has error:serviceCallback");
}

- (void)showDetails{
    _thumibnailsContainer.hidden=true;
    _tableView.hidden=false;
    self.viewType = 2;
}

- (void)showThumbnails{
    _thumibnailsContainer.hidden=false;
    _tableView.hidden=true;
    self.viewType = 1;
}

- (void)editTableView{
    //设置编辑模式
    if (_tableView.editing) {
        [self handleDelete:nil];
        
        [_tableView setEditing:NO animated:YES];
    }else{
        [_tableView setEditing:YES animated:YES];
    }
    deleteDic=[NSMutableDictionary dictionaryWithCapacity:5];
}

- (void)deleteResource{
    NSArray *deleteArray=[deleteDic allValues];
    [dataSource removeObjectsInArray:deleteArray];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[deleteDic allKeys]] withRowAnimation:UITableViewRowAnimationFade];
    
    for (int i=0; i<deleteArray.count; i++) {
        FileModel *f=[deleteArray objectAtIndex:i];
        if (![_fManager removeItemAtPath:[_path stringByAppendingPathComponent:f.name] error:nil]) {
            NSLog(@"remove_error_%@",[_path stringByAppendingPathComponent:f.name]);
        }
    }
    
    
    [deleteDic removeAllObjects];
}

- (void) addFolder:(NSString *)folerName{
    NSDate *today=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strToday=[formatter stringFromDate:today];
    FileModel *fModel=[[FileModel alloc]  initWithFile:@"directory" fileName:folerName fileLength:@"" fileDate:strToday fileType:@""];
    [dataSource insertObject:fModel atIndex:0];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
    
    
    NSString *addResourceFolderPath=[_path stringByAppendingPathComponent:folerName];
    [_fManager createDirectoryAtPath:addResourceFolderPath withIntermediateDirectories:YES attributes:Nil error:Nil];
}
- (void)folderMove:(NSString *)toPath{
    NSArray *fModels=[deleteDic allValues];
    for (int i=0; i<fModels.count; i++) {
        FileModel *fModel=[fModels objectAtIndex:i];
        NSString *filePath=[_path stringByAppendingPathComponent:fModel.name];
        
        NSEnumerator *childFilesEnumerator = [[_fManager subpathsAtPath:filePath] objectEnumerator];
        NSArray *arr= [filePath componentsSeparatedByString:@"/"];
        NSString *str=[arr lastObject];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString *from = [filePath stringByAppendingPathComponent:fileName];
            NSString *to=[toPath stringByAppendingFormat:@"/%@/%@",str,fileName];
            if (![_fManager moveItemAtPath:from toPath:to error:nil]) {
                NSLog(@"error_%@",from);
            }
        }
        
        if(![_fManager moveItemAtPath:filePath toPath:[toPath stringByAppendingPathComponent:fModel.name] error:nil]){
            NSLog(@"error_%@",filePath);
        }
        
    }
    
    [dataSource removeObjectsInArray:fModels];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[deleteDic allKeys]] withRowAnimation:UITableViewRowAnimationFade];
    [deleteDic removeAllObjects];
    [formSheet dismissAnimated:NO completionHandler:nil];
}




#pragma -mark 接收多选按钮点击后执行的方法
- (void)selectSomeFiles:(NSNotification *)noti
{
    //初始化(清空)被选中数组
    _selectedArray=[[NSMutableArray alloc]initWithCapacity:10];
    for (int i=0; i<self.dataSource.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        DigitialMFileCell *cell=(DigitialMFileCell *)[_tableView cellForRowAtIndexPath:indexPath];
        if ([noti.object isEqualToString:@"1"]) {
            [cell.acBtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        }
        else
            [cell.acBtn setImage:[UIImage imageNamed:@"op.png"] forState:UIControlStateNormal];
    }
}

- (void)openGroupFileBtnHidden
{
    [UIView animateWithDuration:2 animations:^{
        _openGroupFileBtn.alpha=0;
    }];
}
- (void)openGroupeFileBtnClick
{
    NSLog(@"打开多组中的某个文件");
    //    [self.resourceDelegate fileItemDidTap:fModel.fileName type:fModel.fileType path:fModel.filePath];
    //替换方法，打开多组中的某一个 _selectedArray
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _thumibnailsContainer.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    int i=0;
    double xNum=0,yNum=0,xSize=100,ySize=140;
    int gap = 10;
    FileItemThumbnailView  *resView=nil;
    int columnCount = (int)self.bounds.size.width/(xSize+gap);

    for(FileModel *f in self.dataSource){
        xNum=i%columnCount;
        yNum=i/columnCount;
        resView=[[FileItemThumbnailView alloc] initWithFrame:CGRectMake(xNum*xSize+gap*xNum+gap
                                                                        , yNum*ySize+yNum*gap, xSize, ySize)];
        
        
        
        
        resView.backgroundColor =[UIColor brownColor];
        resView.delegate = self.resourceDelegate;
        [resView load:f.name andType:f.fileType andFile:f.filePath];
        //[self addSubview:resView];
        [_thumibnailsContainer addSubview:resView];
        i++;
    }
    
    _thumibnailsContainer.contentSize=CGSizeMake(self.frame.size.width, (yNum+1)*ySize+yNum*gap);
    
     _tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    
}

//
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
- (float) fileSizeAtPath:(NSString*) filePath{
    
    //
    //    NSData* data = [NSData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:_convertAmr ofType:@"amr"]];
    //    NSLog(@"amrlength = %d",data.length);
    //    NSString * amr = [NSString stringWithFormat:@"amrlength = %d",data.length];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
    
}

@end
