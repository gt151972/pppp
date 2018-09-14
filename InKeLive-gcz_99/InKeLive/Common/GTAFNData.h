//
//  GTAFNData.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "DPK_NW_Application.h"
#import "CommonAPIDefines.h"

@protocol GTAFNDataDelegate <NSObject>
- (void) responseDataWithCmd :(NSString *)cmd
                         data: (NSDictionary *)data;
@end

@interface GTAFNData : NSObject{
    NSString *currResult;
}

@property (nonatomic, weak) id<GTAFNDataDelegate> delegate;

+(GTAFNData *)shareInstance;

#pragma mark 密保
/**
 手机密保读取

 @param uid <#uid description#>
 */
-(void)requestSecurityReadWithUid: (NSString *)uid;


/**
 手机密保验证码

 @param uid <#uid description#>
 @param phone 手机号
 */
-(void)requestSecurityCodeWithUid: (NSString *)uid
                            phone: (NSString *)phone;


/**
 手机密保保存

 @param uid <#uid description#>
 @param phone 手机号
 @param code 验证码
 */
-(void)requestSecuritySaveWithUid: (NSString *)uid
                            phone: (NSString *)phone
                             code: (NSString *)code;
@end
