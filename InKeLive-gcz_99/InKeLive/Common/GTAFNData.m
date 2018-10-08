//
//  GTAFNData.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "GTAFNData.h"
@implementation GTAFNData

+ (GTAFNData *)shareInstance {
    static GTAFNData *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}
-(void)postData: (NSString *)cmd data: (NSDictionary *)data{
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:data];
    [parameters setValue:cmd forKey:@"cmd"];
    NSString* strAPIUrl = URL_GiftInfo;
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSMutableDictionary *appDic =(NSMutableDictionary*)responseObject;
        if ([appDic[@"code"] intValue] == 0) {
            [self requestCallBack:appDic];
            NSLog(@"%@",appDic[@"msg"]);
        }else{
            NSLog(@"%@",appDic[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);

    }];
}

/**
 *  数据回调
 *
 *  @param webData 字节数据
 */
-(void)requestCallBack:(NSMutableDictionary *)dict
{
    if (_delegate) {
        [self DalDataCallBack:dict :currResult];
    }
}
/**
 *  解析返回的数据
 *
 *  @param data   字节流
 *  @param result 当前执行的命令
 */
-(void)DalDataCallBack:(NSMutableDictionary *)dict :(NSString *)result{
    NSError *error = nil;
    if (_delegate) {
        if (error)
        {
            if (_delegate) {
                [_delegate responseDataWithCmd:result data:dict];
            }
        }
        else{
            if (_delegate) {
                //                NSLog(@"dict == %@",dict);
                [_delegate responseDataWithCmd:result data:dict];
            }
        }
    }
}
#pragma mark 登录
/**
 登录
 
 @param uid 手机账号 微信 QQ
 @param sid 密码 openid unionid
 @param type 1:账号密码 2:QQ 3:手机密码 4:微信
 @param mac 唯一标识符
 */
-(void)LoginWithUid:(NSString *)uid sid:(NSString *)sid type:(NSString *)type mac:(NSString *)mac{
    currResult = CMD_LOGIN;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", sid, @"sid", type, @"type",IOS_REQUEST_FLAG, @"flag", mac, @"mac", nil];
    NSLog(@"dic == %@",dict);
    [self postData:currResult data:dict];
}
#pragma mark 密保
/**
 手机密保读取
 
 */
-(void)requestSecurityRead{
    currResult = CMD_SECURITY_READ;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", nil];
//    NSLog(@"dic == %@",dict);
    [self postData:currResult data:dict];
}

/**
 手机密保验证码
 
 @param phone 手机号
 */
-(void)requestSecurityCodeWithPhone: (NSString *)phone{
    currResult = CMD_SECURITY_CODE;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", phone, @"phone", nil];
    [self postData:currResult data:dict];
}

/**
 手机密保保存
 
 @param phone 手机号
 @param code 验证码
 */
-(void)requestSecuritySaveWithPhone: (NSString *)phone
                               code: (NSString *)code{
    currResult = CMD_SECURITY_SAVE;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", phone, @"phone", code, @"code", nil];
    [self postData:currResult data:dict];
}

/**
 注册or忘记密码 发送验证码
 
 @param phone <#phone description#>
 @param reg <#reg description#>
 */
-(void)phoneMsgWithPhone:(NSString *)phone
                     reg:(NSString *)reg{
    currResult = CMD_REGISTER_SEND_CODE;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: phone, @"phone", reg, @"reg", nil];
    [self postData:currResult data:dict];
}

/**
 注册
 
 @param phone 手机号
 @param code 验证码
 @param pwd 密码
 */
-(void)phoneRegWithPhone: (NSString *)phone
                    code: (NSString *)code
                     pwd: (NSString *)pwd{
    currResult = CMD_REGISTER_REQUEST;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: phone, @"phone", code, @"code", pwd, @"pwd", nil];
    [self postData:currResult data:dict];
}
/**
 找回密码
 
 @param phone 手机号
 @param code 验证码
 @param pwd 新密码
 */
-(void)phoneRetrieveWithPhone: (NSString *)phone
                         code: (NSString *)code
                          pwd: (NSString *)pwd{
    currResult = CMD_PASSWORD_FIND;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: phone, @"phone", code, @"code", pwd, @"pwd", nil];
    [self postData:currResult data:dict];
}

/**
 修改密码
 
 @param oldPwd 老密码
 @param newPwd 新密码
 */
-(void)changePwdWithOldPwd: (NSString *)oldPwd
                    newPwd: (NSString *)newPwd{
    currResult = CMD_PASSWORD_CHANGE;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", oldPwd, @"op", newPwd, @"np", nil];
    [self postData:currResult data:dict];
}

/**
 关注列表
 */
-(void)AttentionList{
    currResult = CMD_ATTENTION_ROOM_LIST;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", nil];
    [self postData:currResult data:dict];
}

/**
 删除关注
 
 @param pid 关注对象的uid
 */
-(void)DeteleAttentionWithPid: (NSString *)pid{
    currResult = CMD_ATTENTION_DELETE;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", pid, @"pid", nil];
    [self postData:currResult data:dict];
}

#pragma mark 获取房间信息
/**
 根据房间ID搜索房间地址房间名
 
 @param rid 房间id
 */
-(void)getRoomInfoWithRid:(NSString *)rid{
    currResult = CMD_REQUEST_ADDTESS;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:rid, @"rid", nil];
    [self postData:currResult data:dict];
}
#pragma mark 请求网页地址
/**
 请求网页地址
 */
-(void)getWebUrl{
    currResult = CMD_REQUEST_WEB_ADDRESS;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:IOS_REQUEST_FLAG, @"flag", nil];
    [self postData:currResult data:dict];
}

#pragma mark banner图
/**
 请求banner图
 */
-(void)getBanner{
    currResult = CMD_REQUEST_BANNER;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:IOS_REQUEST_FLAG, @"flag", nil];
    [self postData:currResult data:dict];
}

#pragma mark 首页数据
/**
 推荐房间列表
 */
-(void)RecommendRoom{
    currResult = CMD_RECOMMEND_ROOM_LIST;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:IOS_REQUEST_FLAG, @"flag", nil];
    [self postData:currResult data:dict];
}
@end
