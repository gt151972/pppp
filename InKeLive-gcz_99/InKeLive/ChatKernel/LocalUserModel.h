//
//  LocalUserModel.h
//  bazhouchat03
//
//  Created by gu  on 16/6/26.
//  Copyright © 2016年 gu . All rights reserved.
//

#import <Foundation/Foundation.h>

//本地用户信息数据模型
@interface LocalUserModel : NSObject

@property(nonatomic, assign) int userID;                   //用户ID
@property(nonatomic, strong) NSString* userLogonPwd;        //
@property(nonatomic, strong) NSString* userSid; //sid
//@property(nonatomic, strong) NSString* userMobile;
@property(nonatomic, strong) NSString* userName;           //用户名称

@property(nonatomic, strong) NSString* userSmallHeadPic;         //用户头像图片
@property(nonatomic, strong) NSString* userBigHeadPic;           //用户头像图片
//@property(nonatomic, strong) NSString* downloadUserHeadPic;      //

//@property(nonatomic, strong) NSString* bankUserName;
//@property(nonatomic, strong) NSString* bankCardNo;
//@property(nonatomic, strong) NSString* bankName;

@property(nonatomic, assign) int gender;                    //用户性别
//@property(nonatomic, strong) NSString* birthday;            //生日
@property(nonatomic, assign) int viplevel;                  //VIP等级
//@property(nonatomic, assign) int playerlevel;               //主持等级
@property(nonatomic, assign) int guishuRoomId;
//@property(nonatomic, assign) int guishuDailiId;
@property(nonatomic, copy) NSString* gsRoomName;
@property(nonatomic, copy) NSString* gsRoomGate;

@property(nonatomic, assign) long long int nk;              //金币
@property(nonatomic, assign) long long int nb;              //积分
@property(nonatomic, strong) NSString* sessionMask;         //session标志
@property(nonatomic, assign) int nextAction;                //下一步动作

@property(nonatomic, strong) NSString* tmpLogonAccount;     //保存临时登录账号
@property(nonatomic, strong) NSString* tmpLogonPwd;         //保存临时登录密码

-(void)reset;

@end
