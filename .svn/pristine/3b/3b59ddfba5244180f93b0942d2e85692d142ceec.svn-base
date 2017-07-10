//
//  FileCustomCell.m
//  zzzf
//
//  Created by mark on 13-11-29.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import "FileCustomCell.h"

@implementation FileCustomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    //[super setSelected:selected animated:animated];
    //    if (selected) {
    //        self.backgroundColor=[UIColor colorWithRed:103.0/255.0 green:216.0/255.0 blue:198.0/255.0 alpha:1];
    //    }else{
    //        self.backgroundColor=[UIColor whiteColor];
    //    }
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithRed:103.0/255.0 green:216.0/255.0 blue:198.0/255.0 alpha:1];
    self.selectedBackgroundView = view;
    [super setSelected:selected animated:animated];
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

//- (void)setCompany:(NSString *)cp{
//    if (![cp isEqualToString:company]) {
//        company = [cp copy];
//        self.lblCompany.text = company;
//    }
//}

- (void)setStrImgFileName:(NSString *)IFName
{
    NSString *strImgUrl=@"";
    
    _strImgFileName=[IFName copy];
    if ([_strImgFileName isEqualToString:@""]) {
        strImgUrl=@"fileicon";
    }else if([_strImgFileName isEqualToString:@"png"]||[_strImgFileName isEqualToString:@"jpg"]){
//        strImgUrl=@"filetype-img48.png";
        strImgUrl=@"pic icon";

    }else if([_strImgFileName isEqualToString:@"docx"] || [_strImgFileName isEqualToString:@"doc"]){
        strImgUrl=@"filetype-word48.png";
    }else if([_strImgFileName isEqualToString:@"xlsx"] || [_strImgFileName isEqualToString:@"xls"]){
        strImgUrl=@"filetype-excel48.png";
    }else if([_strImgFileName isEqualToString:@"pptx"] || [_strImgFileName isEqualToString:@"ppt"]){
        strImgUrl=@"filetype-ppt48.png";
    }else{
        strImgUrl=@"filetype-unknow48.png";
    }
    
    [self.imgUrl setImage:[UIImage imageNamed:strImgUrl]];
    
}

- (void)setFileName:(NSString *)FName{
    
    _fileName=[FName copy];
    self.lblFileName.text=_fileName;
}

- (void)setFileLength:(NSString *)FLength{
    _fileLength = FLength;
    self.lblFileLength.text=_fileLength;
}

- (void)setFileDate:(NSString *)FDate{
    _fileDate = FDate;
    
    self.lblFileDate.text=_fileDate;
    
}

- (void)setByName:(NSString *)byName{
    _byName = byName;
    if (nil!=byName && ![byName isEqualToString:@""]) {
        self.lblFileName.text = byName;
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"began");
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"end");
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"moved");
//}

@end
