//
//  TempCreateRoomInfo.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWServerAddr.h"

@interface TempCreateRoomInfo : NSObject

@property(nonatomic, assign) int roomId;
@property(nonatomic, assign) int creatorId;
@property(nonatomic, assign) int serverId;
@property(nonatomic, strong) NSString* roomName;



-(void)reset;
-(void)setGateAddr:(NSString *)gateAddr;
-(LWServerAddr*)getGateAddr:(int) pos;

@end
