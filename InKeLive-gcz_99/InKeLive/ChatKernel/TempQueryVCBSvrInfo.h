//
//  TempQueryVCBSvrInfo.h
//  InKeLive
//
//  Created by gu  on 17/8/16.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempQueryVCBSvrInfo : NSObject

@property(nonatomic, assign) int serverId;
@property(nonatomic, strong) NSString* serverAddr;
@property(nonatomic, assign) int serverPort;
@property(nonatomic, assign) int roomId;
@property(nonatomic, strong) NSString* roomGateAddr;
@property(nonatomic, assign) int userCount0;
@property(nonatomic, assign) int userCount1;
@property(nonatomic, assign) int roomCount0;
@property(nonatomic, assign) int roomCount1;


-(void) reset;

@end
