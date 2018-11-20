//
//  NoNetViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/20.
//  Copyright © 2018 jh. All rights reserved.
//

#import "NoNetViewController.h"
#import <Reachability.h>
#import "BaseTabBarController.h"
@interface NoNetViewController ()

@end

@implementation NoNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnReloadClicked:(id)sender {
    //注册通知，异步加载，判断网络连接情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
}

/**
 *此函数通过判断联网方式，通知给用户
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == NotReachable) {
    }else{
        // 创建一个通知中心
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"canConnect" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
