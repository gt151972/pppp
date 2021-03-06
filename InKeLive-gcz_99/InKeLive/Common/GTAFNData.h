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
#pragma mark 登录

/**
 登录

 @param uid 手机账号 微信 QQ
 @param sid 密码 openid unionid
 @param type 1:账号密码 2:QQ 3:手机密码 4:微信
 @param mac 唯一标识符
 */
-(void)LoginWithUid:(NSString *)uid sid:(NSString *)sid type:(NSString *)type mac:(NSString *)mac;

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
#pragma mark 注册
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
 找回密码

 @param phone 手机号
 @param code 验证码
 @param pwd 新密码
 */
-(void)phoneRetrieveWithPhone: (NSString *)phone
                         code: (NSString *)code
                          pwd: (NSString *)pwd;

/**
 修改密码

 @param oldPwd 老密码
 @param newPwd 新密码
 */
-(void)changePwdWithOldPwd: (NSString *)oldPwd
                        newPwd:(NSString *)newPwd;

#pragma mark 关注

/**
 关注列表
 */
-(void)AttentionList;

/**
 删除关注

 @param pid 关注对象的uid
 */
-(void)DeteleAttentionWithPid: (NSString *)pid;

#pragma mark 获取房间信息
/**
 根据房间ID搜索房间地址房间名

 @param rid 房间id
 */
-(void)getRoomInfoWithRid:(NSString *)rid;

#pragma mark 请求网页地址
/**
 请求网页地址
 */
-(void)getWebUrl;

#pragma mark banner图

/**
 请求banner图
 */
-(void)getBanner;

#pragma mark 首页数据
/**
 推荐房间列表(弃用)
 */
-(void)RecommendRoom;

/**
 首页分类的数据

 @param key 分类的key
 */
-(void)mainListData:(NSString *)key;
/**
 首页分组列表
 */
-(void)MainListGroup;

/**
 图片等前缀
 */
-(void)requestImageHead;

#pragma mark 版本更新
/**
 版本更新
 */
-(void)versionUpdate;

#pragma mark 个人信息
/**
 读取用户信息
 */
-(void)getUserInfo;
/**
 个人信息修改

 @param uid 用户id
 @param uNick 昵称
 @param head 头像地址
 @param sign 个性签名
 @param gender 性别
 @param qq QQ号
 @param wechat 微信号
 */
-(void)changeUserInfoWithUid:(NSString *)uid uNick:(NSString *)uNick head:(NSString *)head sign:(NSString *)sign gender:(NSString *)gender qq:(NSString *)qq wechat:(NSString *)wechat;
@end
