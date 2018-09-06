//
//  yc_define.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/6.
//  Copyright © 2018年 jh. All rights reserved.
//

//#ifndef yc_define_h
//#define yc_define_h
//
//
//#endif /* yc_define_h */
#ifndef __YC_COMM_DEFINES_HH__20130906__
#define __YC_COMM_DEFINES_HH__20130906__


///////////////////////////////////////////////////////
#define MD5LEN        40
#define PWDLEN        64
#define NAMELEN       32
#define NAMELEN2      64
#define URLLEN        64
#define URLLEN4       256
#define IPADDRLEN     32
#define GIFTTEXTLEN   64
#define GATEADDRLEN   128
#define MEDIAADDRLEN  128
#define DEVICENAMELEN 128
#define BIRTHLEN      32
#define ERRORLEN      32
#define T32LEN        32
#define T64LEN        64
#define T128LEN       128
#define T1024LEN      1024
#define T2048LEN      2048
#define T4096LEN      4096
#define PAIMAI_MAXSIZE  2000
///////////////////////////////////////////////////////

#define LLNB_SOCKET_RECVBUFFER_MAXSIZE   4096*10



//注意: 最大值为2^4= 16,传输时限制, 这些值都是固定的,注意权限等级文件同样用到(房间内等级)
enum {
    RoomMgrType_Null      = 0,    //没有
    
    RoomMgrType_Fangzhu   = 1,    //房主
    RoomMgrType_FuFangzhu = 2,    //副房主
    RoomMgrType_Guan      = 3,    //正管
    RoomMgrType_LinGuan   = 4,    //临管
    
    RoomMgrType_Quzhang   = 5,    //区长
    RoomMgrType_Daili    = 6,     //真代理
    RoomMgrType_Quzhang2  = 7,    //大区长
    RoomMgrType_FuQuzhang = 8,    //副区长
    RoomMgrType_FuQuzhang2  = 9,  //大区副长
    RoomMgrType_ZengsongLinGuan   = 10, //某些等级或者消费大户额外附带的管理标志,跟真正的管理和临管部一样,只是具备房间某些操作权限,
    //具体什么操作权限,根据其消费来决定
    RoomMgrType_Quzhang_zhuli = 11,  //区长助理
    RoomMgrType_Quzhang_zhuli2 = 12, //大区长助理
};


//常用宏定义
#define FT_USERROOMSTATE_HIDEIN            0x00000100      //隐身
#define FT_USERROOMSTATE_MUTECHAT          0x00000200      //禁言
#define FT_USERROOMSTATE_DEVICE_HAVEVIDEO  0x00000400      //有视频
#define FT_USERROOMSTATE_FORBIDMIC         0x00000800      //禁止报麦
#define FT_USERROOMSTATE_SIEGE1            0x00001000      //城主1
#define FT_USERROOMSTATE_SIEGE2            0x00002000      //城主2
#define FT_USERROOMSTATE_MOBILE_MASK       0x000F0000
#define FT_USERROOMSTATE_MOBILE_ANDROID    0x00010000
#define FT_USERROOMSTATE_MOBILE_IOS        0x00020000
//
#define FT_USERROOMSTATE_MIC_MASK          0xFF
#define FT_USERROOMSTATE_MIC_GONG          0x01      //在公麦
#define FT_USERROOMSTATE_MIC_GUAN          0x02      //在管理麦
#define FT_USERROOMSTATE_MIC_SI            0x03      //在私麦
#define FT_USERROOMSTATE_MIC_MI            0x04      //在密麦
#define FT_USERROOMSTATE_MIC_FEE           0x05      //在收费麦
#define FT_USERROOMSTATE_MIC_LIWU          0x06      //在礼物麦
#define FT_USERROOMSTATE_MIC_MBSI          0x07      //在手机私麦
#define FT_USERROOMSTATE_MIC_MBFEE         0x08      //在手机收费麦

//
#define SETROOMINFO_MODBASEINFO_MASK       0x00000001   //修改房间信息
#define SETROOMINFO_MODROOMPWD_MASK        0x00000002   //修改房间密码
#define SETROOMINFO_OPSTATE_MASK           0x00000004   //修改房间操作状态

//
#define SENDGIFT_NEXTACTION_NULL          0
#define SENDGIFT_NEXTACTION_CONNECTUSER   1

//房间操作状态
#define ROOM_OPSTATE_CLOSELABA            0x00000001      //关闭喇叭
#define ROOM_OPSTATE_CLOSEPUBCHAT         0x00000002      //关闭公聊
#define ROOM_OPSTATE_CLOSEPRIVCHAT        0x00000004      //关闭私聊
#define ROOM_OPSTATE_CLOSEPUBMIC          0x00000008      //关闭公麦
#define ROOM_OPSTATE_CLOSESIMIC           0x00000010      //关闭私聊
#define ROOM_OPSTATE_OPENPAIMIC           0x00000020      //打开排麦


#endif //__YC_COMM_DEFINES_HH__20130906__
