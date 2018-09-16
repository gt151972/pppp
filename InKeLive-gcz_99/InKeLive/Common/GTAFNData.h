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

 */
-(void)requestSecurityRead;


/**
 手机密保验证码

 @param phone 手机号
 */
-(void)requestSecurityCodeWithPhone: (NSString *)phone;


/**
 手机密保保存

 @param phone 手机号
 @param code 验证码
 */
-(void)requestSecuritySaveWithPhone: (NSString *)phone
                             code: (NSString *)code;


/**
 注册发送验证码

 @param phone <#phone description#>
 @param reg <#reg description#>
 */
-(void)phoneMsgWithPhone: (NSString *)phone
                     reg: (NSString *)reg;


/**
 注册

 @param phone 手机号
 @param code 验证码
 @param pwd 密码
 */
-(void)phoneRegWithPhone: (NSString *)phone
                    code: (NSString *)code
                     pwd: (NSString *)pwd;


/**
 修改密码

 @param phone <#phone description#>
 @param code <#code description#>
 @param pwd <#pwd description#>
 */
-(void)phoneRetrieveWithPhone: (NSString *)phone
                         code: (NSString *)code
                          pwd: (NSString *)pwd;
@end
