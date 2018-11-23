//
//  ClientUserModel.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientUserModel : NSObject

@property(nonatomic, assign) int userId;
@property(nonatomic, assign) unsigned int inRoomState;
@property(nonatomic, assign) int vipLevel;
@property(nonatomic, assign) int userLevel;//用于房间排序
@property(nonatomic, assign) int roomLevel;
@property(nonatomic, assign) int playerLevel;
@property(nonatomic, assign) int mbTLstatus;
@property(nonatomic, assign) int64_t nk;
@property(nonatomic, assign) int64_t nb;
@property(nonatomic, strong) NSString* userAlias;
@property(nonatomic, strong) NSString* userSmallHeadPic;
@property(nonatomic, strong) NSString* userBigHeadPic;
@property(nonatomic, strong) NSString* pushStreamUrl;
@property(nonatomic, strong) NSString* pullStreamUrl;
@property(nonatomic, strong) NSString* szcidiograph;//签名
@property(nonatomic, assign) int isAttention;//是否被关注
@property(nonatomic, assign) int isVideoStatus;//视频播放状态
@property(nonatomic, assign) int isAudioStatus;//音频播放状态
@property(nonatomic, assign) int micState;//麦状态(0:非主播 1:公麦 7:手机私麦 2:私麦)
@property(nonatomic, assign) int param_01;//用于主播列表排序(先公麦的012,再私麦)

-(void) reset;
@end
