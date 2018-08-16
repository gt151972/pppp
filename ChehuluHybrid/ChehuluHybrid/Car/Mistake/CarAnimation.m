//
//  CarAnimation.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/20.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarAnimation.h"
#import <Masonry.h>
#import "CommendFile.h"

@implementation CarAnimation
- (void)showLoadingAnimation:(UIView *)sup color:(UIColor *)color{
    
    if (self.hidden) {
        self.hidden = false;
    }
    
    if (!self.superview || self.superview != sup) {
        [sup addSubview:self];
    }
    [self initView];
    
}

- (void)initView{
    UIImage *image = [UIImage imageNamed:@"CarDetectionBgColor"];
    self.environment = [[UIImageView alloc] initWithFrame:CGRectMake((gtWIDTH - image.size.width)/2, (gtHEIGHT - image.size.height)/2, image.size.width, image.size.height)];
    self.environment.image = image;
    [self addSubview:self.environment];
}

- (void)initAnimation{
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anBasic.toValue = @(self.environment.center.y+300);
    anBasic.beginTime = CACurrentMediaTime() + 1.0f;
    [self.environment pop_addAnimation:anBasic forKey:@"position"];
}

@end
