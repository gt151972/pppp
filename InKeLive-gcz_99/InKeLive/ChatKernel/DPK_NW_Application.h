//
//  DPK_NW_Application.h
//  InKeLive
//
//  Created by gu  on 17/8/12.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalUserModel.h"
#import "ClientConfigParam.h"
#import "TempQueryVCBSvrInfo.h"
#import "TempLogonInfo.h"
#import "TempCreateRoomInfo.h"
#import "TempJoinRoomInfo.h"
#import "DPKTCPSocket.h"
#import "GTGiftGroupModel.h"
#import "GTGiftListModel.h"

@interface DPK_NW_Application : NSObject<DPKTCPSocketSink>
{
    NSMutableArray* m_roomSocketArray;   //房间socket保存数组
}

@property(nonatomic, assign)BOOL isLogon;   //是否已经登录?
@property(nonatomic, strong)LocalUserModel * localUserModel;   //用户本地数据
@property(nonatomic, strong)ClientConfigParam* clientConfigParam; //客户端配置数据
@property(nonatomic, strong)TempQueryVCBSvrInfo* tmpQueryVCBSvrInfo;  //临时查询服务器结果信息
@property(nonatomic, strong)TempCreateRoomInfo * tempCreateRoomInfo; //临时创建房间数据
@property(nonatomic, strong)TempJoinRoomInfo * tempJoinRoomInfo;     //临时加入房间信息
@property(nonatomic, strong)NSMutableArray* giftList;   //礼物配置
@property(nonatomic, strong)NSMutableArray* giftGroup; //礼物配置


+(DPK_NW_Application*) sharedInstance;

+(NSString *)md5:(NSString *)str;
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)dstSize;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

-(DPKTCPSocket*) CreateSocket;
-(int) CloseRoomSocket:(DPKTCPSocket*)sock;
-(int)SetRoomMessageSink:(DPKTCPSocket*)sock RoomMessageSink:(id) delegate;

-(void) loadGiftVersion;
-(GTGiftListModel*) findGiftConfig:(int)giftId;

@end
