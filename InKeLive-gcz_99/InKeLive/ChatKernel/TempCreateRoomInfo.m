//
//  TempCreateRoomInfo.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "TempCreateRoomInfo.h"


@interface TempCreateRoomInfo()
@property(nonatomic, strong ) NSMutableArray* addrList;
@end

@implementation TempCreateRoomInfo


-(void)reset
{
    self.roomId = 0;
    self.creatorId = 0;
    self.serverId = 0;
    self.roomName =@"";
    if(_addrList != nil)
        [_addrList removeAllObjects];
}

-(LWServerAddr*)getGateAddr:(int) pos
{
    if(_addrList ==nil || pos >= _addrList.count)
        return nil;
    return [_addrList objectAtIndex:pos];
}

-(void)setGateAddr:(NSString *)gateAddr
{
    [self parseGateAddr : gateAddr];
}

-(void) parseGateAddr:(NSString*) gateAddr
{
    if(_addrList==nil)
        _addrList = [NSMutableArray array];
    [_addrList removeAllObjects];
    //字符串分割
    //NSString *nstring = @"美国,加拿大,澳大利亚,津巴布韦,埃及";
    //NSArray *array = [nstring componentsSeparatedByString:@","];
    //for (int i = 0; i < [array count]; i++) {
    //    NSLog(@"string:%@", [array objectAtIndex:i]);
    //}
    gateAddr = [gateAddr stringByReplacingOccurrencesOfString: @"," withString:@";"];
    gateAddr = [gateAddr stringByReplacingOccurrencesOfString: @":" withString:@";"];
    NSArray *array = [gateAddr componentsSeparatedByString:@";"];
    if(array.count == 4) {
        LWServerAddr* serverAddr = [[LWServerAddr alloc] init];
        serverAddr.addr = [array objectAtIndex:0];
        serverAddr.port = [[array objectAtIndex:1] intValue];
        serverAddr.addrType = 0;
        [_addrList addObject:serverAddr];
        //
        serverAddr = [[LWServerAddr alloc]init];
        serverAddr.addr = [array objectAtIndex:2];
        serverAddr.port = [[array objectAtIndex:3] intValue];
        serverAddr.addrType = 0;
        [_addrList addObject:serverAddr];
    }
    NSLog(@"array == %@",array);
}

@end
