//
//  ClientRoomModel.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClientUserModel.h"

@interface ClientRoomModel : NSObject

@property(nonatomic, assign)int roomId;              //房间ID
@property(nonatomic, strong)NSString* roomName;
@property(nonatomic, assign)int creatorId;           //创建人
@property(nonatomic, assign)int op1;
@property(nonatomic, assign)int op2;
@property(nonatomic, assign)int op3;
@property(nonatomic, assign)int op4;
@property(nonatomic, assign)int op5;
@property(nonatomic, assign)int op6;
@property(nonatomic, strong)NSString*  notice1;
@property(nonatomic, strong)NSString*  notice2;
@property(nonatomic, strong)NSString*  notice3;
@property(nonatomic, strong)NSString*  notice4;
@property(nonatomic, strong) NSString* roomGateAddr;
@property(nonatomic, strong) NSString* roomMediaAddr;
@property(nonatomic, assign)int isConnected;         //是否连接
@property(nonatomic, assign)int isJoinRoomFinished;  //是否加入成功
@property(nonatomic, assign)int connectedCount;      //连接成功次数

@property(nonatomic, strong) NSMutableArray* memberList;  //房间成员列表(非隐身)
@property(nonatomic, strong) NSMutableArray* allMemberList; //房间成员列表(所有)
@property(nonatomic, strong) NSMutableArray* onMicUserList;  //在麦成员列表


//函数
-(void) reset;

-(ClientUserModel*) findAllMember: (int)userId;
-(ClientUserModel*) findMember :(int) userId;
-(ClientUserModel*) findOnMicUser: (int) userId;

-(void) addaAllMember: (ClientUserModel *)userObj;
-(void) addMember: (ClientUserModel*) userObj;
-(void) addOnMicUser:(ClientUserModel*) userObj;

-(void) delAllMember: (int)userId;
-(void) delMember: (int) userId;
-(void) delOnMicUser: (int)userId;

-(void) clearAllMember;
-(void) clearMember;
-(void) clearOnMicUser;

@end
