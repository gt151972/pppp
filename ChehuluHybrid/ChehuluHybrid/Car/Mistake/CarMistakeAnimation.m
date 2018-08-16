//
//  CarMistakeAnimation.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/29.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarMistakeAnimation.h"
#import <POP.h>

@implementation CarMistakeAnimation

- (void) initViewWithSuperView: (UIView *)superView{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, gtHEIGHT - 64)];
    view.backgroundColor = COLOR_MAIN_WHITE;
    [superView addSubview:view];
    
    UIImage *imgCar = [UIImage imageNamed:@"misCarVertical"];
    imageCar = [[UIImageView alloc] initWithImage:imgCar];
    [view addSubview:imageCar];
    [imageCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(imgCar.size);
    }];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(MouseMove1) userInfo:nil repeats:YES];
}

- (void)MouseMove{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
    //    0.4
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0);;
    anim.duration = 0.4;
    [imageCar.layer  pop_addAnimation:anim forKey:@"rotation"];
    
    
    POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim2.toValue = [NSValue valueWithCGSize:CGSizeMake(251, 475)];
    anim2.duration = 0.4;
    [imageCar  pop_addAnimation:anim2 forKey:@"size"];
    
    POPBasicAnimation *anim3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGFloat centerX = gtWIDTH/2;
    CGFloat centerY = gtHEIGHT/2;
    anim3.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
    anim3.duration = 0.4;
    [imageCar  pop_addAnimation:anim3 forKey:@"center"];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(MouseMove1) userInfo:nil repeats:YES];
}

- (void)MouseMove1{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
    UIImage *imgCar = [UIImage imageNamed:@"misScanUp"];
    imageScanDown = [[UIImageView alloc] initWithImage:imgCar];
    [view addSubview:imageScanDown];
    [imageScanDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.centerX.and.width.equalTo(view);
        make.height.mas_equalTo(75);
    }];
    [self scanCar];
}

- (void)scanCar{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CGFloat centerX = gtWIDTH/2;
    CGFloat centerY = gtHEIGHT - 113;
    
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
    anim.duration = 2;
    [imageScanDown  pop_addAnimation:anim forKey:@"center"];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(MouseMove2) userInfo:nil repeats:YES];
}

- (void)MouseMove2{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CGFloat centerX = gtWIDTH/2;
    CGFloat centerY = 61;
    
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
    anim.duration = 2;
    [imageScanDown  pop_addAnimation:anim forKey:@"center"];
    timer=[NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(MouseMove3) userInfo:nil repeats:YES];
}

- (void)MouseMove3{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.2;
    anim.toValue = [NSNumber numberWithFloat:0.f];
    anim.fromValue = [NSNumber numberWithFloat:1.0f];
    [imageScanDown pop_addAnimation:anim forKey:@"center"];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(MouseMove4) userInfo:nil repeats:YES];
}

- (void)MouseMove4{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
//    0.4
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(-M_PI/2);
    anim.duration = 0.4;
    [imageCar.layer  pop_addAnimation:anim forKey:@"rotation"];
    
    
    POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim2.toValue = [NSValue valueWithCGSize:CGSizeMake(159, 322)];
    anim2.duration = 0.4;
    [imageCar  pop_addAnimation:anim2 forKey:@"size"];
    
    POPBasicAnimation *anim3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    anim3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGFloat centerX = gtWIDTH/2;
    CGFloat centerY = 130;
    anim3.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
    anim3.duration = 0.4;
    [imageCar  pop_addAnimation:anim3 forKey:@"center"];


}

@end
