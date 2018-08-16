//
//  TimeView.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/15.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "TimeView.h"
#import "commendFile.h"
#import <Masonry.h>
@interface TimeView()
@property (nonatomic ,strong) UIColor *color;
@property (nonatomic, strong) NSArray *arrayStarTime;
@property (nonatomic, strong) NSArray *arrayEndTime;
//@property (nonatomic, strong) CAShapeLayer *longLayer;
//@property (nonatomic, strong) CAShapeLayer *shortLayer;
//@property (nonatomic, strong) UIBezierPath *longPath;
//@property (nonatomic, strong) UIBezierPath *shortPath;
@property (nonatomic, strong)UIView *longView;
@property (nonatomic, strong) UIView *shortView;
@end

@implementation TimeView
- (UIView *)timeViewWithStarTime:(NSArray *)arrStartTime endTime:(NSArray *)endTime hour:(NSString *)strHour color:(UIColor *)color{
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
    labTime.text = [NSString stringWithFormat:@"时间  %@",strHour];
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
    UILabel *labStart = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 70, 14)];
    labStart.text = @"0:00";
    labStart.textColor = _color;
    labStart.textAlignment = NSTextAlignmentLeft;
    labStart.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labStart];
    UILabel *labEnd = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 85, 40, 70, 14)];
    labEnd.text = @"24:00";
    labEnd.textColor = _color;
    labEnd.textAlignment = NSTextAlignmentRight;
    labEnd.font = [UIFont systemFontOfSize:10];
    [viewFooter addSubview:labEnd];
    
    CGFloat width = (gtWIDTH - 30)/144; //间隔宽度
//    int count = [arrStartTime count];
    for (int index = 0; index<[arrStartTime count]; index ++) {
        int start = [self timeChange:[arrStartTime objectAtIndex:index]];
        int end = [self timeChange:[endTime objectAtIndex:index]];
        int interval = end - start +2;//间隔
        if (interval % 2 == 1) {
            for (int index2 = 0; index2 < interval/2; index2 ++) {
                UIView *longLine = [[UIView alloc] initWithFrame:CGRectMake((start/2 + index2) * width * 2, 28, 1, 10)];
                longLine.backgroundColor = _color;
                [viewFooter addSubview:longLine];
                UIView *shortLine = [[UIView alloc] initWithFrame:CGRectMake((start/2 + index2) * width *2+width, 26, 2, 14)];
                shortLine.backgroundColor = _color;
                [viewFooter addSubview:shortLine];
            }
        }else{
            for (int index3 ; index3 < interval/2; index3 ++) {
                UIView *shortLine = [[UIView alloc] initWithFrame:CGRectMake((start + index3*2)*width, 28, 1, 10)];
                shortLine.backgroundColor = _color;
                [viewFooter addSubview:shortLine];
            }
            for (int index2 = 0; index2 < (interval/2 - 1); index2 ++) {
                UIView *longView = [[UIView alloc] initWithFrame:CGRectMake((start + index2*2)*width + width, 26, 1, 14)];
                longView.backgroundColor = _color;
                [viewFooter addSubview:longView];
            }
        }
        //起始时间显示
        UILabel *labStart = [[UILabel alloc] initWithFrame:CGRectMake(start*width-15, 40, 30, 10)];
        labStart.text = [arrStartTime objectAtIndex:index];
        labStart.textColor = _color;
        labStart.textAlignment = NSTextAlignmentCenter;
        labStart.font = [UIFont systemFontOfSize:8];
        [viewFooter addSubview:labStart];
        
        UILabel *labEnd = [[UILabel alloc] initWithFrame:CGRectMake(start*width+width*interval-15, 40, 30, 10)];
        labEnd.text = [endTime objectAtIndex:index];
        labEnd.textColor = _color;
        labEnd.textAlignment = NSTextAlignmentCenter;
        labEnd.font = [UIFont systemFontOfSize:8];
        [viewFooter addSubview:labEnd];
    }
    
    return view;
}

//- (UIView *)longView{
//    _longView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 2, 40)];
//    _longView.backgroundColor = _color;
//    return _longView;
//}
//
//- (UIView *)shortView{
//    _shortView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, 2, 28)];
//    _shortView.backgroundColor = _color;
//    return _shortView;
//}
//
//- (UIView *)shortView{
//    return _shortView;
//}

//- (CAShapeLayer *)longLayer{
//    _longLayer = [CAShapeLayer layer];
//    _longLayer.path = _longPath.CGPath;
//    _longLayer.strokeColor = _color.CGColor;
//    _longLayer.lineWidth = 2;
//    return _longLayer;
//}
//
//- (CAShapeLayer *)shortLayer{
//    return _shortLayer;
//}
//
//- (UIBezierPath *)longPath{
//    _longPath = [UIBezierPath bezierPath];
//    [_longPath moveToPoint:CGPointMake(0, 15)];
//    [_longPath addLineToPoint:CGPointMake(0, 55)];
//    return _longPath;
//}
//
//- (UIBezierPath *)shortPath{
//    return _shortPath;
//}

- (int)timeChange: (NSString *)strTime{
    int time;
    NSRange range;
    range = [strTime rangeOfString:@":"];
    int min = [[strTime substringFromIndex:2] intValue];
    int hour = [[strTime substringToIndex:2] intValue];
    time = (hour * 60 + min)/10;
    NSLog(@"time == %d",time);
    return time;
}
@end
