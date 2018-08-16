//
//  TempJoinRoomInfo.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "TempJoinRoomInfo.h"

@interface TempJoinRoomInfo()
@property(nonatomic, strong ) NSMutableArray* addrList;
@end

@implementation TempJoinRoomInfo


-(void) reset
{
    self.roomId = 0;
    self.lookUserId = 0;
    self.roomName = @"";
    if(_addrList != nil)
       [_addrList removeAllObjects];
}

-(void)setGateAddr:(NSString *)gateAddr
{
    //6位数解析
    [self parseGateAddr : gateAddr];
}

-(void)setGateAddr2:(NSString *)gateAddr
{
    //4位数解析
    [self parseGateAddr2 : gateAddr];
}

-(LWServerAddr*)getGateAddr:(int) pos
{
    if(_addrList ==nil || pos >= _addrList.count)
        return nil;
    return [_addrList objectAtIndex:pos];
}


-(void) parseGateAddr:(NSString*) gateAddr
{
    if(_addrList==nil)
        _addrList = [NSMutableArray array];
    [_addrList removeAllObjects];
    //这里的数据已经没有roomId:roomName了，和PC端的有区别
    //字符串分割
    //gateAddr = [gateAddr stringByReplacingOccurrencesOfString: @"," withString:@";"];
    gateAddr = [gateAddr stringByReplacingOccurrencesOfString: @"," withString:@";"];
    gateAddr = [gateAddr stringByReplacingOccurrencesOfString: @":" withString:@";"];
    NSArray *array = [gateAddr componentsSeparatedByString:@";"];
    if(array.count == 6) {
        //_roomId = [[array objectAtIndex:0] intValue];
        //_roomName = [array objectAtIndex:1];
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
        //
        serverAddr = [[LWServerAddr alloc]init];
        serverAddr.addr = [array objectAtIndex:4];
        serverAddr.port = [[array objectAtIndex:5] intValue];
        serverAddr.addrType = 0;
        [_addrList addObject:serverAddr];
    }
    else {
        NSLog(@"array2 == %@",array);
        NSLog(@"解析数目(%d)有错误,只能解析6位格式!", array.count);
    }
}

-(void) parseGateAddr2:(NSString*) gateAddr
{
    if(_addrList==nil)
        _addrList = [NSMutableArray array];
    [_addrList removeAllObjects];
    //字符串分割

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
}



@end
