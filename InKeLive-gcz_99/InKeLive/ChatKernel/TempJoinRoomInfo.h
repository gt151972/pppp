//
//  TempJoinRoomInfo.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWServerAddr.h"

@interface TempJoinRoomInfo : NSObject

@property(nonatomic, assign)int roomId;
@property(nonatomic, assign)int lookUserId;
@property(nonatomic, strong)NSString* roomName;
@property(nonatomic, assign)BOOL isHide;
@property(nonatomic, strong)NSDictionary *dicRoomInfo;


-(void) reset;

-(void)setGateAddr:(NSString *)gateAddr;
-(void)setGateAddr2:(NSString *)gateAddr;
-(LWServerAddr*)getGateAddr:(int) pos;


@end
