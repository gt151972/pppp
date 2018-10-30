//
//  ShareCopyView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/10/30.
//  Copyright © 2018 jh. All rights reserved.
//

#import "ShareCopyView.h"
#import "MBProgressHUD+MJ.h"
@interface ShareCopyView()
@property (nonatomic, strong) UIButton *viewBK;
@end;
@implementation ShareCopyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews{
    [self addSubview:self.viewBK];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 144)];
    if (kIs_iPhoneX) {
        viewBg.frame = CGRectMake(0, SCREEN_HEIGHT - 44 - 34, SCREEN_WIDTH, 44+34);
    }
    viewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBg];
    
    UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [btnLink setImage:[UIImage imageNamed:@"login_icon_link"] forState:UIControlStateNormal];
    [btnLink.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnLink setTitle:@" 复制粘贴,发送给好友下载" forState:UIControlStateNormal];
    [btnLink setTitleColor:RGB(57, 57, 57) forState:UIControlStateNormal];
    [btnLink addTarget:self action:@selector(btnLickClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnLink];
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

- (void)btnLickClicked{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strUrl = [dict objectForKey:@"share"];
    [MBProgressHUD showAlertMessage:@"链接已复制到剪贴板"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = strUrl;
    [self hide];
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
