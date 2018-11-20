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
#import "AcrossViewController.h"
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashInstallationStandard.h>
#import "Crash.h"
#import "LxFTPRequest.h"
#import "FTPManager.h"
#import <Reachability.h>
#import "NoNetViewController.h"
#import <AFNetworking.h>
@interface AppDelegate ()<GTAFNDataDelegate, FTPManagerDelegate>{
    FMServer* server;
    FTPManager* man;
    NSTimer* progTimer;
    NSString* filePath;  // 上传文件的路径
    BOOL succeeded;  // 记录传输结果是否成功
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册消息处理函数的处理方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    BOOL isConnect = [AutoCommon isEnbnleNet];
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
//        [self sendExceptionLogWithData:data path:dataPath];
        [self uploadWithPath:dataPath];
    }
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
    
    //注册通知，异步加载，判断网络连接情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"canConnect" object:nil];
    
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
    [self installCrashHandler];
    //友盟SDK初始化
    [self initUmShareSDK];
    
    //尝试自动登录服务器
    [self autoLogin];
    return YES;
}


/**
 修改网络状态后刷新

 @param noti <#noti description#>
 */
- (void)receiveNotification:(NSNotification *)noti
{
    
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    BaseTabBarController *base = [[BaseTabBarController alloc]init];
    //    if (self.window.rootViewController != nil) {
    //        self.window.rootViewController = nil;
    //    }
    self.window.rootViewController = base;
    [self.window makeKeyAndVisible];
    self.tabbarVC = base;
    
    //设置图片的最大缓存为30M
    [SDImageCache sharedImageCache].maxCacheSize = 20 * 1024 * 1024;
    [self installCrashHandler];
    //友盟SDK初始化
    [self initUmShareSDK];
    
    //尝试自动登录服务器
    [self autoLogin];
    
}

/**
 *此函数通过判断联网方式，通知给用户
 */
- (void)reachabilityChanged:(NSNotification *)notification
{
    
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == NotReachable) {
        NoNetViewController *nonetVC = [[NoNetViewController alloc] init];
        BaseViewController* naviVC = [[BaseViewController alloc]initWithRootViewController:nonetVC];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:nil];;
    }else{
//        
//        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


//第三步:崩溃日志发动到服务器

#pragma mark -- 发送崩溃日志

-(void)uploadWithPath: (NSString *)path{
    NSString *strUserId =[[NSUserDefaults standardUserDefaults] objectForKey:@"DPK_USERID"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios", @"type", @"file", @"file_type",strUserId, @"file", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager POST:@"http://test.aa1258.com/upload" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
        //        NSString *path = @"/Users/lxf/Desktop/1114.txt";
        //        NSURL *fileUrl = [NSURL URLWithString:dataPath];
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        [formData appendPartWithFileData:data name:@"file" fileName:@"ios.txt" mimeType:@"text/html"];
//        [formData appendPartWithFileData:data name:fileKey] fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress == %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
        //创建文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        //删除
        [manager removeItemAtPath:dataPath error:nil];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
    }];
    
//    [[AFHTTPSessionManager manager] POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        completedBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completedBlock(nil);
//    }];
//
//    // 全局变量设定
//    NSString *url = [NSString stringWithFormat:@"%@:%@/%d/%d", host, FTP_PORT,
//                     [DataModelInstance shareInstance].userModel.client_id.intValue,
//                     [DataModelInstance shareInstance].userModel.client_user_id.intValue
//                     ];
//
//
//    // 配置FTP服务器信息
//    server = [FMServer serverWithDestination:FTP_URL_PATH username:FTP_USER_ID password:FTP_PASSWORD];
//    // 初始化定时器
//    progTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
//    // 激活定时器
//    [progTimer fire];
//    // 调用开始上传文件的方法
//    [self performSelectorInBackground:@selector(startUploading) withObject:nil];
//
    
}
-(void)startUploading {
    // 初始化FTPManager
    man = [[FTPManager alloc] init];
    // 设置代理（非必须）
    man.delegate = self;
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
////        NSString *path = @"/Users/lxf/Desktop/1114.txt";
////        NSURL *fileUrl = [NSURL URLWithString:dataPath];
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//    NSLog(@"data == %d", [man uploadFile:[NSURL URLWithString:dataPath] toServer:server]);
////    succeeded = [man uploadData:data withFileName:@"" toServer:server];
    
    UIImage *img = [UIImage imageNamed:@"noNet_icon"];
    NSData * data = UIImagePNGRepresentation(img);
    // 开始上传并记录结果
    succeeded = [man uploadData:data withFileName:@"20173160007.png" toServer:server];

//    succeeded = [man uploadFile:[NSURL URLWithString:dataPath] toServer:server];
    if (succeeded) {
        [self performSelectorOnMainThread:@selector(uploadFinished) withObject:nil waitUntilDone:NO];
    }
}
-(void)changeProgress {
    if (!man) {
        [progTimer invalidate];
        progTimer = nil;
        return;
    }
    NSLog(@"上传进度：%@",man.progress);
}
// 上传完毕，一切置空
-(void)uploadFinished {
    [progTimer invalidate];
    progTimer = nil;
    filePath = nil;
    server = nil;
    man = nil;
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

- (KSCrashInstallation*) makeStandardInstallation
{
    NSURL* url = [NSURL URLWithString:@"http://test.aa1258.com/upload"];
    
    KSCrashInstallationStandard* standard = [KSCrashInstallationStandard sharedInstance];
    standard.url = url;
    
    
    return standard;
}
- (void) installCrashHandler
{
    // Create an installation (choose one)
    KSCrashInstallation* installation = [self makeStandardInstallation];
    
    // 安装异常处理者，越早安装越好
    // 如下将自动记录崩溃信息，但是它不会自动发送报告
    [installation install];
    // 此方法是确认崩溃报告发送后，如何处理旧的崩溃。
    [KSCrash sharedInstance].deleteBehaviorAfterSendAll = KSCDeleteNever;
    // 发送崩溃日志
    [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
    {
        NSLog(@"reports == %@",reports);
        if(completed)
        {
            NSLog(@"Sent %d reports", (int)[reports count]);
        }
        else{
            NSLog(@"Failed to send reports: %@", error);
        }
    }];
    
}

- (void)uploadCrash{
    NSURL *url = [NSURL URLWithString:FTP_USER_ID];//ip
    NSString *filePath = FTP_USER_ID;//文件地址
    NSString *account = FTP_USER_ID;//账号
    NSString *password = FTP_PASSWORD;//密码
    CFWriteStreamRef ftpStream;
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If youråå application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //进入后台
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //回到app
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    AcrossViewController *acrossVC = [AcrossViewController defaultVideoPlayerViewController];
//    if ([AcrossViewController isBeingShowed]) {
//        && VideoPlayerViewModeFullscreen == acrossVC.viewMode
//        && !acrossVC.presentedViewController
//        && !acrossVC.isVideoPlayerDestroying)
//        return UIInterfaceOrientationMaskLandscape;
//    }
    return UIInterfaceOrientationMaskPortrait;//其他都为竖屏
}

#pragma mark - FTPManagerDelegate
- (void)ftpManagerUploadProgressDidChange:(NSDictionary *)processInfo {
    NSLog(@"processInfo ==%@", processInfo);
}
@end
