//
//  RemoveBindingViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/7.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "RemoveBindingViewController.h"
#import "Time.h"
#import "GTAFNData.h"

@interface RemoveBindingViewController ()<GTAFNDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;

@end

@implementation RemoveBindingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"解除绑定";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _labPhone.text = _strPhone;
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 2;
    _btnSure.layer.masksToBounds = YES;
    _btnSure.layer.cornerRadius = 19;
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnCodeClicked:(id)sender {
    [Time setTheCountdownButton:sender startWithTime:45 title:@"获取验证码" countDownTitle:@"s" mainColor:MAIN_COLOR countColor:MAIN_COLOR];
    if (_textFieldPhone.text.length == 11) {
        GTAFNData *data = [[GTAFNData alloc] init];
        data.delegate = self;
        [data requestSecurityCodeWithPhone:_textFieldPhone.text];
    }else{
        [[GTAlertTool shareInstance] showAlert:@"手机号格式错误" message:@"请重试" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }
}
- (IBAction)btnSureClicked:(id)sender {
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data requestSecuritySaveWithPhone:_textFieldPhone.text code:_textFieldCode.text];
}

-(void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_SECURITY_CODE]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            [[GTAlertTool shareInstance] showAlert:@"验证码发送成功" message:@"请注意查收" cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }else{
            [[GTAlertTool shareInstance] showAlert:@"网络不给力" message:@"请重试" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }
    }else if ([cmd isEqualToString:CMD_SECURITY_SAVE]){
        if ([[data objectForKey:@"code"] intValue] == 0) {
            [[GTAlertTool shareInstance] showAlert:[data objectForKey:@"msg"] message:nil cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                [self btnBackClicked];
            }];
        }else{
            [[GTAlertTool shareInstance] showAlert:@"网络不给力" message:@"请重试" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
        }
    }
}

@end
