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
#import "HomeViewController.h"
#import "GTAFNData.h"
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()<GTAFNDataDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [UMConfigure initWithAppkey:@"59892ebcaed179694b000104" channel:@"App Store"];
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
//    if (self.window.rootViewController != nil) {
//        self.window.rootViewController = nil;
//    }
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

-(void) showLiveRoom:(BOOL)isCreate CameraFront:(BOOL)isFront hide:(BOOL)hide{
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
        joinRoomInfo.roomName = userData.gsRoomName;
        joinRoomInfo.lookUserId = 0;
        [joinRoomInfo setGateAddr:userData.gsRoomGate]; //6位地址
    }
   
    LiveViewController *live = [[LiveViewController alloc]init];
    [live initURL:[NSURL URLWithString:pushStreamUrl] fileList:nil];
    live.isHide = hide;
    live.createFlag = isCreate;//是否主播
    live.caremaIsFront = isFront;//是否前置
    live.dicInfo = joinRoomInfo.dicRoomInfo;
//    NSLog(@"createFlag == %d, caremaIsFront == %d",isCreate, isFront);
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"createFlag.plist"];
    NSDictionary*dict;
    if (isCreate) {
        dict =@{@"createFlag":@"1"};
    }else{
        dict =@{@"createFlag":@"0"};
    }
    [dict writeToFile:filePathName atomically:YES];
    BaseViewController *liveNav = [[BaseViewController alloc]initWithRootViewController:live];
//    [self.tabbarVC presentViewController:liveNav animated:YES completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:liveNav animated:YES completion:nil];
}

-(void) logout
{
     if(![DPK_NW_Application sharedInstance].isLogon)
         return;
    
    [DPK_NW_Application sharedInstance].isLogon = NO;
    [DPK_NW_Application sharedInstance].localUserModel.userID = 0;
    [DPK_NW_Application sharedInstance].localUserModel.userLogonPwd = @"";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DPK_ISLOGON"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DPK_USERID"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DPK_USERLOGONPWD"];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"DPK_USERLOGONTYPE"];
    
    //发出重新加载个人信息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
    
    //用户登录窗口
    BaseTabBarController *base = [[BaseTabBarController alloc]init];
    self.window.rootViewController = base;
    [self.window makeKeyAndVisible];
    
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
    NSString *strType = [[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERLOGONTYPE"];
    NSString *strMac = [[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERLOGONMAC"];
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data LoginWithUid:strUserId sid:strUserLogonPwd type:strType mac:strMac];
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
//    [[SDWebImageManager sharedManager] cancelAll];
//    [[SDImageCache sharedImageCache] clearMemory];
}
+ (NSString *)randomUUID {
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

+ (void)setValue:(NSString *)value forKey:(NSString *)key inService:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_LOGIN]) {
        if ([data[@"code"] intValue] == 0) {
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
            userData.userLogonPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERLOGONPWD"];
            [DPK_NW_Application sharedInstance].isLogon = YES;
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
        }else{
            
        }
    }
}

@end
