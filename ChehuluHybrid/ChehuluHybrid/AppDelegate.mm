//
//  AppDelegate.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/23.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "CarStatusViewController.h"
#import "MineViewController.h"
#import "CommendFile.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *lcManager;
@end

@implementation AppDelegate

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:@"wx2fe81a813b2796c0"];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [self startLocation];
    NSLog(@"DicUserInfo == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DicUserInfo"]);
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DicUserInfo"]) {
//        [indexDAL loginToken];
//    }
    [self initRootView];
    self.window.rootViewController = self.nav;
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.gt.ChehuluHybrid" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ChehuluHybrid" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ChehuluHybrid.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

// NOTE: 10.0以后使用新API接口

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }else if ([url.host isEqualToString:@"platformId=wechat"]){
        [WXApi handleOpenURL:url delegate:[Share sharedManager]];
    }else if ([url.host isEqualToString:@"pay"]){
        [WXApi handleOpenURL:url delegate:[Share sharedManager]];
    }
    NSLog(@"host == %@",url.host);
    return YES;
}
/*
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
 {
 
 }
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[BaseViewController sharedManager]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    NSLog(@"url == %@",url);
    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
    }else if ([url.host isEqualToString:@"platformId=wechat"]){
        [WXApi handleOpenURL:url delegate:[Share sharedManager]];
    }else if ([url.host isEqualToString:@"pay"]){
        [WXApi handleOpenURL:url delegate:[Share sharedManager]];
    }else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:@"chl20160819app://"].location != NSNotFound){
        int num = 0;
        for (int count = 0; count < url.query.length; count ++ ) {
            if ([[url.query substringWithRange:NSMakeRange(count, 1)] isEqualToString:@"="]) {
                num ++;
            }
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *allStr = url.query;
        for (int index= 0; index < num; index ++ ) {
            NSString *strName;
            NSString *strData;
            int lengh = 0;
            int name = 0;
            int data = 0;
            for (int count = 0; count < allStr.length; count ++ ) {
                lengh ++;
                if ([[allStr substringWithRange:NSMakeRange(count, 1)] isEqualToString:@"="]) {
                    name = count;
                    strName = [allStr substringWithRange:NSMakeRange(data, name)];
                }
                if ([[allStr substringWithRange:NSMakeRange(count, 1)] isEqualToString:@"&"]) {
                    data = count;
                    strData = [allStr substringWithRange:NSMakeRange(name + 1, count-name-1)];
                    allStr = [allStr substringFromIndex:count+1];
                    break;
                }else{
                    strData = [allStr substringFromIndex:name+1];
                    //                    strData = [url.query substringWithRange:NSMakeRange(lengh + 1, count-len)];
                }
                NSLog(@"strName == %@, strData == %@, allstr == %@",strName, strData, allStr);
            }
            [dic setObject:strData forKey:strName];
        }
        //        if ([url.query hasPrefix:@"action_name="]) {
        //            <#statements#>
        //        }
        NSLog(@"dic == %@",dic);
        NSArray *arrKey = [dic allKeys];
        NSString *strTag = @"";
        if (arrKey.count > 2) {
            NSString *key1 = [arrKey objectAtIndex:2];
            strTag = [NSString stringWithFormat:@"%@:%@",key1, [dic objectForKey:key1]];
            for (int index = 3; index < [dic count]; index ++ ) {
                NSString *key = [arrKey objectAtIndex:index];
                NSString *string = [NSString stringWithFormat:@",%@:%@",key, [dic objectForKey:key]];
                strTag = [NSString stringWithFormat:@"%@%@",strTag,string];
            }
        }
        NSLog(@"strTag = %@",strTag);
        NSString *strInfo;
        if ([dic objectForKey:@"action_name"] && [dic objectForKey:@"file_name"]) {
            strInfo = [NSString stringWithFormat:@"\"%@\",{%@},\"%@\"", [dic objectForKey:@"action_name"],strTag, [dic objectForKey:@"file_name"]];
        }else if ([dic objectForKey:@"action_name"]){
            strInfo = [NSString stringWithFormat:@" ,{%@},\"%@\"",strTag, [dic objectForKey:@"file_name"]];
        }else if ([dic objectForKey:@"file_name"]){
            strInfo = [NSString stringWithFormat:@"\"%@\",{%@}, ", [dic objectForKey:@"action_name"],strTag];
        }else{
            strInfo = [NSString stringWithFormat:@" ,{%@}, ",strTag];
        }
        //        NSString *strInfo = [NSString stringWithFormat:@"\"%@\",{%@},\"%@\"", [dic objectForKey:@"action_name"],strTag, [dic objectForKey:@"file_name"], nil];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"urlOpen"  object:strInfo];
        [center postNotificationName:@"notificationString"  object:strInfo];
        //        if (app.applicationState == UIApplicationStateInactive && app.applicationState != UIApplicationStateBackground && app.applicationState != UIApplicationStateActive) {
        //            [self alert:@"杀死状态"];
        //        }
    }
    else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:@"iosamap://"].location != NSNotFound){//高德地图
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否前往高德地图" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%AB%98%E5%BE%B7%E5%9C%B0%E5%9B%BE-%E7%B2%BE%E5%87%86%E4%B8%93%E4%B8%9A%E7%9A%84%E6%89%8B%E6%9C%BA%E5%9C%B0%E5%9B%BE-%E8%87%AA%E9%A9%BE-%E5%85%AC%E4%BA%A4-%E9%AA%91%E8%A1%8C%E5%AF%BC%E8%88%AA/id461703208?mt=8"]];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIWindow *aW = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        aW.rootViewController = [[UIViewController alloc]init];
        aW.windowLevel = UIWindowLevelAlert + 1;
        [aW makeKeyAndVisible];
        [aW.rootViewController presentViewController:alert animated:YES completion:nil];
        //        [_viewController presentViewController:alert animated:YES completion:nil];
        [alert addAction:action];
        [alert addAction:action2];
        //
        NSLog(@"高德");
    }else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:@"baidumap://"].location != NSNotFound){//百度地图
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否前往百度地图" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%99%BE%E5%BA%A6%E5%9C%B0%E5%9B%BE-%E6%99%BA%E8%83%BD%E7%9A%84%E6%89%8B%E6%9C%BA%E5%AF%BC%E8%88%AA-%E5%85%AC%E4%BA%A4%E5%9C%B0%E9%93%81%E5%87%BA%E8%A1%8C%E5%BF%85%E5%A4%87/id452186370?mt=8"]];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIWindow *aW = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        aW.rootViewController = [[UIViewController alloc]init];
        aW.windowLevel = UIWindowLevelAlert + 1;
        [aW makeKeyAndVisible];
        [aW.rootViewController presentViewController:alert animated:YES completion:nil];
        //        [_viewController presentViewController:alert animated:YES completion:nil];
        [alert addAction:action];
        [alert addAction:action2];
    }
    NSLog(@"host == %@",url);
    //    [self alert:[NSString stringWithFormat:@"%@",url]];
    //    if (app.applicationState != UIApplicationStateInactive && app.applicationState != UIApplicationStateBackground) {
    //        [self alert:@"杀死状态"];
    //    }
    return YES;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Init root view for window
- (void)initRootView{
    IndexViewController *indexVC = [[IndexViewController alloc] init];
    [indexVC.navigationController.navigationBar setHidden:YES];
    [indexVC.tabBarItem setImage:[UIImage imageNamed:@"itemHomeNormal"]];
    [indexVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"itemHomeSelect"]];
    [indexVC.tabBarItem setTitle:@"首页"];
    [indexVC setTitle:@"首页"];
//    [indexVC.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"itemHomeNormal"] selectedImage:[UIImage imageNamed:@"itemHomeSelect"]];
//
    
    CarStatusViewController *statusVC = [[CarStatusViewController alloc] init];
    [statusVC.navigationController.navigationBar setHidden:NO];
    [statusVC.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [statusVC.tabBarItem setImage:[UIImage imageNamed:@"tabCarStatusNomal"]];
    [statusVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabCarStatusSelect"]];
    [statusVC.tabBarItem setTitle:@"车况"];
//    [statusVC setTitle:@"车辆"];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    [statusVC.navigationController.navigationBar setHidden:YES];
    [mineVC.tabBarItem setImage:[UIImage imageNamed:@"ItemMineNormal"]];
    [mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"itemMineSelect"]];
    [mineVC.tabBarItem setTitle:@"我的"];
    [mineVC setTitle:@"我的"];
    
    NSArray *arrayVC = [[NSArray alloc] initWithObjects:statusVC, indexVC, mineVC, nil];
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBarController setViewControllers:arrayVC];
    self.tabBarController.selectedIndex = 1;
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:14/255.0 green:192/255.0 blue:202/255.0 alpha:1/1.0]];

    
    self.nav = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
//    [self.nav.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.nav.navigationBar setTranslucent:NO];
    [self.nav.navigationBar.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.nav.navigationBar.layer setShadowOffset:CGSizeMake(0, 0.05)];
    [self.nav.navigationBar.layer setShadowOpacity:0.1];
    CGRect navFrame = self.nav.navigationBar.layer.bounds;
    [self.nav.navigationBar.layer setShadowPath:[UIBezierPath bezierPathWithRect:navFrame].CGPath];
}

#pragma mark -- CLLocationManagerDelegate
- (void) startLocation{
    self.lacationManage = [[CLLocationManager alloc] init];
    self.lacationManage.delegate = self;
    self.lacationManage.desiredAccuracy = kCLLocationAccuracyBest;
    self.lacationManage.distanceFilter = 10.0f;
    [self.lacationManage startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.lacationManage stopUpdatingLocation];
    
    NSLog(@"location ok");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(省)  SubLocality(区)
            //            SubThoroughfare == 14号
            //            CountryCode == CN
            //            Street == 翠柏路14号
            //            State == 浙江省
            //            Name == 中国浙江省杭州市西湖区翠苑街道翠柏路14号
            //            Thoroughfare ==翠柏路
            //            City == 杭州市
//            NSMutableDictionary *dicAddr = [NSMutableDictionary dictionaryWithObjectsAndKeys:[test objectForKey:@"State"], @"state", [test objectForKey:@"Name"], @"name", [test objectForKey:@"City"], @"city",[test objectForKey:@"SubLocality"], @"subLocality",[test objectForKey:@"Street"], @"street", nil];
//            NSString *strCity = [test objectForKey:@"City"];
            [[NSUserDefaults standardUserDefaults] setObject:test forKey:@"Location"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)login: (NSDictionary *)dic{
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
    if ([[info objectForKey:@"area_info"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicArea = [[NSDictionary alloc] initWithDictionary:[info objectForKey:@"area_info"]];
        NSDictionary *dicArea2 = [self nullToEmpty:dicArea];
        [[NSUserDefaults standardUserDefaults] setObject:dicArea2 forKey:@"DicArea"];
        
    }
    NSDictionary *dicInfo2 = [self nullToEmpty:dicInfo];
    [[NSUserDefaults standardUserDefaults] setObject:dicInfo2  forKey:@"DicUserInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"usertoken"] forKey:@"usertoken"];
    NSLog(@"userToken == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"loginToken"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [self login:dic];
        }
    }
}

//非空判断
- (NSDictionary *)nullToEmpty:(NSDictionary *)dic{
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic2 setObject:@"" forKey:key];
        }else{
            [dic2 setObject:[dic objectForKey:key] forKey:key];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dic2];
    return dict;
}


@end
