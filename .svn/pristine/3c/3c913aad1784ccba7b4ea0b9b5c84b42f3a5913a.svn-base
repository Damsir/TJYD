//
//  DigitialMFileCell.m
//  XAYD
//
//  Created by songdan Ye on 16/1/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DigitialMFileCell.h"

@implementation DigitialMFileCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


- (void)setStrImgFileName:(NSString *)IFName
{
    _strImgFileName = [IFName copy];
    
    NSString *imageName ;
    NSArray *array = [IFName componentsSeparatedByString:@"."];
    NSString *type = [array lastObject];
    
//    if ([type isEqualToString:@""]) {
//        imageName=@"filetype-unknow48.png";
//    }else if([type isEqualToString:@"png"]||[type isEqualToString:@"PNG"]||[type isEqualToString:@"jpg"]||[type isEqualToString:@"JPG"]){
//        imageName=@"pic icon";
//    }else if([type isEqualToString:@"docx"] || [type isEqualToString:@"doc"]){
//        imageName=@"filetype-word48.png";
//    }else if([type isEqualToString:@"xlsx"] || [type isEqualToString:@"xls"]){
//        imageName=@"filetype-excel48.png";
//    }else if([type isEqualToString:@"pptx"] || [type isEqualToString:@"ppt"]){
//        imageName=@"filetype-ppt48.png";
//    }else if([type isEqualToString:@"pdf"] || [type isEqualToString:@"PDF"]){
//        imageName=@"filetype-pdf48.png";
//    }else if([type isEqualToString:@"zip"] || [type isEqualToString:@"ZIP"]){
//        imageName=@"filetype-zip48.png";
//    }else if([type isEqualToString:@"rar"] || [type isEqualToString:@"RAR"]){
//        imageName=@"filetype-rar48.png";
//    }else if([type isEqualToString:@"dwg"] || [type isEqualToString:@"DWG"]){
//        imageName=@"filetype-dwg48.png";
//    }else if([type isEqualToString:@"mp3"] || [type isEqualToString:@"MP3"]||[type isEqualToString:@"wma"] || [type isEqualToString:@"WMA"]){
//        imageName=@"filetype-music48.png";
//    }else if([type isEqualToString:@"mp4"] || [type isEqualToString:@"MP4"]||[type isEqualToString:@"rmvb"] || [type isEqualToString:@"RMVB"]||[type isEqualToString:@"avi"] || [type isEqualToString:@"AVI"]||[type isEqualToString:@"mov"] || [type isEqualToString:@"MOV"]||[type isEqualToString:@"mkv"] || [type isEqualToString:@"MKV"]){
//        imageName=@"filetype-video48.png";
//    }else if ([type isEqualToString:@"txt"]){
//        imageName=@"filetype-txt48.png";
//    }else if ([type isEqualToString:@"floader"]){
//        imageName=@"wenjianjia@2x";
//    }
    
//    if ([_strImgFileName isEqualToString:@"floader"]) {
//        imageName=@"wenjianjia@2x";
//    }else if([_strImgFileName isEqualToString:@"file"]){
//        imageName=@"wenjian_gw";
//    }else
//    {
//        imageName=@"wenjian_gw";
//    }
//    [self.imgUrl setImage:[UIImage imageNamed:imageName]];
    
}

- (void)setFileModel:(FileModel *)fileModel
{
    //{"fileType":"floader","name":"2016高铁新城概念规划（中间成果）"},{"fileType":"file","name":"新建文本文档.txt"}
    _fileModel = fileModel;
    NSString *fileType = fileModel.fileType;
    NSString *imageName ;
    
    if ([fileType isEqualToString:@"floader"]) {
        imageName=@"wenjianjia@2x";
    }else if ([fileType isEqualToString:@"file"] || [fileType isEqualToString:@""]){
        NSArray *array = [fileModel.name componentsSeparatedByString:@"."];
        NSString *type = [array lastObject];
        if ([type isEqualToString:@""]) {
            imageName=@"filetype-unknow48.png";
        }else if([type isEqualToString:@"png"]||[type isEqualToString:@"PNG"]||[type isEqualToString:@"jpg"]||[type isEqualToString:@"JPG"]){
            imageName=@"pic icon";
        }else if([type isEqualToString:@"docx"] || [type isEqualToString:@"doc"]){
            imageName=@"filetype-word48.png";
        }else if([type isEqualToString:@"xlsx"] || [type isEqualToString:@"xls"]){
            imageName=@"filetype-excel48.png";
        }else if([type isEqualToString:@"pptx"] || [type isEqualToString:@"ppt"]){
            imageName=@"filetype-ppt48.png";
        }else if([type isEqualToString:@"pdf"] || [type isEqualToString:@"PDF"]){
            imageName=@"filetype-pdf48.png";
        }else if([type isEqualToString:@"zip"] || [type isEqualToString:@"ZIP"]){
            imageName=@"filetype-zip48.png";
        }else if([type isEqualToString:@"rar"] || [type isEqualToString:@"RAR"]){
            imageName=@"filetype-rar48.png";
        }else if([type isEqualToString:@"dwg"] || [type isEqualToString:@"DWG"]){
            imageName=@"filetype-dwg48.png";
        }else if([type isEqualToString:@"mp3"] || [type isEqualToString:@"MP3"]||[type isEqualToString:@"wma"] || [type isEqualToString:@"WMA"]){
            imageName=@"filetype-music48.png";
        }else if([type isEqualToString:@"mp4"] || [type isEqualToString:@"MP4"]||[type isEqualToString:@"rmvb"] || [type isEqualToString:@"RMVB"]||[type isEqualToString:@"avi"] || [type isEqualToString:@"AVI"]||[type isEqualToString:@"mov"] || [type isEqualToString:@"MOV"]||[type isEqualToString:@"mkv"] || [type isEqualToString:@"MKV"]){
            imageName=@"filetype-video48.png";
        }else if ([type isEqualToString:@"txt"]){
            imageName=@"filetype-txt48.png";
        }
    }
    [self.imgUrl setImage:[UIImage imageNamed:imageName]];
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

@end
