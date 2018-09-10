//
//  TopToolView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/9.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "TopToolView.h"

@implementation TopToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor]; //背景透明
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    UIButton *btnSpecialEffects = [[UIButton alloc] init];
    [btnSpecialEffects setImage:[UIImage imageNamed:@"living_special_effects"] forState:UIControlStateNormal];
    [btnSpecialEffects setImage:[UIImage imageNamed:@"living_special_turndown"] forState:UIControlStateSelected];
    [btnSpecialEffects addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSpecialEffects setTag:511];
    [self addSubview:btnSpecialEffects];
    
    UIButton *btnShare = [[UIButton alloc] init];
    [btnShare setImage:[UIImage imageNamed:@"living_share"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTag:512];
    [self addSubview:btnShare];
    
    UIButton *btnUserList = [[UIButton alloc] init];
    [btnUserList setImage:[UIImage imageNamed:@"living_user_list"] forState:UIControlStateNormal];
    [btnUserList addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnUserList setTag:513];
    [self addSubview:btnUserList];
    
    UIButton *btnClose = [[UIButton alloc] init];
    [btnClose setImage:[UIImage imageNamed:@"living_close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTag:514];
    [self addSubview:btnClose];
    NSInteger padding = 0;
    
    [@[btnSpecialEffects,btnShare,btnUserList,btnClose] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:0 tailSpacing:0];
    [@[btnSpecialEffects,btnShare,btnUserList,btnClose] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height);
        make.bottom.mas_equalTo(self);
    }];

}

- (void)btnClicked:(UIButton *)btn{
    self.toolClicked(btn);
}

@end
