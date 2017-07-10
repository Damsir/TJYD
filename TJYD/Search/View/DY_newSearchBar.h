//
//  DY_newSearchBar.h
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DY_newSearchBarDelegate <NSObject>
//代理方法
//回调用户输入的内容,用于搜索 string为用户输入的内容
- (void)searchDataWithInputString:(NSString *)string;

//当用户把输入框清空的时候会去隐藏搜索结果列表,显示搜索历史记录列表
- (void)hideSearchResultTabelView;


@end


@interface DY_newSearchBar : UIView<UITextFieldDelegate>
//放大镜
@property (nonatomic,strong) UIImageView *searchImageView;
//圆角白色背景框
@property (nonatomic,strong) UIView *searchBackView;
//输入框
@property (nonatomic,strong) UITextField *searchTextField;
//设置代理
@property (nonatomic,weak) id <DY_newSearchBarDelegate> delegate;


@end
