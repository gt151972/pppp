//
//  AppDelegate.h
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/23.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "IndexRequestDAL.h"
#import <WXApi.h>
#import "BaseViewController.h"
#import "Share.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate,IndexRequestDelegate>{
    IndexRequestDAL *indexDAL;
    enum WXScene _scene;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *nav;

@property (strong, nonatomic) BaseViewController *baseVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) CLLocationManager *lacationManage;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

