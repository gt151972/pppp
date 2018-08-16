//
//  Share.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import <UIKit/UIKit.h>

@interface Share : NSObject<WXApiDelegate>
@property(assign,nonatomic) int scene;

+(instancetype)sharedManager;

#pragma mark --微信分享
#pragma mark
- (void)wxShareMessagetitle:(NSString *)title desc: (NSString *)desc url: (NSString *)url mode: (NSString *)mode target: (NSString *)target shareImgUrl: (NSString *)shareImgUrl;

#pragma mark -- 微信图片分享
#pragma mark
- (void)WXSendImageData:(UIImage *)image target: (NSString *)target;


#pragma mark ---微信支付
#pragma mark
//String partnerId,String prepayId,String packageValue,String nonceStr,String timeStamp,String sign
- (void)WXPayRmbpartnerId :(NSString *)partnerId prepayId:(NSString *)prepayId packageValue:(NSString *)packageValue nonceStr: (NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign;
@end
