//
//  CarbonView.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/18.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarbonView.h"

@implementation CarbonView
- (UIView *)carbonViewWithColor:(UIColor *)color carbon:(NSString *)carbon maxCarbon:(int)maxCarbon{
    _color = color;
    _carbonFloat = [carbon floatValue];
    max = maxCarbon;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 104)];
    //    view.backgroundColor = [UIColor redColor];
    
    UIView *viewInfo = [[UIView alloc] initWithFrame:CGRectMake(15, 0, gtWIDTH - 30, 104)];
    [view addSubview:viewInfo];
    UIView *viewHeader = [[UIView alloc] init];
    [viewInfo addSubview:viewHeader];
    [viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(viewInfo);
        make.height.mas_equalTo(35);
    }];
    UILabel *labTime = [[UILabel alloc] init];
    labTime.text = [NSString stringWithFormat:@"碳排  %@kg",carbon];
    labTime.textColor = color;
    labTime.textAlignment = NSTextAlignmentLeft;
    labTime.font = [UIFont systemFontOfSize:14];
    [viewHeader addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.centerY.and.width.equalTo(viewHeader);
        make.height.mas_equalTo(14);
    }];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(15, 35, gtWIDTH - 30, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:31.0/255 green:35.0/255 blue:38.0/255 alpha:1.0];
    [view addSubview:viewLine];
    
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
    [dashedLineLayer setStrokeColor:[UIColor grayColor].CGColor];
    [dashedLineLayer setLineJoin:kCALineJoinRound];
    [dashedLineLayer setLineWidth:2.0f];
    [dashedLineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 15, 50);
    CGPathAddLineToPoint(path, NULL, gtWIDTH - 15,50);
    [dashedLineLayer setPath:path];
    [viewFooter.layer addSublayer:dashedLineLayer];
    
    //区间
    UILabel *labStart = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 70, 14)];
    labStart.text = @"0";
    labStart.textColor = _color;
    labStart.textAlignment = NSTextAlignmentLeft;
    labStart.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labStart];
    UILabel *labEnd = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 85, 40, 70, 14)];
    labEnd.text = [NSString stringWithFormat:@"%d",maxCarbon];
    labEnd.textColor = _color;
    labEnd.textAlignment = NSTextAlignmentRight;
    labEnd.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labEnd];
    
    float carbonInt = [carbon floatValue]*(gtWIDTH-30)/maxCarbon;
    UIView *viewLineData = [[UIView alloc] initWithFrame:CGRectMake(15, 31, carbonInt, 4)];
    viewLineData.backgroundColor = _color;
    [viewFooter addSubview:viewLineData];
    
    //圈圈
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(0, 0, gtWIDTH - 30, 70);
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.strokeColor = _color.CGColor;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.path = self.pathCircle.CGPath;
    circleLayer.lineWidth = 1;
    [viewFooter.layer addSublayer:circleLayer];
    
    return view;
}

- (UIBezierPath *)pathCircle{
    float index = _carbonFloat*(gtWIDTH-30)/max;
    _pathCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(index+2, 33-6, 12, 12)];
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor set];
    [_pathCircle fill];
    
    UIColor *strokeColor = _color;
    [strokeColor set];
    [_pathCircle stroke];
    return _pathCircle;
}


@end
