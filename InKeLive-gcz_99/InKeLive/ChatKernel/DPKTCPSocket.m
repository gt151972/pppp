
#import "DPKTCPSocket.h"
#import "DPK_NW_Application.h"

@implementation DPKTCPSocket

-(id)init
{
    if((self=[super init])) {
        _asyncSocket=nil;
        _socketSink =nil;
        _messageEventSink=nil;
        _isConnecting =0;
        _isConnected =0;
        m_nRecvSize =0;
    }
    return self;
}

-(void)SetSocketSink:(id)delegate
{
    _socketSink = delegate;
}

- (void)SetMessageEventSink:(id)delegate
{
    _messageEventSink =delegate;
}

- (id)GetMessageEventSink
{
    return _messageEventSink;
}

- (BOOL)ConnectServer:(NSString*)ipAddr ServerPort:(int)port
{
    BOOL bRet;
    if(_asyncSocket ==nil) {
        _asyncSocket=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    if(_isConnected ==1) {
        NSLog(@"服务器已经处于连接中.");
        return YES;
    }
    if(_isConnected == 1) {
        NSLog(@"服务器已经连接成功.");
        return YES;
    }
    NSError* error=nil;
    bRet = [_asyncSocket connectToHost:ipAddr onPort:port withTimeout:5 error:&error];
    NSLog(@"%@", error);
    if(!bRet)
        return NO;
    
    _isConnecting =1;
    return YES;
}

- (void)CloseSocket:(int)reason_code
{
    if(_asyncSocket != nil) {
        [_asyncSocket disconnect];
    }
    _isConnecting = 0;
    _isConnected = 0;
    m_nRecvSize =0;
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"DPKTCPSocket INFO_didConnectToHost");
    _isConnected =1;
    _isConnecting = 0;
    //开始接受数据
    [sock readDataWithTimeout:-1 tag:0];
    
    if(_socketSink) {
        [_socketSink OnEventTCPSocketLink:self error:0];
    }
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //NSLog(@"+++++++ DPKTCPSocket INFO_didReadData");
    int nRecvLen =[data length];
    if(nRecvLen >0) {
        if(m_nRecvSize <0) {
            //NSLog(@"+++++++++ DPKTCPSocket INFO_didReadData [3]");
        }
        
        char* pWriteData =m_szRecvBuf + m_nRecvSize;
        [data getBytes:pWriteData length:nRecvLen];
        m_nRecvSize += nRecvLen;
        
        char* p= m_szRecvBuf;
        while( m_nRecvSize >4) {
            int msglen =*((int*)p);
            if(msglen <0 || msglen > SOCKET_TCP_BUFFER_SIZE) {
                m_nRecvSize =0;
                //[sock disconnect];
                return;
            }
            else if(m_nRecvSize < msglen)
                break;
            else {
                //NSLog(@"++++++++ DPKTCPSocket INFO_didReadData [1]");
                if([self HandleData:p DataLen:msglen] == -1)
                {
                    //NSLog(@"+++++++ DPKTCPSocket INFO_didReadData [2]");
                    return;
                }
                //NSLog(@"+++++++ prepare: m_nRecvSize=%d, msglen=%d", m_nRecvSize, msglen);
                m_nRecvSize -= msglen;
                p += msglen;
            }
        }
        if(m_nRecvSize >= SOCKET_TCP_BUFFER_SIZE) {
            m_nRecvSize = 0;
            //[sock disconnect];
            return;
        }
        if( p!= m_szRecvBuf && m_nRecvSize >0)
        {
            memmove(m_szRecvBuf, p, m_nRecvSize);
        }
    }
    else if(nRecvLen <0) {
        //NSLog(@"+++++++ DPKTCPSocket INFO_didReadData [4]");
    }
    
    //继续接受数据
    [sock readDataWithTimeout:-1 tag:0];
    
}

-(void)socket:(GCDAsyncSocket* )sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"发送数据的tag");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"DPKTCPSocket INFO_socketDidDisconnect, error:%@", err);
    if(_isConnecting ==1) {
        _isConnecting = 0;
        if(_socketSink != nil) {
            [_socketSink OnEventTCPSocketLink:self error:err.code];
        }
    }
    //
    if(_isConnected ==1) {
        _isConnected = 0;
        if(_socketSink != nil ) {
            [_socketSink OnEventTCPSocketShut:self reason:err.code];
        }
    }
}


- (int)SendData:(int)main_cmd SubCommand:(int)sub_cmd
{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"SocketVerify.plist"];
    NSArray*dataArray = [NSArray arrayWithContentsOfFile:filePathName];
    char szBuffer[256];
    HBNetHead_t* header = (HBNetHead_t*)szBuffer;
    header->mainCmd = main_cmd;
    header->subCmd = sub_cmd;
    header->xcode = 0;
    header->ntime = [dataArray[0] intValue];
    header->nRoomID = [dataArray[1] intValue];
    header->nUserID = [dataArray[2] intValue];
    header->length = sizeof(HBNetHead_t);
    if(_isConnected == 1 && _asyncSocket != nil)
    {
        NSData* nsData =[[NSData alloc]initWithBytes:szBuffer length:header->length];
        [_asyncSocket writeData:nsData withTimeout:0 tag:0];
		return 0;
    }
	return -1;
}

- (int)SendData:(int)main_cmd SubCommand:(int)sub_cmd
Data:(const char*)pdata
DataLen:(int)data_len
{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"SocketVerify.plist"];
    NSArray*dataArray = [NSArray arrayWithContentsOfFile:filePathName];
    char szBuffer[SOCKET_TCP_BUFFER_SIZE];
    HBNetHead_t* header =(HBNetHead_t*)szBuffer;
    header->mainCmd = main_cmd;
    header->subCmd = sub_cmd;
    header->xcode = 0;
    header->ntime = [dataArray[0] intValue];
    header->nRoomID = [dataArray[1] intValue];
    header->nUserID = [dataArray[2] intValue];
    memcpy(header->content, pdata, data_len);
    header->length = sizeof(HBNetHead_t) + data_len;
    if(_isConnected == 1&& _asyncSocket != nil)
    {
        NSData* nsData =[[NSData alloc]initWithBytes:szBuffer length:header->length];
        [_asyncSocket writeData:nsData withTimeout:0 tag:0];
		return 0;
    }
    return -1;
}


- (int)HandleData:(const char*)pdata DataLen:(int)data_len
{
    //NSLog(@"HandleData");
    HBNetHead_t* header = (HBNetHead_t *)pdata;
    if(header->length != data_len || data_len < sizeof(HBNetHead_t))
    {
        NSLog(@"收到不一样的数据，应该要临时保存的!header->length=%d, data_len=%d", header->length, data_len);
        return -1;
    }
    if(header->mainCmd == MXP_MAINCMD_COMMON && header->subCmd == MXP_SUBCMD_COMMON_SERVERPING)
    {
        [self SendData:MXP_MAINCMD_COMMON SubCommand:MXP_SUBCMD_COMMON_CLIENTPING];
        return 0;
    }
    //other message process
    if(_socketSink) {
        NSLog(@"处理消息数据: mainCmd=%d,subCmd=%d,dataLen=%d time = %d, room = %d, user = %d", header->mainCmd, header->subCmd,data_len,header->ntime,header->nRoomID,header->nUserID);
        [_socketSink OnEventTCPSocketRead:self
                              MainCommand:header->mainCmd
                               SubCommand:header->subCmd
                                     Data:header->content
                                     time:header->ntime
                                   roomID:header->nRoomID
                                   userID:header->nUserID
                                  DataLen:header->length - sizeof(HBNetHead_t)];
//        [_socketSink OnEventTCPSocketRead:self
//                              MainCommand:header->mainCmd
//                               SubCommand:header->subCmd
//                                     Data:header->content
//                                  DataLen:header->length - sizeof(HBNetHead_t)
//         ];
    }
    return 0;
    
}

#pragma mark 发送数据方法
//获取空闲服务器请求(主播端)
-(int)SendQueryRoomServerReq:(int)userId
{
   HBCMD_VideoChat_Query_VCBServer_Req_t req;
   memset(&req, 0, sizeof(req));
   req.userId = userId;
   if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_QUERY_VCBSERVER_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_Query_VCBServer_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//创建房间请求
-(int)SendCreateRoomReq:(int)userId
               RoomServerId:(int)roomServerId
               RoomName:(const char*)roomName
                UserPwd:(const char*)userPwd
{
    HBCMD_VideoChat_Create_MobileRoom_Req_t req;
    memset(&req, 0, sizeof(req));
    req.userId = userId;
	req.vcbServerId = roomServerId;
    if(roomName != 0)
    strcpy(req.roomName, roomName);
    //strcpy(req.userPwd, userPwd);
    
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_CREATE_MOBILEROOM_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_Create_MobileRoom_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//上手机麦请求(主播端)
-(int)SendUpMBMicReq:(int)userId
              RoomID:(int)roomId
          PhoneStyle:(int)phoneStyle
           MBMicType:(int)mbMicType
           PhoneInfo:(const char*)phoneInfo
{
    HBCMD_VideoChat_UpMBMic_Req_t req;
    memset(&req, 0, sizeof(req));
    req.userId = userId;
    req.vcbId = roomId;
    req.phoneStyle = phoneStyle;
    req.mictype = mbMicType;
    if(phoneInfo!=0) {
        strcpy(req.phoneInfo, phoneInfo);
    }
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_UPMBMIC_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_UpMBMic_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;

    
}

//下手机麦请求(主播端)
-(int)SendDownMBMicReq:(int)userId
                RoomID:(int)roomId
{
    HBCMD_VideoChat_DownMBMic_Req_t req;
    memset(&req, 0, sizeof(req));
    req.userId = userId;
    req.vcbId = roomId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_DownMBMic_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//设置推流状态请求(主播端)
-(int)SendMBTLStatusReq:(int)userId
                 RoomID:(int)roomId
               TLStatus:(int)tlStatus
{
    HBCMD_VideoChat_SetMBTLStatus_Req_t req;
    memset(&req, 0, sizeof(req));
    req.userId = userId;
    req.vcbId = roomId;
    req.TLStatus = tlStatus;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_SetMBTLStatus_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}


//加入房间请求
-(int)SendJoinRoomReq:(int)versionId
              RoomID:(int)roomId
               UserID:(int)userId
          SessionMask:(const char*)sessionMask
              UserPwd:(const char*)userPwd
              RoomPwd:(const char*)roomPwd
          IsReconnect:(int)isReconnect
               IsHide:(int)isHide
             isMobile:(int)isMobile
{
    HBCMD_VideoChat_JoinRoom_Req_t req;
    memset(&req, 0, sizeof(req));
	req.versionId = JOINROOM_VERSION;
	req.userId = userId;
	req.vcbId = roomId;
	req.qxFileMaskSeed = 0;
	req.isReconnect = 0;
	req.isHide = isHide;
	req.isMobile = 2;
	strcpy(req.userPwd, userPwd);
    strcpy(req.vcbPwd, roomPwd);
//    if(sessionMask !=0)
//        strcpy(req.sessionmask, sessionMask);
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_JOINROOM_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_JoinRoom_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//发送房间聊天请求
-(int)SendRoomChatMsgReq:(int)roomId
                   SrcID:(int)srcId
                    ToID:(int)toId
                 MsgType:(int8_t)msgType
                 TextLen:(int16_t)textLen
            SrcUserAlias:(const char*)srcUserAlias
             ToUserAlias:(const char*)toUserAlias
              MsgContent:(const char*)msgContent
{
    char szBuffer[SOCKET_TCP_BUFFER_SIZE];
    memset(szBuffer, 0, sizeof(szBuffer));
    HBCMD_VideoChat_RoomChatMsg_t* req = (HBCMD_VideoChat_RoomChatMsg_t*)szBuffer;
    req->errorCode = 0;
    req->vcbId = roomId;
    req->srcId = srcId;
    req->toId = toId;
    req->chatTypeId = msgType;
    req->textLen = strlen(msgContent)+1;
    if(srcUserAlias != 0)
        strcpy(req->srcName, srcUserAlias);
    if(toUserAlias != 0)
        strcpy(req->vcbName, toUserAlias);
    if(msgContent !=0)
        strcpy(req->text, msgContent);
    if(_isConnected == 1) {
        int nret =[self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_REQ Data:szBuffer DataLen:sizeof(HBCMD_VideoChat_RoomChatMsg_t) + req->textLen];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

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
             hideMode:(int8_t)hideModel
{
    char szBuffer[SOCKET_TCP_BUFFER_SIZE];
    memset(szBuffer, 0, sizeof(szBuffer));
    HBCMD_VideoChat_GiftRecord_t* req = (HBCMD_VideoChat_GiftRecord_t*)szBuffer;
    req->errorCode = 0;
    req->vcbId   = roomId;
    req->srcId   = srcId;
    req->toId    = toId;
    req->giftId  = giftId;
    req->giftNum = giftNum;
    req->hideMode = hideModel;
    if(giftText !=0)
        req->textLen = strlen(giftText)+1;
    if(srcUserAlias !=0)
        strcpy(req->srcName, srcUserAlias);
    if(toUserAlias !=0)
        strcpy(req->toName, toUserAlias);
    if(giftText >0 && giftText != 0)
        strcpy(req->text, giftText);
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_REQ Data:szBuffer DataLen:sizeof(HBCMD_VideoChat_GiftRecord_t)+req->textLen];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}
//
////进房间跑道消息通知
//-(void)OnNetMsg_trackInfoNoty:(int)roomId
//                        srcId:(int)scrId
//                         toId:(int)toId
//                       giftId:(int)giftId
//                      giftNum:(int)giftNum
//                        flyId:(int)flyId
//                     castMode:(int)castMode
//                   serverMode:(int)serverMode
//                     hideMode:(int)hideMode
//                     sendType:(int)sendType
//                   nextAction:(int)nextAction
//                      textLen:(int)textLen
//                    reserve01:(int)reserve01
//                      srcName:(NSString *)srcName
//                       toName:(NSString *)toName
//                      vcbName:(NSString *)vcbName
//                         text:(NSString *)text{
//    char szBuffer[SOCKET_TCP_BUFFER_SIZE];
//    memset(szBuffer, 0, sizeof(szBuffer));
//    HBCMD_VideoChat_GiftRecord_t* req = (HBCMD_VideoChat_GiftRecord_t*)szBuffer;
//    req->errorCode = 0;
//    req->vcbId = roomId;
//    req->srcId = scrId;
//    req->toId = toId;
//    req->giftId = giftId;
//    req->giftNum = giftNum;
//    req->flyId = flyId;
//    req->castMode = castMode;
//    req->serverMode = serverMode;
//    req->hideMode = hideMode;
//    req->sendType = sendType;
//    req->nextAction = nextAction;
//    req->textLen = textLen;
//    req->reserve01 =reserve01;
//    if(text !=0)
//        req->textLen = strlen(textLen)+1;
//    if(srcName !=0)
//        strcpy(req->srcName, srcName);
//}

//发送房间请求用户账户信息请求
-(int)SendGetUserAccountReq:(int)roomId
                       SrcID:(int)srcId
                        ToID:(int)toId
{
    HBCMD_VideoChat_GetUserAccount_Req_t req;
    memset(&req, 0, sizeof(req));
    req.vcbId = roomId;
    req.runnerId =srcId;
    req.userId = toId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_GetUserAccount_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//发出退出房间请求
-(int)SendExitRoomReq:(int)roomId
                UserID:(int)userId
{
    HBCMD_VideoChat_ExitRoom_Req_t req;
    memset(&req, 0, sizeof(req));
    req.vcbId = roomId;
    req.userId = userId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_EXITROOM_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_ExitRoom_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//发出删除房间请求
-(int)SendDelRoomReq:(int)roomId
             OPUserID:(int)opuserId
{
    //这里是删除手机创建的房间

    return -2;
}

//发送房间增加/删除管理请求
-(int)SendRoomAddMgrReq:(int)roomId
                   SrcID:(int)srcId
                    ToID:(int)toId
                ActionID:(int8_t)actionId
{
    //手机版不使用
#if 0
    HBCMD_YDZB_RoomAddMgrReq_t req;
    memset(&req, 0, sizeof(req));
    req.roomId = roomId;
    req.srcId = srcId;
    req.toId = toId;
    req.actionId = actionId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_YDZB_MAINCMD SubCommand:MXP_YDZB_SUBCMD_ROOMADDMGR_REQ Data:(char*)&req DataLen:sizeof(HBCMD_YDZB_RoomAddMgrReq_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
#endif 
    return -2;
}

//发送房间禁言/取消禁言请求
-(int)SendRoomForbidChatReq:(int)roomId
                       SrcID:(int)srcId
                        ToID:(int)toId
                    ActionID:(int8_t)actionId
{
    //手机版不使用
#if 0
    YDZB_RoomForbidChatReq_t req;
    memset(&req, 0, sizeof(req));
    req.roomId = roomId;
    req.srcId = srcId;
    req.toId = toId;
    req.actionId = actionId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_YDZB_MAINCMD SubCommand:MXP_YDZB_SUBCMD_ROOMFORBIDCHAT_REQ Data:(char*)&req DataLen:sizeof(YDZB_RoomForbidChatReq_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
#endif
    return -2;
}

//发送房间踢出用户请求
-(int)SendRoomKickUserReq:(int)roomId
                     SrcID:(int)srcId
                      ToID:(int)toId
                  ReasonID:(int)reasonId
{
    //手机版不使用
#if 0
    HBCMD_YDZB_RoomKickUerReq_t req;
    memset(&req, 0, sizeof(req));
    req.roomId = roomId;
    req.srcId = srcId;
    req.toId = toId;
    req.reasonId = reasonId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_YDZB_MAINCMD SubCommand:MXP_YDZB_SUBCMD_ROOMKICKUSER_REQ Data:(char*)&req DataLen:sizeof(HBCMD_YDZB_RoomKickUerReq_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
#endif 	
    return -2;
}

//发送房间心跳消息
-(int)SendRoomKeeplive:(int)roomId
                UserID:(int)userId
{
    HBCMD_VideoChat_RoomKeepLive_Req_t req;
    memset(&req, 0, sizeof(req));
    req.userId = userId;
    req.vcbId = roomId;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_ROOMKEEPLIVE_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_RoomKeepLive_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
}

//用户关注请求
-(int)SendUserAttentionReq:(int)nFlag
                    uUserID:(int)nUserID
                    nRoomID:(int)nRoomID
                    nSinger:(int)nSinge{
    HBCMD_VIDEOCHAT_UserAttention_Req_t req;
    memset(&req, 0, sizeof(req));
    req.nFlag = nFlag;
    req.nUserID = nUserID;
    req.nRoomID = nRoomID;
    req.nSinger = nSinge;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_USERATTENTION_REQ Data:(char*)&req DataLen:sizeof(HBCMD_VIDEOCHAT_UserAttention_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
    
}

//积分兑换
-(int)sendScoreChargeReq:(int)vcbId
                  userId:(int)userId
                   money:(int)money{
    HBCMD_VideoChat_RoomNB2NK_Req_t req;
    memset(&req, 0, sizeof(req));
    req.vcbId = vcbId;
    req.userId = userId;
    req.money = money;
    if(_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand: MXP_SUBCMD_VIDEOCHAT_ROOMNB2NK_REQ  Data:(char*)&req DataLen:sizeof(HBCMD_VideoChat_RoomNB2NK_Req_t)];
        return 0;
    }
    else if(_isConnecting == 1) {
        return -1;
    }
    return -2;
    
}

- (int)sendMicStatusModifyReq:(int)roomId
                       userId:(int)userId
                       status:(int)status{
    HBCMD_VIDEOCHAT_MicStatusModify_Req_t req;
    memset(&req, 0, sizeof(req));
    req.nroomid = roomId;
    req.nsrcuserid = userId;
    req.nstatus = status;
    NSLog(@"status == %d",status);
    if (_isConnected == 1) {
        int nret = [self SendData:MXP_MAINCMD_VIDEOCHAT SubCommand:MXP_SUBCMD_VIDEOCHAT_MICSTATUSMODIFY_REQ Data:(char *)&req DataLen:sizeof(HBCMD_VIDEOCHAT_MicStatusModify_Req_t)];
        return 0;
    }else if (_isConnecting == 1){
        return -1;
    }
    return -2;
}

@end
