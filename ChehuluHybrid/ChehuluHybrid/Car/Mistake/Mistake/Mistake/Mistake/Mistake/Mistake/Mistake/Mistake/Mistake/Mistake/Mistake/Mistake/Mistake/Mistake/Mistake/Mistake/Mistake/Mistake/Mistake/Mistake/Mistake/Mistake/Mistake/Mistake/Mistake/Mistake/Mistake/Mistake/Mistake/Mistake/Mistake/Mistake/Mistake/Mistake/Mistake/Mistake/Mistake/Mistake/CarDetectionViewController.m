//
//  CarDetectionViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/22.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarDetectionViewController.h"
#import "math.h"
#import "CarMistakeViewController.h"
//#import "TestDataViewController.h"

@interface CarDetectionViewController ()
@property (nonatomic, retain) UIView *car;
@property (nonatomic, retain) UIView *environment;
@property (nonatomic, retain) UIImageView *bgMountain;
@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) UIButton *btnShow;
@property (nonatomic, retain) UIButton *btnDismiss;


@property (nonatomic, retain) CABasicAnimation *animationBg;
@property (nonatomic, retain) CABasicAnimation *animationBg2;
@property (nonatomic, retain) CABasicAnimation *animationBg3;
@property (nonatomic, retain) CABasicAnimation *animationBgRemove;

@property (nonatomic, retain) CABasicAnimation *animationBgMountainIn;
@property (nonatomic, retain) CABasicAnimation *animationBgMountainOut;

@property (nonatomic, retain) CABasicAnimation *animationCarIn;
@property (nonatomic, retain) CABasicAnimation *animationCarOut;
@property (nonatomic, retain) CABasicAnimation *animationCarRun;
@end

@implementation CarDetectionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeBlack:@"车况检测"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG_BLACK_DEEP;
    

}

//- (UIBezierPath *)ringBgPath{
//    if (!_ringBgPath) {
//        _ringBgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(80, 0)
//                                                    radius:80
//                                                startAngle:M_PI/6*5
//                                                  endAngle:M_PI/6*13
//                                                 clockwise:YES];
//    }
//    return _ringBgPath;
//}
//- (void)timeCountDown{
//    __block int timeout=0; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.05*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout>100){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                CarMistakeViewController *mistakeVC = [[CarMistakeViewController alloc] init];
//                [self.navigationController pushViewController:mistakeVC animated:YES];
//            });
//        }else{
//            int seconds = timeout;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
////            NSLog(@"strTime == %@",strTime);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                _labPercent.text = [NSString stringWithFormat:@"%d",seconds];
//            });
//            timeout++;
//        }
//    });
//    dispatch_resume(_timer);
//}


+ (instancetype)shareInstance{
    static CarDetectionViewController *instaceSelf = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instaceSelf = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    });
    return instaceSelf;
}

- (void)initBgPanel{
    if (!_environment) {
        _environment = [[UIView alloc] initWithFrame:CGRectMake(-DEFAULT_WIDTH, -DEFAULT_WIDTH, DEFAULT_WIDTH, DEFAULT_WIDTH)];
        _environment.layer.cornerRadius = DEFAULT_WIDTH/2;
        _environment.layer.masksToBounds = YES;
        _environment.backgroundColor = [UIColor cyanColor];
        [self addSubview:_environment];
    }
}

- (void)initBgMountain{
    if (!_bgMountain) {
        _bgMountain = [[UIImageView alloc] initWithFrame:CGRectMake(DEFAULT_WIDTH/4, DEFAULT_WIDTH, DEFAULT_WIDTH/2, DEFAULT_WIDTH/2)];
        _bgMountain.layer.cornerRadius = DEFAULT_WIDTH/4;
        _bgMountain.layer.masksToBounds = YES;
        _bgMountain.image = [UIImage imageNamed:@"bgMountain.png"];
        [_environment addSubview:_bgMountain];
    }
}

- (void)initCar{
    if (!_car) {
        _car = [[UIView alloc] initWithFrame:CGRectMake((DEFAULT_WIDTH-DEFAULT_CAR)/2, DEFAULT_WIDTH, DEFAULT_CAR, DEFAULT_WIDTH)];
        _car.backgroundColor = [UIColor clearColor];
        [_environment addSubview:_car];
        
        UIImageView *littleCar = [[UIImageView alloc] initWithFrame:CGRectMake(0, DEFAULT_WIDTH-DEFAULT_CAR, DEFAULT_CAR, DEFAULT_CAR)];
        littleCar.image = [UIImage imageNamed:@"bike.png"];
        littleCar.layer.cornerRadius = DEFAULT_CAR/2;
        littleCar.layer.masksToBounds = YES;
        [_car addSubview:littleCar];
        
    }
}

- (void)initTipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        _tipLabel.center = self.center;
        _tipLabel.text = @"Hello World!";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:20];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.hidden = true;
        [self addSubview:_tipLabel];
    }
}

- (void)initTipButton{
    if (!_btnShow) {
        _btnShow = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-250)/2, SCREENWIDTH/2+30, 100, 40)];
        _btnShow.backgroundColor = [UIColor orangeColor];
        [_btnShow setTitle:@"Again" forState:UIControlStateNormal];
        [_btnShow addTarget:self action:@selector(startLoadAnimation) forControlEvents:UIControlEventTouchUpInside];
        _btnShow.hidden = true;
        [self addSubview:_btnShow];
        
        _btnDismiss = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-250)/2+150, SCREENWIDTH/2+30, 100, 40)];
        _btnDismiss.backgroundColor = [UIColor lightGrayColor];
        [_btnDismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_btnDismiss addTarget:self action:@selector(dismissLoadAnimation) forControlEvents:UIControlEventTouchUpInside];
        _btnDismiss.hidden = true;
        [self addSubview:_btnDismiss];
    }
}

- (void)startLoadAnimation{
    if (_tipLabel) {
        _tipLabel.hidden = true;
        _btnDismiss.hidden = true;
        _btnShow.hidden = true;
    }
    [_environment.layer addAnimation:_animationBg forKey:@"bgStartIn"];
}

//该方法开放给.h
- (void)showLoadingAnimation:(UIView *)sup{
    
    if (self.hidden) {
        self.hidden = false;
    }
    
    if (!self.superview || self.superview != sup) {
        [sup addSubview:self];
    }
    
    [self initAnimation];
    
    [self initBgPanel];
    [self initBgMountain];
    [self initCar];
    [self initTipLabel];
    [self initTipButton];
    
    
    [self startLoadAnimation];
}

- (void)dismissLoadAnimation{
    self.hidden = true;
    
    [_environment.layer addAnimation:_animationBgRemove forKey:@"bgRemove"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (anim == [_environment.layer animationForKey:@"bgStartIn"] && flag == YES) {
        [_environment.layer addAnimation:_animationBg2 forKey:@"bgStartIn2"];
    }
    else if (anim == [_environment.layer animationForKey:@"bgStartIn2"] && flag == YES) {
        [_environment.layer addAnimation:_animationBg3 forKey:@"bgStartIn3"];
    }
    else if (anim == [_environment.layer animationForKey:@"bgStartIn3"] && flag == YES) {
        [_bgMountain.layer addAnimation:_animationBgMountainIn forKey:@"bgMountainIn"];
    }
    else if (anim == [_bgMountain.layer animationForKey:@"bgMountainIn"] && flag == YES) {
        [_car.layer addAnimation:_animationCarIn forKey:@"foreCarIn"];
    }
    else if (anim == [_car.layer animationForKey:@"foreCarIn"] && flag == YES) {
        [NSThread sleepForTimeInterval:0.2];
        [_car.layer addAnimation:_animationCarRun forKey:@"CarStartUp"];
    }
    else if (anim == [_car.layer animationForKey:@"CarStartUp"] && flag == YES) {
        [_bgMountain.layer addAnimation:_animationBgMountainOut forKey:@"bgMountainOut"];
    }
    else if (anim == [_bgMountain.layer animationForKey:@"bgMountainOut"] && flag == YES) {
        [_car.layer addAnimation:_animationCarOut forKey:@"foreCarOut"];
    }
    else if (anim == [_car.layer animationForKey:@"foreCarOut"] && flag == YES) {
        [_environment.layer addAnimation:_animationBg forKey:@"bgEnd"];
    }
    else if (anim == [_environment.layer animationForKey:@"bgEnd"] && flag == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            _tipLabel.hidden = false;
            _btnDismiss.hidden = false;
            _btnShow.hidden = false;
        }];
    }
}


- (void)initAnimation{
    
#pragma mark - BackGround In
    if (!_animationBg) {
        _animationBg = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _animationBg.toValue = @10;
        _animationBg.delegate = self;
        _animationBg.duration = 0.5;
        _animationBg.removedOnCompletion = NO;
        _animationBg.autoreverses = NO;
        _animationBg.fillMode = kCAFillModeForwards;
        _animationBg.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    if (!_animationBg2) {
        _animationBg2 = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationBg2.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        _animationBg2.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2)];
        _animationBg2.delegate = self;
        _animationBg2.duration = 0.01;
        _animationBg2.removedOnCompletion = NO;
        _animationBg2.autoreverses = NO;
        _animationBg2.fillMode = kCAFillModeForwards;
        _animationBg2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    if (!_animationBg3) {
        _animationBg3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _animationBg3.toValue = @1;
        _animationBg3.delegate = self;
        _animationBg3.duration = 1;
        _animationBg3.removedOnCompletion = NO;
        _animationBg3.autoreverses = NO;
        _animationBg3.fillMode = kCAFillModeForwards;
        _animationBg3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    if (!_animationBgRemove) {
        _animationBgRemove = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationBgRemove.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        _animationBgRemove.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2)];
        _animationBgRemove.delegate = self;
        _animationBgRemove.duration = 0.01;
        _animationBgRemove.removedOnCompletion = NO;
        _animationBgRemove.autoreverses = NO;
        _animationBgRemove.fillMode = kCAFillModeForwards;
        _animationBgRemove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    
#pragma mark - BackGround Mountain In&Out
    if (!_animationBgMountainIn) {
        _animationBgMountainIn = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationBgMountainIn.toValue = [NSValue valueWithCGPoint:CGPointMake(DEFAULT_WIDTH/2, DEFAULT_WIDTH/2)];
        _animationBgMountainIn.delegate = self;
        _animationBgMountainIn.duration = 0.3;
        _animationBgMountainIn.removedOnCompletion = NO;
        _animationBgMountainIn.autoreverses = NO;
        _animationBgMountainIn.fillMode = kCAFillModeForwards;
        _animationBgMountainIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    if (!_animationBgMountainOut) {
        _animationBgMountainOut = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationBgMountainOut.toValue = [NSValue valueWithCGPoint:CGPointMake(DEFAULT_WIDTH/2, DEFAULT_WIDTH*2)];
        _animationBgMountainOut.delegate = self;
        _animationBgMountainOut.duration = 0.3;
        _animationBgMountainOut.removedOnCompletion = NO;
        _animationBgMountainOut.autoreverses = NO;
        _animationBgMountainOut.fillMode = kCAFillModeForwards;
        _animationBgMountainOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    
#pragma mark - ForeGround Car
    if (!_animationCarIn) {
        _animationCarIn = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationCarIn.toValue = [NSValue valueWithCGPoint:CGPointMake(DEFAULT_WIDTH/2, DEFAULT_WIDTH/2)];
        _animationCarIn.delegate = self;
        _animationCarIn.duration = 0.5;
        _animationCarIn.removedOnCompletion = NO;
        _animationCarIn.fillMode = kCAFillModeForwards;
        _animationCarIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    if (!_animationCarOut) {
        _animationCarOut = [CABasicAnimation animationWithKeyPath:@"position"];
        _animationCarOut.toValue = [NSValue valueWithCGPoint:CGPointMake(DEFAULT_WIDTH/2, DEFAULT_WIDTH*2)];
        _animationCarOut.delegate = self;
        _animationCarOut.duration = 0.8;
        _animationCarOut.removedOnCompletion = NO;
        _animationCarOut.autoreverses = NO;
        _animationCarOut.fillMode = kCAFillModeForwards;
        _animationCarOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    }
    
    if (!_animationCarRun) {
        _animationCarRun = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _animationCarRun.toValue = @(2*M_PI);
        _animationCarRun.delegate = self;
        _animationCarRun.duration = 1.5;
        _animationCarRun.removedOnCompletion = NO;
        _animationCarRun.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _animationCarRun.repeatCount = 2;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
