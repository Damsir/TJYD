//
//  DistGesButton.m
//  GesturePassword
//
//  Created by 吴定如 on 17/4/11.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistGesButton.h"

@implementation DistGesButton

#define bounds self.bounds

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_selected) {
        if (_success) {
//            CGContextSetRGBStrokeColor(context, 255/255.f, 255/255.f, 255/255.f,1);//线条颜色(成功)
//            CGContextSetRGBFillColor(context,255/255.f, 255/255.f, 255/255.f,1);
            CGContextSetRGBStrokeColor(context, 37/255.f, 145/255.f, 136/255.f,1);//线条颜色(成功)
            CGContextSetRGBFillColor(context,37/255.f, 145/255.f, 136/255.f,1);
        }
        else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色(失败)
            CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,1);
        }
        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1, bounds.size.height/2-bounds.size.height/8, bounds.size.width/4, bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
//        CGContextSetRGBStrokeColor(context, 1,1,1,1);//线条颜色
        CGContextSetRGBStrokeColor(context, 37/255.f, 145/255.f, 136/255.f,1);//线条颜色
    }
    
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (_success) {
//        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.3);
        CGContextSetRGBFillColor(context,37/255.f, 145/255.f, 136/255.f,0.3);
    }
    else {
        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.3);
    }
    CGContextAddEllipseInRect(context,frame);
    if (_selected) {
        CGContextFillPath(context);
    }
    
}

@end
