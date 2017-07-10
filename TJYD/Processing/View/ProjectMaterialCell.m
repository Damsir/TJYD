//
//  ProjectMaterialCell.m
//  TJYD
//
//  Created by 吴定如 on 17/4/13.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "ProjectMaterialCell.h"

@implementation ProjectMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMaterialCellWithModel:(MaterialChildrenModel *)model {
    
    self.fileName.text = model.name;

    // (model.materialSize = 14346 KB)
    NSArray *sizeArray = [model.materialSize componentsSeparatedByString:@" "];
    NSString *fileSize = [sizeArray firstObject];
    CGFloat totalSize = [fileSize floatValue]/1024.0;
    self.fileSize.text = totalSize > 1 ? [NSString stringWithFormat:@"%.02f MB",totalSize] : [NSString stringWithFormat:@"%.02f KB",totalSize * 1024.0];
//    self.fileSize.text = model.materialSize;
    
    // 判断文件类型
    NSString *type = model.type;
    NSString *imageName ;
    if ([type isEqualToString:@""]) {
        imageName=@"filetype-unknow48.png";
    } else if ([type isEqualToString:@"png"]||[type isEqualToString:@"PNG"]||[type isEqualToString:@"jpg"]||[type isEqualToString:@"JPG"]) {
        imageName=@"pic icon";
    } else if ([type isEqualToString:@"docx"] || [type isEqualToString:@"doc"]) {
        imageName=@"filetype-word48.png";
    } else if ([type isEqualToString:@"xlsx"] || [type isEqualToString:@"xls"]) {
        imageName=@"filetype-excel48.png";
    } else if ([type isEqualToString:@"pptx"] || [type isEqualToString:@"ppt"]) {
        imageName=@"filetype-ppt48.png";
    } else if ([type isEqualToString:@"pdf"] || [type isEqualToString:@"PDF"]) {
        imageName=@"filetype-pdf48.png";
    } else if ([type isEqualToString:@"zip"] || [type isEqualToString:@"ZIP"]) {
        imageName=@"filetype-zip48.png";
    } else if ([type isEqualToString:@"rar"] || [type isEqualToString:@"RAR"]) {
        imageName=@"filetype-rar48.png";
    } else if ([type isEqualToString:@"dwg"] || [type isEqualToString:@"DWG"]) {
        imageName=@"filetype-dwg48.png";
    } else if ([type isEqualToString:@"mp3"] || [type isEqualToString:@"MP3"]||[type isEqualToString:@"wma"] || [type isEqualToString:@"WMA"]) {
        imageName=@"filetype-music48.png";
    } else if ([type isEqualToString:@"mp4"] || [type isEqualToString:@"MP4"]||[type isEqualToString:@"rmvb"] || [type isEqualToString:@"RMVB"]||[type isEqualToString:@"avi"] || [type isEqualToString:@"AVI"]||[type isEqualToString:@"mov"] || [type isEqualToString:@"MOV"]||[type isEqualToString:@"mkv"] || [type isEqualToString:@"MKV"]) {
        imageName=@"filetype-video48.png";
    } else {
        imageName=@"filetype-unknow48.png";
    }
    // 根据材料类型加载不同的图片
    [self.fileTypeImage setImage:[UIImage imageNamed:imageName]];
    
}

@end
