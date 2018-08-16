
//
//  LoginViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/27.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textFieldPhone;
@property (nonatomic, strong)UITextField *textFieldCode;
@property (nonatomic, strong)UIButton *btnGetCode;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    indexDAL=[[IndexRequestDAL alloc]init];
    indexDAL.delegate=self;
    UIImageView *imageViewBg = [[UIImageView alloc] init];
    imageViewBg.image = [UIImage imageNamed:@"loginBg"];
    [self.view addSubview:imageViewBg];
    [imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.and.centerY.equalTo(SW);
    }];
    
    UIImage *imageClose = [UIImage imageNamed:@"close"];
    UIButton *btnClose = [[UIButton alloc] init];
    [btnClose setImage:imageClose forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(imageClose.size);
    }];
    
    UIImage *imageHead = [UIImage imageNamed:@"loginHead"];
    UIImageView *imageViewHead = [[UIImageView alloc] init];
    imageViewHead.image = imageHead;
    [self.view addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SW);
        make.size.mas_equalTo(imageHead.size);
        make.top.mas_equalTo(60);
    }];
    
    UIView *viewPhone = [[UIView alloc] init];
    viewPhone.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewPhone];
    [viewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SW);
        make.top.equalTo(imageViewHead.mas_bottom).offset(33);
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(25);
    }];
    
    UIImage *imagePhone = [UIImage imageNamed:@"phone"];
    UIImageView *imageViewPhone = [[UIImageView alloc] init];
    imageViewPhone.image = imagePhone;
    [viewPhone addSubview:imageViewPhone];
    [imageViewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.centerY.equalTo(viewPhone);
        make.size.mas_equalTo(imagePhone.size);
    }];
    
    _textFieldPhone = [[UITextField alloc] init];
    _textFieldPhone.tag = 301;
    _textFieldPhone.delegate = self;
    _textFieldPhone.placeholder = @"手机号";
    _textFieldPhone.textColor = [UIColor blackColor];
    _textFieldPhone.textAlignment = NSTextAlignmentLeft;
    _textFieldPhone.font = [UIFont systemFontOfSize:16];
    _textFieldPhone.keyboardType = UIKeyboardTypeNumberPad;
//    [_textFieldPhone addTarget:self action:@selector(keyboardExit:) forControlEvents:UIControlEventEditingDidBegin];
    [viewPhone addSubview:_textFieldPhone];
    [_textFieldPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageViewPhone.mas_right).offset(10);
        make.height.equalTo(viewPhone);
        make.centerX.mas_equalTo(200);
        make.top.equalTo(viewPhone);
    }];
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = [super colorWithHexString:@"#dddddd"];
    [viewPhone addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.width.and.left.equalTo(viewPhone);
        make.height.mas_equalTo(1);
    }];
    
    UIView *viewCode = [[UIView alloc] init];
    viewCode.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewCode];
    [viewCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewPhone.mas_bottom).offset(33);
        make.size.and.centerX.equalTo(viewPhone);
    }];
    
    UIImageView *imageViewCode = [[UIImageView alloc] init];
    UIImage *imageCode = [UIImage imageNamed:@"code"];
    imageViewCode.image = imageCode;
    [viewCode addSubview:imageViewCode];
    [imageViewCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.centerY.equalTo(viewCode);
        make.size.mas_equalTo(imageCode.size);
    }];
    
    _textFieldCode = [[UITextField alloc] init];
    _textFieldCode.tag = 302;
    _textFieldCode.delegate = self;
    _textFieldCode.placeholder = @"验证码";
    _textFieldCode.textColor = [UIColor blackColor];
    _textFieldCode.textAlignment = NSTextAlignmentLeft;
    _textFieldCode.font = [UIFont systemFontOfSize:16];
    _textFieldCode.keyboardType = UIKeyboardTypeNumberPad;

    [viewCode addSubview:_textFieldCode];
    [_textFieldCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageViewCode.mas_right).offset(10);
        make.height.equalTo(viewCode);
        make.centerX.mas_equalTo(200);
        make.top.equalTo(viewCode);
    }];
    
    _btnGetCode = [[UIButton alloc] init];
    [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnGetCode setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
    [_btnGetCode.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_btnGetCode addTarget:self action:@selector(btnGetCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewCode addSubview:_btnGetCode];
    [_btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.height.equalTo(viewCode);
        make.width.mas_equalTo(100);
    }];

    UIView *viewLine2 = [[UIView alloc] init];
    viewLine2.backgroundColor = [super colorWithHexString:@"#dddddd"];
    [viewCode addSubview:viewLine2];
    [viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.width.and.left.equalTo(viewCode);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *btnSubmit = [[UIButton alloc] init];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 20;
    [btnSubmit setBackgroundColor:COLOR_MAIN_GREEN];
    [btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SW);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(430);
    }];
    
    UILabel *labAgree = [[UILabel alloc] init];
    labAgree.text = @"登录即默认登录";
    labAgree.textColor = [UIColor blackColor];
    labAgree.textAlignment = NSTextAlignmentRight;
    labAgree.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labAgree];
    [labAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SW);
        make.top.equalTo(btnSubmit.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(gtWIDTH/2+10, 10));
    }];
    UIButton *btnProtocol = [[UIButton alloc] init];
    [btnProtocol setTitle:@"《智驾协议》" forState:UIControlStateNormal];
    btnProtocol.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnProtocol.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnProtocol setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
    [btnProtocol addTarget:self action:@selector(btnProtocolClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnProtocol];
    [btnProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labAgree.mas_right);
        make.size.and.top.equalTo(labAgree);
    }];
}

#pragma mark -- UITextFieldDelegate
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    NSLog(@"%@",textField.text);
//    return YES;
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"return == %@",textField.text);
//    return YES;
//}


#pragma mark -- Action
- (void)btnCloseClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnGetCodeClicked{
    //    [super showLoading];
    
    [indexDAL getVerifyCode:_textFieldPhone.text];
    if (_textFieldPhone.text.length != 0 && _textFieldPhone.text.length == 11) {
        __block int timeout=45; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                    _btnGetCode.userInteractionEnabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
//                    NSLog(@"____%@",strTime);
                    [_btnGetCode setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    _btnGetCode.userInteractionEnabled = NO;
                    _btnGetCode.titleLabel.font = [UIFont systemFontOfSize:18];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)btnSubmitClicked{
    if (_textFieldPhone.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if (_textFieldCode.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入验证码" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if (_textFieldPhone.text.length != 11){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else if (_textFieldCode.text.length != 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的验证码" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [indexDAL loginWithMobile:_textFieldPhone.text verfycode:_textFieldCode.text];

    }
}

- (void)btnProtocolClicked{
    WebViewController *webVC = [[WebViewController alloc] init];
    [self presentViewController:webVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1) {
        if ([cmd isEqualToString:@"getVerifyCode"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:@"请查收" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else if ([cmd isEqualToString:@"login"]){
            NSDictionary *info = [dic objectForKey:@"info"];
            NSDictionary *dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [info objectForKey:@"usertoken"], @"usertoken",
                                     [info objectForKey:@"mobile" ], @"mobile",
                                     [info objectForKey:@"expire" ], @"expire",
                                     [info objectForKey:@"has_buy_safety" ], @"has_buy_safety",
                                     [info objectForKey:@"has_last_safety" ], @"has_last_safety",
                                     [info objectForKey:@"is_fakecar" ], @"is_fakecar",
                                     [info objectForKey:@"is_obd" ], @"is_obd",
                                     [info objectForKey:@"traff_status" ], @"traff_status",
                                     nil];
            
            NSDictionary *dicInfo2 = [super nullToEmpty:dicInfo];
            [[NSUserDefaults standardUserDefaults] setObject:dicInfo2  forKey:@"DicUserInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"usertoken"] forKey:@"usertoken"];
            NSDictionary *dicArea;
            if ([info objectForKey:@"area_info"]) {
                dicArea = [[NSDictionary alloc] initWithDictionary:[info objectForKey:@"area_info"]];
                NSDictionary *dicArea2 = [super nullToEmpty:dicArea];
                [[NSUserDefaults standardUserDefaults] setObject:dicArea2 forKey:@"DicArea"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
