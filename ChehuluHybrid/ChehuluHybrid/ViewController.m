//
//  ViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/23.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "CommendFile.h"

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property(strong, nonatomic) NSURL *baseURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HUD loadingHUDbg];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"JHJSB"];
    [config.userContentController addScriptMessageHandler:self name:@"TEST"];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)
                                        configuration:config];
    //    [self.wkWebView loadHTMLString:jsCont baseURL:baseURL];
    self.wkWebView.backgroundColor = [UIColor clearColor];
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    NSLog(@"%@", string);
    
    //    [self.wkWebView evaluateJavaScript:jsCont completionHandler:nil];
    //    self.wkWebView.loadRequest[NSURLRequest(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().[[[pathForResource(["sencha", ofType: "js"]! ]]]
    NSString *path = [[NSBundle mainBundle] bundlePath];
    _baseURL = [NSURL fileURLWithPath:path];
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSLog(@"jsPath == %@",jsPath);
    //    NSString *strJsPath = [NSString stringWithFormat:@"%@?action_name=AppHome",jsPath];
    //    NSLog(@"strJsPath == %@",strJsPath);
    NSString *jsCont = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    //    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jsPath]]];
    [self.view addSubview:self.wkWebView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:MAIN_URL,string]]]];
    //    NSLog(@"jsCont == %@",jsCont);
    //    [self.wkWebView loadHTMLString:jsCont baseURL:_baseURL];
    
    // 导航代理
    self.wkWebView.navigationDelegate = self;
    // 与webview UI交互代理
    self.wkWebView.UIDelegate = self;
    self.wkWebView.scrollView.delegate = self;
    //    self.wkWebView.scrollView.zoomScale = 0.5;
    
}

//页面开始加载时
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    self.HUD.delegate = self;
    //    self.HUD.color = [UIColor lightGrayColor];
    //    self.HUD.labelText = @"飞速加载中...";
    ////    [self.HUD hide:YES afterDelay:2];
    //    [self.HUD show:YES];
}

//内容开始返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation");
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //    [self noNetWork];
//    NoNetViewController *noNetVC = [[NoNetViewController alloc] init];
//    [self presentViewController:noNetVC animated:YES completion:nil];
}

//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    //    NSLog(@"str == %@",_str);
    //    if (![_str isEqualToString: @""]) {
    //        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.ActionCreate(%@)",_str] completionHandler:nil];
    //    }
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 发送通知
    [center postNotificationName:@"loadFinish"  object:@"ok"];
    //    NSString *strURL = [NSString stringWithFormat:@"%@",_baseURL];
    //    NSString *strURL2 = [NSString stringWithFormat:@"postPath(\"%@\")",strURL];
    //    NSLog(@"strURL2 == %@",strURL2);
    //    [self.wkWebView evaluateJavaScript:strURL2 completionHandler:^(id object, NSError *error) {
    //        NSLog(@"objext == %@",object);
    //        NSLog(@"error1 == %@",error);
    //    }];
    if (webView.title.length > 0) {
        self.title = webView.title;
    }
    [HUD hidHUD];
}
//WKWebView crash后调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"url == %@",webView.URL);
    [webView reload];
}
#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    //    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"URL == %@", self.wkWebView.URL);
    if (![self.wkWebView.URL.host isEqual:[NSNull null]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              completionHandler();
                                                          }]];
        
        [self presentViewController:alertController animated:YES completion:^{}];    NSLog(@"%@", message);
    }else{
        
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm 1" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框 1" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


//JS调用OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"JS调用OC");
    NSLog(@"%@", message.body);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
