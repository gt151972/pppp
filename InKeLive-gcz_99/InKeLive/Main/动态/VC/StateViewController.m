//
//  StateViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "StateViewController.h"
#import "GTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>

#define url @"http://up.aa1258.com/upload.php"
@interface StateViewController ()<CLLocationManagerDelegate>{
    double latitude;
    double longitude;
}
@property (nonatomic, strong)NSArray *arrData;
@property (nonatomic, strong)CLLocationManager *locationManager;
@end

@implementation StateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //只获取一次
    __block  BOOL isOnece = YES;
    [GTLocationManager getMoLocationWithSuccess:^(double lat, double lng){
        isOnece = NO;
        //只打印一次经纬度
        NSLog(@"lat lng (%f, %f)", lat, lng);
        latitude = lat;
        longitude = lng;
        if (!isOnece) {
            [GTLocationManager stop];
        }
        [self loadGiftConf];
    } Failure:^(NSError *error){
        isOnece = NO;
        NSLog(@"error = %@", error);
        if (!isOnece) {
            [GTLocationManager stop];
        }
    }];

}


-(void) loadGiftConf
{
    NSLog(@"动态请求>>>>> ");
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"1259";
    parameters[@"userName"] = @"1259";
    parameters[@"longitude"] = [NSString stringWithFormat:@"%f",fabs(longitude)];
    parameters[@"latitude"] = [NSString stringWithFormat:@"%f",fabs(latitude)];
    parameters[@"nType"] = @"1";
    parameters[@"nNum"] = @"1";
    parameters[@"context"] = @"动态";
    parameters[@"cmd"] = @"1146";
    NSString* strAPIUrl = url;
    NSLog(@"parameters:%@", parameters);
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSString* errorCode= appDic[@"errorCode"];
        NSString* errorMsg = appDic[@"errorMsg"];
        NSLog(@"%@",appDic);
        if([errorCode isEqualToString:@"0"])
        {
//            [self.giftArray removeAllObjects];
//            NSString* url_giftpic_prefix = appDic[@"urlGiftPicPrefix"];
//            NSArray* giftconflist = (NSArray*)appDic[@"GiftList"];
//            for(NSDictionary* giftItem in giftconflist) {
//
//                [self.giftArray addObject:model];
//            }
        }

//        NSLog(@"load gift-config, gift count=%lu", (unsigned long)self.giftArray.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
