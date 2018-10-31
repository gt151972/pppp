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
#import "GTAFNData.h"
#import "ForgetPasswordViewController.h"
#import "RegisteredViewController.h"
#import "WebViewController.h"
@interface LogonViewController ()<GTAFNDataDelegate, UITableViewDelegate, UITableViewDataSource>{
    int type;//1:账号密码 2:QQ 3:手机密码 4:微信
}

@property(nonatomic, assign) BOOL isLogining;
@property(nonatomic, strong) MBProgressHUD* hud;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHead;
@property (weak, nonatomic) IBOutlet UIButton *btnPwdVisable;
@property (weak, nonatomic) IBOutlet UIButton *btnRegiest;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIButton *btnUserId;
//@property (strong, nonatomic)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *arrUserAndPWD;
@property (strong, nonatomic)NSDictionary *dicUserAndPWD;

@end

@implementation LogonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrUserAndPWD = [NSArray array];
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"USERID_PWD.plist"];
    self.arrUserAndPWD = [NSArray arrayWithContentsOfFile:filePathName];
    type = 1;
    [self.navigationController.navigationBar setHidden:YES];
    [self.btnPwdVisable setImage:[UIImage imageNamed:@"password_hidden"] forState:UIControlStateNormal];
    [self.btnPwdVisable setImage:[UIImage imageNamed:@"password_visible"] forState:UIControlStateSelected];
    self.edtUserPwd.secureTextEntry = YES;
#if 0
    textView.layer.borderColor = [UIColorgrayColor].CGColor;
    textView.layer.borderWidth =1.0;
    textView.layer.cornerRadius =5.0;
#endif 
    
    //增加主View的点击事件，注意去除Button的影响
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];

    self.viewFooter.hidden = YES;
    [self.tableView setHidden:YES];
    
    [self.btnUserId setImage:[UIImage imageNamed:@"login_up"] forState:UIControlStateSelected];
    [self.btnUserId setImage:[UIImage imageNamed:@"login_down"] forState:UIControlStateNormal];
    
    
}

-(UITableView *)tableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    _tableView.height = self.arrUserAndPWD.count * 40;
    _tableView.backgroundColor = [UIColor whiteColor];
    return _tableView;
}

- (UIButton *)btnRegiest{
    _btnRegiest.layer.cornerRadius = 19;
    _btnRegiest.layer.masksToBounds = YES;
    _btnRegiest.layer.borderColor = MAIN_COLOR.CGColor;
    _btnRegiest.layer.borderWidth = 2.0f;
    return _btnRegiest;
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
    NSString *strUUID = [self randomUUID];
    NSString *strPwd;
    if (type == 1) {
        strPwd = [NSString md5:_edtUserPwd.text];
    }else{
        strPwd = @"";
    }
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    userData.userLogonPwd = strPwd;
    [[NSUserDefaults standardUserDefaults] setValue:_edtUserID.text forKey:@"DPK_USERID"];
    [[NSUserDefaults standardUserDefaults] setValue:strPwd forKey:@"DPK_USERLOGONPWD"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",type] forKey:@"DPK_USERLOGONTYPE"];
    [[NSUserDefaults standardUserDefaults] setValue:strUUID forKey:@"DPK_USERLOGONMAC"];
  
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data LoginWithUid:_edtUserID.text sid:strPwd type:[NSString stringWithFormat:@"%d",type] mac:strUUID];
    [self showLoadingHud];
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

- (IBAction)btnUserClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.hidden = !sender.selected;
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
-(NSString *)randomUUID {
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"deviceUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uuid;
}

#pragma mark  三方登录

/**
 微信登录

 @param sender <#sender description#>
 */
- (IBAction)btnWeichatLogin:(id)sender {
    type = 4;
}


/**
 QQ登录

 @param sender <#sender description#>
 */
- (IBAction)btnQQLogin:(id)sender {
}

- (IBAction)btnProtocolClicked:(UIButton *)sender {
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strUrl = [dict objectForKey:@"agreement"];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.strUrl = strUrl;
    webVC.strTitle = @"充值";
    [self.navigationController pushViewController:webVC animated:YES];
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

-(void)onAPI_UserLogonRequest_Failed {
    [self hideLoadingHud];
    self.isLogining = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrUserAndPWD) {
        if (_arrUserAndPWD.count > 4) {
            return 4;
        }else{
            return _arrUserAndPWD.count;
        }
    }else{
        return 0;
    }
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"historyTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.userInteractionEnabled = NO;
    NSLog(@"_arrUserAndPWD == %@",_arrUserAndPWD);
    if (_arrUserAndPWD) {
        int uid = [[[_arrUserAndPWD objectAtIndex:indexPath.row] objectForKey:@"uid"] intValue];
        cell.textLabel.text = [NSString stringWithFormat:@"%d",uid];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int uid = [[[_arrUserAndPWD objectAtIndex:indexPath.row] objectForKey:@"uid"] intValue];
    _edtUserID.text = [NSString stringWithFormat:@"%d",uid];
    _edtUserPwd.text = [[_arrUserAndPWD objectAtIndex:indexPath.row] objectForKey:@"userPwd"];
    _edtUserPwd.secureTextEntry = YES;
    _tableView.hidden = YES;
}
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    NSLog(@"cmd == %@\n data == %@",cmd, data);

    if ([cmd isEqualToString:CMD_LOGIN]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
            userData.userID =  [data[@"uid"] intValue];
            userData.userSid = data[@"sid"];
            userData.gender = [data[@"Gender"] intValue];
            userData.userName = data[@"uNick"];
            userData.viplevel = [data[@"Level"] intValue];
            userData.guishuRoomId = [data[@"rId"] intValue];
            userData.userBigHeadPic = data[@"StarPic"];
            userData.userSmallHeadPic =data[@"HeadPic"];
            userData.nk =[ data[@"nk"] longLongValue];
            userData.nb =[ data[@"nb"] longLongValue ];
            [DPK_NW_Application sharedInstance].isLogon = YES;
            
            NSString *strPwd = [NSString md5:_edtUserPwd.text];
            self.dicUserAndPWD = [NSDictionary dictionaryWithObjectsAndKeys:strPwd, @"userPwd", data[@"uid"], @"uid", nil];
            BOOL isUser  = [_arrUserAndPWD containsObject:_dicUserAndPWD];
            if (!isUser) {
                NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
                NSString*cachePath = array[0];
                NSString*filePathName = [cachePath stringByAppendingPathComponent:@"USERID_PWD.plist"];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:_arrUserAndPWD];
                [arr addObject:_dicUserAndPWD];
                [arr writeToFile:filePathName atomically:YES];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DPK_ISLOGON"];
            [[NSUserDefaults standardUserDefaults] setValue:data[@"uid"] forKey:@"DPK_USERID"];
            [[NSUserDefaults standardUserDefaults] setValue:data[@"sid"] forKey:@"DPK_USERLOGONSID"];
            //发出重新加载个人信息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
            //获取礼物配置列表
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.00001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
                [dpk_app loadGiftVersion];
            });
            [self hideLoadingHud];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self hideLoadingHud];
            [MBProgressHUD showAlertMessage:[data objectForKey:@"msg"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
