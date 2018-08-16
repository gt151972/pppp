//
//  CircleBg.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/14.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CircleBg.h"
#import "CommendFile.h"
@interface CircleBg(){
    CGFloat greenWidth;
    CGFloat yellowWidth;
    CGFloat blueWidth;
    CGFloat circleWidth;
}
@property (nonatomic, strong)CAShapeLayer *greenLayer;
@property (nonatomic, strong)CAShapeLayer *yellowLayer;
@property (nonatomic, strong)CAShapeLayer *blueLayer;
@property (nonatomic, strong)UIBezierPath *greenPath;
@property (nonatomic, strong)UIBezierPath *yellowPath;
@property (nonatomic, strong)UIBezierPath *bluePath;
@property (nonatomic, strong)UIColor  *greenColor;
@property (nonatomic, strong)UIColor *yellowColor;
@property (nonatomic, strong)UIColor *blueColor;
@end

@implementation CircleBg
#pragma mark - Life Cycle

- (UIView *)circleBackgroundgreenColor:(UIColor *)greenColor yellowColor:(UIColor *)yellowColor blueColor:(UIColor *)blueColor{
    [self initDate];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -10, gtWIDTH, 260)];
//    view.backgroundColor = [UIColor redColor];
    _greenLayer = [CAShapeLayer layer];
    _greenLayer.frame = CGRectMake(gtWIDTH/2, 30+greenWidth/2, greenWidth, greenWidth);//原点frame;
    _greenLayer.fillColor = [UIColor clearColor].CGColor;
    _greenLayer.strokeColor = greenColor.CGColor;
    _greenLayer.lineCap = kCALineCapButt;
    _greenLayer.lineWidth = circleWidth;
    _greenLayer.path = self.greenPath.CGPath;
    [view.layer addSublayer:_greenLayer];
    
    _yellowLayer = [CAShapeLayer layer];
    _yellowLayer.frame = CGRectMake((gtWIDTH - yellowWidth)/2, (260 - yellowWidth)/2, yellowWidth, yellowWidth);//原点frame;
    _yellowLayer.fillColor = [UIColor clearColor].CGColor;
    _yellowLayer.strokeColor = yellowColor.CGColor;
    _yellowLayer.lineCap = kCALineCapButt;
    _yellowLayer.lineWidth = circleWidth;
    _yellowLayer.path = self.yellowPath.CGPath;
    [view.layer addSublayer:_yellowLayer];
    
    _blueLayer = [CAShapeLayer layer];
    _blueLayer.frame = CGRectMake((gtWIDTH - blueWidth)/2, (260 - blueWidth)/2, blueWidth, blueWidth);//原点frame;
    _blueLayer.fillColor = [UIColor clearColor].CGColor;
    _blueLayer.strokeColor = blueColor.CGColor;
    _blueLayer.lineCap = kCALineCapButt;
    _blueLayer.lineWidth = circleWidth;
    _blueLayer.path = self.bluePath.CGPath;
    [view.layer addSublayer:_blueLayer];
    return view;
}

- (void)initDate{
    greenWidth = 200;
    yellowWidth = 158;
    blueWidth = 116;
    circleWidth = 20;
    self.greenColor = [UIColor colorWithRed:22/255 green:41/255 blue:37/255 alpha:1.0];
    self.yellowColor = [UIColor colorWithRed:45/255 green:47/255 blue:36/255 alpha:1.0];
    self.blueColor = [UIColor colorWithRed:25/255 green:43/255 blue:47/255 alpha:1.0];
}

- (UIBezierPath *)greenPath{
    if (!_greenPath) {
        _greenPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0)
                                               radius:(greenWidth - circleWidth)/2
                                           startAngle:-M_PI/2
                                             endAngle:M_PI/2*3
                                            clockwise:YES];
    }
    return _greenPath;
}

- (UIBezierPath *)yellowPath{
    if (!_yellowPath) {
        CGFloat halfWidth = yellowWidth/2;
        _yellowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                                    radius:(yellowWidth - circleWidth)/2
                                                startAngle:-M_PI/2
                                                  endAngle:M_PI/2*3
                                                 clockwise:YES];
    }
    return _yellowPath;
}

- (UIBezierPath *)bluePath{
    if (!_bluePath) {
        CGFloat halfWidth = blueWidth/2;
        _bluePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                                     radius:(blueWidth - circleWidth)/2
                                                 startAngle:-M_PI/2
                                                   endAngle:M_PI/2*3
                                                  clockwise:YES];
    }
    return _bluePath;
}

@end
