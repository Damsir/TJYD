//
//  DY_newSearchBar.m
//  XAYD
//
//  Created by songdan Ye on 16/4/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DY_newSearchBar.h"

@implementation DY_newSearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame: frame]) {
        //设置view的背景颜色
        self.backgroundColor =[UIColor whiteColor];
        
        //设置圆角白色背景框
        self.searchBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, frame.size.height - 20)];
        self.searchBackView.backgroundColor =RGB(238, 238, 238);

        self.searchBackView.userInteractionEnabled = YES;
        self.searchBackView.layer.masksToBounds = YES;
        self.searchBackView.layer.cornerRadius  = 5;
        [self addSubview:self.searchBackView];
        
        //设置放大镜
        
        self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.searchImageView.image =[UIImage imageNamed:@"searchm"];
        self.searchImageView.contentMode = UIViewContentModeCenter;
        [self.searchBackView addSubview:self.searchImageView];
        
        //输入框
        
        self.searchTextField =[[UITextField alloc] initWithFrame:CGRectMake(self.searchImageView.frame.size.width, 0, self.searchBackView.frame.size.width-self.searchImageView.frame.size.width, self.searchBackView.frame.size.height)];
        
        
//        self.searchTextField =[[UITextField alloc] initWithFrame:CGRectMake(self.searchImageView.frame.size.width, 0, 1000, self.searchBackView.frame.size.height)];
        
        self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchTextField.font = [UIFont systemFontOfSize:14];
        self.searchTextField.placeholder = @"输入搜索内容";
        self.searchTextField.delegate =self;
        self.searchTextField.enabled = YES;
        self.searchTextField.userInteractionEnabled = YES;
        self.searchTextField.tintColor = [UIColor blackColor];
        self.searchTextField.textColor = [UIColor blackColor];
        self.searchTextField.backgroundColor =[UIColor clearColor];
        self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        [self.searchBackView addSubview:self.searchTextField];
        
    }
    return self;

}


// 点击键盘return键的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //过滤掉输入框的文字前后的空格
    NSString *textString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //搜索内容不为空
    if (![textString isEqualToString:@""]) {
        //执行代理方法
        [self.delegate searchDataWithInputString:textField.text];
    }
    return  YES;

}

//监听文本框右侧清除按钮响应的方法
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchTextField.text = @"";
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(hideSearchResultTabelView)])
    {
        [self.delegate hideSearchResultTabelView];
    }

    return YES;
}



//监听输入框文本的变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    self.searchTextField.text = string;
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(hideSearchResultTabelView)]) {
            [self.delegate hideSearchResultTabelView];
        }
    }
    return YES;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.searchBackView.frame=CGRectMake(10, 10, SCREEN_WIDTH-20, self.frame.size.height - 20);
    self.searchImageView.frame =CGRectMake(0, 0, 30, 30);
    self.searchTextField =[[UITextField alloc] initWithFrame:CGRectMake(self.searchImageView.frame.size.width, 0, self.searchBackView.frame.size.width-self.searchImageView.frame.size.width, self.searchBackView.frame.size.height)];

}


@end
