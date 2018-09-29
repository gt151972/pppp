//
//  ShareView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/17.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ShareView.h"
@interface ShareView()
@property (nonatomic, strong) UIButton *viewBK;
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) NSArray *arrayImage;
@end
@implementation ShareView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrayTitle = @[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈"];
        _arrayImage = @[@"living_share_qq", @"living_share_space", @"living_share_wechat", @"living_share_circle"];
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews{
    [self addSubview:self.viewBK];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 144, SCREEN_WIDTH, 144)];
    if (kIs_iPhoneX) {
        viewBg.frame = CGRectMake(0, SCREEN_HEIGHT - 144 - 34, SCREEN_WIDTH, 144+34);
    }
    viewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBg];
    
    int widthIcon = 40;
    int interspaceIcon = (SCREEN_WIDTH - (_arrayImage.count*widthIcon))/_arrayImage.count;
    int widthTitle = 60;
    for (int index = 0; index < _arrayImage.count; index ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(interspaceIcon *index + interspaceIcon/2 + widthIcon * index, 20, widthIcon, widthIcon)];
        [button setImage:[UIImage imageNamed:[_arrayImage objectAtIndex:index]] forState:UIControlStateNormal];
        [viewBg addSubview:button];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(interspaceIcon *index + interspaceIcon/2 + widthIcon * index - 10, 75, widthTitle, 14)];
        lable.text = [_arrayTitle objectAtIndex:index];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TEXT_COLOR;
        [viewBg addSubview:lable];
    }
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, 1)];
    viewLine.backgroundColor = RGB(191, 191, 191);
    [viewBg addSubview:viewLine];
    
    UIButton *btnCancle = [[UIButton alloc] initWithFrame:CGRectMake(0, 106, SCREEN_WIDTH, 39)];
    [btnCancle setTitle:@"取消分享" forState:UIControlStateNormal];
    [btnCancle setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [btnCancle addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnCancle];
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
