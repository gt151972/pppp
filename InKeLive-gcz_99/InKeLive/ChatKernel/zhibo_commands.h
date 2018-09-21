//
//  zhibo_commands.h
//  1234
//
//  Created by 高婷婷 on 2018/8/8.
//  Copyright © 2018年 高婷婷. All rights reserved.
//

#ifndef __ZHIBO_COMMANDS_HH__
#define __ZHIBO_COMMANDS_HH__

#include "mxpbase_commands.h"

#define MXP_MAINCMD_VIDEOCHAT  102

#define MXP_SUBCMD_VIDEOCHAT_USERLOGON_REQ       1001    //用户登录请求
#define MXP_SUBCMD_VIDEOCHAT_USERLOGON_RESP      1002    //用户登录响应
#define MXP_SUBCMD_VIDEOCHAT_GUESTLOGON_REQ      1003    //游客登陆

#define MXP_SUBCMD_VIDEOCHAT_JOINROOM_REQ        1011    //加入房间请求
#define MXP_SUBCMD_VIDEOCHAT_JOINROOM_RESP       1012    //加入房间响应

#define MXP_SUBCMD_VIDEOCHAT_JOINROOM_FINISH     1013    //加入房间完成

#define MXP_SUBCMD_VIDEOCHAT_ROOMINFO_NOTY       1014    //房间信息通知
#define MXP_SUBCMD_VIDEOCHAT_ROOMNOTICE_NOTY     1015    //房间公告通知
#define MXP_SUBCMD_VIDEOCHAT_ROOMMICSTATE_NOTY   1016    //房间麦状态通知
#define MXP_SUBCMD_VIDEOCHAT_FLYGIFTRECORD_NOTY  1017    //房间跑道礼物通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_BEGIN  1018    //房间成员列表开始
#define MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_DATA   1019    //房间成员列表数据
#define MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_END    1020    //房间成员列表结束

#define MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_REQ     1021    //房间聊天请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_RESP    1022    //房间聊天响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_NOTY    1023    //房间聊天通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_REQ    1024    //房间赠送礼物请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_RESP   1025    //房间赠送礼物响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_NOTY   1026    //房间赠送礼物通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMUPMIC_REQ       1027    //房间上麦请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMUPMIC_RESP      1028    //房间上麦响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMUPMIC_NOTY      1029    //房间上麦通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMDOWNMIC_REQ     1030    //房间下麦请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMDOWNMIC_RESP    1031    //房间下麦响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMDOWNMIC_NOTY    1032    //房间下麦通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMPAIMIC_REQ      1033    //房间排麦请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMPAIMIC_RESP     1034    //房间排麦响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMPAIMIC_NOTY      1035   //房间排麦通知

#define MXP_SUBCMD_VIDEOCHAT_EXITROOM_REQ        1036    //退出房间请求
#define MXP_SUBCMD_VIDEOCHAT_EXITROOM_RESP       1037    //退出房间响应
#define MXP_SUBCMD_VIDEOCHAT_EXITROOM_NOTY       1038    //退出房间通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_REQ   1039   //房间踢出用户请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_RESP  1040   //房间踢出用户响应
#define MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_NOTY  1041   //房间踢出用户通知

#define MXP_SUBCMD_VIDEOCHAT_SETROOMINFO_REQ       1042   //设置房间信息请求
#define MXP_SUBCMD_VIDEOCHAT_SETROOMINFO_RESP      1043

#define MXP_SUBCMD_VIDEOCHAT_SETROOMNOTICE_REQ     1044   //设置房间公告请求
#define MXP_SUBCMD_VIDEOCHAT_SETROOMNOTICE_RESP    1045

#define MXP_SUBCMD_VIDEOCHAT_SETUSERINFO_REQ       1046   //设置用户信息请求
#define MXP_SUBCMD_VIDEOCHAT_SETUSERINFO_RESP      1047

#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_REQ        1048   //房间增加管理请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_RESP       1049
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_NOTY       1050

#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMGR_REQ        1051   //房间删除管理请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMGR_RESP       1052
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMGR_NOTY       1053

#define MXP_SUBCMD_VIDEOCHAT_ROOMNB2NK_REQ         1054    //房间积分换币请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMNB2NK_RESP        1055

#define MXP_SUBCMD_VIDEOCHAT_ROOMTRANSFER_REQ      1056    //房间金币转账请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMTRANSFER_RESP     1057
#define MXP_SUBCMD_VIDEOCHAT_ROOMTRANSFER_NOTY     1058

#define MXP_SUBCMD_VIDEOCHAT_ROOMNB2RMB_REQ        1059    //房间积分换RMB请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMNB2RMB_RESP       1060

#define MXP_SUBCMD_VIDEOCHAT_ROOMKEEPLIVE_REQ      1061    //房间心跳请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMKEEPLIVE_RESP     1062

#define MXP_SUBCMD_VIDEOCHAT_LOTTERY_XINYUN_NOTY   1063    //幸运礼物奖励通知
#define MXP_SUBCMD_VIDEOCHAT_LOTTERY_BAOZHA_NOTY   1064    //爆炸礼物奖励通知

#define MXP_SUBCMD_VIDEOCHAT_ROOMUSERCOMEIN_NOTY   1065    //房间用户进入通知

#define MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_REQ       1066    //获取用户账户请求
#define MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_RESP      1067
#define MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_NOTY      1068    //刷新金币金额

#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_REQ   1069    //房间增加禁言用户
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_RESP  1070
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_NOTY  1071

#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMUTEUSER_REQ   1072    //房间删除禁言用户
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMUTEUSER_RESP  1073
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELMUTEUSER_NOTY  1074

#define MXP_SUBCMD_VIDEOCHAT_ROOMADDBALCKUSER_REQ  1075    //房间增加黑名单用户请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDBLACKUSER_RESP 1076
#define MXP_SUBCMD_VIDEOCHAT_ROOMADDBLACKUSER_NOTY 1077

#define MXP_SUBCMD_VIDEOCHAT_ROOMDELBALCKUSER_REQ  1078    //房间删除黑名单请求
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELBLACKUSER_RESP 1079
#define MXP_SUBCMD_VIDEOCHAT_ROOMDELBLACKUSER_NOTY 1080

#define MXP_SUBCMD_VIDEOCHAT_TRANSMEDIA_REQ        1081    //媒体请求
#define MXP_SUBCMD_VIDEOCHAT_TRANSMEDIA_RESP       1082

#define MXP_SUBCMD_VIDEOCHAT_ROOMMEDIASERVER_NOTY  1083     //房间媒体服务器地址更新通知
#define MXP_SUBCMD_VIDEOCHAT_SETROOMMEDIASERVER_REQ       1084   //设置房间媒体服务器地址请求
#define MXP_SUBCMD_VIDEOCHAT_SETROOMMEDIASERVER_RESP      1085

#define MXP_SUBCMD_VIDEOCHAT_REGISTUSER_REQ        1086    //注册用户请求
#define MXP_SUBCMD_VIDEOCHAT_REGISTUSER_RESP       1087

#define MXP_SUBCMD_VIDEOCHAT_CLEARROOMCHAT_REQ     1088    //房间清理屏幕信息请求
#define MXP_SUBCMD_VIDEOCHAT_CLEARROOMCHAT_RESP    1089
#define MXP_SUBCMD_VIDEOCHAT_CLEARROOMCHAT_NOTY    1090

#define MXP_SUBCMD_VIDEOCHAT_SETROOMLAYOUT_REQ    1091    //房间设置UI布局请求
#define MXP_SUBCMD_VIDEOCHAT_SETROOMLAYOUT_RESP   1092
#define MXP_SUBCMD_VIDEOCHAT_SETROOMLAYOUT_NOTY   1093

#define MXP_SUBCMD_VIDEOCHAT_SETAPPZHUBO_REQ      1094    //房间设置APP主播请求
#define MXP_SUBCMD_VIDEOCHAT_SETAPPZHUBO_RESP     1095
#define MXP_SUBCMD_VIDEOCHAT_SETAPPZHUBO_NOTY     1096

#define MXP_SUBCMD_VIDEOCHAT_GLOBALCHAT_REQ       1097    //全局聊天请求，系统聊天请求，系统消息请求
#define MXP_SUBCMD_VIDEOCHAT_GLOBALCHAT_RESP      1098    // 发送消息的响应(有错误时)
#define MXP_SUBCMD_VIDEOCHAT_GLOBALCHAT_NOTY      1099    //全局聊天消息，兼做"系统公告/通知消息"的通知(如游戏中奖消息)

#define MXP_SUBCMD_VIDEOCHAT_SETUSERPWD_REQ       1100     //设置用户密码请求(登录密码，交易密码)
#define MXP_SUBCMD_VIDEOCHAT_SETUSERPWD_RESP      1101

#define MXP_SUBCMD_VIDEOCHAT_FLYGIFT_INFO         1102     //跑道礼物记录信息 (加入房间时)

#define MXP_SUBCMD_VIDEOCHAT_GETUSERIP_REQ        1103     //查看用户IP请求
#define MXP_SUBCMD_VIDEOCHAT_GETUSERIP_RESP       1104     //查看用户IP响应

#define MXP_SUBCMD_VIDEOCHAT_SIEGE_INFO           1105     //城主纪录信息(加入房间时和纪录变化时)

#define MXP_SUBCMD_VIDEOCHAT_QUERY_VCBSERVER_REQ  1106     //查询空闲的房间服务器(用于创建房间)
#define MXP_SUBCMD_VIDEOCHAT_QUERY_VCBSERVER_RESP 1107     //查询空闲的房间服务器响应

#define MXP_SUBCMD_VIDEOCHAT_CREATE_MOBILEROOM_REQ 1108    //创建移动直播房间请求
#define MXP_SUBCMD_VIDEOCHAT_CREATE_MOBILEROOM_RESP 1109   //创建移动直播房间响应

#define MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_REQ   1120     //删除直播房间请求
#define MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_RESP   1121
#define MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_NOTY   1122

#define MXP_SUBCMD_VIDEOCHAT_UPMBMIC_REQ          1130    //上手机麦请求（开播)
#define MXP_SUBCMD_VIDEOCHAT_UPMBMIC_RESP         1131
#define MXP_SUBCMD_VIDEOCHAT_UPMBMIC_NOTY         1132

#define MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_REQ        1133    //下手机麦请求(停播)
#define MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_RESP       1134
#define MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_NOTY       1135

#define MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_REQ    1136    //设置手机麦推流状态请求
#define MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_RESP   1137
#define MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_NOTY   1138

#define MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_BEGIN  1139  //手机麦主播用户列表(含状态)
#define MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_DATA   1140
#define MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_END    1141

//#define MXP_SUBCMD_VIDEOCHAT_ROOMMBZBUSER_STATUS     1142  //手机麦主播用户状态通知(含信息)

#define MXP_SUBCMD_VIDEOCHAT_GETSYSTEMNOTICE_REQ      1143  //获取"系统公告/通知列表"请求(定时请求),这里获取的都是"非一次性系统公告/通知信息"。
#define MXP_SUBCMD_VIDEOCHAT_SYSTEMNOTICELIST_BEGIN   1144
#define MXP_SUBCMD_VIDEOCHAT_SYSTEMNOTICELIST_DATA    1145
#define MXP_SUBCMD_VIDEOCHAT_SYSTEMNOTICELIST_END     1146

#define MXP_SUBCMD_WEB_USERPAY_REQ                    1166        //用户充值通知
#define MXP_SUBCMD_WEB_GIFTVERSIONMODIFY_REQ          1167        //礼物版本号变动通知

#define MXP_SUBCMD_VIDEOCHAT_USERATTENTION_REQ            1168        //用户关注请求
#define MXP_SUBCMD_VIDEOCHAT_USERATTENTION_RESP            1169        //用户关注回包


//////////////////////////////////////////////////////////////////////////
#pragma pack(1)

#define JOINROOM_VERSION  ((1<<24)||(0<<16)||(0<<8)||3)    //1.0.0.3 #20170916

//////////////////////////////////////////////////////////////////////////
#pragma pack(1)

//用户登录请求
typedef struct _tag_HBCMD_VideoChat_UserLogon_Req
{
    uint32  userId;
    char    szAccount[32];
    uint32  maskCode;            //session-mask
    char    userPwd[PWDLEN];
    uint8   isMobile;            //1 PC手机登录  2 PC用户ID登录，3 android手机登录 4 android用户ID登录 5 IOS手机登录 6 IOS用户ID登录
    char    szIpAddr[IPADDRLEN];
    char    szSoftSerialMd5[MD5LEN];
    char    szMacAddrMd5[MD5LEN];
}HBCMD_VideoChat_UserLogon_Req_t;
//用户登录响应
typedef struct _tag_HBCMD_VideoChat_UserLogon_Resp
{
    int32   errorCode;
    uint32  userId;
    uint32  maskCode;
    char    userName[NAMELEN];    //用户呢称
    uint8   vipLevel;
    uint8   playerLevel;
    int64   user_nk;
    int64   user_nb;
    int8    ngender ;        //用户性别
    char    szguid[32] ;        //用户本次安全校验码
}HBCMD_VideoChat_UserLogon_Resp_t;

//加入房间请求
typedef struct _tag_HBCMD_VideoChat_JoinRoom_Req
{
    uint32 versionId;              //协议版本号,
    uint32 userId;
    uint32 vcbId;
    uint32 qxFileMaskSeed;
    char   qxFileMask[PWDLEN];
    char   userPwd[PWDLEN];
    char   vcbPwd[PWDLEN];
    uint8  isReconnect;            //是否是重连(1),还是第一次连接(0)
    uint8  isHide;                 //是否隐身登陆, 1-隐身
    uint8  isMobile;               //是否手机用户登录, 1-android,2-ios
    char    szIpAddr[IPADDRLEN];
    char    szSoftSerialMd5[MD5LEN];
    char    szMacAddrMd5[MD5LEN];
    
}HBCMD_VideoChat_JoinRoom_Req_t;

//加入房间响应
typedef struct _tag_HBCMD_VideoChat_JoinRoom_Resp
{
    int32  errorCode;
    uint32 versionId;           //协议版本号,
    uint32 userId;
    uint32 vcbId;
    uint32 vcbCreatorId;        //房主ID
    uint32 opUser01;
    uint32 opUser02;
    uint32 opUser03;
    uint32 opUser04;
    uint32 opUser05;
    uint32 opUser06;
    uint32 roomState;
    
    int8   layoutType;
    int8   roomAttrId;
    int8   reserved_01;
    int8   reserved_02;
    
    char   vcbName[NAMELEN];    //房间名称
    char   vcbMediaServer[MEDIAADDRLEN];  //媒体服务器地址(用于TCPMedia协议)
    
    uint8  vcbIsUsedPwd;        //房间是否使用密码了？
    uint8   vipLevel;           //请求用户的信息
    uint8   playerLevel;
    uint8   roomLevel;
    
    uint32  userRoomState;
    int64   user_nk;
    int64   user_nb;
    int8    ngende;     //性别
}HBCMD_VideoChat_JoinRoom_Resp_t;

//房间基本信息
typedef struct _tag_HBCMD_VideoChat_RoomInfo
{
    int errroCode;
    uint32 runnerId;
    uint32 vcbId;
    uint32 vcbCreatorId;         //房主
    uint32 opUser01;
    uint32 opUser02;
    uint32 opUser03;
    uint32 opUser04;
    uint32 opUser05;
    uint32 opUser06;
    uint32 opState;
    char   vcbName[NAMELEN];    //房间名称
    char   vcbPwd[PWDLEN];      //密码
    uint8  vcbIsUsedPwd;        //房间是否使用密码
    
}HBCMD_VideoChat_RoomInfo_t;

//该房间公告信息
typedef struct _tag_HBCMD_VideoChat_RoomNotice
{
    int errorCode;
    int runnerId;
    uint32 vcbId;
    uint16 textLen;           //文字长度
    int8   textIndex;         //公告index
    char   text[0];
}HBCMD_VideoChat_RoomNotice_t;

typedef struct _tag_HBCMD_VideoChat_RoomMediaServer
{
    int errorCode;
    uint32 vcbId;
    char   vcbMediaServer[MEDIAADDRLEN];  //媒体服务器地址(用于TCPMedia协议)
}HBCMD_VideoChat_RoomMediaServer_t;

//房赠送礼物记录结构
typedef struct _tag_HBCMD_VideoChat_GiftRecord
{
    int     errorCode;
    uint32  vcbId;
    uint32  srcId;
    uint8   srcvipLevel;        //送礼物人等级
    uint8   desvipLevel;        //收礼物人等级
    uint32  toId;           //散花用户=0,根据sendType判断
    uint32  giftId;         //礼物ID
    uint32  giftNum;        //礼物数量
    uint32  senttime;       //赠送时间
    int8    flyId;          //跑道ID
    int8    castMode;       //广播模式
    int8    serverMode;     //服务器模式
    uint8   hideMode;       //隐身模式,0-无,1-发送者隐身
    uint8    sendType;       //发送类型,0-普通,1-所有用户,2-所有主播,3-所有VIP
    uint8   nextAction;     //下一步状态,0-没状态
    uint8   textLen;        //赠言文字长度
    int8    reserve01;
    char    srcName[NAMELEN];
    char    toName[NAMELEN];
    char    vcbName[NAMELEN];
    char    text[0];
}HBCMD_VideoChat_GiftRecord_t;

//房间用户信息结构
typedef struct _tag_HBCMD_VideoChat_RoomUserInfo
{
    uint32  vcbId;
    uint32  userId;
    uint32  userRoomState;     //含城主、城后
    uint8   vipLevel;
    uint8   playerLevel;
    uint8   roomLevel;
    uint8   reserve_01;
    uint32  comeInTime;        //进入时间
    uint32  upMicTime;         //上麦时间
    uint32  sealExpiredTime;   //盖章过期时间
    uint16  sealId;            //章ID
    uint16  carId;             //座驾ID
//    uint32  starFlag;          //0xFF week-star, 0xFF00 top-star
    int32  param_01;           //pubMicIndex,MicGiftId
    int32  param_02;           //pubMicRemainTime,MicGiftNum
    char   userName[NAMELEN];  //用户呢称
    char   userHeadPic[MD5LEN];//用户头像,可能有
    int8   ngender;            //用户性别
    int8   nsatrt[20];         //周星、日星数据
}HBCMD_VideoChat_RoomUserInfo_t;

//房间聊天信息结构
typedef struct _tag_HBCMD_VideoChat_RoomChatMsg
{
    int     errorCode;
    uint32  vcbId;
    uint32  srcId;
    uint32  toId;             //所有人=0
    int8    chatTypeId;       //消息模式(<10),1-公聊,2-私聊,3-房间公告
    uint16  textLen;          //聊天文字长度
    char    srcName[NAMELEN]; //发送人的呢称
    char    vcbName[NAMELEN]; //接收人的昵称
    char    text[0];
}HBCMD_VideoChat_RoomChatMsg_t;

//房间上麦请求
typedef struct _tag_HBCMD_VideoChat_RoomUpMic_Req
{
    uint32  vcbId;
    uint32  runnerId;       //操作人ID
    uint32  userId;
    uint8   micType;        //麦类型:1-公麦,2-管理麦,3-私麦,4-密麦,5-收费麦,6-礼物麦
    uint8   reserved_01;
    int32   param_01;        //pubMicIndex,MicGiftId
    int32   param_02;        //pubMicRemainTime,MicGiftNum
}HBCMD_VideoChat_RoomUpMic_Req_t;

//房间上麦请求响应
typedef struct _tag_HBCMD_VideoChat_RoomUpMic_Resp
{
    int     errorCode;
    uint32  vcbId;
    uint32  runnerId;
    uint32  userId;
    uint8   micType;
    uint8   reserved_01;
    int32   param_01;     //pubMicIndex,MicGiftId
    int32   param_02;     //pubMicRemainTime,MicGiftNum
    char   TLMeidauri1[T64LEN];   //push_addr
    char   TLMeidauri2[T64LEN];   //pull_addr_1
    
}HBCMD_VideoChat_RoomUpMic_Resp_t;

//房间上麦通知
typedef struct _tag_HBCMD_VideoChat_RoomUpMic_Noty
{
    uint32  vcbId;
    uint32  runnerId;
    uint32  userId;
    uint8   micType;
    uint8   reserved_01;
    int32   param_01;       //pubMicIndex,MicGiftId
    int32   param_02;       //pubMicRemainTime,MicGiftNum
    uint32  userRoomState;  //用户最新的房间状态
    char   TLMeidauri1[T64LEN];   //push_addr
    char   TLMeidauri2[T64LEN];   //pull_addr_1
    
}HBCMD_VideoChat_RoomUpMic_Noty_t;

//房间下麦请求
typedef struct _tag_HBCMD_VideoChat_RoomDownMic_Req
{
    uint32  vcbId;
    uint32  runnerId;
    uint32  userId;
}HBCMD_VideoChat_RoomDownMic_Req_t;

//房间下麦请求响应
typedef struct _tag_HBCMD_VideoChat_RoomDownMic_Resp
{
    int     errorCode;
    uint32  vcbId;
    uint32  runnerId;
    uint32  userId;
}HBCMD_VideoChat_RoomDownMic_Resp_t;

//房间下麦请求通知
typedef struct _tag_HBCMD_VideoChat_RoomDownMic_Noty
{
    uint32  vcbId;
    uint32  runnerId;
    uint32  userId;
    uint32  userRoomState;   //用户最新的房间状态
}HBCMD_VideoChat_RoomDownMic_Noty_t;

//退出房间请求
typedef struct _tag_HBCMD_VideoChat_ExitRoom_Req
{
    uint32 vcbId;
    uint32 userId;
}HBCMD_VideoChat_ExitRoom_Req_t;

//退出房间请求响应
typedef struct _tag_HBCMD_VideoChat_ExitRoom_Resp
{
    int    errorCode;
    uint32 vcbId;
    uint32 userId;
}HBCMD_VideoChat_ExitRoom_Resp_t;

//退出房间通知
typedef struct _tag_HBCMD_VideoChat_ExitRoom_Noty
{
    uint32 vcbId;
    uint32 userId;
}HBCMD_VideoChat_ExitRoom_Noty_t;

//踢出用户请求
typedef struct _tag_HBCMD_VideoChat_RoomKickUser_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 blackMode;  //拉黑模式: 0-无,1-房间拉黑
    uint8 textLen;    //附加的文字消息长度
    char  text[0];
}HBCMD_VideoChat_RoomKickUser_Req_t;

//踢出用户响应
typedef struct _tag_HBCMD_VideoChat_RoomKickUser_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 blackMode;  //拉黑模式: 0-无,1-房间拉黑
    uint8 textLen;    //附加的文字消息长度
    char  text[0];
}HBCMD_VideoChat_RoomKickUser_Resp_t;

//踢出用户通知
typedef struct _tag_HBCMD_VideoChat_RoomKickUser_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint32 reasonId;   //原因ID, 701-用户超时被系统请出,702-重复登录被踢出,707-房间请出所有yonghu
    uint8  blackMode;  //拉黑模式: 0-无,1-房间拉黑
    uint8  textLen;    //附加的文字消息长度
    char   text[0];
}HBCMD_VideoChat_RoomKickUser_Noty_t;

//设置房间信息请求
typedef struct _tag_HBCMD_VideoChat_SetRoomInfo_Req
{
    int runnerId;
    uint32 vcbId;
    uint32 vcbCreatorId;  //房主ID
    uint32 opUser01;
    uint32 opUser02;
    uint32 opUser03;
    uint32 opUser04;
    uint32 opUser05;
    uint32 opUser06;
    uint32 opState;
    uint32 setMode;       //组合设置模式, yc_defines.h
    uint8  vcbIsUsedPwd;  //是否使用密码
    char   vcbName[NAMELEN];  //房间名称
    char   vcbPwd[PWDLEN];    //新密码
}HBCMD_VideoChat_SetRoomInfo_Req_t;

//设置房间信息响应
typedef struct _tag_HBCMD_VideoChat_SetRoomInfo_Resp
{
    int errorCode;
    int runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_SetRoomInfo_Resp_t;

//设置房间公告请求
typedef struct _tag_HBCMD_VideoChat_SetRoomNotice_Req
{
    int runnerId;
    uint32 vcbId;
    uint16 textLen;
    int8   textIndex;
    char   text[0];
}HBCMD_VideoChat_SetRoomNotice_Req_t;

//设置房间公告响应
typedef struct _tag_HBCMD_VideoChat_SetRoomNotice_Resp
{
    int errorCode;
    int runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_SetRoomNotice_Resp_t;

//设置房间媒体服务器请求
typedef struct _tag_HBCMD_VideoChat_SetRoomMediaServer_Req
{
    int runnerId;
    uint32 vcbId;
    char   vcbMediaServer[MEDIAADDRLEN];
}HBCMD_VideoChat_SetRoomMediaServer_Req_t;

//设置房间媒体服务器响应
typedef struct _tag_HBCMD_VideoChat_SetRoomMediaServer_Resp
{
    int errorCode;
    int runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_SetRoomMediaServer_Resp_t;

//设置用户信息请求
typedef struct _tag_HBCMD_VideoChat_SetUserInfo_Req
{
    uint32 userId;
    char   userName[NAMELEN];
    int8   ngender ;            //用户性别
}HBCMD_VideoChat_SetUserInfo_Req_t;

//设置用户信息响应
typedef struct _tag_HBCMD_VideoChat_SetUserInfo_Resp
{
    int errorCode;
    uint32 userId;
    char  userName[NAMELEN];
    int8  ngender ;            //用户性别
}HBCMD_VideoChat_SetUserInfo_Resp_t;

//增加房间管理请求
typedef struct _tag_HBCMD_VideoChat_RoomAddMgr_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8  addMode;  //1-正管, 2-临管
}HBCMD_VideoChat_RoomAddMgr_Req_t;

//增加房间管理响应
typedef struct _tag_HBCMD_VideoChat_RoomAddMgr_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 addMode;
}HBCMD_VideoChat_RoomAddMgr_Resp_t;

//增加房间管理通知
typedef struct _tag_HBCMD_VideoChat_RoomAddMgr_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 userRoomLevel;
}HBCMD_VideoChat_RoomAddMgr_Noty_t;

//房间删除管理(下管)请求
typedef struct _tag_HBCMD_VideoChat_RoomDelMgr_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelMgr_Req_t;

//房间删除管理(下管)响应
typedef struct _tag_HBCMD_VideoChat_RoomDelMgr_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelMgr_Resp_t;

//房间删除管理(下管)通知
typedef struct _tag_HBCMD_VideoChat_RoomDelMgr_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 userRoomLevel;
}HBCMD_VideoChat_RoomDelMgr_Noty_t;

//房间积分换金币请求
typedef struct _tag_HBCMD_VideoChat_RoomNB2NK_Req
{
    uint32 vcbId;
    uint32 userId;
    uint32 money;
}HBCMD_VideoChat_RoomNB2NK_Req_t;

//房间积分换金币响应
typedef struct _tag_HBCMD_VideoChat_RoomNB2NK_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 userId;
    uint32 money;
}HBCMD_VideoChat_RoomNB2NK_Resp_t;

//房间转账请求
typedef struct _tag_HBCMD_VideoChat_RoomTransfer_Req
{
    uint32 vcbId;
    uint32 srcId;
    uint32 toId;
    uint32 money;
}HBCMD_VideoChat_RoomTransfer_Req_t;

//房间转账响应
typedef struct _tag_HBCMD_VideoChat_RoomTransfer_Resp
{
    int errorId;
    uint32 vcbId;
    uint32 srcId;
    uint32 toId;
    uint32 money;
}HBCMD_VideoChat_RoomTransfer_Resp_t;

//房间转账通知
typedef struct _tag_HBCMD_VideoChat_RoomTransfer_Noty
{
    uint32 vcbId;
    uint32 srcId;
    uint32 toId;
    uint32 money;
}HBCMD_VideoChat_RoomTransfer_Noty_t;


typedef struct _tag_HBCMD_VideoChat_RoomNB2RMB_Req
{
    uint32 vcbId;
    uint32 userId;
    uint32 money;
}HBCMD_VideoChat_RoomNB2RMB_Req_t;

typedef struct _tag_HBCMD_VideoChat_RoomNB2RMB_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 userId;
    uint32 money;
}HBCMD_VideoChat_RoomNB2RMB_Resp_t;

//房间心跳保持请求
typedef struct _tag_HBCMD_VideoChat_RoomKeepLive_Req
{
    uint32 vcbId;
    uint32 userId;
}HBCMD_VideoChat_RoomKeepLive_Req_t;

//房间心跳保持响应
typedef struct _tag_HBCMD_VideoChat_RoomKeepLive_Resp
{
    uint32 vcbId;
    uint32 userId;
}HBCMD_VideoChat_RoomKeepLive_Resp_t;

//房间幸运礼物中奖通知
typedef struct _tag_HBCMD_VideoChat_Lottery_XinYun_Noty
{
    uint32 vcbId;
    uint32 userId;
    uint32 giftId;
    uint32 giftNum;
    uint32 nten ;
    uint32 nfifty ;
    uint32 nfivehundred ;
    uint32 nOnethou ;
    char   userName[NAMELEN];
}HBCMD_VideoChat_Lottery_XinYun_Noty_t;

//房间爆炸礼物中奖通知
typedef struct _tag_HBCMD_VideoChat_Lottery_BaoZha_Noty
{
    uint32 vcbId;
    uint32 userId;
    uint32 giftId;
    uint32 giftNum;
    uint32 wincount;
    uint64 winmoney;
    char   userName[NAMELEN];
}HBCMD_VideoChat_Lottery_BaoZha_Noty_t;

//获取用户账户信息请求
typedef struct _tag_HBCMD_VideoChat_GetUserAccount_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_GetUserAccount_Req_t;

//获取用户账户信息响应
typedef struct _tag_HBCMD_VideoChat_GetUserAccount_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint64 nk;
    uint64 nb;
}HBCMD_VideoChat_GetUserAccount_Resp_t;

//获取用户账户信息通知
typedef struct _tag_HBCMD_VideoChat_UserAccount_Noty
{
    uint32 vcbId;
    uint32 userId;
    uint64 nk;
    uint64 nb;
}HBCMD_VideoChat_UserAccount_Noty_t;

//房间禁言请求
typedef struct _tag_HBCMD_VideoChat_RoomAddMuteUser_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomAddMuteUser_Req_t;

//房间禁言响应
typedef struct _tag_HBCMD_VideoChat_RoomAddMuteUser_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomAddMuteUser_Resp_t;

//房间禁言通知
typedef struct tag_HBCMD_VideoChat_RoomAddMuteUser_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint32 userRoomState;
}HBCMD_VideoChat_RoomAddMuteUser_Noty_t;

//房间取消禁言请求
typedef struct _tag_HBCMD_VideoChat_RoomDelMuteUser_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelMuteUser_Req_t;

typedef struct _tag_HBCMD_VideoChat_RoomDelMuteUser_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelMuteUser_Resp_t;

typedef struct tag_HBCMD_VideoChat_RoomDelMuteUser_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint32 userRoomState;
}HBCMD_VideoChat_RoomDelMuteUser_Noty_t;

//房间增加黑名单请求
typedef struct tag_HBCMD_VideoChat_RoomAddBlackUser_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 blackMode;  //拉黑模式: 0-无,1-房间拉黑
}HBCMD_VideoChat_RoomAddBlackUser_Req_t;

typedef struct tag_HBCMD_VideoChat_RoomAddBlackUser_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 blackMode;
}HBCMD_VideoChat_RoomAddBlackUser_Resp_t;

typedef struct tag_HBCMD_VideoChat_RoomAddBlackUser_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
    uint8 blackMode;
}HBCMD_VideoChat_RoomAddBlackUser_Noty_t;

//房间删除黑名单请求
typedef struct tag_HBCMD_VideoChat_RoomDelBlackUser_Req
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelBlackUser_Req_t;

typedef struct _tag_HBCMD_VideoChat_RoomDelBlackUser_Resp
{
    int errorCode;
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelBlackUser_Resp_t;

typedef struct _tag_HBCMD_VideoChat_RoomDelBlackUser_Noty
{
    uint32 vcbId;
    uint32 runnerId;
    uint32 userId;
}HBCMD_VideoChat_RoomDelBlackUser_Noty_t;

//房间传输媒体数据
typedef struct _tag_HBCMD_VideoChat_TransMediaInfo
{
    int errorCode;
    uint32 vcbId;
    uint32 srcId;
    uint32 toId;
    uint8  action;   //动作：1表示请求打开对方音视频，3表示请求关闭对方音视频。
}HBCMD_VideoChat_TransMediaInfo_t;

//注册用户请求
typedef struct _tag_HBCMD_VideoChat_RegistUser_Req
{
    char userName[NAMELEN];
    char userPwd[PWDLEN];
    uint8 isMobile;
}HBCMD_VideoChat_RegistUser_Req_t;

typedef struct _tag_HBCMD_VideoChat_RegistUser_Resp
{
    int errorCode;
    uint32 userId;
    char userName[NAMELEN];
}HBCMD_VideoChat_RegistUser_Resp_t;

//清除房间聊天信息请求
typedef struct _tag_HBCMD_VideoChat_ClearRoomChat_Req
{
    uint32 runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_ClearRoomChat_Req_t;

typedef struct _tag_HBCMD_VideoChat_ClearRoomChat_Resp
{
    int errorCode;
    uint32 runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_ClearRoomChat_Resp_t;

typedef struct _tag_HBCMD_VideoChat_ClearRoomChat_Noty
{
    uint32 runnerId;
    uint32 vcbId;
}HBCMD_VideoChat_ClearRoomChat_Noty_t;

//设置房间布局请求
typedef struct _tag_HBCMD_VideoChat_SetRoomLayout_Req
{
    uint32 runnerId;
    uint32 vcbId;
    int8   layoutType;   //1:2固定,2:2缩放,3:1固定,4:1缩放
}HBCMD_VideoChat_SetRoomLayout_Req_t;

typedef struct _tag_HBCMD_VideoChat_SetRoomLayout_Resp
{
    int errorCode;
    uint32 runnerId;
    uint32 vcbId;
    int8   layoutType;
}HBCMD_VideoChat_SetRoomLayout_Resp_t;

typedef struct _tag_HBCMD_VideoChat_SetRoomLayout_Noty
{
    uint32 runnerId;
    uint32 vcbId;
    int8   layoutType;
}HBCMD_VideoChat_SetRoomLayout_Noty_t;

//这个不再使用了!!!!
typedef struct _tag_HBCMD_VideoChat_SetAppZhubo_Req
{
    uint32 userId;
    uint32 vcbId;
    char szPushRtmpUrl[URLLEN4];
    char szPullRtmpUrl[URLLEN4];
}HBCMD_VideoChat_SetAppZhubo_Req_t;

//这个不再使用了!!!!
typedef struct _tag_HBCMD_VideoChat_SetAppZhubo_Resp
{
    int errorCode;
    uint32 userId;
    uint32 vcbId;
    char szPushRtmpUrl[URLLEN4];
    char szPullRtmpUrl[URLLEN4];
}HBCMD_VideoChat_SetAppZhubo_Resp_t;

//这个不再使用了!!!!
typedef struct _tag_HBCMD_VideoChat_SetAppZhubo_Noty
{
    uint32 userId;
    uint32 vcbId;
    char szPushRtmpUrl[URLLEN4];
    char szPullRtmpUrl[URLLEN4];
}HBCMD_VideoChat_SetAppZhubo_Noty_t;

//系统聊天/通知信息
typedef struct _tag_HBCMD_VideoChat_GlobalChatMsg
{
    int     errorCode;
    uint32  vcbId;
    uint32  srcId;
    uint32  toId;        //所有人=0
    int8    chatTypeId;  //消息模式(>=10):10-系统公告,11-小喇叭, 12-礼物消息 13-幸运中奖消息, 14-爆炸中奖消息
    uint16  textLen;
    char    srcName[NAMELEN];
    char    toName[NAMELEN];
    char    vcbName[NAMELEN];
    char    text[0];
}HBCMD_VideoChat_GlobalChatMsg_t;

//设置用户密码请求
typedef struct _tag_HBCMD_VideoChat_SetUserPwd_Req
{
    int pwdType;
    uint32 userId;
    char szOldPwd[PWDLEN];
    char szNewPwd[PWDLEN];
}HBCMD_VideoChat_SetUserPwd_Req_t;

typedef struct _tag_HBCMD_VideoChat_SetUserPwd_Resp
{
    int errorCode;
    int pwdType;
    uint32 userId;
}HBCMD_VideoChat_SetUserPwd_Resp_t;

//查看用户IP请求
typedef struct _tag_HBCMD_VideoChat_GetUserIP_Req
{
    uint32 userId;
    uint32 vcbId;
}HBCMD_VideoChat_GetUserIP_Req_t;

typedef struct _tag_HBCMD_VideoChat_GetUserIP_Resp
{
    int errorCode;
    uint32 userId;
    uint32 vcbId;
    char szClientIP[IPADDRLEN];
    char szIPDesc[T128LEN];
}HBCMD_VideoChat_GetUserIP_Resp_t;

//城主/城后消息
typedef struct _tag_HBCMD_VideoChat_SiegeInfo
{
    int  errorCode;
    uint32  vcbId;
    uint32  userId;
    uint32  buddyId;
    uint32  giftId;
    uint32  giftNum;
    uint32  senttime;
    char srcName[NAMELEN];
    char toName[NAMELEN];
    char vcbName[NAMELEN];
}HBCMD_VideoChat_SiegeInfo_t;

//查询可创建房间的服务器列表
typedef struct _tag_HBCMD_VideoChat_Query_VCBServer_Req
{
    uint32 userId;
    
}HBCMD_VideoChat_Query_VCBServer_Req_t;

typedef struct _tag_HMCMD_VideoChat_Query_VCBServer_Resp
{
    int    errorCode;
    uint32 vcbServerId;
    uint32 userId;
    char   gateAddr[T128LEN];  //考虑到用户后期长连,所以使用返回网关地址
}HMCMD_VideoChat_Query_VCBServer_Resp_t;

//创建房间(手机直播间)请求
typedef struct _tag_HBCMD_VideoChat_Create_MobileRoom_Req
{
    uint32  userId;   //创建人ID
    uint32  vcbServerId;
    int8    isVisible;
    int8    isUsePwd;
    int8    feesType;
    int8    reserved01;
    int32   feesValue;
    char    roomName[NAMELEN]; //要创建的房间名称
    char    roomPwd[PWDLEN]; //要创建的房间名称
    
}HBCMD_VideoChat_Create_MobileRoom_Req_t;

typedef struct _tag_HBCMD_VideoChat_Create_MobileRoom_Resp
{
    int errorCode;              //
    uint32 userId;
    uint32 roomId;              //房间ID
    uint32 creatorId;           //创建人ID,房主ID
    int8    isVisible;
    int8    isUsePwd;
    int8    feesType;
    int8    reserved01;
    int32   feesValue;
    char roomName[NAMELEN];
    char    roomPwd[PWDLEN];     //要创建的房间名称
    char serverAddr[T64LEN];    //这个参数不再使用
    char gateAddr[T128LEN];     //网关地址
    char mediaAddr[T128LEN];    //媒体服务器地址,PC端使用
    uint16 serverPort;          //这个参数不再使用
    
}HBCMD_VideoChat_Create_MobileRoom_Resp_t;

//上手机麦请求
typedef struct _tag_HBCMD_VideoChat_UpMBMic_Req
{
    uint32 userId;
    uint32 vcbId;
    int8   phoneStyle;   //手机类型:1-android,2-ios
    int8   mictype;      //麦类型,手机麦分为私麦(FT_USERROOMSTATE_MIC_MBSI) 和收费私麦( FT_USERROOMSTATE_MIC_MBFEE 按时间收费)
    int16  reserve_02;
    char   phoneInfo[T64LEN]; //手机信息
}HBCMD_VideoChat_UpMBMic_Req_t;

typedef struct _tag_HBCMD_VideoChat_UpMBMic_Resp
{
    int    errorCode;
    uint32 userId;
    uint32 vcbId;
    uint32 userRoomState;
    int8   TLStatus;
    char   TLMeidauri1[T64LEN];   //push_addr
    char   TLMeidauri2[T64LEN];   //pull_addr_1
}HBCMD_VideoChat_UpMBMic_Resp_t;

typedef struct _tag_HBCMD_VideoChat_UpMBMic_Noty
{
    uint32 userId;
    uint32 vcbId;
    uint32 userRoomState;
    int8   TLStatus;
    char   TLMeidauri1[T64LEN];   //push_addr
    char   TLMeidauri2[T64LEN];   //pull_addr_1
}HBCMD_VideoChat_UpMBMic_Noty_t;

//下手机麦请求
typedef struct _tag_HBCMD_VideoChat_DownMBMic_Req
{
    uint32 userId;
    uint32 vcbId;
}HBCMD_VideoChat_DownMBMic_Req_t;

typedef struct _tag_HBCMD_VideoChat_DownMBMic_Resp
{
    int errorCode;
    uint32 userId;
    uint32 vcbId;
    uint32 userRoomState;
}HBCMD_VideoChat_DownMBMic_Resp_t;

typedef struct _tag_HBCMD_VideoChat_DownMBMic_Noty
{
    uint32 userId;
    uint32 vcbId;
    uint32 userRoomState;
}HBCMD_VideoChat_DownMBMic_Noty_t;

//设置推流状态(Mobile RTMP stream Status)请求
typedef struct _tag_HBCMD_VideoChat_SetMBTLStatus_Req
{
    uint32 userId;
    uint32 vcbId;
    int8   TLStatus;  //rtmp流状态
    
}HBCMD_VideoChat_SetMBTLStatus_Req_t;

typedef struct _tag_HBCMD_VideoChat_SetMBTLStatus_Resp
{
    int    errorCode;
    uint32 userId;
    uint32 vcbId;
    int8   TLStatus;  //rtmp流状态
}HBCMD_VideoChat_SetMBTLStatus_Resp_t;

typedef struct _tag_HBCMD_VideoChat_SetMBTLStatus_Noty
{
    uint32 userId;      //用户ID
    uint32 vcbId;       //房间ID
    int8   TLStatus;    //rtmp流状态
}HBCMD_VideoChat_SetMBTLStatus_Noty_t;

//在麦用户(列表)信息
typedef struct _tag_HBCMD_VideoChat_RoomOnMicUserInfo
{
    uint32  userId;               //用户ID
    uint32  vcbId;                //房间ID
    int32   userRoomState;        //用户房间状态
    
    uint8   vipLevel;             //用户等级
    uint8   playerLevel;
    uint8   roomLevel;
    int8    TLStatus;             //推流状态(0-未连接,1-正在连接,2-连接成功,3-开始推流)
    
    char   userName[NAMELEN];    //用户呢称
    char   TLMeidauri1[T64LEN];   //push_addr
    char   TLMeidauri2[T64LEN];   //pull_addr_1
}HBCMD_VideoChat_RoomOnMicUserInfo_t;


//用户关注请求
typedef struct _tag_HBCMD_VIDEOCHAT_UserAttention_Req
{
    uint8    nFlag;        //1标识增加，2表示删除
    uint32    nUserID;     //用户ID
    uint32    nRoomID;        //房间ID
    uint32    nSinger;        //歌手ID
}HBCMD_VIDEOCHAT_UserAttention_Req_t;

typedef struct _tag_HBCMD_VIDEOCHAT_UserAttention_Resp
{
    uint8    nRet;        //操作返回标识，0标识成功
    uint8    nFlag;        //1标识增加，2表示删除
    uint32    nUserID;     //用户ID
    uint32    nRoomID;        //房间ID
    uint32    nSinger;        //歌手ID
}HBCMD_VIDEOCHAT_UserAttention_Resp_t;

#pragma pack()
//////////////////////////////////////////////////////////////////////////


#endif //__ZHIBO_COMMANDS_HH__


