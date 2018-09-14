//
//  BeautyView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeautyView : UIView
@property(readwrite,nonatomic) float grind;//磨皮
@property(readwrite,nonatomic) float whiten;//美白
@property(readwrite,nonatomic) float ruddy;//红润
@property (nonatomic, strong)UISlider *slidergrind;
@property (nonatomic, strong)UISlider *sliderwhiten;
@property (nonatomic, strong)UISlider *sliderruddy;
@property (nonatomic, copy) void(^sliderClick)(float value, int slideNum);
- (void)popShow;
- (void)hide;
@end
