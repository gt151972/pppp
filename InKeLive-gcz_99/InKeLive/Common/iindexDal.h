//
//  iindexDal.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
#import <AFNetworkReachabilityManager.h>
@protocol IndexRequestDelegate <NSObject>
@optional
-(void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd;

@end

typedef void (^ABlock)(void);
@interface iindexDal :  NSObject
{
    NSString *currResult;
}
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property(nonatomic,assign) id<IndexRequestDelegate> delegate;
@property(nonatomic,assign) BOOL isoverLay;


#pragma mark -- 获取版本号
- (void)getVersionType : (NSString *)type source: (NSString *)source iOSVersion: (NSString *)iOSVersion androidVersion: (NSString *)androidVersion;

#pragma mark --- 版本号
- (void)getAppScreen : (NSString *)type source: (NSString *)source;

/**
 * 上传图片
 *
 *  @param picture 待上传图片(base64)
 *  @param token
 */
- (void)uploadimgWithPicture:(NSString *)picture token: (NSString *)token;


/**
 * C端推送设备编号更新
 *
 *  @param c_pcid C端推送的channelID
 *  @param c_ptype 1:iOS  2:安卓
 *  @param token
 */
- (void)userUpdateWithChannelID:(NSString *)c_pcid type:(NSString*)c_ptype;


/**
 * 商城首页轮播图
 *
 *  @param source 轮播图来源(1-环境宝 2-首页 3-商城首页 4-商城广告位轮播 5-启动页)
 */
- (void)getSlidesImagesLists: (NSString *)source;
@end
