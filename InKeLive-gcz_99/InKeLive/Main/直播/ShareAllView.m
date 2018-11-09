//
//  ShareAllView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/9.
//  Copyright © 2018 jh. All rights reserved.
//

#import "ShareAllView.h"
#import "MBProgressHUD+MJ.h"
@interface ShareAllView()
@property (nonatomic, strong) UIButton *viewBK;
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) NSArray *arrayImage;
@end
@implementation ShareAllView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _arrayTitle = @[@"复制链接",@"尚未开启",@"尚未开启",@"尚未开启",@"尚未开启"];
        _arrayImage = @[@"living_shareAll_copy", @"living_shareAll_qq", @"living_shareAll_square", @"living_shareAll_wechat",@"living_shareAll_circle"];
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews{
    [self addSubview:self.viewBK];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 160, SCREEN_WIDTH, 160)];
    if (kIs_iPhoneX) {
        viewBg.frame = CGRectMake(0, SCREEN_HEIGHT - 160 - 34, SCREEN_WIDTH, 160+34);
    }
    viewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBg];
    
    int widthIcon = 40;
    int interspaceIcon = (SCREEN_WIDTH - (_arrayImage.count*widthIcon))/_arrayImage.count;
    int widthTitle = 60;
    for (int index = 0; index < _arrayImage.count; index ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(interspaceIcon *index + interspaceIcon/2 + widthIcon * index, 14, widthIcon, widthIcon)];
        [button setImage:[UIImage imageNamed:[_arrayImage objectAtIndex:index]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:500+index];
        [viewBg addSubview:button];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(interspaceIcon *index + interspaceIcon/2 + widthIcon * index - 10, 64, widthTitle, 14)];
        lable.text = [_arrayTitle objectAtIndex:index];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TEXT_COLOR;
        [viewBg addSubview:lable];
        
        
    }
    
//    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, 1)];
//    viewLine.backgroundColor = RGB(191, 191, 191);
//    [viewBg addSubview:viewLine];
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 84, 190, 31)];
    [imageBg setImage:[UIImage imageNamed:@"living_shareAll_bg"]];
    [viewBg addSubview:imageBg];
    
    UILabel *labCopy = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 190, 12)];
    labCopy.text = @"复制黏贴，发送给好友下载！";
    labCopy.textColor = TEXT_COLOR;
    labCopy.font = [UIFont systemFontOfSize:12];
    labCopy.textAlignment = NSTextAlignmentCenter;
    [imageBg addSubview:labCopy];
    
    UIButton *btnCancle = [[UIButton alloc] initWithFrame:CGRectMake(0, 134, SCREEN_WIDTH, 20)];
    [btnCancle setTitle:@"取消分享" forState:UIControlStateNormal];
    [btnCancle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
- (void)btnShareClicked:(UIButton *)button{
    if (button.tag == 500) {
        NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString*cachePath = array[0];
        NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
        NSString *strUrl = [dict objectForKey:@"share"];
        [MBProgressHUD showAlertMessage:@"链接已复制到剪贴板"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = strUrl;
    }
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
