//
//  GTRequestManager.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/22.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeOutInterval 30  //请求超时时间

@interface GTRequestManager : NSObject
+(GTRequestManager *)shareSingletonClasss;

#pragma mark  Get 请求数据
-(void)GetParsingDataSourceWithUrl:(NSString *)url
                            WithVC:(UIViewController * )VC
                           success:(void(^)(id responseObject))success
                              fail:(void(^)())fail;

#pragma mark  post上传数据
- (void)PostParsingDataSourceWithUrl:(NSString *)url
                          parameters:(NSDictionary *)parameters
                              WithVC:(UIViewController * )VC
                             success:(void(^)(id responseObject))success
                                fail:(void(^)())fail;

#pragma mark 上传图片 Method
- (void)uploadWithUser:(NSString *)userId
             UrlString:(NSString *)urlString
                 upImg:(UIImage *)upImg;

#pragma mark 下载
- (void)downLoadWithUrlString:(NSString * )urlString;

- (NSMutableDictionary * )getWillPOSTData;

#pragma mark  GET  请求数据
- (void)GetParsingDataSoucrceWithUrl:(NSString * )url success:(void(^)(id responseObject))success fail:(void(^)())fail;


@end
