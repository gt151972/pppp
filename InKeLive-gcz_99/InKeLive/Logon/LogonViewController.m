//
//  LogonViewController.m
//  InKeLive
//
//  Created by gu  on 17/8/12.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "LogonViewController.h"

#import "DPK_NW_Application.h"
#import <QuartzCore/QuartzCore.h>

#import "NSString+Common.h"
#import <AFNetworking.h>
#import "MBProgressHUD+MJ.h"

#import "CommonAPIDefines.h"
#import "AppDelegate.h"

#import "ForgetPasswordViewController.h"
#import "RegisteredViewController.h"

@interface LogonViewController ()

@property(nonatomic, assign) BOOL isLogining;
@property(nonatomic, strong) MBProgressHUD* hud;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHead;

@end

@implementation LogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    //为导航栏左侧添加系统自定义按钮
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(perFormAdd:)];
    
    //UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    
//    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
//    [backButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem=backButton;
    
    //UIButton *backButton = [UIButton buttonWithType:101];
    //[backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //[backButton setTitle:@"返回" forState:UIControlStateNormal];
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //self.navigationItem.leftBarButtonItem= backItem;
    
//    self.navigationItem.title = @"登录";
    
    //设置TextFiled/textView 的边框
#if 0
    textView.layer.borderColor = [UIColorgrayColor].CGColor;
    textView.layer.borderWidth =1.0;
    textView.layer.cornerRadius =5.0;
#endif 
    
    //增加主View的点击事件，注意去除Button的影响
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];

    
}
-(UIImageView *)imgViewHead{
    _imgViewHead.layer.masksToBounds = YES;
    _imgViewHead.layer.cornerRadius = 48;
    _imgViewHead.backgroundColor = [UIColor grayColor];
    return _imgViewHead;
}

- (void)eventTapGesture:(UITapGestureRecognizer *)gesture
{
    [self.edtUserID resignFirstResponder];
    [self.edtUserPwd resignFirstResponder];
}



#pragma mark  登录
- (IBAction)logonButtonClicked:(id)sender {
    [self sendUserLogonRequest];
    return;
    
    
    [DPK_NW_Application sharedInstance].isLogon = YES;
//    发出重新加载个人信息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
//    测试代码 testcode
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 忘记密码
- (IBAction)btnForgetPassword:(id)sender {
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:NO];
}

#pragma mark 新用户注册
- (IBAction)btnRegistered:(id)sender {
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc] init];
    [self.navigationController pushViewController:registeredVC animated:NO];
}


/**
 密码可见切换

 @param sender <#sender description#>
 */
- (IBAction)btnPasswordClicked:(UIButton *)sender {
    self.edtUserPwd.enabled = NO;    // the first one;
    self.edtUserPwd.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    self.edtUserPwd.enabled = YES;  // the second one;
    [self.edtUserPwd becomeFirstResponder];
}


#pragma mark  三方登录

/**
 微信登录

 @param sender <#sender description#>
 */
- (IBAction)btnWeichatLogin:(id)sender {
}


/**
 QQ登录

 @param sender <#sender description#>
 */
- (IBAction)btnQQLogin:(id)sender {
}


-(void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showLoadingHud {
    //======================
    //圆形进度条
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.hud = [[MBProgressHUD alloc]initWithFrame:frame];
    //全屏禁止
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    //[self.view addSubview:hud];
    //当前view背景颜色暗下去
    self.hud.minShowTime= 10000;
    self.hud.dimBackground =YES;
    self.hud.labelText = @"正在登录...";
    [self.hud showAnimated:YES whileExecutingBlock:^{
        //sleep(2);
    } completionBlock:^{
        //[hud removeFromSuperview];
    }];
    //=====================
}

-(void)hideLoadingHud {
    [self.hud removeFromSuperview];
}

-(void) sendUserLogonRequest {
    if(self.isLogining) return;
    
    NSString* strUserLogonAccount = self.edtUserID.text;
    NSString* strUserLogonPwd = self.edtUserPwd.text;
    strUserLogonAccount = [strUserLogonAccount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(strUserLogonAccount.length <=0)
        return;
    strUserLogonPwd = [NSString md5:strUserLogonPwd];
    
    self.isLogining  =YES;
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    userData.tmpLogonAccount =strUserLogonAccount;
    userData.tmpLogonPwd =strUserLogonPwd;
    //网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@"mobile"];
    [parameters setObject:@"" forKey:@"authCode"];
    [parameters setObject:strUserLogonAccount forKey:@"userId"];
    [parameters setObject:strUserLogonPwd forKey:@"logonPwd"];
    [parameters setObject:@"2" forKey:@"logonType"]; //账号密码登录方式
    
    [self showLoadingHud];
    
    WEAKSELF;
    
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_UserLogon];
    NSLog(@"========================================");
    NSLog(@"%@", strAPIUrl);
    NSLog(@"========================================");
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do nothing
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        if(weakSelf !=nil)
        [weakSelf onAPI_UserLogonRequest_Success:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(weakSelf !=nil)
            [weakSelf onAPI_UserLogonRequest_Failed];
    }];
}


-(void)onAPI_UserLogonRequest_Success:(id)responseObject {
    NSDictionary *appDic =(NSDictionary*)responseObject;
    NSString* errorCode= appDic[@"errorCode"];
    NSString* errorMsg = appDic[@"errorMsg"];
    //先移除,后面可能还会弹出
    [self hideLoadingHud];
    self.isLogining = NO;

    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    
    if(![errorCode isEqualToString:@"0"]) {
    NSLog(@" return, errCode=%@, errMsg=%@", errorCode, errorMsg);
        [MBProgressHUD showError:errorMsg];
    }
    else {
        userData.userMobile = appDic[@"mobile"];
        userData.userID =  [appDic[@"userId"] intValue];
        userData.userLogonPwd = appDic[@"userPwd"];
        userData.gender = [appDic[@"gender"] intValue];
        userData.birthday = appDic[@"birthday"];
        userData.userName = appDic[@"userAlias"];
        userData.viplevel = [appDic[@"viplevel"] intValue];
        userData.playerlevel = [appDic[@"playerlevel"] intValue];
        userData.guishuRoomId = [appDic[@"guishuRoomId"] intValue];
        userData.guishuDailiId = [appDic[@"guishuDailiId"] intValue];
        userData.userBigHeadPic = appDic[@"starpic"];
        userData.userSmallHeadPic =appDic[@"headpic"];
        userData.nk =[ appDic[@"nk"] longLongValue];
        userData.nb =[ appDic[@"nb"] longLongValue ];
        userData.bankUserName = appDic[@"bankusername"];
        userData.bankName = appDic[@"bankname"];
        userData.bankCardNo = appDic[@"bankcardno"];
        userData.gsRoomName = appDic[@"gsroomname"];
        userData.gsRoomGate = appDic[@"gsroomgate"];
        
        [DPK_NW_Application sharedInstance].isLogon = YES;
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DPK_ISLOGON"];
        [[NSUserDefaults standardUserDefaults] setValue:appDic[@"userId"] forKey:@"DPK_USERID"];
        [[NSUserDefaults standardUserDefaults] setValue:appDic[@"userPwd"] forKey:@"DPK_USERLOGONPWD"];

        //发出重新加载个人信息通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
        
        //获取礼物配置列表
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.00001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
            [dpk_app loadGiftVersion];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)onAPI_UserLogonRequest_Failed {
    [self hideLoadingHud];
    self.isLogining = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
