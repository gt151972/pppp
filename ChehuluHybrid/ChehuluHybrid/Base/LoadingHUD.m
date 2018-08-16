//
//  LoadingHUD.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "LoadingHUD.h"
#import <POP.h>

@implementation LoadingHUD
- (void)loadingHUD{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [self.backGroundView.layer setShadowColor:[UIColor clearColor].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    UIImage *imgLoading = [UIImage imageNamed:@"loading"];
    UIImageView *imageLoading = [[UIImageView alloc] initWithImage:imgLoading];
    [self.backGroundView addSubview:imageLoading];
    [imageLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.size.mas_equalTo(imgLoading.size);
        make.centerX.equalTo(self.backGroundView);
    }];
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(M_PI*2);
    anim.duration = 1;
    anim.repeatCount = 500;
    [imageLoading.layer  pop_addAnimation:anim forKey:@"rotation"];

    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)hidHUD{
    [self removeFromSuperview];
}

- (void)loadingHUDbg{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [self.backGroundView.layer setShadowColor:[UIColor clearColor].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    UIImage *imgBg = [UIImage imageNamed:@"hudBG"];
    UIImageView *imageBg = [[UIImageView alloc] initWithImage:imgBg];
    [self.backGroundView addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgBg.size);
        make.centerX.equalTo(self.backGroundView);
        make.centerY.equalTo(self.backGroundView).offset(-64);
    }];
    
    UIImage *imgLoading = [UIImage imageNamed:@"hud"];
    UIImageView *imageLoading = [[UIImageView alloc] initWithImage:imgLoading];
    [self.backGroundView addSubview:imageLoading];
    [imageLoading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgLoading.size);
        make.centerX.equalTo(self.backGroundView);
        make.centerY.equalTo(self.backGroundView).offset(-64);
    }];
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(M_PI*2);
    anim.duration = 1;
    anim.repeatCount = 500;
    [imageLoading.layer  pop_addAnimation:anim forKey:@"rotation"];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)hidHUDbg{
    [self removeFromSuperview];
}
@end
