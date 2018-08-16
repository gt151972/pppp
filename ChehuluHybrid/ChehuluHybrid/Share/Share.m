//
//  Share.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "Share.h"

@implementation Share

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static Share *instance;
    dispatch_once(&onceToken,^{
        instance = [[Share alloc] init];
    });
    return instance;
}
#pragma mark --微信分享
#pragma mark
- (void)wxShareMessagetitle:(NSString *)title desc: (NSString *)desc url: (NSString *)url mode: (NSString *)mode target: (NSString *)target shareImgUrl: (NSString *)shareImgUrl{
    NSLog(@"title == %@",title);
    NSLog(@"desc == %@",desc);
    NSLog(@"url == %@",url);
    NSLog(@"mode == %@",mode);
    NSLog(@"target == %@",target);
    NSLog(@"shareImgUrl == %@",shareImgUrl);
    // NSString *strPhoto = [NSString stringWithFormat:@"http://wx.buyubi.com/ZJJH_SHARE_ICON/share_icon_%@.jpg",mode];
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,        /**< 收藏       */
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = desc;
    //  NSURL *shareUrl = [NSURL URLWithString:strPhoto];
    NSURL *urlPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",shareImgUrl]];
    UIImage *photo =   [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPhoto]];
    
    [message setThumbImage:photo];
    
    WXWebpageObject *webpageObject = [[WXWebpageObject alloc] init];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if ([target isEqualToString:@"session"]) {
        req.scene = WXSceneSession;
    }else{
        req.scene = WXSceneTimeline;
    }
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [WXApi sendReq:req];
    });
    
    if (req.scene == 0) {
        _scene = 0;//聊天界面
        
    }else if (req.scene == 1){
        _scene = 1;//朋友圈
        
    }
}


#pragma mark -- 微信图片分享
#pragma mark
- (void)WXSendImageData:(UIImage *)image target: (NSString *)target {
    
    WXMediaMessage *message = [WXMediaMessage message];
    //    UIImage *thumbImage = [self generatePhotoThumbnail:image];
    [message setThumbImage:[UIImage imageNamed:@"Thumbnail"]];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if ([target isEqualToString:@"timeline"]) {
        req.scene = WXSceneTimeline;
        _scene = 1;
    }else{
        req.scene = WXSceneSession;
        _scene = 0;
    }
    [WXApi sendReq:req];
}


#pragma mark ---微信支付
#pragma mark
//String partnerId,String prepayId,String packageValue,String nonceStr,String timeStamp,String sign
- (void)WXPayRmbpartnerId :(NSString *)partnerId prepayId:(NSString *)prepayId packageValue:(NSString *)packageValue nonceStr: (NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign{
    NSLog(@"partnerId == %@",partnerId);
    NSLog(@"prepayId == %@",prepayId);
    NSLog(@"package == %@",packageValue);
    NSLog(@"nonceStr == %@",nonceStr);
    NSLog(@"timeStamp == %@",timeStamp);
    NSLog(@"sign == %@",sign);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = partnerId;
    request.prepayId= prepayId;
    request.package = packageValue;
    request.nonceStr= nonceStr;
    request.timeStamp= [timeStamp intValue];
    request.sign= sign;
    [WXApi sendReq:request];
    
    //    [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.wxOnPayRmbSuccess()"] completionHandler:nil];
}


#pragma mark ---微信回调
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"resp == %d\n str == %@",resp.errCode,resp.errStr);
    NSString *strResult;
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = [NSString stringWithFormat:@"%d", resp.errCode];
        if ([strMsg isEqualToString:@"0"]) {
            strResult = [NSString stringWithFormat:@"%d,1", _scene];
        }else{
            strResult = [NSString stringWithFormat:@"%d,0", _scene];
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:strResult, @"strResult", @"share", @"use",nil];
        // 发送通知
        [center postNotificationName:@"weChatResult"  object:dic];
    }else if ([resp isKindOfClass:[PayResp class]]){
        
        NSString *strPay = [NSString stringWithFormat:@"%d",resp.errCode];
        if ([strPay isEqualToString:@"0"]) {
            strResult = @"1";
        }else {
            strResult = @"0";
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:strResult, @"strResult", @"pay", @"use",nil];
        // 发送通知
        [center postNotificationName:@"weChatResult"  object:dic];
    }
}


@end
