//
//  WebView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/27.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "WebView.h"

@implementation WebView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    
}

- (void)navView{
    UIView *viewNavBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    viewNavBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewNavBg];
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    _labTitle.textColor = TEXT_COLOR;
    _labTitle.font = [UIFont systemFontOfSize:16];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    [viewNavBg addSubview:_labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    
    if (kIs_iPhoneX) {
        viewNavBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        _labTitle.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
        btnBack.frame = CGRectMake(0, 20, 44, 44);
    }
}
@end
