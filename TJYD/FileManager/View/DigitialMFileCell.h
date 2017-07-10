//
//  DigitialMFileCell.h
//  XAYD
//
//  Created by songdan Ye on 16/1/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface DigitialMFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblFileLength;
@property (weak, nonatomic) IBOutlet UILabel *lblFileDate;
@property (weak, nonatomic) IBOutlet UIButton *acBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filesizeRC;

@property (strong, nonatomic) NSString *strImgFileName;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileLength;
@property (strong, nonatomic) NSString *fileDate;
@property (strong, nonatomic) NSString *byName;
@property (strong, nonatomic) NSMutableDictionary *deleteDic;
@property (nonatomic, strong) FileModel *fileModel;

@end
