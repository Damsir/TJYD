//
//  ResourceManagerAddressBar.m
//  zzzf
//
//  Created by zhangliang on 14-2-17.
//  Copyright (c) 2014年 dist. All rights reserved.
//

#import "ResourceManagerAddressBar.h"

@implementation ResourceManagerAddressBar

@synthesize bar,btnNext,btnPrevious;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubViews];
        _path=@"";
    }
    return self;
}

- (void)createSubViews{
    self.btnNext = [SysButton buttonWithType:UIButtonTypeCustom];
    [self.btnNext setImage:[UIImage imageNamed:@"digit_arrow_Right"] forState:UIControlStateNormal];
    
    [self.btnNext addTarget:self action:@selector(onBtnNextTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPrevious = [SysButton buttonWithType:UIButtonTypeCustom];
    [self.btnPrevious setImage:[UIImage imageNamed:@"digit_arrow_Left"] forState:UIControlStateNormal];
    
    [self.btnPrevious addTarget:self action:@selector(onBtnPreviousTap) forControlEvents:UIControlEventTouchUpInside];
    if (iPhone) {
        self.btnNext.frame = CGRectMake(26, 6, 26, 26);
        self.btnPrevious.frame = CGRectMake(0, 6, 26, 26);
        self.bar = [[UIScrollView alloc] initWithFrame:CGRectMake(52, 2, 268, 30)];
        self.bar.contentSize=CGSizeMake(900, 30);
        self.bar.contentOffset=CGPointMake(0, 0);
        self.bar.scrollEnabled=YES;
    }
    else{
        self.btnNext.frame = CGRectMake(44, 2, 30, 30);
        self.btnPrevious.frame = CGRectMake(6, 2, 30, 30);
        self.bar = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 2, 900, 35)];
    }
    [self addSubview:self.btnPrevious];
    [self addSubview:self.btnNext];
    [self addSubview:self.bar];
    
    _backStack = [NSMutableArray arrayWithCapacity:10];
    _addressStack = [NSMutableArray arrayWithCapacity:10];
    
}

//前进
- (void)go:(NSString *)path{
    //保存路径
    _path  = path;
    //保存点击的路径数组(栈)
    //将点击的路径保存到_addressStack,以方便后退按钮是否可用.
    [_addressStack addObject:path];
    [self update];
}


//前进
- (void)onBtnNextTap{
    if (_backStack.count==0) {
        return;
    }
    NSString *p = [_backStack objectAtIndex:_backStack.count-1];;
    [_backStack removeObjectAtIndex:_backStack.count-1];
    [self go:p];
    [self.delegate addressBar:self didChange:_path];
}

//后退
- (void)onBtnPreviousTap{
    if (_addressStack.count<=1) {
        return;
    }
    NSString *lastDirectory = [_addressStack objectAtIndex:_addressStack.count-1];
    [_addressStack removeObjectAtIndex:_addressStack.count-1];
    [_backStack addObject:lastDirectory];
    _path = [_addressStack objectAtIndex:_addressStack.count-1];
    [self update];
    [self.delegate addressBar:self didChange:_path];
}

//更新目录按钮
- (void)update{
    NSArray *ps = [_path pathComponents];
    int left = 0;//按钮的起始位置
    for(UIView *view in self.bar.subviews)
    {
        [view removeFromSuperview];
    }
    SysButton *rootItem = [self createAddressItem:[self.rootPathName stringByAppendingString:@"/"] left:left];
    rootItem.tag = 0;
    [self.bar addSubview:rootItem];
    if (ps.count==0) {
        rootItem.selected = YES;
    }
    left += rootItem.frame.size.width+5;
    

    for (int i=1;i<ps.count;i++) {
        NSString *directoryName = [ps objectAtIndex:i];
        SysButton *addressItem = [self createAddressItem:[directoryName stringByAppendingString:@"/"] left:left];
        addressItem.tag = i;
        left += addressItem.frame.size.width+5;
        //默认选中最后一个按钮(当前按钮)
        if (i==ps.count-1) {
            addressItem.selected = YES;
        }
        [self.bar addSubview:addressItem];
    }
    //前进按钮
    self.btnNext.enabled = _backStack.count>0;
    //后退按钮
    self.btnPrevious.enabled = _addressStack.count>1;
}


//创建/目录按钮
- (SysButton *)createAddressItem:(NSString *)name left:(int)left{
    
    SysButton *addressItem = [SysButton buttonWithType:UIButtonTypeCustom];
    addressItem.layer.cornerRadius = 5;
    addressItem.titleLabel.font = [addressItem.titleLabel.font fontWithSize:16];
    [addressItem setTitle:name forState:UIControlStateNormal];
    [addressItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    CGSize size = [name sizeWithFont:addressItem.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, addressItem.frame.size.height)];

    CGSize pathSize=[_path sizeWithAttributes:@{NSFontAttributeName:addressItem.titleLabel.font}];
    if (pathSize.width+100>SCREEN_WIDTH) {
        self.bar.contentOffset=CGPointMake(pathSize.width-210, 0);
    }
    else
        self.bar.contentOffset=CGPointMake(0, 0);

    CGSize size=[name sizeWithAttributes:@{NSFontAttributeName:addressItem.titleLabel.font}];
    
    [addressItem setFrame:CGRectMake(left, 5, size.width, 25)];
    [addressItem addTarget:self action:@selector(onItemTap:) forControlEvents:UIControlEventTouchUpInside];
    return addressItem;
}

//点击目录按钮
- (void)onItemTap:(SysButton *)sender{
    if (sender.selected) {
        return;
    }
    NSArray *ps = [_path pathComponents];
    NSMutableString *toPath = [NSMutableString stringWithCapacity:10];
    
    for (int i=1; i<=sender.tag; i++) {
        [toPath appendString:[NSString stringWithFormat:@"/%@",[ps objectAtIndex:i]]];
    }
    _path = toPath;
    [_addressStack addObject:toPath];
    [self update];
    [self.delegate addressBar:self didChange:_path];
}

- (NSString *)currentPath{
    return _path;
}

@end
