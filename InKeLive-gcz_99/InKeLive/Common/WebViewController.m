//
//  WebViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/10.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate, WKUIDelegate>{
    NSString *childUrl;
}
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation WebViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        childUrl = @"";
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([_strTitle isEqualToString:@"排行榜"]){
        [self.navigationController setNavigationBarHidden:YES];
        [self nav];
    }else{
        self.title = _strTitle;
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
        self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    }
}

- (void)nav{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = RGB(204, 174, 235);
    [self.view addSubview:view];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [view addSubview:viewBg];
    if (kIs_iPhoneX) {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        viewBg.frame = CGRectMake(0, 22, SCREEN_WIDTH, 64);
    }
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnBack];
    
    UIButton *btnWeek = [[UIButton alloc] initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH/2-22, 44)];
    [btnWeek setTitle:@"幸运周星榜" forState:UIControlStateNormal];
    [btnWeek setTitleColor:RGB(119, 59, 175) forState:UIControlStateSelected];
    [btnWeek setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [btnWeek setTag:201];
    btnWeek.selected = YES;
    [btnWeek addTarget:self action:@selector(btnHeadViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnWeek];
    
    UIButton *btnDay = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+22, 20, SCREEN_WIDTH/2-22, 44)];
    [btnDay setTitle:@"幸运日星榜" forState:UIControlStateNormal];
    [btnDay setTitleColor:RGB(119, 59, 175) forState:UIControlStateSelected];
    [btnDay setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [btnDay setTag:202];
    [btnDay addTarget:self action:@selector(btnHeadViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnDay];
    
    [btnWeek.titleLabel sizeToFit];
    self.viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 61, btnWeek.titleLabel.width, 3)];
    self.viewLine.backgroundColor = RGB(119, 59, 175);
    self.viewLine.centerX = btnWeek.centerX;
    [viewBg addSubview:self.viewLine];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearWbCache];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    [self.view addSubview:_webView];
    NSLog(@"url ==  %@",_strUrl);
    /* 加载服务器url的方法*/
    NSString *url = _strUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;

}

- (void)clearWbCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
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
            }
            
        }else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
//    [webView reload];
//}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnHeadViewClicked: (UIButton *)button{
    UIButton *btnWeek = (UIButton *)[self.view viewWithTag:201];
    UIButton *btnDay = (UIButton *)[self.view viewWithTag:202];
    if (button.tag == 201) {
        NSString *url = _strUrl;
        url = [url stringByReplacingOccurrencesOfString:@"key=2"withString:@"key=1"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
        _strUrl = url;
        btnWeek.selected = YES;
        btnDay.selected = NO;
    }else if (button.tag == 202){
        NSString *url = _strUrl;
        url = [url stringByReplacingOccurrencesOfString:@"key=1"withString:@"key=2"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
        _strUrl = url;
        btnWeek.selected = NO;
        btnDay.selected = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.viewLine.centerX = button.centerX;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
