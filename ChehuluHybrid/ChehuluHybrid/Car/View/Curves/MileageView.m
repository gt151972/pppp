//
//  MileageView.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/15.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MileageView.h"
#import "CommendFile.h"
#import <Masonry.h>
#import <QuartzCore/QuartzCore.h>

@interface MileageView(){
    int max;
}
@property (nonatomic, strong)UIBezierPath *pathFirst;
@property (nonatomic, strong)UIBezierPath *pathSecond;
@property (nonatomic, strong)UIBezierPath *pathThird;
@property (nonatomic, strong)UIBezierPath *pathFirst2;
@property (nonatomic, strong)UIBezierPath *pathSecond2;
@property (nonatomic, strong)UIBezierPath *pathThird2;
@property (nonatomic, strong)UIBezierPath *pathFirst3;
@property (nonatomic, strong)UIBezierPath *pathSecond3;
@property (nonatomic, strong)UIBezierPath *pathThird3;
@property (nonatomic, strong)UIBezierPath *pathCircle;
@property (nonatomic, assign)int count;
@property (nonatomic, strong)UIColor *color;

@end
#define COLOR [UIColor colorWithRed:55/255 green:147/255 blue:108/255 alpha:1.0]
@implementation MileageView
- (UIView *)mileage:(int)count :(UIColor *)color :(int)maxMileage{
    _count = count;
    _color = color;
    max = maxMileage;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, gtWIDTH-30, 104)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *viewHeader = [[UIView alloc] init];
    viewHeader.backgroundColor = [UIColor clearColor];
    [view addSubview:viewHeader];
    [viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view);
        make.height.mas_equalTo(34);
        make.top.equalTo(view);
    }];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, gtWIDTH - 30, 35)];
    labTitle.text = [NSString stringWithFormat:@"里程  %dkm",count];
    labTitle.textColor = color;
    labTitle.textAlignment = NSTextAlignmentLeft;
    labTitle.font = [UIFont systemFontOfSize:16];
    [viewHeader addSubview:labTitle];
//    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.and.width.and.centerY.equalTo(viewHeader);
//        make.left.equalTo(viewHeader);
//    }];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 35, gtWIDTH - 30, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:31.0/255 green:35.0/255 blue:38.0/255 alpha:1.0];
    [view addSubview:viewLine];
//    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(viewHeader.mas_bottom);
//        make.height.mas_equalTo(1);
//        make.width.equalTo(viewHeader);
//    }];
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 36, gtWIDTH - 30, 104-35)];
    viewFooter.backgroundColor = [UIColor clearColor];
    [view addSubview:viewFooter];
//    [viewFooter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(viewLine.mas_bottom);
//        make.bottom.and.width.equalTo(view);
//    }];

    //虚线
    CAShapeLayer *dashedLineLayer = [CAShapeLayer layer];
    [dashedLineLayer setBounds:view.bounds];
    [dashedLineLayer setPosition:CGPointMake(gtWIDTH/2, 35)];
    [dashedLineLayer setFillColor:[UIColor clearColor].CGColor];
    [dashedLineLayer setStrokeColor:color.CGColor];
    [dashedLineLayer setLineJoin:kCALineJoinRound];
    [dashedLineLayer setLineWidth:2.0f];
    [dashedLineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -15, 50);
    CGPathAddLineToPoint(path, NULL, gtWIDTH - 45,50);
    [dashedLineLayer setPath:path];
    [viewFooter.layer addSublayer:dashedLineLayer];
    
    //区间
    UILabel *labStart = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 20, 14)];
    labStart.text = @"0";
    labStart.textColor = _color;
    labStart.textAlignment = NSTextAlignmentLeft;
    labStart.font = [UIFont systemFontOfSize:14];
    [viewFooter addSubview:labStart];
    UILabel *labEnd = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 100, 40, 70, 14)];
    labEnd.text = [NSString stringWithFormat:@"%d",maxMileage];
    labEnd.textColor = _color;
    labEnd.textAlignment = NSTextAlignmentRight;
    labEnd.font = [UIFont systemFontOfSize:14];
    [viewFooter addSubview:labEnd];
    
    //第一段三次贝塞尔曲线主线
    CAShapeLayer *curvesFirstLayer  = [CAShapeLayer layer];
    curvesFirstLayer.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesFirstLayer.fillColor = [UIColor clearColor].CGColor;
    curvesFirstLayer.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesFirstLayer.lineCap = kCALineCapRound;
    curvesFirstLayer.path = self.pathFirst.CGPath;
    curvesFirstLayer.lineWidth = 3;
//    [self loadLayer:curvesFirstLayer WithPath:_pathFirst WithWidth:3];
    [viewFooter.layer addSublayer:curvesFirstLayer];
    
    //两条辅线
    CAShapeLayer *curvesFirstLayer1  = [CAShapeLayer layer];
    curvesFirstLayer1.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesFirstLayer1.fillColor = [UIColor clearColor].CGColor;
    curvesFirstLayer1.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesFirstLayer1.lineCap = kCALineCapRound;
    curvesFirstLayer1.path = self.pathFirst2.CGPath;
    curvesFirstLayer1.lineWidth = 1;
    //    [self loadLayer:curvesFirstLayer WithPath:_pathFirst WithWidth:3];
    [viewFooter.layer addSublayer:curvesFirstLayer1];
    CAShapeLayer *curvesFirstLayer2  = [CAShapeLayer layer];
    curvesFirstLayer2.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesFirstLayer2.fillColor = [UIColor clearColor].CGColor;
    curvesFirstLayer2.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesFirstLayer2.lineCap = kCALineCapRound;
    curvesFirstLayer2.path = self.pathFirst3.CGPath;
    curvesFirstLayer2.lineWidth = 1;
    //    [self loadLayer:curvesFirstLayer WithPath:_pathFirst WithWidth:3];
    [viewFooter.layer addSublayer:curvesFirstLayer2];
    //第二段二次主线
    CAShapeLayer *curvesSecondLayer  = [CAShapeLayer layer];
    curvesSecondLayer.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesSecondLayer.fillColor = [UIColor clearColor].CGColor;
    curvesSecondLayer.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesSecondLayer.lineCap = kCALineCapRound;
    curvesSecondLayer.path = self.pathSecond.CGPath;
    curvesSecondLayer.lineWidth = 3;
//    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesSecondLayer];
    //两条辅线
    CAShapeLayer *curvesSecondLayer2  = [CAShapeLayer layer];
    curvesSecondLayer2.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesSecondLayer2.fillColor = [UIColor clearColor].CGColor;
    curvesSecondLayer2.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesSecondLayer2.lineCap = kCALineCapRound;
    curvesSecondLayer2.path = self.pathSecond2.CGPath;
    curvesSecondLayer2.lineWidth = 1;
    //    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesSecondLayer2];
    CAShapeLayer *curvesSecondLayer3  = [CAShapeLayer layer];
    curvesSecondLayer3.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesSecondLayer3.fillColor = [UIColor clearColor].CGColor;
    curvesSecondLayer3.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesSecondLayer3.lineCap = kCALineCapRound;
    curvesSecondLayer3.path = self.pathSecond3.CGPath;
    curvesSecondLayer3.lineWidth = 1;
    //    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesSecondLayer3];
    //第三段三次主线
    CAShapeLayer *curvesThirdLayer  = [CAShapeLayer layer];
    curvesThirdLayer.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesThirdLayer.fillColor = [UIColor clearColor].CGColor;
    curvesThirdLayer.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesThirdLayer.lineCap = kCALineCapRound;
    curvesThirdLayer.path = self.pathThird.CGPath;
    curvesThirdLayer.lineWidth = 3;
    //    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesThirdLayer];
    //两条辅线
    CAShapeLayer *curvesThirdLayer1  = [CAShapeLayer layer];
    curvesThirdLayer1.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesThirdLayer1.fillColor = [UIColor clearColor].CGColor;
    curvesThirdLayer1.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesThirdLayer1.lineCap = kCALineCapRound;
    curvesThirdLayer1.path = self.pathThird2.CGPath;
    curvesThirdLayer1.lineWidth = 1;
    //    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesThirdLayer1];
    CAShapeLayer *curvesThirdLayer2  = [CAShapeLayer layer];
    curvesThirdLayer2.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    curvesThirdLayer2.fillColor = [UIColor clearColor].CGColor;
    curvesThirdLayer2.strokeColor = _color.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    curvesThirdLayer2.lineCap = kCALineCapRound;
    curvesThirdLayer2.path = self.pathThird3.CGPath;
    curvesThirdLayer2.lineWidth = 1;
    //    [self loadLayer:curvesSecondLayer WithPath:_pathSecond WithWidth:3];
    [viewFooter.layer addSublayer:curvesThirdLayer2];
    
    //圈圈
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(0, 0, gtWIDTH - 30, 70);
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = _color.CGColor;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.path = self.pathCircle.CGPath;
    circleLayer.lineWidth = 1;
    [viewFooter.layer addSublayer:circleLayer];
    return view;
}

/**
 *  第一段三次贝塞尔曲线主线路径
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathFirst{
    float index = _count*(gtWIDTH-30)/max;
    _pathFirst = [UIBezierPath bezierPath];
    [_pathFirst moveToPoint:CGPointMake(0, 35) ];
    [_pathFirst addCurveToPoint:CGPointMake(index/3, 35)//终点
            controlPoint1:CGPointMake(index/6, 45)
            controlPoint2:CGPointMake(index/6, 5)];
    _pathFirst.lineWidth = 2;
    _pathFirst.lineCapStyle = kCGLineCapRound;
    _pathFirst.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathFirst stroke];
//    [self loadThirdPath:_pathFirst withStarPoint:CGPointMake(0, 35) withEndPoint:CGPointMake(index/3, 35) withPoint1:CGPointMake(index/6, 45) withPoint2:CGPointMake(index/6, 5) withWidth:3];
    return _pathFirst;
}

/**
 *  第一段辅助路径2
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathFirst2{
    float index = _count*(gtWIDTH-30)/max;
    _pathFirst2 = [UIBezierPath bezierPath];
    [_pathFirst2 moveToPoint:CGPointMake(0, 35) ];
    [_pathFirst2 addCurveToPoint:CGPointMake(index/3, 35)//终点
                  controlPoint1:CGPointMake(index/6, 35+5)
                  controlPoint2:CGPointMake(index/6, 35-15)];
    _pathFirst2.lineWidth = 1;
    _pathFirst2.lineCapStyle = kCGLineCapRound;
    _pathFirst2.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathFirst2 stroke];
    return _pathFirst2;
}

/**
 *  第一段反方向辅助线
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathFirst3{
    float index = _count*(gtWIDTH-30)/max;
    _pathFirst3 = [UIBezierPath bezierPath];
    [_pathFirst3 moveToPoint:CGPointMake(0, 35) ];
    [_pathFirst3 addCurveToPoint:CGPointMake(index/3, 35)//终点
                   controlPoint1:CGPointMake(index/6, 35- 5)
                   controlPoint2:CGPointMake(index/6, 35+15)];
    _pathFirst3.lineWidth = 1;
    _pathFirst3.lineCapStyle = kCGLineCapRound;
    _pathFirst3.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathFirst3 stroke];
    return _pathFirst3;
}

/**
 *  第二段二次贝塞尔曲线主线路径
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathSecond{
    float index = _count*(gtWIDTH-30)/(max*3);
    _pathSecond = [UIBezierPath bezierPath];
    [_pathSecond moveToPoint:CGPointMake(index, 35)];
    [_pathSecond addQuadCurveToPoint:CGPointMake(index*2, 35) controlPoint:CGPointMake(index*3/2, 70)];
    _pathSecond.lineWidth = 2;
    _pathSecond.lineCapStyle = kCGLineCapRound;
    _pathSecond.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathSecond stroke];
//    [self loadThirdPath:_pathSecond withStarPoint:CGPointMake(index, 35) withEndPoint:CGPointMake(index*2, 35) withPoint1:CGPointMake(index+index/2, 35+30) withPoint2:CGPointMake(index+index/2, 35) withWidth:3];
    return _pathSecond;
}

/**
 *  第二段辅助路径
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathSecond2{
    float index = _count*(gtWIDTH-30)/(max*3);
    _pathSecond2 = [UIBezierPath bezierPath];
    [_pathSecond2 moveToPoint:CGPointMake(index, 35)];
    [_pathSecond2 addQuadCurveToPoint:CGPointMake(index*2, 35) controlPoint:CGPointMake(index*3/2, 35+17)];
    _pathSecond2.lineWidth = 1;
    _pathSecond2.lineCapStyle = kCGLineCapRound;
    _pathSecond2.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathSecond2 stroke];
    //    [self loadThirdPath:_pathSecond withStarPoint:CGPointMake(index, 35) withEndPoint:CGPointMake(index*2, 35) withPoint1:CGPointMake(index+index/2, 35+30) withPoint2:CGPointMake(index+index/2, 35) withWidth:3];
    return _pathSecond2;
}

/**
 *  第二段反方向辅助线
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathSecond3{
    float index = _count*(gtWIDTH-30)/(max * 3);
    _pathSecond3 = [UIBezierPath bezierPath];
    [_pathSecond3 moveToPoint:CGPointMake(index, 35)];
    [_pathSecond3 addQuadCurveToPoint:CGPointMake(index*2, 35) controlPoint:CGPointMake(index*3/2, 35-17)];
    _pathSecond3.lineWidth = 1;
    _pathSecond3.lineCapStyle = kCGLineCapRound;
    _pathSecond3.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathSecond3 stroke];
    //    [self loadThirdPath:_pathSecond withStarPoint:CGPointMake(index, 35) withEndPoint:CGPointMake(index*2, 35) withPoint1:CGPointMake(index+index/2, 35+30) withPoint2:CGPointMake(index+index/2, 35) withWidth:3];
    return _pathSecond3;
}

/**
 *  第三段三次贝塞尔曲线主线路径
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathThird{
    float index = _count*(gtWIDTH-30)/(max *3);
    _pathThird = [UIBezierPath bezierPath];
    [_pathThird moveToPoint:CGPointMake(index*2, 35)  ];
    [_pathThird addCurveToPoint:CGPointMake(index*3, 35)//终点
                   controlPoint1:CGPointMake(index*2+index/2, 35-30)
                   controlPoint2:CGPointMake(index*2+index/2, 35+10)];
    _pathThird.lineWidth = 2;
    _pathThird.lineCapStyle = kCGLineCapRound;
    _pathThird.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathThird stroke];
    return _pathThird;
}

/**
 *  第三段曲线辅助线
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathThird2{
    float index = _count*(gtWIDTH-30)/(max*3);
    _pathThird2 = [UIBezierPath bezierPath];
    [_pathThird2 moveToPoint:CGPointMake(index*2, 35)  ];
    [_pathThird2 addCurveToPoint:CGPointMake(index*3, 35)//终点
                  controlPoint1:CGPointMake(index*2+index/2, 35-15)
                  controlPoint2:CGPointMake(index*2+index/2, 35+5)];
    _pathThird2.lineWidth = 1;
    _pathThird2.lineCapStyle = kCGLineCapRound;
    _pathThird2.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathThird2 stroke];
    return _pathThird2;
}

/**
 *  第三段反向辅助线
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathThird3{
    float index = _count*(gtWIDTH-30)/(max *3);
    _pathThird3 = [UIBezierPath bezierPath];
    [_pathThird3 moveToPoint:CGPointMake(index*2, 35)  ];
    [_pathThird3 addCurveToPoint:CGPointMake(index*3, 35)//终点
                   controlPoint1:CGPointMake(index*2+index/2, 35+15)
                   controlPoint2:CGPointMake(index*2+index/2, 35-5)];
    _pathThird3.lineWidth = 1;
    _pathThird3.lineCapStyle = kCGLineCapRound;
    _pathThird3.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathThird3 stroke];
    return _pathThird3;
}

/**
 *  圈圈
 *
 *  @return <#return value description#>
 */
- (UIBezierPath *)pathCircle{
    float index = _count*(gtWIDTH-30)/max;
    _pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(index, 35-6, 12, 12)];
    UIColor *fillColor = [UIColor clearColor];
    [fillColor set];
    [_pathCircle fill];
    
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathCircle stroke];
    return _pathCircle;
}

- (void)loadLayer:(CAShapeLayer *)layer WithPath:(UIBezierPath *)path WithWidth: (CGFloat)width {
    layer.frame = CGRectMake(0, 0, gtWIDTH - 30, 70);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = _color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = width;
    layer.path = path.CGPath;
}

- (void)loadThirdPath: (UIBezierPath *)path withStarPoint: (CGPoint)startPoint withEndPoint: (CGPoint)endPoint withPoint1:(CGPoint)point1 withPoint2: (CGPoint)point2 withWidth: (CGFloat)width{
    path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint//终点
                  controlPoint1:point1
                  controlPoint2:point2];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    UIColor *strokeColor = _color;
    [strokeColor set];
    [path stroke];
}

@end
