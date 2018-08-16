//
//  GTLocationManager.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/16.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^GTLocationSuccess) (double lat, double lng);
typedef void(^GTLocationFailed) (NSError *error);
@interface GTLocationManager : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *manager;
    GTLocationSuccess successCallBack;
    GTLocationFailed failedCallBack;
}

+ (GTLocationManager *) sharedGpsManager;

+ (void) getMoLocationWithSuccess:(GTLocationSuccess)success Failure:(GTLocationFailed)failure;

+ (void) stop;

@end
