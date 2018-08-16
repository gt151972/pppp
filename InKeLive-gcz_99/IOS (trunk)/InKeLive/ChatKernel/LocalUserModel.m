//
//  LocalUserModel.m
//  bazhouchat03
//
//  Created by gu  on 16/6/26.
//  Copyright © 2016年 gu . All rights reserved.
//
//本地用户信息

#import "LocalUserModel.h"

@implementation LocalUserModel

-(void)reset
{
    self.userID = 0;
    self.userLogonPwd = @"";
    self.userMobile = @"";
    self.userName = @"";

    self.userSmallHeadPic = @"";
    self.userBigHeadPic = @"";
    self.downloadUserHeadPic =@"";
    self.bankUserName = @"";
    self.bankCardNo =@"";
    self.bankName = @"";
    self.gender = 0;
    self.birthday =@"";
    self.viplevel = 0;
    self.playerlevel =0;
    self.guishuRoomId = 0;
    self.guishuDailiId = 0;
    self.nk = 0;
    self.nb = 0;
    self.sessionMask =@"";
    self.nextAction =0;
    self.tmpLogonAccount =@"";
    self.tmpLogonPwd = @"";
}

@end
