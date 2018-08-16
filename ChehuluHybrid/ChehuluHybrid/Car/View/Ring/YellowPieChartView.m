//
//  HKPieChartView.m
//  PieChart
//
//  Created by hukaiyin on 16/6/20.
//  Copyright © 2016年 HKY. All rights reserved.
//

#import "YellowPieChartView.h"

@interface YellowPieChartView()

@property (nonatomic, strong) CAShapeLayer *trackLayer;//背景
@property (nonatomic, strong) CAShapeLayer *progressLayer;//色环
@property (nonatomic, strong) CAShapeLayer *pointLayer;//白点
@property (nonatomic, strong) CAGradientLayer *gradientLayer;//渐变
@property (nonatomic, assign) UIColor *trackColor;
@property (nonatomic, assign) UIColor *progressColor;
@property (nonatomic, assign) UIColor *pointColor;
@property (nonatomic, assign) CGFloat lineWidth;//环宽度
@property (nonatomic, assign) CGFloat pointRedius;//点半径
@property (nonatomic, strong) UIBezierPath *path;//环路径
@property (nonatomic, strong) UIBezierPath *pointPath;//点路径
@property (nonatomic, assign) CGFloat percent; //饼状图显示的百分比，最大为100
@property (nonatomic, assign) CGFloat animationDuration;//动画持续时长
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, assign) CGFloat pathWidth;//环半径
@property (nonatomic, assign) CGFloat sumSteps;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation YellowPieChartView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self updateUI];
}

- (void)updateUI {
    self.trackColor = [UIColor blackColor];
    self.progressColor = [UIColor orangeColor];
    self.pointColor = [UIColor whiteColor];
    self.animationDuration = 3;
    self.pathWidth = self.bounds.size.width;
    self.pointRedius = 4;
    [self shadowImageView];
//    [self trackLayer];
    [self gradientLayer];
    [self pointLayer];
}

#pragma mark - Load

- (void)loadLayer:(CAShapeLayer *)layer WithColor:(UIColor *)color {
    
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}

#pragma mark - Animation

- (void)updatePercent:(CGFloat)percent animation:(BOOL)animationed {
    self.percent = percent;
    [self.progressLayer removeAllAnimations];
    
    if (!animationed) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setAnimationDuration:1];
        
        self.progressLayer.strokeEnd = self.percent / 100.0;
        
        [CATransaction commit];
    } else {
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(self.percent / 100.);
        animation.duration = self.animationDuration * self.percent / 100;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        self.progressLayer.strokeEnd = self.percent / 100;
        [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    self.timer = [NSTimer timerWithTimeInterval:1/60.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self invalidateTimer];
//        self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%", self.percent];
    }
}

- (void)timerAction {
    id strokeEnd = [[_progressLayer presentationLayer] valueForKey:@"strokeEnd"];
    if (![strokeEnd isKindOfClass:[NSNumber class]]) {
        return;
    }
    CGFloat progress = [strokeEnd floatValue];
//    self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",floorf(progress * 100)];
}

- (void)invalidateTimer {
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Getters & Setters
- (CAShapeLayer *)pointLayer{
    if (!_pointLayer) {
        _pointLayer  = [CAShapeLayer layer];
        CGFloat layerWidth = self.pathWidth;
        CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
        _pointLayer.frame = CGRectMake(layerX, 0, 14, 14);
        _pointLayer.fillColor = [UIColor clearColor].CGColor;
        _pointLayer.strokeColor = _pointColor.CGColor;
        //        [self loadLayer:_pointLayer WithColor:self.pointColor];
        _pointLayer.lineCap = kCALineCapRound;
        _pointLayer.path = self.pointPath.CGPath;
        _pointLayer.lineWidth = self.pointRedius*2;
        [self.layer addSublayer:_pointLayer];
    }
    return _pointLayer;
}
- (CAShapeLayer *)trackLayer {
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        [self loadLayer:_trackLayer WithColor:self.trackColor];
        [self.layer addSublayer:_trackLayer];
    }
    return _trackLayer;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _shadowImageView.image = [UIImage imageNamed:@"shadow"];
        [self addSubview:_shadowImageView];
    }
    return _shadowImageView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        [self loadLayer:_progressLayer WithColor:self.progressColor];
        _progressLayer.strokeEnd = 0;
        self.progressLayer.lineCap = kCALineCapRound;
        
        CAShapeLayer *cap = [CAShapeLayer layer];
        cap.shadowColor = [UIColor blackColor].CGColor;
        cap.shadowRadius = 6.0;
        cap.shadowOpacity = 0.9;
        cap.shadowOffset = CGSizeMake(0, 0);
        cap.fillColor = [UIColor grayColor].CGColor;
//        [self.progressLayer addSublayer:cap];
    }
    
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        //颜色
        _gradientLayer.colors = @[(id)[UIColor colorWithRed:252/255.0 green:240/255.0 blue:138/255.0 alpha:1.000].CGColor, (id)[UIColor colorWithRed:254 /255.0 green:239/255.0 blue:110/255.0 alpha:1.0].CGColor];
        _gradientLayer.shadowColor = [UIColor redColor].CGColor;
        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        
        [_gradientLayer setMask:self.progressLayer];
        [self.layer addSublayer:_gradientLayer];
        
    }
    return _gradientLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _progressLabel.textColor = [UIColor colorWithRed:0.310 green:0.627 blue:0.984 alpha:1.000];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:38];

        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    _percent = _percent > 100 ? 100 : _percent;
    _percent = _percent < 0 ? 0 : _percent;
}

- (UIBezierPath *)path {
    if (!_path) {
        
        CGFloat halfWidth = self.pathWidth / 2;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                               radius:(self.pathWidth - self.lineWidth)/2
                                           startAngle:-M_PI/2
                                             endAngle:M_PI/2*3
                                            clockwise:YES];
        _path.lineCapStyle = kCGLineCapRound;
        _path.lineJoinStyle = kCGLineJoinRound;
    }
    return _path;
}

- (UIBezierPath *)pointPath{
    if (!_pointPath) {
        CGFloat halfWidth = self.pathWidth / 2;
        //        _pointPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, halfWidth + 3, 14, 14)];
        _pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth+3, 10 )
                                                    radius:self.pointRedius
                                                startAngle:-M_PI/2
                                                  endAngle:M_PI/2*3
                                                 clockwise:YES];
    }
    return _pointPath;
}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 20;
    }
    return _lineWidth;
}

@end
