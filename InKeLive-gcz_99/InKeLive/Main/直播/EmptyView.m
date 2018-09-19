//
//  EmptyView.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "EmptyView.h"

#define BackGroundColor RGB(239, 239, 239)
#define EmptyMargin (SCREEN_WIDTH - 200)/2

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.emptyImageView];
        //对子View进行约束
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(176, 136));
            make.top.equalTo(@89);
        }];
        UILabel *labEmpty = [[UILabel alloc] init];
        labEmpty.text = @"当前界面空空如也~";
        labEmpty.font = [UIFont systemFontOfSize:12];
        labEmpty.textAlignment = NSTextAlignmentCenter;
        labEmpty.textColor = RGB(32, 32, 32);
        [self addSubview:labEmpty];
        [labEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emptyImageView.mas_bottom).offset(18);
            make.width.centerX.equalTo(self);
            make.height.equalTo(@13);
        }];
    }
    return self;
}


- (UIImageView *)emptyImageView{
    if (!_emptyImageView) {
        //创建ImageView 并加载图片
        _emptyImageView = [[UIImageView alloc]init];
        _emptyImageView.image = [UIImage imageNamed:@"emptyIcon"];
    }
    return _emptyImageView;
}

@end
