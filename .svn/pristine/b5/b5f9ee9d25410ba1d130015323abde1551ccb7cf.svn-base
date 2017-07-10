//
//  UIWebView+Highlight.m
//  nbOneMap
//
//  Created by zhangliang on 15/7/21.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "UIWebView+Highlight.h"

//by zx
//static BOOL jsLoaded = NO;

@implementation UIWebView (Highlight)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    //if(!jsLoaded)
    //{
        [self loadJavaScript];
        //jsLoaded = YES;
    //}
    
    //运行SearchWebView.js中的MyApp_HighlightAllOccurencesOfString()方法，实现高亮显示
    NSString *startSearch = [NSString stringWithFormat:@"MyApp_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    //返回匹配的结果数目
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"MyApp_SearchResultCount"];
    
    return [result integerValue];
}

- (void)loadJavaScript
{
    //得到SearchWebView.js代码
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsCode==%@",jsCode);
    
    //在当前 wiewbview中加载SearchWebView.js
    [self stringByEvaluatingJavaScriptFromString:jsCode];//返回js执行结果
    //NSLog(@"加载JS");
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"MyApp_RemoveAllHighlights()"];
}

- (NSInteger)searchKeyword:(NSString *)str;
{
    //if(!jsLoaded)
    //{
        [self loadJavaScript];
    //    jsLoaded = YES;
    //}
    //NSString *jsFuncStr = [NSString stringWithFormat:@"zxSearchKeyword('%@')",str];
    
    NSString *jsFuncStr = [NSString stringWithFormat:@"zxSearchKeyword('%@')",str];

    [self stringByEvaluatingJavaScriptFromString:jsFuncStr];
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"MyApp_SearchResultCount"];
    
    return [result integerValue];
}


@end
