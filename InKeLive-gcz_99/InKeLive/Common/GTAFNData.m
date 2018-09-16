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
#pragma mark 密保
/**
 手机密保读取
 
 */
-(void)requestSecurityRead{
    currResult = CMD_SECURITY_READ;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",model.userID], @"uid", nil];
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
 注册发送验证码
 
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
    currResult = CMD_PASSWORD_FIND;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: phone, @"phone", code, @"code", pwd, @"pwd", nil];
    [self postData:currResult data:dict];
}

/**
 修改密码
 
 @param phone <#phone description#>
 @param code <#code description#>
 @param pwd <#pwd description#>
 */
-(void)phoneRetrieveWithPhone: (NSString *)phone
                         code: (NSString *)code
                          pwd: (NSString *)pwd{
    currResult = CMD_PASSWORD_CHANGE;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: phone, @"phone", code, @"code", pwd, @"pwd", nil];
    [self postData:currResult data:dict];
}
@end
