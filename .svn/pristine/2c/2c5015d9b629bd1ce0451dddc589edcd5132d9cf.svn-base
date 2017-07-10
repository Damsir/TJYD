//
//  JSDownloadView.m
//  JSDownloadView
//
//  Created by  on 16/8/27.
//  Copyright © 2016年 Dam. All rights reserved.
//https://github.com/Josin22/JSDownloadView

#import "JSDownloadView.h"
#import "JSAnimationService.h"
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

@interface JSDownloadView ()
{
    id _target;
    SEL _action;
    BOOL isAnimating;
    NSTimer *_waveTimer;
}
//进度圈
@property (nonatomic, strong) CAShapeLayer *realCircleLayer;
//底圈
@property (nonatomic, strong) CAShapeLayer *maskCircleLayer;
//箭头
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
//竖线
@property (nonatomic, strong) CAShapeLayer *verticalLineLayer;
//进度
@property (nonatomic, retain) UILabel *progressLabel;
//下载大小
@property (nonatomic, retain) UILabel *downloadLabel;

/* 波浪属性 */
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat waveCurvature;
@property (nonatomic, assign) CGFloat waveSpeed;
@property (nonatomic, assign) CGFloat waveHeight;

@property (nonatomic, strong) JSAnimationService *service;

@end

@implementation JSDownloadView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //监听屏幕旋转的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.progressWidth = 4;
    self.waveSpeed = 1.0;
    self.waveCurvature = .25;
    self.waveHeight = 3;
    _progress = 0.0;
    isAnimating = NO;
    
    self.service = [[JSAnimationService alloc] init];
    self.service.viewRect = self.frame;
    
    [self setDefaultPaths];
    
    /**
     *  2.一进视图就开始下载
     */
    //[self stopAllAnimations];
    //[self startAnimationBeforeCircle];

}

- (void)screenRotation{
    self.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
}

#pragma mark - Lazy View
// 底圈
- (CAShapeLayer *)maskCircleLayer{
    
    if (!_maskCircleLayer) {
        _maskCircleLayer = [self getOriginLayer];
        _maskCircleLayer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self bounds]];
        _maskCircleLayer.path = path.CGPath;
        [self.layer addSublayer:self.maskCircleLayer];
    }
    return _maskCircleLayer;
}
#pragma mark -- 进度圈
- (CAShapeLayer *)realCircleLayer{
    
    if (!_realCircleLayer) {
        _realCircleLayer = [self getOriginLayer];
        _realCircleLayer.strokeColor = [[UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000] colorWithAlphaComponent:1].CGColor;
        _realCircleLayer.strokeColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000].CGColor;
        [self.layer addSublayer:self.realCircleLayer];
    }
    
    return _realCircleLayer;
}

- (CAShapeLayer *)getOriginLayer{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = [self bounds];
    layer.lineWidth = self.progressWidth;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    return layer;
}
#pragma mark -- 箭头
- (CAShapeLayer *)arrowLayer{
    
    if (!_arrowLayer) {
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.frame = [self bounds];
        _arrowLayer.strokeColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000].CGColor;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.lineWidth = self.progressWidth-1;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:self.arrowLayer];
    }
    return _arrowLayer;
}

#pragma mark -- 竖线
- (CAShapeLayer *)verticalLineLayer{
    
    if (!_verticalLineLayer) {
        _verticalLineLayer = [CAShapeLayer layer];
        _verticalLineLayer.frame = [self bounds];
        _verticalLineLayer.strokeColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000].CGColor;
        _verticalLineLayer.lineCap = kCALineCapRound;
        _verticalLineLayer.lineWidth = self.progressWidth-1;
        _verticalLineLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.verticalLineLayer];
        
    }
    return _verticalLineLayer;
}
#pragma mark -- 进度
- (UILabel *)progressLabel{
    
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:[self.service getProgressRect]];
        _progressLabel.textColor = [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        _progressLabel.text = @"00%";
        //_progressLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}
#pragma mark -- 下载大小
- (UILabel *)downloadLabel{
    
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc] initWithFrame:[self.service getDownloadRect]];
        _downloadLabel.textColor = [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
        _downloadLabel.font = [UIFont systemFontOfSize:15];
        _downloadLabel.textAlignment = NSTextAlignmentCenter;
        _downloadLabel.adjustsFontSizeToFitWidth = YES;
        _downloadLabel.text = @"";
        //_downloadLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_downloadLabel];
    }
    return _downloadLabel;
}


#pragma mark - Method

- (void)setProgressWidth:(CGFloat)progressWidth{
    
    _progressWidth = progressWidth;
    
    self.realCircleLayer.lineWidth = progressWidth;
    self.maskCircleLayer.lineWidth = progressWidth;
    self.verticalLineLayer.lineWidth = progressWidth-1;
    self.arrowLayer.lineWidth = progressWidth-1;
}

- (void)setDefaultPaths{

    //箭头开始
    self.arrowLayer.path = self.service.arrowStartPath.CGPath;
    //竖线
    _verticalLineLayer.path = self.service.verticalLineStartPath.CGPath;
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = MAX( MIN(progress, 1.0), 0.0); // keep it between 0 and 1

    //进度
    self.realCircleLayer.path = [self.service getCirclePathWithProgress:_progress].CGPath;

    //1.label(小数)
    //self.progressLabel.text = [NSString stringWithFormat:@"%.2f",_progress];
    //2.label(百分数)
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_progress*100)];
    
}

- (void)setDownloadRate:(NSString *)downloadRate{
    
    // 下载大小
    self.downloadLabel.text = downloadRate;
}

- (void)setIsSuccess:(BOOL)isSuccess{
    
    _isSuccess = isSuccess;
    
    if (_isSuccess) {
        [_waveTimer invalidate];
        _waveTimer = nil;
        //移除label
        [self showProgressLabel:NO];
        [self showDownloadLabel:NO];
        //变成对号
        [self showSuccessAnimation];
    } else {
        //失败状态
    }
    
}

- (void)stopAllAnimations{
    
    // 重置波浪偏移
    self.offset = 0.0;
    /* 结束动画 */
    isAnimating = NO;
    [_waveTimer invalidate];
    _waveTimer = nil;
    
    self.userInteractionEnabled = NO;
    [self removeProgressLabel];
    [self removeDownloadLabel];
    [self.verticalLineLayer removeAllAnimations];
    [self.arrowLayer removeAllAnimations];
    if (!self.service.progressPath.empty) {
        [self.service.progressPath removeAllPoints];
        self.realCircleLayer.path = self.service.progressPath.CGPath;
    }
}

- (void)waveWithHeight:(CGFloat)waveHeight {
    
    self.offset += self.waveSpeed;
    
    self.arrowLayer.path = [self.service getWavePathWithOffset:self.offset WaveHeight:waveHeight WaveCurvature:self.waveCurvature].CGPath;
    
}

#pragma mark - Animation

- (void)startAnimationBeforeCircle{
    
    CAAnimationGroup *lineAnimation = [self.service getLineToPointUpAnimationWithValues:@[(__bridge id)self.service.verticalLineStartPath.CGPath,(__bridge id)self.service.verticalLineEndPath.CGPath]];
    
    lineAnimation.delegate  = self;
    [self.verticalLineLayer addAnimation:lineAnimation forKey:kLineToPointUpAnimationKey];

    CAAnimationGroup *arrowGroup = [self.service getArrowToLineAnimationWithValues:@[(__bridge id)self.service.arrowStartPath.CGPath,(__bridge id)self.service.arrowDownPath.CGPath,(__bridge id)self.service.arrowMidtPath.CGPath,(__bridge id)self.service.arrowEndPath.CGPath]];
    arrowGroup.delegate  = self;
    [self.arrowLayer addAnimation:arrowGroup forKey:kArrowToLineAnimationKey];
    
}

- (void)removeArrowLayer{
    
    [self.arrowLayer removeFromSuperlayer];
    self.arrowLayer = nil;
}

- (void)removeProgressLabel{
    
    if (self.progressLabel) {
        [self.progressLabel removeFromSuperview];
        [self.progressLabel.layer removeAllAnimations];
        self.progressLabel = nil;
    }
}

- (void)removeDownloadLabel{
    
    if (self.downloadLabel) {
        [self.downloadLabel removeFromSuperview];
        [self.downloadLabel.layer removeAllAnimations];
        self.downloadLabel = nil;
    }
}

- (void)showProgressLabel:(BOOL)isShow{
    
    CASpringAnimation *springAnimation = [self.service getProgressAnimationShow:isShow];
    [self.progressLabel.layer addAnimation:springAnimation forKey:kProgressAnimationKey];
    if (!isShow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeProgressLabel];
        });
    }
}

- (void)showDownloadLabel:(BOOL)isShow{
    
    CASpringAnimation *springAnimation = [self.service getDownloadAnimationShow:isShow];
    [self.downloadLabel.layer addAnimation:springAnimation forKey:kDownloadAnimationKey];
    if (!isShow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeDownloadLabel];
        });
    }
}


- (void)showSuccessAnimation{
    
    CAAnimationGroup *group = [self.service getLineToSuccessAnimationWithValues:@[(__bridge id)self.service.arrowEndPath.CGPath,(__bridge id)self.service.succesPath.CGPath]];
    group.delegate = self;
    [self.arrowLayer addAnimation:group forKey:kSuccessAnimationKey];
    
}

- (void)waveAnimation{
    
    CGFloat progressWaveHeight = 10.0 * ( _progress - powf(_progress, 2)) ;
    //浪
    [self waveWithHeight:_progress < 0.5 ? _waveHeight : progressWaveHeight];
}

#pragma mark - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.verticalLineLayer animationForKey:kLineToPointUpAnimationKey]==anim)
    {
        /* 线到点动画结束 */
        self.userInteractionEnabled =  YES;
        /* 真正动画开始 */
        isAnimating = YES;
        //移除当前arrow
        [self removeArrowLayer];
        //显示progress
        [self showProgressLabel:YES];
        //显示下载大小
        [self showDownloadLabel:YES];
        //浪
        _waveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(waveAnimation) userInfo:nil repeats:YES];
        if ([self.delegate respondsToSelector:@selector(animationStart)]) {
            [self.delegate animationStart];
        }
        
    } else if ([self.arrowLayer animationForKey:kSuccessAnimationKey] == anim){
        /* 结束动画 */
        isAnimating = NO;
   
        if ([self.delegate respondsToSelector:@selector(animationEnd)]) {
            [self.delegate animationEnd];
        }
    }
}


#pragma mark - Hit

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    /* 判断点击区域是否在圆内 */
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [self.layer convertPoint:point toLayer:self.maskCircleLayer];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.maskCircleLayer.path];

    if ([path containsPoint:point] && !isAnimating) {
        
        [self stopAllAnimations];
        
        [self startAnimationBeforeCircle];
    }
}

#pragma mark -- 重置原始状态
- (void)setUpOriginDownloadViewState{
    
    [self stopAllAnimations];
    
    [self startAnimationBeforeCircle];
    
}

@end
