//
//  OIlView.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/15.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "OIlView.h"
#import "CommendFile.h"
#import <Masonry.h>
@interface OIlView()
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;//渐变
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;
@end

@implementation OIlView
- (UIView *)oilViewWithColor:(UIColor *)color strOil:(NSString *)strOil array:(NSArray *)array{
    _color = color;
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
    labTime.text = [NSString stringWithFormat:@"油耗  %@L",strOil];
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
    [dashedLineLayer setPosition:CGPointMake(gtWIDTH/2, 45)];
    [dashedLineLayer setFillColor:[UIColor clearColor].CGColor];
    [dashedLineLayer setStrokeColor:color.CGColor];
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
    UILabel *labStart = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 70, 14)];
    labStart.text = @"0:00";
    labStart.textColor = _color;
    labStart.textAlignment = NSTextAlignmentLeft;
    labStart.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labStart];
    UILabel *labEnd = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 85, 50, 70, 14)];
    labEnd.text = @"24:00";
    labEnd.textColor = _color;
    labEnd.textAlignment = NSTextAlignmentRight;
    labEnd.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labEnd];
    
    NSLog(@"dic == %@",array);
    for (int index = 0 ; index < array.count; index ++) {
        int hour = [[[array objectAtIndex:index] objectForKey:@"hour"] intValue];
        NSArray *arrayDetail = [[array objectAtIndex:index] objectForKey:@"min_detail"];
        for (int num = 0; num < arrayDetail.count; num ++) {
            float minOil = [[[arrayDetail objectAtIndex:num] objectForKey:@"min_oil"] floatValue];
            int minType = [[[arrayDetail objectAtIndex:num] objectForKey:@"min_type"] intValue];
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.frame = CGRectMake(0, 0, gtWIDTH - 30, 70);
            _shapeLayer.fillColor = [UIColor clearColor].CGColor;
            _shapeLayer.strokeColor = _color.CGColor;
            _shapeLayer.lineCap = kCALineCapRound;
            float x = (hour * 6 + minType) * (gtWIDTH - 30) / 144;
            _shapeLayer.path = [self path:minOil*20 :x+15].CGPath;
            _shapeLayer.lineWidth = 1;
            [viewFooter.layer addSublayer:_shapeLayer];
        }
    }
    
//    NSArray *arrTestData = @[@12,@34,@2,@13,@2,@4,@13,@25,@4,@24,@12,@34,@2,@13,@2,@4,@13];
//    for (int number = 0; number < arrTestData.count; number ++) {
//        _shapeLayer = [CAShapeLayer layer];
//        _shapeLayer.frame = CGRectMake(0, 0, gtWIDTH - 30, 70);
//        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
//        _shapeLayer.strokeColor = _color.CGColor;
//        _shapeLayer.lineCap = kCALineCapRound;
//        float x = number * (gtWIDTH - 30) / 240;
//        _shapeLayer.path = [self path:[[arrTestData objectAtIndex:number] intValue] :x+15].CGPath;
//        _shapeLayer.lineWidth = 1;
//        [viewFooter.layer addSublayer:_shapeLayer];
//    }
    return view;
}

- (CAGradientLayer *)gradientLayer{
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.colors = @[(id)[UIColor colorWithRed:82/255.0 green:213/255.0 blue:233/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:101/255.0 green:234.0/255 blue:215/255.0 alpha:1.0].CGColor];
    [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
    [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
    [_gradientLayer setShadowRadius:1.0];
    [_gradientLayer setMask:self.shapeLayer];
    [self.layer addSublayer:_gradientLayer];
    return _gradientLayer;
}

- (UIBezierPath *)path : (int)height :(float)x{
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(x, 43)];
    [_path addLineToPoint:CGPointMake(x, 43 - height)];
    _path.lineWidth = 1.0;
    UIColor *fillColor = [UIColor grayColor];
    [fillColor set];
    [_path fill];
    return _path;
}

@end
