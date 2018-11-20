//
//  WebView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/27.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "WebView.h"
#import <WebKit/WebKit.h>
@interface WebView()<WKNavigationDelegate, WKUIDelegate>{
    NSString *childUrl;
}
@property (nonatomic, strong) WKWebView *webView;
@end
@implementation WebView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
        childUrl = @"";
    }
    return self;
}

-(void)setSubViews{
    [self navView];
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strUrl = [dict objectForKey:@"pay"];
   
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
    if (kIs_iPhoneX) {
        _webView.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88);
    }
    [self addSubview:_webView];
//    NSLog(@"url ==  %@",_strUrl);
    /* 加载服务器url的方法*/
    _strUrl = strUrl;
    NSString *url = strUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
}

- (void)navView{
    UIView *viewNavBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    viewNavBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewNavBg];
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    
    _labTitle.textColor = TEXT_COLOR;
    _labTitle.text = @"充值";
    _labTitle.font = [UIFont systemFontOfSize:16];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    [viewNavBg addSubview:_labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
 
    [btnBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [viewNavBg addSubview:btnBack];
    
    if (kIs_iPhoneX) {
        viewNavBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        _labTitle.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
        btnBack.frame = CGRectMake(0, 44, 44, 44);
    }
}

#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    
    
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",error);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (![navigationAction.request.URL.absoluteString isEqualToString:_strUrl]) {
        if (![navigationAction.request.URL.absoluteString isEqualToString:childUrl]) {
            NSLog(@"url == %@", navigationAction.request.URL.absoluteString);
            NSString *strUrl = [NSString stringWithFormat:@"%@",navigationAction.request.URL.absoluteString];
            NSString *strWeb = @"jiujiu://Web/";
            NSString *strQQ = @"jiujiu://QQ/";
            NSString *strPhone = @"jiujiu://Phone/";
            NSString *strAlipay = @"alipay://";
            NSString *strAlipays = @"alipays://";
            if([strUrl rangeOfString:strWeb].location != NSNotFound){
                strUrl = [strUrl stringByReplacingOccurrencesOfString:strWeb withString:@""];
                childUrl = strUrl;
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
                [webView loadRequest:request];
                decisionHandler(WKNavigationActionPolicyCancel);
            }else if ([strUrl rangeOfString:strQQ].location != NSNotFound){
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                    strUrl = [strUrl stringByReplacingOccurrencesOfString:strQQ withString:@""];
                    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",strQQ];
                    NSURL *url = [NSURL URLWithString:qq];
                    [[UIApplication sharedApplication] openURL:url];
                    decisionHandler(WKNavigationActionPolicyCancel);
                }else{
                    [[GTAlertTool shareInstance]showAlert:@"尚未安装QQ" message:@"请先去商店下载QQ" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                    }];
                    decisionHandler(WKNavigationActionPolicyCancel);
                }
            }else if ([strUrl rangeOfString:strPhone].location != NSNotFound){
                strUrl = [strUrl stringByReplacingOccurrencesOfString:strPhone withString:@""];
                NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", strUrl];
                /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                decisionHandler(WKNavigationActionPolicyCancel);
            }else if ([strUrl hasPrefix:strAlipay]||[strUrl hasPrefix:strAlipays]){
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
                BOOL bSucc = [[UIApplication sharedApplication] openURL:request.URL];
                if (!bSucc) {
                    [[GTAlertTool shareInstance] showAlert:@"未检测到支付宝客户端" message:@"请安装后重试" cancelTitle:@"确定" titleArray:@[@"取消"] viewController:self confirm:^(NSInteger buttonTag) {
                        if (buttonTag == -1) {
                            NSString *alipayPath = @"https://itunes.apple.com/cn/app/支付宝-让生活更简单/id333206289?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4";
                            NSURL *url = [NSURL URLWithString:alipayPath];
                            [[UIApplication sharedApplication] openURL:url];
                            decisionHandler(WKNavigationActionPolicyCancel);
                        }
                    }];
                }else{
                    decisionHandler(WKNavigationActionPolicyAllow);
                }
            }else{
                decisionHandler(WKNavigationActionPolicyAllow);
            }
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}
- (void)popShow {
    [self setSubViews];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
-(void)hide {
    if (self.btnCloseClick) {
        self.btnCloseClick();
    }
    [self removeFromSuperview];
}
@end
