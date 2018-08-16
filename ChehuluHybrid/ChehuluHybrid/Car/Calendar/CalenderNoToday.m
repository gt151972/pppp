//
//  CalenderNoToday.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/7.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CalenderNoToday.h"

@implementation CalenderNoToday
- (void)initView{
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 35);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [self.backGroundView.layer setShadowColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    
}

@end
