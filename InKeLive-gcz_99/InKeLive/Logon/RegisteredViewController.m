//
//  RegisteredViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/2.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "RegisteredViewController.h"
#import <AFNetworking.h>
#import "DPK_NW_Application.h"
#import "CommonAPIDefines.h"
#import "MBProgressHUD+MJ.h"
#import "GTAFNData.h"
#import "Time.h"
@interface RegisteredViewController ()<GTAFNDataDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisteredClicked;

@end

@implementation RegisteredViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"注册中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textFieldPassword.secureTextEntry = YES;
    _textFieldPassword2.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnGetCodeClicked:(id)sender {
    if (_textFieldPhone.text.length == 11) {
        [Time setTheCountdownButton:sender startWithTime:45 title:@"获取验证码" countDownTitle:@"s" mainColor:MAIN_COLOR countColor:MAIN_COLOR];
        GTAFNData *data = [[GTAFNData alloc] init];
        data.delegate = self;
        [data phoneMsgWithPhone:_textFieldPhone.text reg:@"1"];
    }else{
        [[GTAlertTool shareInstance] showAlert:@"您输入的手机号格式有误" message:@"请重新输入" cancelTitle:nil titleArray:nil viewController:self confirm:nil];
    }
}
- (IBAction)btnRegisterClicked:(id)sender {
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data phoneRegWithPhone:_textFieldPhone.text code:_textFieldCode.text pwd:_textFieldPassword.text];
}

-(void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GTAFNDataDelegate
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_REGISTER_SEND_CODE]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            [[GTAlertTool shareInstance]showAlert:@"验证码发送成功" message:@"请注意查收" cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }else{
            [[GTAlertTool shareInstance]showAlert:@"提示" message:[data objectForKey:@"msg"] cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }
    }else if ([cmd isEqualToString:CMD_REGISTER_REQUEST]){
        if ([[data objectForKey:@"code"] intValue] == 0) {
            [[GTAlertTool shareInstance]showAlert:@"注册成功" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DPK_ISLOGON"];
                [[NSUserDefaults standardUserDefaults] setValue:_textFieldPhone.text forKey:@"DPK_USERID"];
                [[NSUserDefaults standardUserDefaults] setValue:_textFieldPassword.text forKey:@"DPK_USERLOGONPWD"];
                
                //发出重新加载个人信息通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
                [self btnBackClicked];
            }];
        }else{
            [[GTAlertTool shareInstance]showAlert:@"提示" message:[data objectForKey:@"msg"] cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }
    }
}


@end
