//
//  isLoginAlert.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/1/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "isLoginAlert.h"
#import "LoginViewController.h"

@implementation isLoginAlert
- (UIAlertController *)isLoginAlert: (NSString *)info : (UIViewController *)vc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:info message:nil preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alertController animated:YES completion:nil];
    if ([info isEqualToString:@"用户未登录！"]) {
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertController addAction:actionCancle];
        [alertController addAction:actionLogin];
    }else if ([info isEqualToString:@"未指定车辆！"]) {
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //跳转车辆选择列表
            
        }];
        [alertController addAction:actionCancle];
        [alertController addAction:actionLogin];
    }
    else{
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:actionCancle];
    }
    return alertController;
}
@end
