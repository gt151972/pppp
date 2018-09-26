//
//  DPK_NW_Application.m
//  InKeLive
//
//  Created by gu  on 17/8/12.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "DPK_NW_Application.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>
#import "CommonAPIDefines.h"

#define typeCount 6

static DPK_NW_Application* DPKApp_ShareObj =nil;
@interface DPK_NW_Application()
@property (nonatomic, strong)NSMutableArray *array;
@end

@implementation DPK_NW_Application


+(DPK_NW_Application*) sharedInstance
{
    //NSLog(@"DPK_NW_Application:sharedInstance");
    @synchronized(self) {
        if(DPKApp_ShareObj ==nil) {
            DPKApp_ShareObj =[[self alloc] init];
        }
    }
    return DPKApp_ShareObj;
}

+(id)allocWithZone:(NSZone *)zone
{
    NSLog(@"DPK_NW_Application:allocWithZone");
    @synchronized(self) {
        if(DPKApp_ShareObj ==nil) {
            DPKApp_ShareObj =[super allocWithZone:zone];
            DPKApp_ShareObj.localUserModel = [[LocalUserModel alloc]init];
            DPKApp_ShareObj->m_roomSocketArray = [NSMutableArray array];
            //DPKApp_ShareObj.giftConf =[NSMutableArray array];
            //DPKApp_ShareObj.defaultServerAddr = DEFAULT_SERVER_ADDRESS;
            //DPKApp_ShareObj.defaultServerPort = DEFAULT_SERVER_PORT;
            return DPKApp_ShareObj;
        }
    }
    return nil;
}

-(ClientConfigParam*)clientConfigParam {
    if(!_clientConfigParam) {
        _clientConfigParam =[[ClientConfigParam alloc]init];
        _clientConfigParam.userHeadPicPrefix = @"";
        _clientConfigParam.commonApiPrefix = @"";
    }
    return _clientConfigParam;
}

-(TempQueryVCBSvrInfo*)tmpQueryVCBSvrInfo {
    if(!_tmpQueryVCBSvrInfo) {
        _tmpQueryVCBSvrInfo = [[TempQueryVCBSvrInfo alloc]init];
        [_tmpQueryVCBSvrInfo reset];
    }
    return _tmpQueryVCBSvrInfo;
}

-(TempCreateRoomInfo*)tempCreateRoomInfo {
    if(!_tempCreateRoomInfo) {
        _tempCreateRoomInfo = [[TempCreateRoomInfo alloc] init];
        [_tempCreateRoomInfo reset];
    }
    return _tempCreateRoomInfo;
}

-(TempJoinRoomInfo*)tempJoinRoomInfo {
    if(!_tempJoinRoomInfo) {
        _tempJoinRoomInfo = [[TempJoinRoomInfo alloc] init];
        [_tempJoinRoomInfo reset];
    }
    return _tempJoinRoomInfo;
}

- (NSMutableArray *)giftGroup{
    if (!_giftGroup) {
        _giftGroup = [NSMutableArray array];
    }
    return _giftGroup;
}

- (NSMutableArray *)giftList{
    if (!_giftList) {
        _giftList = [NSMutableArray array];
    }
    return _giftList;
}

+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    
    return [string lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

#pragma mark- 缩放图片 对大小压缩
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    //*******************************
    //使用方式
    //UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    //original = [HZSInstances scaleImage:original toScale:0.4];
    //*******************************
    
    //设置图片尺寸
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //对图片包得大小进行压缩
    //NSData *imageData = UIImageJPEGRepresentation(scaledImage,1.0);
    //UIImage *m_selectImage = [UIImage imageWithData:imageData];
    //return m_selectImage;
    
    return scaledImage;
}

+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)dstSize
{
    //设置图片尺寸
    UIGraphicsBeginImageContext(CGSizeMake(dstSize.width,dstSize.height));
    [image drawInRect:CGRectMake(0, 0, dstSize.width, dstSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //对图片包得大小进行压缩
    //NSData *imageData = UIImageJPEGRepresentation(scaledImage,1.0);
    //UIImage *m_selectImage = [UIImage imageWithData:imageData];
    //return m_selectImage;
    
    return scaledImage;
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(DPKTCPSocket*) CreateSocket
{
    NSLog(@"DPK_NW_Application:GetRoomSocket 创建新的Socket");
    DPKTCPSocket* pobj = [[DPKTCPSocket alloc]init];
    [pobj SetSocketSink:self];
    pobj.roomid =0;
    return pobj;
}

-(int) CloseRoomSocket:(DPKTCPSocket*)sock
{
    if(sock != nil) {
        [m_roomSocketArray removeObject:sock];
        [sock SetSocketSink:nil];
        [sock SetMessageEventSink:nil];
        [sock CloseSocket:0];
        return 0;
    }
    return -1;

}

-(int)SetRoomMessageSink:(DPKTCPSocket*)sock RoomMessageSink:(id) delegate
{
    if(sock !=nil)
        [sock SetMessageEventSink:delegate];
    return 0;
}
- (void)loadGiftVersion{
    NSLog(@"请求礼物配置 >>>>> ");
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = @"20001";
    parameters[@"flag"] = @"0";
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        if(1){
            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString*cachePath = array[0];
            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
            NSDictionary*dict =@{@"res": [appDic objectForKey:@"res"],@"uDown":[appDic objectForKey:@"uDown"],@"uUp":[appDic objectForKey:@"uUp"],@"GiftVersion":[NSString stringWithFormat:@"%@",[appDic objectForKey:@"GiftVersion"]]};
            [dict writeToFile:filePathName atomically:YES];
            [self loadGiftConf];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

-(void) loadGiftConf
{
    NSLog(@"请求礼物配置 >>>>> ");
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = @"20001";
    parameters[@"flag"] = @"2";
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSString* errorCode= appDic[@"errorCode"];
        NSString* errorMsg = appDic[@"errorMsg"];
        if(1)
        {
            [self.giftList removeAllObjects];
            [self.giftGroup removeAllObjects];
//            NSString* url_giftpic_prefix = appDic[@"urlGiftPicPrefix"];
            NSArray* giftconflist = (NSArray*)appDic[@"GiftList"];
            NSArray* giftGroup = (NSArray*)appDic[@"GiftGroup"];
            NSDictionary* webAddress = (NSDictionary *)appDic[@"mConfig"];
            for(NSDictionary* giftItem in giftconflist) {
                GTGiftListModel* model = [[GTGiftListModel alloc] init];
                model.ctype = [giftItem[@"ctype"] intValue];
                model.flag = [giftItem[@"flag"] intValue];
                model.giftId =[giftItem[@"id"] intValue];
                model.name = giftItem[@"name"];
                model.note = giftItem[@"experience"];
                model.pic_original = giftItem[@"pic_original"];
                model.pic_s = giftItem[@"pic_s"];
                model.pic_thumb = giftItem[@"pic_thumb"];
                model.price = [giftItem[@"price"] intValue];
                model.sname = giftItem[@"sname"];
                model.sort = [giftItem[@"sort"] intValue];
                model.ssort = [giftItem[@"ssort"] intValue];
                model.stype = [giftItem[@"stype"] intValue];
                model.stype = [giftItem[@"tprice"] intValue];
                [self.giftList addObject:model];
            }
            NSLog(@"NSArray* giftconflist == %@",giftconflist);
            for (NSDictionary *giftItem in giftGroup) {
                GTGiftGroupModel* model = [[GTGiftGroupModel alloc] init];
                model.giftId = [giftItem[@"Id"] intValue];
                model.order = [giftItem[@"Order"] intValue];
                model.display =[giftItem[@"display"] intValue];
                model.title = giftItem[@"Title"];
                model.list = giftItem[@"list"];
                [self.giftGroup addObject:model];
            }
            NSLog(@"webAddress == %@",webAddress);
            NSArray *arrKey = [webAddress allKeys];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int index = 0; index < arrKey.count; index ++) {
                NSString *string = [webAddress objectForKey:arrKey[index]];
                string = [string stringByReplacingOccurrencesOfString:@"{uid}"withString:[NSString stringWithFormat:@"%d",_localUserModel.userID]];
                string = [string stringByReplacingOccurrencesOfString:@"{sid}"withString:[NSString stringWithFormat:@"%@",_localUserModel.userSid]];
                [dic setValue:string forKey:arrKey[index]];
            }
            NSLog(@"dic == %@",dic);
            NSLog(@"_localUserModel.userID == %d",_localUserModel.userID);
            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString*cachePath = array[0];
            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
            [dic writeToFile:filePathName atomically:YES];
        }
        NSLog(@"load gift-config, gift count=%lu", (unsigned long)self.giftList.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

- (NSMutableArray *)array{
    _array = [NSMutableArray array];
    DPK_NW_Application* dpk_app= [DPK_NW_Application sharedInstance];
    NSArray *arrayGroup = [NSArray arrayWithArray: dpk_app.giftGroup];
    NSArray *arrayList = [NSArray arrayWithArray: dpk_app.giftList];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:APP_info ofType:@"plist"];
    NSMutableArray *arrData = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:GIFT_LIST];
    if (arrayGroup.count > 0 && arrData.count > 0) {
        for (int count = 0; count < typeCount ; count ++) {
            NSMutableArray *arrSame = [NSMutableArray array];
            GTGiftGroupModel*model = [arrayGroup objectAtIndex:count];
            for (int index = 0; index < model.list.count; index ++) {
                //        NSLog(@"%@",model.list[index]);
                for (int x = 0; x < arrayList.count; x++) {
                    GTGiftListModel *listModel = [arrayList objectAtIndex:x];
                    //            NSLog(@"group == %@",[model.list objectAtIndex:index]);
                    //            NSLog(@"list == %d",listModel.giftId);
                    if ([[model.list objectAtIndex:index]intValue] == listModel.giftId) {
                        [arrSame addObject:listModel];
                    }
                }
            }
            NSLog(@"arrSame == %lu",(unsigned long)arrSame.count);
            //        [_array addObject:arrSame];
            [_array insertObject:arrSame atIndex:count];
        }
        arrData = _array;
        [arrData writeToFile:plistPath atomically:YES];
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:APP_info ofType:@"plist"];
        NSMutableArray *arr = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:GIFT_LIST];
        NSLog(@"arr == %@",arr);
    }else{
        _array = arrData;
    }
    return _array;
}

-(GTGiftListModel*) findGiftConfig:(int)giftId
{
    if(_giftList != nil) {
        for(int i=0; i<_giftList.count; i++) {
            if(((GTGiftListModel*)[_giftList objectAtIndex:i]).giftId == giftId) {
                return [_giftList objectAtIndex:i];
            }
        }
    }
    return nil;
}

#pragma mark DPKTCPSocketSink delegate

- (void)OnEventTCPSocketLink:(DPKTCPSocket*)sock error:(int) error_code
{
    //TODO:
    NSLog(@"DPK_NW_Application:OnEventTCPSocketLink 服务器连接响应！error_code=%d", error_code);
    if(error_code == 0) {
        NSLog(@"服务器连接成功");
        NSLog(@"自动发送握手数据");
        HBCMD_COMMON_ClientHello_t clientHello;
        memset(&clientHello, 0, sizeof(HBCMD_COMMON_ClientHello_t));
        clientHello.a = 1001;
        clientHello.b = 1002;
        clientHello.c = 10003;
        clientHello.d = 10004;
        [sock SendData:MXP_MAINCMD_COMMON
            SubCommand:MXP_SUBCMD_COMMON_CLIENT_HELLO
                  Data:(char*)&clientHello
               DataLen:sizeof(HBCMD_COMMON_ClientHello_t)];
        
    }
    __strong id delegate =[sock GetMessageEventSink];
    if(delegate != nil) {
        [delegate OnDPKEventTCPSocketLink:error_code];
    }
}

- (void)OnEventTCPSocketShut:(DPKTCPSocket*)sock reason:(int)reason_code
{
    //TODO:
    NSLog(@"DPK_NW_Application:OnEventTCPSocketShut 服务器断开！reson_code=%d", reason_code);
    __strong id delegate =[sock GetMessageEventSink];
    if(delegate !=nil) {
        [delegate OnDPKEventTCPSocketShut:reason_code];
    }
}

- (void)OnEventTCPSocketRead:(DPKTCPSocket *)sock
                 MainCommand:(int)main_cmd
                  SubCommand:(int)sub_cmd
                        Data:(char *)data
                        time:(int)time
                      roomID:(int)roomID
                      userID:(int)userID
                     DataLen:(int)data_len

//- (void)OnEventTCPSocketRead:(DPKTCPSocket*)sock MainCommand:(int)main_cmd
//                  SubCommand:(int)sub_cmd
//                        Data:(char*)data
//                     DataLen:(int)data_len
{
    
    
    //TODO:
    NSLog(@"OnEventTCPSocketRead...");
    
    if(main_cmd == MXP_MAINCMD_VIDEOCHAT) {
        switch(sub_cmd) {
            case MXP_SUBCMD_VIDEOCHAT_QUERY_VCBSERVER_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_QUERY_VCBSERVER_RESP");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_CREATE_MOBILEROOM_RESP:
            {
                //创建MB房间响应
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_CREATE_MOBILEROOM_RESP");
                
                HBCMD_VideoChat_Create_MobileRoom_Resp_t* pResp = (HBCMD_VideoChat_Create_MobileRoom_Resp_t*)data;
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                //NSString* strAccount = [[NSString alloc] initWithCString:pLogonResp->user_account encoding:NSASCIIStringEncoding ];
                //NSString* strNickName = [[NSString alloc] initWithCString:pLogonResp->user_nickname encoding:enc];
                NSString* strRoomName = [[NSString alloc] initWithCString:pResp->roomName encoding:enc];
                NSString* strMediaAddr =[[NSString alloc] initWithCString:pResp->mediaAddr encoding:NSASCIIStringEncoding];
                NSString* strGateAddr =[[NSString alloc] initWithCString:pResp->gateAddr encoding:NSASCIIStringEncoding];
                NSString* strServerAddr =[[NSString alloc] initWithCString:pResp->serverAddr encoding:NSASCIIStringEncoding];
                
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_CreateRoomResp:pResp->errorCode
                                               UserID:pResp->userId
                                               RoomID:pResp->roomId
                                            CreatorID:pResp->creatorId
                                             RoomName:strRoomName
                                           ServerAddr:strServerAddr
                                             GateAddr:strGateAddr
                                            MediaAddr:strMediaAddr
                                           ServerPort:pResp->serverPort];
                    
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_RESP:
            {
                //TODO:
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_RESP");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_NOTY:
            {
                //TODO:
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_DEL_MOBILEROOM_NOTY");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_UPMBMIC_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_UPMBMIC_RESP");
                HBCMD_VideoChat_UpMBMic_Resp_t* pResp = (HBCMD_VideoChat_UpMBMic_Resp_t*)data;
                NSString* strTLMeidauri1 =[[NSString alloc] initWithCString:pResp->TLMeidauri1 encoding:NSASCIIStringEncoding];
                NSString* strTLMeidauri2 =[[NSString alloc] initWithCString:pResp->TLMeidauri2 encoding:NSASCIIStringEncoding];
                
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_UpMBMicResp:pResp->errorCode
                                            UserID:pResp->userId
                                            RoomID:pResp->vcbId
                                     UserRoomState:pResp->userRoomState
                                          TLStatus:pResp->TLStatus
                                       TLMediaUrl1:strTLMeidauri1
                                       TLMediaUrl2:strTLMeidauri2];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_UPMBMIC_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_UPMBMIC_NOTY");
                HBCMD_VideoChat_UpMBMic_Noty_t* pNoty = (HBCMD_VideoChat_UpMBMic_Noty_t*)data;
                NSString* strTLMeidauri1 =[[NSString alloc] initWithCString:pNoty->TLMeidauri1 encoding:NSASCIIStringEncoding];
                NSString* strTLMeidauri2 =[[NSString alloc] initWithCString:pNoty->TLMeidauri2 encoding:NSASCIIStringEncoding];
                
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_UpMBMicNoty:pNoty->userId
                                            RoomID:pNoty->vcbId
                                     UserRoomState:pNoty->userRoomState
                                          TLStatus:pNoty->TLStatus
                                       TLMediaUrl1:strTLMeidauri1
                                       TLMediaUrl2:strTLMeidauri2];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_RESP");
                HBCMD_VideoChat_DownMBMic_Resp_t* pResp =(HBCMD_VideoChat_DownMBMic_Resp_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_DownMBMicResp:pResp->errorCode
                                              UserID:pResp->userId
                                              RoomID:pResp->vcbId
                     UserRoomState:pResp->userRoomState];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_DOWNMBMIC_NOTY");
                HBCMD_VideoChat_DownMBMic_Noty_t* pNoty = (HBCMD_VideoChat_DownMBMic_Noty_t *)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_DownMBMicNoty:pNoty->userId
                                              RoomID:pNoty->vcbId
                     UserRoomState:pNoty->userRoomState];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_RESP");
                HBCMD_VideoChat_SetMBTLStatus_Resp_t* pResp=(HBCMD_VideoChat_SetMBTLStatus_Resp_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_SetMBTLStatusResp:pResp->errorCode UserID:pResp->userId RoomID:pResp->vcbId TLStatus:pResp->TLStatus];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_SETMBTLSTATUS_NOTY");
                HBCMD_VideoChat_SetMBTLStatus_Noty_t* pNoty=(HBCMD_VideoChat_SetMBTLStatus_Noty_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_SetMBTLStatusNoty:pNoty->userId RoomID:pNoty->vcbId TLStatus:pNoty->TLStatus];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_JOINROOM_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_JOINROOM_RESP");
                NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
                NSString *cachePath = array[0];
                NSString *filePathName = [cachePath stringByAppendingPathComponent:@"SocketVerify.plist"];
                NSArray*dataArray =[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",time], [NSString stringWithFormat:@"%d",roomID], [NSString stringWithFormat:@"%d",userID], nil];
                [dataArray writeToFile:filePathName atomically:YES];
                HBCMD_VideoChat_JoinRoom_Resp_t* pResp = (HBCMD_VideoChat_JoinRoom_Resp_t*)data;
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                NSString* strRoomName = [[NSString alloc] initWithCString:pResp->vcbName encoding:enc];
                NSString* strMediaServer =[[NSString alloc] initWithCString:pResp->vcbMediaServer encoding:NSASCIIStringEncoding];
                
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_JoinRoomResp:pResp->errorCode
                                          VersionID:pResp->versionId
                                             UserID:pResp->userId
                                              VcbID:pResp->vcbId
                                          CreatorID:pResp->vcbCreatorId
                                         OPUserID01:pResp->opUser01
                                         OPUserID02:pResp->opUser02
                                         OPUserID03:pResp->opUser03
                                         OPUserID04:pResp->opUser04
                                         OPUserID05:pResp->opUser05
                                         OPUserID06:pResp->opUser06
                                          RoomState:pResp->roomState
                                         LayoutType:pResp->layoutType
                                         RoomAttrId:pResp->roomAttrId
                                        Reserved_01:pResp->reserved_01
                                        Reserved_02:pResp->reserved_02
                                           RoomName:strRoomName
                                        MediaServer:strMediaServer
                                      RoomIsUsedPwd:pResp->vcbIsUsedPwd
                                           VipLevel:pResp->vipLevel
                                        PlayerLevel:pResp->playerLevel
                                          RoomLevel:pResp->roomLevel
                                      UserRoomState:pResp->userRoomState
                                                 NK:pResp->user_nk
                                                 NB:pResp->user_nb
                                             Ngende:pResp->ngende];
             
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_BEGIN:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_BEGIN");
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomUserListBegin];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_DATA:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_DATA");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_RoomUserInfo_t* pUserItem = (HBCMD_VideoChat_RoomUserInfo_t *)data;
                    int cur_pos =0;
                    while(cur_pos + sizeof(HBCMD_VideoChat_RoomUserInfo_t) <=data_len) {
                        NSString* strUserAlias =[[NSString alloc]initWithCString:pUserItem->userName encoding:enc];
                        NSString* strHeadPic = [[NSString alloc] initWithCString:pUserItem->userHeadPic encoding:NSASCIIStringEncoding];
                        [delegate OnNetMsg_RoomUserListItem:pUserItem->vcbId
                                                     UserID:pUserItem->userId
                                                     Gender:0
                                                   VipLevel:pUserItem->vipLevel
                                                PlayerLevel:pUserItem->playerLevel
                                                  RoomLevel:pUserItem->roomLevel
                                                InRoomState:pUserItem->userRoomState
                                                   ComeTime:0
                                                     SealID:pUserItem->sealId
                                            SealExpiredTime:pUserItem->sealExpiredTime
                                                      CarID:pUserItem->carId
                                                  UserAlias:strUserAlias
                                                UserHeadPic:strHeadPic
                         ];
                        pUserItem++;
                        cur_pos += sizeof(HBCMD_VideoChat_RoomUserInfo_t);
                    }
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_END:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMUSERLIST_END");
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomUserListEnd];
                }
                
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_JOINROOM_FINISH:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_JOINROOM_FINISH");
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_JoinRoomFinished];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMINFO_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMINFO_NOTY");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_RoomInfo_t* pInfo = (HBCMD_VideoChat_RoomInfo_t *)data;
                    NSString* vcbName =[[NSString alloc]initWithCString:pInfo->vcbName encoding:enc];
                    [delegate OnNetMsg_RoomInfoNoty:pInfo->errroCode
                                           RunnerID:pInfo->runnerId
                                             RoomID:pInfo->vcbId
                                          CreatorID:pInfo->vcbCreatorId
                                           OpUser01:pInfo->opUser01
                                           OpUser02:pInfo->opUser02
                                           OpUser03:pInfo->opUser03
                                           OpUser04:pInfo->opUser04
                                           OpUser05:pInfo->opUser05
                                           OpUser06:pInfo->opUser06
                                            OpState:pInfo->opState
                                           RoomName:vcbName
                                          IsUsedPwd:pInfo->vcbIsUsedPwd];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMNOTICE_NOTY:
            {
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    HBCMD_VideoChat_RoomNotice_t* pNoty = (HBCMD_VideoChat_RoomNotice_t*)data;
                    
                    NSString* strMsgText =@"";
                    char* szText = pNoty->text;
                    
                    if(pNoty->textLen > 0)
                        strMsgText = [[NSString alloc] initWithCString:szText encoding:enc];
                    [delegate OnNetMsg_RoomNoticeNoty:pNoty->errorCode
                                             RunnerID:pNoty->runnerId
                                               RoomID:pNoty->vcbId
                                              TextLen:pNoty->textLen
                                            TextIndex:pNoty->textIndex
                                                 Text:strMsgText];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMMEDIASERVER_NOTY:
                {
                    __strong id delegate =[sock GetMessageEventSink];
                    if(delegate !=nil) {
                        HBCMD_VideoChat_RoomMediaServer_t* pNoty = (HBCMD_VideoChat_RoomMediaServer_t*)data;
                        NSString* strMediaServer =[[NSString alloc] initWithCString:pNoty->vcbMediaServer encoding:NSASCIIStringEncoding];
                        [delegate OnNetMsg_RoomMediaServerNoty:pNoty->errorCode
                                                        RoomID:pNoty->vcbId
                                                  MediaSvrAddr:strMediaServer];
                    }
                }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMMICSTATE_NOTY:
            {
                //TODO:
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_FLYGIFTRECORD_NOTY:
            {
                //跑道
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_SIEGE_INFO:
            {
                //TODO:
            }
                break;
            
            case MXP_SUBCMD_VIDEOCHAT_ROOMUSERCOMEIN_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMUSERCOMEIN_NOTY");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_RoomUserInfo_t* pUserItem = (HBCMD_VideoChat_RoomUserInfo_t *)data;
                    NSString* strUserAlias =[[NSString alloc]initWithCString:pUserItem->userName encoding:enc];
                    NSString* strHeadPic = [[NSString alloc] initWithCString:pUserItem->userHeadPic encoding:NSASCIIStringEncoding];
                    [delegate OnNetMsg_RoomUserComeNoty:pUserItem->vcbId
                                                 UserID:pUserItem->userId
                                                 Gender:0
                                               VipLevel:pUserItem->vipLevel
                                            PlayerLevel:pUserItem->playerLevel
                                              RoomLevel:pUserItem->roomLevel
                                            InRoomState:pUserItem->userRoomState
                                               ComeTime:0
                                                 SealID:pUserItem->sealId
                                        SealExpiredTime:pUserItem->sealExpiredTime
                                                 CardID:pUserItem->carId
                                              UserAlias:strUserAlias
                                            UserHeadPic:strHeadPic];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMCHATMSG_NOTY");//聊天
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    HBCMD_VideoChat_RoomChatMsg_t* pNoty =(HBCMD_VideoChat_RoomChatMsg_t*)data;
                    NSLog(@"%s",data);
                    NSString* strSrcAlias = [[NSString alloc] initWithCString:pNoty->srcName encoding:enc];
                    NSString* strToAlias = [[NSString alloc] initWithCString:pNoty->vcbName encoding:enc];
                    NSString* strMsgText = [[NSString alloc] initWithCString:pNoty->text encoding:enc];
                    [delegate OnNetMsg_RoomChatMsgNoty:pNoty->vcbId
                                                 SrcID:pNoty->srcId
                                                  ToID:pNoty->toId
                                               MsgType:pNoty->chatTypeId
                                               TextLen:pNoty->textLen
                                          SrcUserAlias:strSrcAlias
                                           ToUserAlias:strToAlias
                                           ChatContent:strMsgText
                     ];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_RESP");
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_GiftRecord_t* pResp =(HBCMD_VideoChat_GiftRecord_t*)data;
                    [delegate OnNetMsg_RoomSendGiftResp:pResp->errorCode];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMSENDGIFT_NOTY");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_GiftRecord_t* pNoty=(HBCMD_VideoChat_GiftRecord_t*)data;
                    NSString* strSrcAlias =[[NSString alloc] initWithCString:pNoty->srcName encoding:enc];
                    NSString* strToAlias =[[NSString alloc] initWithCString:pNoty->toName encoding:enc];
                    NSString* strGiftText = [[NSString alloc] initWithCString:pNoty->text encoding:enc];
                    [delegate OnNetMsg_RoomSendGiftNoty:pNoty->vcbId
                                                  SrcID:pNoty->srcId
                                                   ToID:pNoty->toId
                                                 GiftID:pNoty->giftId
                                                GiftNum:pNoty->giftNum
                                                  flyId:pNoty->flyId
                                                TextLen:pNoty->textLen
                                           SrcUserAlias:strSrcAlias
                                            ToUserAlias:strToAlias
                                               GiftText:strGiftText
                     ];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_RESP");
                HBCMD_VideoChat_GetUserAccount_Resp_t* pResp =(HBCMD_VideoChat_GetUserAccount_Resp_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_GetUserAccoutResp:pResp->errorCode];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_USERACCOUNT_NOTY");
                HBCMD_VideoChat_UserAccount_Noty_t* pNoty =(HBCMD_VideoChat_UserAccount_Noty_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_UserAccountNoty:pNoty->userId
                                                    NK:pNoty->nk
                                                    NB:pNoty->nb
                     ];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_EXITROOM_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_EXITROOM_RESP");
                HBCMD_VideoChat_ExitRoom_Resp_t* pResp =(HBCMD_VideoChat_ExitRoom_Resp_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_ExitRoomResp:pResp->errorCode];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_EXITROOM_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_EXITROOM_NOTY");
                HBCMD_VideoChat_ExitRoom_Noty_t* pNoty =(HBCMD_VideoChat_ExitRoom_Noty_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_ExitRoomNoty:pNoty->vcbId
                                             UserID:pNoty->userId
                     ];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMUPMIC_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMUPMIC_NOTY");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                
                HBCMD_VideoChat_RoomUpMic_Noty_t *pNoty =(HBCMD_VideoChat_RoomUpMic_Noty_t*)data;
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    NSString* strTLMediaUrl1 =[[NSString alloc] initWithCString:pNoty->TLMeidauri1 encoding:NSASCIIStringEncoding];
                    NSString* strTLMediaUrl2 =[[NSString alloc] initWithCString:pNoty->TLMeidauri2 encoding:NSASCIIStringEncoding];
                    
                    [delegate OnNetMsg_UpMicNoty:pNoty->vcbId
                                        RunnerID:pNoty->runnerId
                                          UserID:pNoty->userId
                                         MicType:pNoty->micType
                                         Param01:pNoty->param_01
                                         Param02:pNoty->param_02
                                   UserRoomState:pNoty->userRoomState
                                     TLMediaurl1:strTLMediaUrl1
                                     TLMediaurl2:strTLMediaUrl2];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMDOWNMIC_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMDOWNMIC_NOTY");
                HBCMD_VideoChat_RoomDownMic_Noty_t* pNoty = (HBCMD_VideoChat_RoomDownMic_Noty_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate !=nil) {
                    [delegate OnNetMsg_DownMicNoty:pNoty->vcbId
                                          RunnerID:pNoty->runnerId
                                            UserID:pNoty->userId
                                     UserRoomState:pNoty->userRoomState];
                }
                
            }
                break;
            
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_RESP:
            {
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_EXITROOM_NOTY");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_NOTY:
            {
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_ROOMADDMGR_NOTY");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_RESP:
            {
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_RESP");
                
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_NOTY:
            {
                NSLog(@"TODO://MXP_SUBCMD_VIDEOCHAT_ROOMADDMUTEUSER_NOTY");
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_RESP:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_RESP");
                
                HBCMD_VideoChat_RoomKickUser_Resp_t* pResp =(HBCMD_VideoChat_RoomKickUser_Resp_t*)data;
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomKickUserResp:pResp->errorCode
                                                 RoomID:pResp->vcbId
                                                  SrcID:pResp->runnerId
                                                   ToID:pResp->userId
                                               ReasonID:0
                     ];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_NOTY:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMKICKOUTUSER_NOTY");
                
                HBCMD_VideoChat_RoomKickUser_Noty_t* pNoty =(HBCMD_VideoChat_RoomKickUser_Noty_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomKickUserNoty:pNoty->vcbId
                                                  SrcID:pNoty->runnerId
                                                   ToID:pNoty->userId
                                               ReasonID:pNoty->reasonId
                     ];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_BEGIN:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_BEGIN");
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomOnMicUserListBegin];
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_DATA:
            {
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_RoomOnMicUserInfo_t* pUserItem =(HBCMD_VideoChat_RoomOnMicUserInfo_t*)data;
                    int cur_pos =0;
                    while(cur_pos + sizeof(HBCMD_VideoChat_RoomOnMicUserInfo_t) <=data_len)
                    {
                         NSString* strUserAlias =[[NSString alloc]initWithCString:pUserItem->userName encoding:enc];
                        NSString* strTLMediaUrl1=[[NSString alloc]initWithCString:pUserItem->TLMeidauri1 encoding:NSASCIIStringEncoding];
                        NSString* strTLMediaUrl2=[[NSString alloc]initWithCString:pUserItem->TLMeidauri2 encoding:NSASCIIStringEncoding];
                        
                        [delegate OnNetMsg_RoomOnMicUserListItem:pUserItem->vcbId
                                                          UserID:pUserItem->userId
                                                   UserRoomState:pUserItem->userRoomState
                                                        VipLevel:pUserItem->vipLevel
                                                     PlayerLevel:pUserItem->playerLevel
                                                       RoomLevel:pUserItem->roomLevel
                                                        TLStatus:pUserItem->TLStatus
                                                        UserName:strUserAlias
                                                     TLMediaUrl1:strTLMediaUrl1
                                                     TLMediaUrl2:strTLMediaUrl2];
                        
                        pUserItem++;
                        cur_pos += sizeof(HBCMD_VideoChat_RoomOnMicUserInfo_t);
                    }
                }
            }
                break;
                
            case MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_END:
            {
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_ROOMONMICUSERLIST_END");
                __strong id delegate = [sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_RoomOnMicUserListEnd];
                }
            }
                break;
            case MXP_SUBCMD_WEB_USERPAY_REQ:{
                NSLog(@"MXP_SUBCMD_WEB_USERPAY_REQ");
            }
                break;
            case MXP_SUBCMD_WEB_GIFTVERSIONMODIFY_REQ:{
                NSLog(@"MXP_SUBCMD_WEB_GIFTVERSIONMODIFY_REQ");
                [self loadGiftVersion];
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_FLYGIFT_INFO:{
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_FLYGIFT_INFO");
                //跑道
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_GiftRecord_t* pNoty=(HBCMD_VideoChat_GiftRecord_t*)data;
                    NSString* strSrcAlias =[[NSString alloc] initWithCString:pNoty->srcName encoding:enc];
                    NSString* strToAlias =[[NSString alloc] initWithCString:pNoty->toName encoding:enc];
                    NSString* strGiftText = [[NSString alloc] initWithCString:pNoty->text encoding:enc];
                    NSString* strVcdName = [[NSString alloc] initWithCString:pNoty->vcbName encoding:enc];
                    [delegate OnNetMsg_trackInfoNoty:pNoty->vcbId
                                               srcId:pNoty->srcId
                                                toId:pNoty->toId
                                              giftId:pNoty->giftId
                                             giftNum:pNoty->giftNum
                                               flyId:pNoty->flyId
                                            castMode:pNoty->castMode
                                          serverMode:pNoty->serverMode
                                            hideMode:pNoty->hideMode
                                            sendType:pNoty->sendType
                                          nextAction:pNoty->nextAction
                                             textLen:pNoty->textLen
                                           reserve01:pNoty->reserve01
                                             srcName:strSrcAlias
                                              toName:strToAlias
                                             vcbName:strVcdName
                                                text:strGiftText];
                }

            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_USERATTENTION_REQ:{//1168
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_USERATTENTION_REQ");

            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_USERATTENTION_RESP:{//1169
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_USERATTENTION_RESP");
                HBCMD_VIDEOCHAT_UserAttention_Resp_t* pResp =(HBCMD_VIDEOCHAT_UserAttention_Resp_t*)data;
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    [delegate OnNetMsg_UserAttentionResp:pResp->nRet
                                                   nFlag:pResp->nFlag
                                                 nUserID:pResp->nUserID
                                                 nRoomID:pResp->nRoomID
                                                 nSinger:pResp->nSinger];
                }
            }
                break;
            case MXP_SUBCMD_VIDEOCHAT_GLOBALCHAT_NOTY:{//1099
                NSLog(@"MXP_SUBCMD_VIDEOCHAT_GLOBALCHAT_NOTY");
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
                __strong id delegate =[sock GetMessageEventSink];
                if(delegate != nil) {
                    HBCMD_VideoChat_GlobalChatMsg_t *pNoty = (HBCMD_VideoChat_GlobalChatMsg_t *)data;
                    NSString* srcName =[[NSString alloc] initWithCString:pNoty->srcName encoding:enc];
                    NSString* toName =[[NSString alloc] initWithCString:pNoty->toName encoding:enc];
                    NSString* vcbName =[[NSString alloc] initWithCString:pNoty->vcbName encoding:enc];
                    NSString* text =[[NSString alloc] initWithCString:pNoty->text encoding:enc];
                    [delegate OnNetMsg_GlobalChatMsgNoty:pNoty->vcbId
                                                   SrcID:pNoty->srcId
                                                    ToID:pNoty->toId
                                                ChatType:pNoty->chatTypeId
                                                 TextLen:pNoty->textLen
                                                 SrcName:srcName
                                                  ToName:toName
                                                RoomName:vcbName
                                                    Text:text];
                }
            }
                break;
            default:{
                NSLog(@"收到未知的SubCommand消息,subCmd=%d", sub_cmd);
            }
                break;
        }
    }
    else{
        NSLog(@"收到未知的mainCommand消息.mainCmd=%d", main_cmd);
        
    }
}


@end
