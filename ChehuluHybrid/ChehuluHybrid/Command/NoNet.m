//
//  NoNet.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/31.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "NoNet.h"

@implementation NoNet
- (void)noNetView{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.backGroundView.backgroundColor = COLOR_BG_GRAY;
    [self.backGroundView.layer setShadowColor:[UIColor clearColor].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    UIImage *imgNonet = [UIImage imageNamed:@"noNet"];
    UIImageView *imageNonet  = [[UIImageView alloc] initWithImage:imgNonet];
    [self.backGroundView addSubview:imageNonet];
    [imageNonet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(132);
        make.size.mas_equalTo(imgNonet.size);
        make.centerX.equalTo(self.backGroundView);
    }];
    
    UILabel *labNonet = [[UILabel alloc] init];
    labNonet.text = @"网络连接异常";
    labNonet.textColor = COLOR_TEXT_GARY_DEEP;
    labNonet.textAlignment = NSTextAlignmentCenter;
    labNonet.font = [UIFont systemFontOfSize:14];
    [self.backGroundView addSubview:labNonet];
    [labNonet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageNonet).offset(25);
        make.width.and.centerX.equalTo(self.backGroundView);
        make.height.mas_equalTo(24);
    }];
    
    BaseButton *button = [[BaseButton alloc] init];
    UIButton *btnReload = [button btnWhite:@"重新加载"];
    [btnReload.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnReload addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:btnReload];
    [btnReload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labNonet).offset(28);
        make.centerX.equalTo(self.backGroundView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
}

- (void)btnClicked{
    [_delegate noNetClicked];
}
@end
