//
//  AppDelegate.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "BaseViewController.h"
//友盟分享
//#import "UMSocialWechatHandler.h"
#import "DPK_NW_Application.h"

#import "LogonViewController.h"
#import "LiveViewController.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [DPK_NW_Application sharedInstance].isLogon = NO;
    LocalUserModel* localUserData = [DPK_NW_Application sharedInstance].localUserModel;
    [localUserData reset];
    
    //客户端配置信息
    ClientConfigParam* clientConfig = [DPK_NW_Application sharedInstance].clientConfigParam;
    clientConfig.commonApiPrefix   = @"http://www.aa1258.com/real_bailh.com/mobileapi/";
    clientConfig.userHeadPicPrefix = @"http://www.aa1258.com/real_bailh.com/mobileapi/userheadpic/";
    clientConfig.roomPicPrefix     = @"http://www.aa1258.com/real_bailh.com/mobileapi/roompic/";
    clientConfig.giftList = @"http://em.aa1258.com/E/Api";
    
    self.tabbarVC = nil;
    self.createCameraVC =nil;
    self.LiveViewNavVC = nil;
    
    //窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    //使用BaseTabBar
    BaseTabBarController *base = [[BaseTabBarController alloc]init];
    
    self.window.rootViewController = base;
    [self.window makeKeyAndVisible];
    
    self.tabbarVC = base;
    
    //设置图片的最大缓存为30M
    [SDImageCache sharedImageCache].maxCacheSize = 20 * 1024 * 1024;
    
    //友盟SDK初始化
    [self initUmShareSDK];
    
    //尝试自动登录服务器
    [self autoLogin];
    
    return YES;
}


-(void)initUmShareSDK{
    //设置友盟appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58522dadf43e481e4e000424"];////
    
    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8acbfae835c631a1" appSecret:@"e98b5a5e6353cbf4c04bd8a8f9e39193" redirectURL:@"https://www.anyrtc.io"];
}

//// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

-(void) showLiveRoom:(BOOL)isCreate CameraFront:(BOOL)isFront {
    TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    //
    LWServerAddr* serverAddr = [joinRoomInfo getGateAddr:0];
    NSString* pushStreamUrl = serverAddr.addr;
    
    //新的主播上麦方式
    if(isCreate) {
        LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
        TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
        [joinRoomInfo reset];
        joinRoomInfo.roomId = userData.guishuRoomId;
        joinRoomInfo.lookUserId = 0;
        [joinRoomInfo setGateAddr:userData.gsRoomGate]; //6位地址
    }
    
    LiveViewController *live = [[LiveViewController alloc]init];
    [live initURL:[NSURL URLWithString:pushStreamUrl] fileList:nil];
    live.createFlag = isCreate;//是否主播
    live.caremaIsFront = isFront;//是否前置
    live.dicInfo = joinRoomInfo.dicRoomInfo;
//    NSLog(@"createFlag == %d, caremaIsFront == %d",isCreate, isFront);
    BaseViewController *liveNav = [[BaseViewController alloc]initWithRootViewController:live];
    [self.tabbarVC presentViewController:liveNav animated:YES completion:nil];
}

-(void) logout
{
     if(![DPK_NW_Application sharedInstance].isLogon)
         return;
    
    [DPK_NW_Application sharedInstance].isLogon = NO;
    [DPK_NW_Application sharedInstance].localUserModel.userID = 0;
    [DPK_NW_Application sharedInstance].localUserModel.userLogonPwd = @"";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DPK_ISLOGON"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DPK_USERID"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DPK_USERLOGONPWD"];
    
    //发出重新加载个人信息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
}

-(void) doLogon
{
    //用户登录窗口
    LogonViewController* logonVC =[[LogonViewController alloc] init];
    BaseViewController* naviVC = [[BaseViewController alloc]initWithRootViewController:logonVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:nil];
}

-(void) autoLogin
{
    if([DPK_NW_Application sharedInstance].isLogon)
        return;
    NSString *isLogon = [[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_ISLOGON"];
    if(isLogon == nil || ![isLogon isEqualToString:@"1"])
        return;
    NSString *strUserId =[[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERID"];
    NSString *strUserLogonPwd =[[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERLOGONPWD"];
    if(strUserId !=nil && strUserLogonPwd !=nil && strUserId.length >0 && strUserLogonPwd.length >0)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"" forKey:@"mobile"];
        [parameters setObject:@"" forKey:@"authCode"];
        [parameters setObject:strUserId forKey:@"userId"];
        [parameters setObject:strUserLogonPwd forKey:@"logonPwd"];
        [parameters setObject:@"2" forKey:@"logonType"]; //账号密码登录方式
        
        NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_UserLogon];
        NSLog(@"=========================");
        NSLog(@"%@", strAPIUrl);
        NSLog(@"=========================");
        [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do nothing
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            NSDictionary *appDic =(NSDictionary*)responseObject;
            NSString* errorCode= appDic[@"errorCode"];
            NSString* errorMsg = appDic[@"errorMsg"];
            
            LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
            if([errorCode isEqualToString:@"0"])
            {
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
                    [dpk_app loadGiftConf];
                });
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If youråå application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //清除缓存
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}


@end
