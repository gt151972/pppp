//
//  CommonAPIDefines.h
//  InKeLive
//
//  Created by gu  on 17/8/15.
//  Copyright © 2017年 jh. All rights reserved.
//

#ifndef CommonAPIDefines_h
#define CommonAPIDefines_h

#define URL_UserLogon       @"logon2.php"            //登录
#define URL_QueryVCBServer  @"queryvcblist.php"      //获取vcd服务器
#define URL_HotPlayerList   @"hot_player_list2.php"  //首页数据
#define URL_GetGiftConf     @"get_giftconf.php"
#define URL_UploadUserHead  @"upload_userheadimg.php"
#define URL_ChangePWD       @"set_userlogonpwd.php"   //修改密码
#define URL_ChangeNickName  @"set_useralias.php"      //修改昵称

//cmd
#define CMD_REQUEST_SEARCH         @"21006"   //搜索接口cmd
#define CMD_ATTENTION_ROOM_LIST    @"21007"   //请求关注房间列表({"cmd":21007,"uid":11})
#define CMD_ENTER_ROOM_RECORD      @"21014"   //进房记录({"cmd":21014,"uid":11})
#define CMD_REQUEST_BANNER         @"21019"   //首页请求banner接口({"cmd":21019,"flag":2} img 实际路径为 res+web+img)
#define CMD_REQUEST_ADDTESS        @"20002"   //根据rid请求房间名和房间地址 ("cmd":20001,"rid":100000)
#define CMD_REQUEST_WEB_ADDRESS    @"20001"   //请求网页url链接 ({"cmd":20001,"flag":2})
#define CMD_ATTENTION_DELETE       @"21008"   //删除关注{"cmd":21008,"uid":12345,"pid":12} pid为删除对象
#define CMD_REGISTER_SEND_CODE     @"21004"   //注册发送验证码
#define CMD_REGISTER_REQUEST       @"21005"   //注册
#define CMD_PASSWORD_FIND          @"21013"   //找回密码
#define CMD_PASSWORD_CHANGE        @"21015"   //修改密码
#define CMD_SECURITY_READ          @"21016"   //手机密保读取
#define CMD_SECURITY_CODE          @"21017"   //手机密保验证码
#define CMD_SECURITY_SAVE          @"21018"   //手机密保保存

#define IOS_REQUEST_FLAG @"2" //客户端分类flag 1 pc 2 ios 4 android

#define URL_GiftInfo   @"http://em.aa1258.com/E/Api" //礼物状态和分组列表
#endif /* CommonAPIDefines_h */
