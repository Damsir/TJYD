//
//  ResourcesView.h
//  zzzf
//
//  Created by mark on 13-11-25.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FileItemThumbnailDelegate <NSObject>
- (void)fileItemDidTap:(NSString *)name type:(NSString *)type path:(NSString *)path;
@end

@interface FileItemThumbnailView : UIView{
    UILabel *lblFileName;
    NSString *_name;
    NSString *_type;
    NSString *_filePath;
}

- (void)load:(NSString *) name andType:(NSString *) type andFile:(NSString *)filePath;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (nonatomic,retain) id<FileItemThumbnailDelegate> delegate;
@end
