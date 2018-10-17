//
//  BeautyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "BeautyView.h"
@interface BeautyView()
@property (nonatomic, strong) UIButton *viewBK;
@property (nonatomic, strong) NSArray *arrayTitle;
@end
@implementation BeautyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrayTitle = @[@"磨皮",@"美白",@"红润"];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self addSubview:self.viewBK];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 210, SCREEN_WIDTH, 210)];
    if (kIs_iPhoneX) {
        viewBg.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
    }
    viewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBg];
    NSLog(@"array == %f",_grind);
    for (int index = 0; index < 3; index ++) {
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, index*70+30, 40, 40)];
        labTitle.text = [_arrayTitle objectAtIndex:index];
        labTitle.textColor = [UIColor blackColor];
        labTitle.textAlignment = NSTextAlignmentLeft;
        labTitle.font = [UIFont systemFontOfSize:15];
        [viewBg addSubview:labTitle];
    }
    _slidergrind= [[UISlider alloc] initWithFrame:CGRectMake(50, 30, SCREEN_WIDTH - 90, 40)];
    _slidergrind.minimumValue = 0.0;
    _slidergrind.maximumValue = 100.0;
    [_slidergrind setContinuous:YES];
    _slidergrind.minimumTrackTintColor = MAIN_COLOR;
    _slidergrind.maximumTrackTintColor = MAIN_COLOR;
    _slidergrind.thumbTintColor = MAIN_COLOR;
    _slidergrind.tag = 1000;
    [_slidergrind addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [viewBg addSubview:_slidergrind];
    _sliderwhiten= [[UISlider alloc] initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH - 90, 40)];
    _sliderwhiten.minimumValue = 0.0;
    _sliderwhiten.maximumValue = 100.0;
    [_sliderwhiten setContinuous:YES];
    _sliderwhiten.minimumTrackTintColor = MAIN_COLOR;
    _sliderwhiten.maximumTrackTintColor = MAIN_COLOR;
    _sliderwhiten.thumbTintColor = MAIN_COLOR;
    _sliderwhiten.tag = 1001;
    [_sliderwhiten addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [viewBg addSubview:_sliderwhiten];
    _sliderruddy= [[UISlider alloc] initWithFrame:CGRectMake(50, 170, SCREEN_WIDTH - 90, 40)];
    _sliderruddy.minimumValue = 0.0;
    _sliderruddy.maximumValue = 100.0;
    [_sliderruddy setContinuous:YES];
    _sliderruddy.minimumTrackTintColor = MAIN_COLOR;
    _sliderruddy.maximumTrackTintColor = MAIN_COLOR;
    _sliderruddy.thumbTintColor = MAIN_COLOR;
    _sliderruddy.tag = 1002;
    [_sliderruddy addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [viewBg addSubview:_sliderruddy];
}
-(UIButton*)viewBK {
    if(_viewBK == nil) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _viewBK = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBK.frame = frame;
        _viewBK.backgroundColor = [UIColor clearColor];
        [_viewBK addTarget:self action:@selector(btnBgClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewBK;
}

- (void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"slider value%f",slider.value);
    if (self.sliderClick) {
        self.sliderClick(slider.value, (int)slider.tag - 1000);
    }
}

- (void)btnBgClicked{
    [self hide];
}
- (void)popShow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
-(void)hide {
    [self removeFromSuperview];
}

@end
