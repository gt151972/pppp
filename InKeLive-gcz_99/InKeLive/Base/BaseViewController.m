//
//  BaseViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/13.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar = [UINavigationBar appearance];
    //背景色，文字颜色
    bar.barTintColor = [UIColor whiteColor];
   [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(24, 24, 24)}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}

@end
