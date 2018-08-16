//
//  IsLoginViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/1/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "IsLoginViewController.h"
#import "LoginViewController.h"

@interface IsLoginViewController ()

@end

@implementation IsLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_strInfo message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    if ([_strInfo isEqualToString:@"用户未登录！"]) {
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertController addAction:actionCancle];
        [alertController addAction:actionLogin];
    }else{
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:actionCancle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
