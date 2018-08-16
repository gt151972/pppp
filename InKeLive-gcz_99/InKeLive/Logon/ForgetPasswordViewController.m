//
//  ForgetPasswordViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/2.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Time.h"
#import "AutoCommon.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnFindPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 找回密码

 @param sender <#sender description#>
 */
- (IBAction)btnFindPasswordClicked:(id)sender {
}


/**
 获取验证码

 @param sender <#sender description#>
 */
- (IBAction)btnGetCodeClicked:(id)sender {
    [Time setTheCountdownButton:sender startWithTime:45 title:@"获取验证码" countDownTitle:@"s" mainColor:[UIColor redColor] countColor:[UIColor redColor]];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
