//
//  TempQueryVCBSvrInfo.m
//  InKeLive
//
//  Created by gu  on 17/8/16.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "TempQueryVCBSvrInfo.h"

@implementation TempQueryVCBSvrInfo

-(void) reset
{
    self.serverId = 0;
    self.serverAddr = @"";
    self.serverPort =0;
    self.roomId = 0;
    self.roomGateAddr = @"";
    self.userCount0 = 0;
    self.userCount1 = 0;
    self.roomCount0 = 0;
    self.roomCount1 = 0;
}

@end
