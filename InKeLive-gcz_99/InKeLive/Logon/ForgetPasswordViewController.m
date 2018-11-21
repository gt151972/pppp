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
#import "GTAFNData.h"

@interface ForgetPasswordViewController ()<GTAFNDataDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFindPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@end

@implementation ForgetPasswordViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame]; 
    _textFieldPassword.secureTextEntry = YES;
    _textFieldPassword2.secureTextEntry = YES;
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
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data phoneRetrieveWithPhone:_textFieldPhone.text code:_textFieldCode.text pwd:_textFieldPassword.text];
}


/**
 获取验证码

 @param sender <#sender description#>
 */
- (IBAction)btnGetCodeClicked:(id)sender {
    [Time setTheCountdownButton:sender startWithTime:45 title:@"获取验证码" countDownTitle:@"s" mainColor:MAIN_COLOR countColor:MAIN_COLOR];
    if (_textFieldPhone.text.length == 11) {
        GTAFNData *data = [[GTAFNData alloc] init];
        data.delegate = self;
        [data phoneMsgWithPhone:_textFieldPhone.text reg:@"false"];
    }else{
        [[GTAlertTool shareInstance] showAlert:@"您输入的手机号格式有误" message:@"请重新输入" cancelTitle:nil titleArray:nil viewController:self confirm:nil];
    }
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
    }else if ([cmd isEqualToString:CMD_PASSWORD_FIND]){
        if ([[data objectForKey:@"code"] intValue] == 0) {
            [[GTAlertTool shareInstance]showAlert:@"密码修改成功" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                [self btnBackClicked];
            }];
        }else{
            [[GTAlertTool shareInstance]showAlert:@"提示" message:[data objectForKey:@"msg"] cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }
    }
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
