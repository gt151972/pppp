//
//  AppDelegate.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *developerID = @"teameetingtest";
static NSString *token = @"c4cd1ab6c34ada58e622e75e41b46d6d";
static NSString *key = @"OPJXF3xnMqW+7MMTA4tRsZd6L41gnvrPcI25h9JCA4M";
static NSString *appID = @"meetingtest";

//全局获取方式
//XXXAppDelegate *appDelegate = (XXXAppDelegate *)[[UIApplication sharedApplication] delegate];


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController* tabbarVC;
@property (strong, nonatomic) UIViewController* createCameraVC;
@property (strong, nonatomic) UIViewController* LiveViewNavVC;

-(void) showLiveRoom:(BOOL)isCreate CameraFront:(BOOL)isFront hide: (BOOL)hide;
-(void) logout;
-(void) autoLogin;
-(void) doLogon;


@end

