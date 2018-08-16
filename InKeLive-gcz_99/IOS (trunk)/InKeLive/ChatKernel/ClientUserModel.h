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

-(void) reset;
@end
