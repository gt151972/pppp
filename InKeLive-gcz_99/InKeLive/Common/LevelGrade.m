//
//  LevelGrade.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/10.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "LevelGrade.h"
#import <ImageIO/ImageIO.h>

@implementation LevelGrade

+ (LevelGrade *)shareInstance {
    static LevelGrade *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}

- (UIWebView *)greadImage:(int)level{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,16,16)];
    webView.backgroundColor = [UIColor clearColor];
    NSString *resource;
    NSString *type = @"gif";
    
    switch (level) {
        case 1://游客
            resource = @"youke";
            type = @"png";
            break;
        case 2://普通用户
            resource = @"ptyh";
            break;
        case 3://VIP
            resource = @"vip";
            break;
        case 4://红冠
            resource = @"fuhao";
            break;
        case 5://紫冠
            resource = @"caizhu";
            break;
        case 6://超冠
            resource = @"chaoguan";
            break;
        case 7://钻石
            resource = @"tianhuang";
            break;
        case 8://至尊
            resource = @"zun";
            break;
        case 9://天尊
            resource = @"tianzuin";
            break;
        case 21://一级主持
            resource = @"1xing";
            break;
        case 22://二级主持
            resource = @"2xing";
            break;
        case 23://三级主持
            resource = @"3xing";
            break;
        case 24://四级主持
            resource = @"4xing";
            break;
        case 25://五级主持
            resource = @"5xing";
            break;
        case 30://超级主持
            resource = @"cjzc";
            break;
        case 201://灰代理
            resource = @"hdaili";
            break;
        case 205://客服
            resource = @"kefu";
            break;
        case 207://超管
            resource = @"gly";
            break;
        case 210://站长
            resource = @"zhanzhang";
            break;
        case 211://管理员
            resource = @"guanliyuan";
            break;
        default:
            break;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSURL *url = [NSURL URLWithString:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    return webView;
}
@end
