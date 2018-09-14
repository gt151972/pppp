//
//  iindexDal.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "iindexDal.h"
#import <sys/utsname.h>
#import "JSONKit.h"
#import "AESCrypt.h"
#import "commonFile.h"

#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
@implementation iindexDal
@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *str = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    return newStr;
}

#pragma mark - get请求
- (void)getRequestAction:(NSDictionary *)dict URL:(NSString *)strUrl {
    
    [self.manager GET:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dictResult = responseObject;
        //        NSLog(@"dictResult == %@",dictResult);
        [self requestCallBack:dictResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        [self requestCallBack:nil];
    }];
}
#pragma mark - post请求
- (void)postRequestAction:(NSDictionary *)dict URL:(NSString *)strUrl {
    [self.manager POST:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dictResult = responseObject;
        //        NSLog(@"responseObject == %@",responseObject);
        [self requestCallBack:dictResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        [self requestCallBack:nil];
    }];
}
-(void)requestCancel:(NSString *)sender{
    
    [UIApplication  sharedApplication].networkActivityIndicatorVisible=NO;
}

#pragma mark - UrlRequestDelegate

/**
 *  数据回调
 *
 *  @param webData 字节数据
 */
-(void)requestCallBack:(NSMutableDictionary *)dict
{
    if (delegate) {
        [self DalDataCallBack:dict :currResult];
    }
}

/**
 *  解析返回的数据
 *
 *  @param data   字节流
 *  @param result 当前执行的命令
 */
-(void)DalDataCallBack:(NSMutableDictionary *)dict :(NSString *)result{
    NSError *error = nil;
    if (delegate) {
        if (error)
        {
            if (delegate) {
                [delegate InfoCallBackDic:nil :currResult];
            }
        }
        else{
            if (delegate) {
                //                NSLog(@"dict == %@",dict);
                [delegate InfoCallBackDic:dict :result];
            }
        }
    }
}


#pragma mark --- 版本号

/**
 <#Description#>
 
 @param type <#type description#>
 @param source <#source description#>
 @param iOSVersion <#iOSVersion description#>
 @param androidVersion <#androidVersion description#>
 */
- (void)getVersionType : (NSString *)type source: (NSString *)source iOSVersion: (NSString *)iOSVersion androidVersion: (NSString *)androidVersion{
    currResult = @"version";
    NSString *method = @"App/version";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:
                          type, @"type" , source, @"source", iOSVersion, @"ios_version", androidVersion, @"android_version",
                          nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

#pragma mark --- 版本号
- (void)getAppScreen : (NSString *)type source: (NSString *)source{
    currResult = @"version";
    NSString *method = @"App/screen";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:
                          type, @"type" , source, @"source",
                          [AESCrypt encryptText:[NSString stringWithFormat:@"%@,",method]],@"token",
                          nil];
    //    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * C端推送设备编号更新
 *
 *  @param c_pcid C端推送的channelID
 *  @param c_ptype 1:iOS  2:安卓
 *  @param token
 */
- (void)userUpdateWithChannelID:(NSString *)c_pcid type:(NSString*)c_ptype{
    currResult = @"UserUpdate";
    NSString *method = @"User/update";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:
                          c_pcid, @"c_pcid" , c_ptype, @"c_ptype",
                          [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token",
                          nil];
    NSLog(@"token == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"]);
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 
 * 商城首页轮播图
 *
 *  @param source 轮播图来源(1-环境宝 2-首页 3-商城首页 4-商城广告位轮播)
 */
- (void)getSlidesImagesLists: (NSString *)source{
    currResult = @"SlidesImagesLists";
    NSString *method = @"SlidesImages/lists";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: [AESCrypt encryptText:[NSString stringWithFormat:@"%@,%@",method,[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"]]],@"token", source, @"source", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

@end
