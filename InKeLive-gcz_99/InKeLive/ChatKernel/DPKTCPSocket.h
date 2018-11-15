

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "msg_defines.h"
#import "msg_commands.h"

#define SOCKET_TCP_BUFFER_SIZE   16384
#define SOCKET_TCP_BUFFER_MAXSIZE SOCKET_TCP_BUFFER_SIZE *10

@class DPKTCPSocket;
//
@protocol DPKTCPSocketSink
- (void)OnEventTCPSocketLink:(DPKTCPSocket*)sock error:(int) error_code;
- (void)OnEventTCPSocketShut:(DPKTCPSocket*)sock reason:(int)reason_code;
- (void)OnEventTCPSocketRead:(DPKTCPSocket*)sock MainCommand:(int)main_cmd
                  SubCommand:(int)sub_cmd
                        Data:(char*)data
                        time:(int)time
                      roomID:(int)roomID
                      userID:(int)userID
                     DataLen:(int)data_len;
@end //DPKTCPSocketSink

///////////////////////////////////////////////////////////////////
@protocol DPKRoomMessageSink

@required
- (void) OnDPKEventTCPSocketLink:(int)error_code;
- (void) OnDPKEventTCPSocketShut:(int)reason_code;

//各种业务回文回调函数
//创建房间响应(主播端)
- (void) OnNetMsg_CreateRoomResp:(int)error_code
                       UserID:(int)userId
                          RoomID:(int)roomId
                       CreatorID:(int)creatorId
                        RoomName:(NSString*)roomName
                        ServerAddr:(NSString*)serverAddr
						GateAddr:(NSString*)gateAddr
                       MediaAddr:(NSString*)mediaAddr
                      ServerPort:(int)serverPort;

//上手机麦响应(手机版)
-(void)OnNetMsg_UpMBMicResp:(int)error_code
                     UserID:(int)userId
                     RoomID:(int)roomId
              UserRoomState:(int)userRoomState
                   TLStatus:(int)tlStatus
                TLMediaUrl1:(NSString*)tlMediaUrl1
                TLMediaUrl2:(NSString*)tlMediaUrl2;

//上手机麦通知(手机版)
-(void)OnNetMsg_UpMBMicNoty:(int)userId
                     RoomID:(int)roomId
              UserRoomState:(int)userRoomState
                   TLStatus:(int)tlStatus
                TLMediaUrl1:(NSString*)tlMediaUrl1
                TLMediaUrl2:(NSString*)tlMediaUrl2;

//下手机麦响应(手机版)
-(void)OnNetMsg_DownMBMicResp:(int)error_code
                       UserID:(int)userId
                       RoomID:(int)roomId
                UserRoomState:(int)userState;

//下手机麦通知(手机版)
-(void)OnNetMsg_DownMBMicNoty:(int)userId
                       RoomID:(int)roomId
                UserRoomState:(int)userRoomState;

//设置推流状态响应(手机版)
-(void)OnNetMsg_SetMBTLStatusResp:(int)error_code
                           UserID:(int)userId
                           RoomID:(int)roomId
                         TLStatus:(int)tlStatus;

//设置推流状态通知(手机版)
-(void)OnNetMsg_SetMBTLStatusNoty:(int)userId
                           RoomID:(int)roomId
                         TLStatus:(int)tlStatus;

//加入房间响应
-(void) OnNetMsg_JoinRoomResp:(int)error_code
                    VersionID:(int)VersionId
					UserID:(int)userId
					VcbID:(int)vcbId
                    CreatorID:(int)creatorId
					OPUserID01:(int)opUserId01
					OPUserID02:(int)opUserId02
					OPUserID03:(int)opUserId03
					OPUserID04:(int)opUserId04
					OPUserID05:(int)opUserId05
					OPUserID06:(int)opUserId06
					RoomState:(int)roomState
                   LayoutType:(int)layoutType
                   RoomAttrId:(int)roomAttId
                  Reserved_01:(int)reserved_01
                  Reserved_02:(int)reserved_02
                     RoomName:(NSString*)roomName
                  MediaServer:(NSString*)mediaServer
				    RoomIsUsedPwd:(int)roomIsUsedPwd
                     VipLevel:(int)vipLevel
                  PlayerLevel:(int)playerLevel
				  RoomLevel:(int)roomLevel
				  UserRoomState:(int)userRoomState
                           NK:(int64_t)nk
                           NB:(int64_t)nb
                       Ngende:(int)ngende;

//获取房间用户列表
-(void) OnNetMsg_RoomUserListBegin;
-(void) OnNetMsg_RoomUserListItem:(int)roomId
                           UserID:(int)userId
                           Gender:(int)gender
                         VipLevel:(int)vipLevel
                      PlayerLevel:(int)playerLevel
					  RoomLevel:(int)roomLevel
                      InRoomState:(int)inroomstate
                         ComeTime:(int)comeTime
						 SealID:(int)sealId
						 SealExpiredTime:(int)sealExpiredTime
						 CarID:(int)carId
                         param_01:(int)param_01
                        UserAlias:(NSString*)userAlias
                      UserHeadPic:(NSString*)userHeadPic
                     nVideoStatus:(int)nVideoStatus
                     nAudioStatus:(int)nAudioStatus;
-(void) OnNetMsg_RoomUserListEnd;

//获取房间在麦用户列表
-(void)OnNetMsg_RoomOnMicUserListBegin;
-(void)OnNetMsg_RoomOnMicUserListItem:(int)roomId
                               UserID:(int)userId
                        UserRoomState:(int)userRoomState
                             VipLevel:(int)vipLevel
                          PlayerLevel:(int)playerLevel
                            RoomLevel:(int)roomLevel
                             TLStatus:(int)tlStatus
                             UserName:(NSString*)userName
                          TLMediaUrl1:(NSString*)tlMediaUrl1
                          TLMediaUrl2:(NSString*)tlMediaUrl2;
-(void)OnNetMsg_RoomOnMicUserListEnd;


//加入房间结束
-(void) OnNetMsg_JoinRoomFinished;

//房间信息(变化)通知
-(void) OnNetMsg_RoomInfoNoty:(int)errroCode
                     RunnerID:(int)runnerId
                       RoomID:(int)roomId
                    CreatorID:(int)creatorId
                     OpUser01:(int)opUser01
                     OpUser02:(int)opUser02
                     OpUser03:(int)opUser03
                     OpUser04:(int)opUser04
                     OpUser05:(int)opUser05
                     OpUser06:(int)opUser06
                      OpState:(int)opState
                     RoomName:(NSString*)roomName
                    IsUsedPwd:(int)isUsedPwd;

//房间公告(变化)通知
-(void) OnNetMsg_RoomNoticeNoty:(int)errorCode
                       RunnerID:(int)runnerId
                         RoomID:(int)roomId
                        TextLen:(int)textLen
                      TextIndex:(int)textIndex
                           Text:(NSString*)text;

//房间媒体服务器变化通知
-(void) OnNetMsg_RoomMediaServerNoty:(int)errorCode
                              RoomID:(int)roomId
                        MediaSvrAddr:(NSString*)mediaSvrAddr;


//新用户进入通知 
-(void) OnNetMsg_RoomUserComeNoty:(int)roomId
                           UserID:(int)userId
                           Gender:(int)gender
                         VipLevel:(int)vipLevel
                      PlayerLevel:(int)playerLevel
                        RoomLevel:(int)roomLevel
                      InRoomState:(int)inroomstate
                         ComeTime:(int)comeTime
                           SealID:(int)sealId
                  SealExpiredTime:(int)sealExpiredTime
                           CardID:(int)cardId
                         param_01:(int)param_01
                        UserAlias:(NSString*)userAlias
                      UserHeadPic:(NSString*)userHeadPic
                      videoStatus:(int)videoStatus
                      audioStatus:(int)audioStatus;

//用户聊天通知 
-(void)OnNetMsg_RoomChatMsgNoty:(int)roomId
                          SrcID:(int)srcId
                           ToID:(int)toId
                        MsgType:(int)msgType
                        TextLen:(int)textLen
                   SrcUserAlias:(NSString*)srcUserAlias
                    ToUserAlias:(NSString*)toUserAlias
                    ChatContent:(NSString*)chatContent
                          error:(int)error;

//用户赠送礼物响应
-(void)OnNetMsg_RoomSendGiftResp:(int)error_code;

//用户赠送礼物通知
-(void)OnNetMsg_RoomSendGiftNoty:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                          GiftID:(int)giftId
                         GiftNum:(int)giftNum
                           flyId:(int)flyId
                         TextLen:(int)textLen
                    SrcUserAlias:(NSString*)srcUserAlias
                     ToUserAlias:(NSString*)toUserAlias
                        GiftText:(NSString*)giftText;

//进房间跑道消息通知
-(void)OnNetMsg_trackInfoNoty:(int)roomId
                        srcId:(int)scrId
                         toId:(int)toId
                       giftId:(int)giftId
                      giftNum:(int)giftNum
                        flyId:(int)flyId
                     castMode:(int)castMode
                   serverMode:(int)serverMode
                     hideMode:(int)hideMode
                     sendType:(int)sendType
                   nextAction:(int)nextAction
                      textLen:(int)textLen
                    reserve01:(int)reserve01
                      srcName:(NSString *)srcName
                       toName:(NSString *)toName
                      vcbName:(NSString *)vcbName
                         text:(NSString *)text;


//获取用户帐户信息响应
-(void)OnNetMsg_GetUserAccoutResp:(int)error_code;

//获取用户账户通知
-(void)OnNetMsg_UserAccountNoty:(int)userId
                             NK:(int64_t)nk
                             NB:(int64_t)nb;

//用户退出房间响应
-(void)OnNetMsg_ExitRoomResp:(int)error_code;

//用户退出房间通知 
-(void)OnNetMsg_ExitRoomNoty:(int)roomId
                      UserID:(int)userId;

//用户上PC麦通知
-(void)OnNetMsg_UpMicNoty:(int)RoomId
                 RunnerID:(int)runnerId
                   UserID:(int)userId
                  MicType:(int)micType
                  Param01:(int)param_01
                  Param02:(int)param_02
            UserRoomState:(int)userRoomState
              TLMediaurl1:(NSString*)tlMediaUrl1
              TLMediaurl2:(NSString*)tlMediaUrl2;

//用户下PC麦通知
-(void)OnNetMsg_DownMicNoty:(int)RoomId
                   RunnerID:(int)runnerId
                     UserID:(int)userId
              UserRoomState:(int)userRoomState;

//删除房间响应
-(void)OnNetMsg_DelRoomResp:(int)error_code
                     RoomID:(int)roomId
                   OPUserID:(int)opuserId;
//删除房间通知
-(void)OnNetMsg_delRoomNoty:(int)roomId
                   OPUserID:(int)opuserId;

//增加/删除管理响应
-(void)OnNetMsg_RoomAddMgrResp:(int)error_code
                        RoomID:(int)roomId
                         SrcID:(int)srcId
                          ToID:(int)toId
                      ActionID:(int)actionId;
//增加/删除管理通知
-(void)OnNetMsg_RoomAddMgrNoty:(int)roomId
                         SrcID:(int)srcId
                          ToID:(int)toId
                 UserRoomState:(int)userRoomState
                      ActionID:(int)actionId;

//禁言/取消禁言响应
-(void)OnNetMsg_RoomForbidUserResp:(int)error_code
                            RoomID:(int)roomId
                             SrcID:(int)srcId
                              ToID:(int)toId
                          ActionID:(int)actionId;
//禁言/取消禁言通知
-(void)OnNetMsg_RoomForbidUserNoty:(int)roomId
                             SrcID:(int)srcId
                              ToID:(int)toId
                     UserRoomState:(int)userRoomState
                          ActionID:(int)actionId;

//踢出用户响应
-(void)OnNetMsg_RoomKickUserResp:(int)error_code
                          RoomID:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                        ReasonID:(int)reasonId;
						
//踢出用户通知
-(void)OnNetMsg_RoomKickUserNoty:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                        ReasonID:(int)reasonId;

//全局聊天(小喇叭，各种系统)信息通知
-(void)OnNetMsg_GlobalChatMsgNoty:(int)roomId
                            SrcID:(int)srcId
                             ToID:(int)toId
                         ChatType:(int)chatType
                          TextLen:(int)textLen
                          SrcName:(NSString*)srcName
                           ToName:(NSString*)toName
                         RoomName:(NSString*)roomName
                             Text:(NSString*)text
                         errorMsg:(int)error;


//用户关注回包
-(void)OnNetMsg_UserAttentionResp:(int)nRet
                            nFlag:(int)nFlag
                          nUserID:(int)nUserID
                          nRoomID:(int)nRoomID
                          nSinger:(int)nSinger;

/**
 积分兑换回调
 
 @param vcbId <#vcbId description#>
 @param userId <#userId description#>
 @param money <#money description#>
 */
-(void)OnNetMsg_ScoreChargeResp:(int)vcbId
                         userId:(int)userId
                          money:(int)money;


/**
 音视频状态变化

 @param roomId 房间Id
 @param userId 用户Id
 @param status 1：视频播放，2视频暂停，3音频播放，4音频暂停
 */
-(void)OnNetMsg_micStatusModifyResp:(int)roomId
                              userId:(int)userId
                             status:(int)status;
@end

///////////////////////////////////////////////////////////////////
@interface DPKTCPSocket : NSObject
{
    GCDAsyncSocket* _asyncSocket;
    __weak id<DPKTCPSocketSink> _socketSink;            //socket回调接口
    __weak id<DPKRoomMessageSink> _messageEventSink;    //message回调接口
    int  m_nRecvSize;
    char m_szRecvBuf[SOCKET_TCP_BUFFER_MAXSIZE];        //接受数据缓冲
}
@property(nonatomic, assign) int roomid;               //如果使用roomid,则使用该属性
@property(nonatomic, assign) int isConnecting;         //socket正在连接标志
@property(nonatomic, assign) int isConnected;          //socket已连接标志

// --基本方法
- (BOOL)ConnectServer:(NSString*)ipAddr ServerPort:(int)port;
- (void)CloseSocket:(int)reason_code;

- (void)SetSocketSink:(id)delegate;
- (void)SetMessageEventSink:(id)delegate;
- (id)GetMessageEventSink;

//发送数据
- (int)SendData:(int)main_cmd SubCommand:(int)sub_cmd;
- (int)SendData:(int)main_cmd SubCommand:(int)sub_cmd
           Data:(const char*)pdata
        DataLen:(int)data_len;
//处理数据
- (int)HandleData:(const char*)pdata DataLen:(int)data_len;

// --发送数据方法
//获取空闲服务器请求(主播端)
-(int)SendQueryRoomServerReq:(int)userId;

//创建房间请求(主播端)
-(int)SendCreateRoomReq:(int)userId
               RoomServerId:(int)roomServerId
               RoomName:(const char*)roomName
                UserPwd:(const char*)userPwd;

//上手机麦请求(主播端)
-(int)SendUpMBMicReq:(int)userId
              RoomID:(int)roomId
          PhoneStyle:(int)phoneStyle
           MBMicType:(int)mbMicType
           PhoneInfo:(const char*)phoneInfo;

//下手机麦请求(主播端)
-(int)SendDownMBMicReq:(int)userId
                RoomID:(int)roomId;

//设置推流状态请求(主播端)
-(int)SendMBTLStatusReq:(int)userId
                 RoomID:(int)roomId
               TLStatus:(int)tlStatus;


//加入房间请求
-(int)SendJoinRoomReq:(int)versionId
               RoomID:(int)roomId
               UserID:(int)userId
          SessionMask:(const char*)sessionMask
              UserPwd:(const char*)userPwd
              RoomPwd:(const char*)roomPwd
          IsReconnect:(int)isReconnect
               IsHide:(int)isHide
             isMobile:(int)isMobile;

//发送房间聊天请求
-(int)SendRoomChatMsgReq:(int)roomId
                   SrcID:(int)srcId
                    ToID:(int)toId
                 MsgType:(int8_t)msgType
                 TextLen:(int16_t)textLen
            SrcUserAlias:(const char*)srcUserAlias
             ToUserAlias:(const char*)toUserAlias
              MsgContent:(const char*)msgContent;

//发送房间赠送礼物请求
-(int)SendRoomGiftReq:(int)roomId
                 SrcID:(int)srcId
                  ToID:(int)toId
                GiftID:(int16_t)giftId
               GiftNum:(int16_t)giftNum
               TextLen:(int16_t)textLen
          SrcUserAlias:(const char*)srcUserAlias
           ToUserAlias:(const char*)toUserAlias
              GiftText:(const char*)giftText
              hideMode:(int8_t)hideModel;

//发送房间请求用户账户信息请求
-(int)SendGetUserAccountReq:(int)roomId
                       SrcID:(int)srcId
                        ToID:(int)toId;

//发出退出房间请求
-(int)SendExitRoomReq:(int)roomId
                UserID:(int)userId;

//发出删除房间请求
-(int)SendDelRoomReq:(int)roomId
             OPUserID:(int)opuserId;

//发送房间增加/删除管理请求
-(int)SendRoomAddMgrReq:(int)roomId
                   SrcID:(int)srcId
                    ToID:(int)toId
                ActionID:(int8_t)actionId;

//发送房间禁言/取消禁言请求
-(int)SendRoomForbidChatReq:(int)roomId
                       SrcID:(int)srcId
                        ToID:(int)toId
                    ActionID:(int8_t)actionId;

//发送房间踢出用户请求
-(int)SendRoomKickUserReq:(int)roomId
                     SrcID:(int)srcId
                      ToID:(int)toId
                  ReasonID:(int)reasonId;

//发送房间心跳消息
-(int)SendRoomKeeplive:(int)roomId
                UserID:(int)userId;

//用户关注请求
-(int)SendUserAttentionReq:(int)nFlag
                    uUserID:(int)nUserID
                    nRoomID:(int)nRoomID
                    nSinger:(int)nSinger;
//积分兑换
-(int)sendScoreChargeReq:(int)vcbId
                  userId:(int)userId
                   money:(int)money;


/**
 麦状态更改

 @param roomId 房间Id
 @param userId 用户Id
 @param status 1：视频播放，2视频暂停，3音频播放，4音频暂停
 @return 
 */
-(int)sendMicStatusModifyReq:(int)roomId
                      userId:(int)userId
                      status:(int)status;
@end

///////////////////////////////////////////////////////////////////




