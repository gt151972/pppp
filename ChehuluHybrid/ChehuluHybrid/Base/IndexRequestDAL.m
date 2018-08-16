//
//  IndexRequestDAL.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token"

#import "IndexRequestDAL.h"
#import <sys/utsname.h>
#import "CommendFile.h"
#import "AESCrypt.h"
#import "CJSONDeserializer.h"

@implementation IndexRequestDAL

@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *str = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *newStr = [str stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    return newStr;
}

#pragma mark - get请求
- (void)getRequestAction:(NSDictionary *)dict URL:(NSString *)strUrl {
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];//允许无效证书
    [securityPolicy setPinnedCertificates:cerSet];
    
    [self.manager GET:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dictResult = responseObject;
        NSLog(@"dictResult == %@",dictResult);
        [self requestCallBack:dictResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        [self requestCallBack:nil];
    }];
}
#pragma mark - post请求
- (void)postRequestAction:(NSDictionary *)dict URL:(NSString *)strUrl {
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    [securityPolicy setAllowInvalidCertificates:YES];//允许无效证书
//    [securityPolicy setPinnedCertificates:cerSet];
//
    [self.manager POST:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dictResult = responseObject;
        NSLog(@"responseObject == %@",responseObject);
        [self requestCallBack:dictResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        [self requestCallBack:nil];
    }];
}

- (void)addHttpsCer{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];//允许无效证书
    [securityPolicy setPinnedCertificates:cerSet];
    _manager = [AFHTTPSessionManager manager];
    _manager.securityPolicy = securityPolicy;
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self postRequestAction:nil URL:ServerUrl];
    [_manager POST:ServerUrl parameters:nil progress:^(NSProgress *uploadProgress) {
//        NSLog(@"uploadProgress == %@",uploadProgress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"OK ");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error ==%@",error.description);
    }];
//    [_manager GET:ServerUrl parameters:nil progress:^(NSProgress * downloadProgress) {
//        NSLog(@"downloadProgress == %@",downloadProgress);
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"OK === %@",array);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error ==%@",error.description);
//    }];
}
-(void)requestCancel:(NSString *)sender{
    
    [UIApplication  sharedApplication].networkActivityIndicatorVisible=NO;
}

#pragma mark - UrlRequestDelegate

/**
 *  数据回调
 *
 *  @param webData 字节数据
 */
-(void)requestCallBack:(NSMutableDictionary *)dict
{
    if (delegate) {
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
    dict = [self nullToEmpty:dict];
    if (delegate) {
        if (error)
        {
            if (delegate) {
                [delegate InfoCallBackDic:nil :currResult];
            }
        }
        else{
            if (delegate) {
                NSLog(@"dict == %@",dict);
                [delegate InfoCallBackDic:dict :result];
            }
        }
    }
}

//非空判断
- (NSMutableDictionary *)nullToEmpty:(NSMutableDictionary *)dic{
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSDictionary *dict3 = [[NSDictionary alloc] init];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic2 setObject:dict3 forKey:key];
        }else{
            [dic2 setObject:[dic objectForKey:key] forKey:key];
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic2];
    return dict;
}


/**************************  各个功能请求方法  start*********************************************/
#pragma mark -- 登录
/**
 * 用户获取验证码
 *
 *  @param mobile 手机号码
 */
-(void)getVerifyCode:(NSString *)mobile{
    currResult=@"getVerifyCode";
    NSString *method=@"User/getVerifyCode";
    [self addHttpsCer];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:
                          mobile,@"mobile",
                          [AESCrypt encryptText:[NSString stringWithFormat:@"%@,",method]],@"token",
                          nil];
//    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 *  登录
 *
 *  @param mobile    手机号
 *  @param verfycode 验证码
 */
- (void)loginWithMobile:(NSString *)mobile verfycode:(NSString *)verfycode{
    currResult = @"login";
    NSString *method = @"User/login";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:mobile, @"mobile",verfycode, @"verfycode",
                            from_source , @"from_source",
                            login_source, @"login_source",
                            [AESCrypt encryptText:[NSString stringWithFormat:@"%@,",method]],@"token", nil];
    NSLog(@"params == %@", params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 *  登录
 */
- (void)loginToken{
    currResult = @"loginToken";
    NSString *method = @"User/loginToken";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [AESCrypt encryptText:[NSString stringWithFormat:@"%@,%@",method,[[[NSUserDefaults standardUserDefaults] objectForKey:@"DicUserInfo"] objectForKey:@"usertoken"]]],@"token"
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"], @"usertoken" ,
                            from_source, @"from_source" ,
                            login_source, @"login_source",
//                            [AESCrypt encryptText:[NSString stringWithFormat:@"%@,",method]],@"token",
                            nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

#pragma mark -- 个人中心
/**
 *  个人信息获取
 */
- (void)getInfo{
//    5tvPbX4+tNmhz/54/W4qSnN6tOR7ej/ZpleJVXTquqxWdbANlN/XmXLb96X8RPH7
    currResult = @"info";
    NSString *method = @"User/info";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 *  车币查询
 */
- (void)MoneyInfo{
    currResult = @"MoneyInfo";
    NSString *method = @"Profit/getInfo";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 上传图片
 *
 *  @param picture 待上传图片(base64)
 */
- (void)uploadimgWithPicture:(NSString *)picture{
    currResult = @"Uploadimg";
    NSString *method = @"Car/upload_img";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", picture, @"file", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 更新用户信息
 *
 *  @param headImg 待上传头像ID
 */
- (void)updateWithHeadImgID:(NSString *)headImg sex:(NSString *)sex realname:(NSString *)realname{
    currResult = @"Update";
    NSString *method = @"User/update";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", headImg, @"headImg", sex, @"sex",realname, @"realname", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 获取省份列表
 *
 *  @param searchType 查询类型 1-购险省份 2-全部省份
 *  @param gpsProvince 定位所在省份
 */
- (void)getProvinceWithSearchType:(NSString *)searchType gpsProvince:(NSString *)gpsProvince{
    currResult = @"GetProvince";
    NSString *method = @"Insurance/province";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token",searchType, @"search_type",gpsProvince, @"gps_province", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 获取城市列表
 *
 *  @param searchType 查询类型
 *  @param gpsProvince 定位所在城市
 */
- (void)getAreaWithSeachType:(NSString *)searchType gpsArea:(NSString *)gpsArea{
    currResult = @"GetArea";
    NSString *method = @"Insurance/area";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", searchType, @"search_type",gpsArea, @"gps_area", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 用户车辆列表
 *
 *  @param p 页码
 */
- (void)getCarIndexWithPage: (NSString *)p{
    currResult = @"CarIndex";
    NSString *method = @"Car/index";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", p, @"p", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 车辆首页数据
 *
 *  @param carNo 车牌号
 *  @param date 日期
 *  @param isFake 是否是假数据(1-是 0-否)
 */
- (void)getCarDayLogWithCarNo: (NSString *)carNo date: (NSString *)date isFake: (NSString *)isFake{
    currResult = @"CarDayLog";
    NSString *method = @"Car/dayLog";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", date, @"date", isFake, @"is_fake", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * C端车辆故障数量
 *
 *  @param obdID OBD编号
 *  @param carNum 车牌号
 */
- (void)getFaultNumWithObdId: (NSString *)obdID carNum: (NSString *)carNum{
    currResult = @"CarFaultNum";
    NSString *method = @"Car/fault_num";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", obdID, @"obdid", carNum, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 当前故障检测
 *
 *  @param carID 车辆id
 */
- (void)getCarStatusWithCarId: (NSString *)carID{
    currResult = @"CarFaultNum";
    NSString *method = @"Car/fault_num";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carID, @"car_id",  nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 车辆历史故障
 *
 *  @param CarNo 车辆号
 *  @param page 第几页
 *  @param limit 一页几个
 *  @param start 第几个开始
 */
- (void)getHistoryFalteWithCarNo: (NSString *)CarNo page: (NSString *)page limit: (NSString *)limit start: (NSString *)start{
    currResult = @"CarHistoryFault";
    NSString *method = @"Car/faults";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", CarNo, @"car_no", page, @"page", limit, @"limit", start, @"start",  nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 车辆耗油详情
 *
 *  @param obdID OBD编号
 *  @param date 日期（默认今天)
 *  @param carNO 车牌号
 */
- (void)getObdOilWithObdID: (NSString *)obdID date: (NSString *)date carNO: (NSString *)carNO{
    currResult = @"CarObdOil";
    NSString *method = @"Car/obd_oil";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", obdID, @"obdid", date, @"date", carNO, @"car_no",  nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 车辆周数据
 *
 *  @param carID 车牌ID
 *  @param date 日期（默认今天)
 *  @param isFake 是否假数据
 
 */
- (void)getWeekLogWithCarID: (NSString *)carID date: (NSString *)date isFake: (NSString *)isFake{
    currResult = @"CarWeekLog";
    NSString *method = @"Car/weekLog";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carID, @"car_id", date, @"date", isFake, @"is_fake",  nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 车辆月数据
 *
 *  @param carID 车牌ID
 *  @param month 日期（默认今天)
 */
- (void)getMonthLogWithCarNo: (NSString *)carNo month: (NSString *)month isFake: (NSString *)isFake{
    currResult = @"CarMonthLog";
    NSString *method = @"Car/monthLog";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", month, @"month", isFake, @"is_fake", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 C端车辆列表

 @param page 第几页（默认第1页）
 @param limit 一页显示几个 （默认10个
 @param listType 列表类型（1-违章代办 2-年检代办 3-人工购险模块 4-车况列表，默认为空显示全部）
 @param provinceId 省份ID(可为空)
 @param areaId 城市ID(可为空)
 @param isFake 是否是假数据(1-是 0-否，可为空，默认为否)
 */
- (void)getCarListsWithPage: (NSString *)page limit: (NSString *)limit listType: (NSString *)listType provinceId: (NSString *)provinceId areaId: (NSString *)areaId isFake: (NSString *)isFake{
    currResult = @"CarLists";
    NSString *method = @"Car/lists";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", page, @"page", limit, @"limit", listType ,@"list_type", provinceId , @"province_id", areaId, @"area_id", isFake, @"is_fake", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
//    Li3pL45j4k8eW0CsCw+Hy7uwe6xFKu+rl9Sbf7jwYAk=
}


/**
 * C端根据车辆ID查询车辆详情
 *
 *  @param carID 车辆ID
 *  @param isVio 是否查询违章车辆(1:是 可为空)
 *  @param isMot 是否查询年检代办车辆(同上)
 */
- (void)getCarDetailWithCarID: (NSString *)carID isVio: (NSString *)isVio isMot: (NSString *)isMot casualty:(NSString *)casualty{
    currResult = @"CarDetail";
    NSString *method = @"Car/detail";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carID, @"car_id", isVio, @"is_vio", isMot, @"is_mot", casualty, @"casualty",  nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 C端更新车辆信息
 
 @param carID 车辆ID（若修改则不能为空）
 @param carNo 车牌号（不能为空,若更换默认车辆可为空）
 @param drvOwner 车主姓名（不能为空,若更换默认车辆可为空）
 @param vhlFrm 车架号（不能为空,若更换默认车辆可为空）
 @param engNo 发动机号（不能为空,若更换默认车辆可为空）
 @param fstRegDte 初登日期(格式：年-月-日，不能为空，若更换默认车辆可为空)
 @param operating 是否是营运车辆（string 1-是 0-否，若更换默认车辆可为空）
 @param brandId 车辆品牌ID（可为空，若更换默认车辆可为空）
 @param carSeries 车系名称(可为空，若更换默认车辆可为空)
 @param img 行驶证正面图片ID（可为空，若更换默认车辆可为空）
 @param updateType 更新方式（1-车辆信息更新 2-更换默认车辆 3-添加默认车辆 4-更新加油型号,可为空，默认为1）
 */
- (void)postCarUpdateWithCarID: (NSString *)carID carNo: (NSString *)carNo drvOwner: (NSString *)drvOwner vhlFrm: (NSString *)vhlFrm engNo: (NSString *)engNo fstRegDte: (NSString *)fstRegDte operating: (NSString *)operating brandId: (NSString *)brandId carSeries: (NSString *)carSeries img: (NSString *)img updateType: (NSString *)updateType{
    currResult = @"CarUpdate";
    NSString *method = @"Car/update";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carID, @"car_id", carNo, @"car_no", drvOwner, @"drv_owner", vhlFrm, @"vhl_frm", engNo, @"eng_no", fstRegDte, @"fst_reg_dte", operating, @"operating", brandId, @"brand_id", carSeries, @"car_series", img, @"img", updateType, @"update_type",  nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 * C端模块移动车辆
 *
 *  @param carIDs 车辆IDs(多个车辆逗号分隔)
 *  @param carType 车辆类型（不能为空 1-年检代办 2-违章代办）
 *  @param status 状态（1-有效 0-无效 -1-删除)
 */
- (void)postCarMoveWithCarIDs: (NSString *)carIDs carType: (NSString *)carType status: (NSString *)status{
    currResult = @"CarMove";
    NSString *method = @"Car/move";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carIDs, @"car_ids", carType, @"car_type", status, @"status", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * C端获取保单期间内的OBD信息
 *
 *  @param policyid 购险订单ID（若未购险，则传0）
 *  @param carNo 车牌号
 */
- (void)postCarPolicyObdInfoWithPolicyid: (NSString *)policyid carNo: (NSString *)carNo{
    currResult = @"CarPolicyObdinfo";
    NSString *method = @"Car/policy_obdinfo";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", policyid, @"policyid", carNo, @"car_no", nil];
//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: @"9iVt75V5HO+NLtti8Uor8yrYUOkGoPdtTXKijMN262w=",@"token", policyid, @"policyid", carNo, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 * C端保险订单详情
 *
 *  @param policyid 购险订单ID
 */
- (void)postOrderDetailWithPolicyid: (NSString *)policyid{
    currResult = @"OrderDetail";
    NSString *method = @"Order/detail";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", policyid, @"policyid", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 *  C端获取车辆品牌列表
 */
- (void)getCarBrand{
    currResult = @"CarBrand";
    NSString *method = @"Car/brand";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * C端获取车辆车系列表
 *
 *  @param brandID 品牌ID
 */
- (void)getCarSeriesWithBrandID: (NSString *)brandID{
    currResult = @"CarSeries";
    NSString *method = @"Car/series";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", brandID, @"brand_id", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 首页业务模块列表
 *
 *  @param areaID 城市id(可为空)（string）
 *  @param provinceId 省份ID(可为空)（string）
 *  @param showType 展示类型 (1-首页业务模块 2-首页购险模块)
 *  @param source 来源（1-车险模块 2-维修保养 3-商城 4-违章代办 5-年检代办）
 */
- (void)getIndexBusWithAreaID: (NSString *)areaID provinceId:(NSString *)provinceId showType:(NSString *)showType source:(NSString *)source{
    currResult = @"IndexBus";
    NSString *method = @"Index/bus";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", areaID, @"area_id", provinceId, @"province_id", showType, @"show_type", source, @"source", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 轮播图列表
 
 @param source 轮播图来源(1-环境宝 2-首页 3-商城首页 4-商城广告位轮播 5-APP开机图片)
 @param provinceId 定位省份ID(可为空)
 @param areaId 定位城市id(可为空)
 */
- (void)getSlidesImagesLists: (NSString *)source provinceId: (NSString *)provinceId areaId: (NSString *)areaId{
    currResult = @"SlidesImagesLists";
    NSString *method = @"SlidesImages/lists";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            source, @"source",
                            provinceId, @"province_id",
                            areaId, @"area_id",
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token",
                            nil];
    NSLog(@"param == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 商城首页最新商品
 *
 *  @param provinceID 定位省份ID(可为空)
 *  @param areaID 定位城市id(可为空)
 */
- (void)getCarSeriesWithProvinceID: (NSString *)provinceID areaID: (NSString *)areaID{
    currResult = @"CarSeries";
    NSString *method = @"Car/series";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", provinceID, @"province_id",areaID, @"area_id", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 * 获取默认车辆
 *
 */
- (void)getCarCheckDefault{
    currResult = @"CarCheckDefault";
    NSString *method = @"Car/check_default";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", nil];
//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 推荐商品列表
 
 @param provinceID 定位省份ID(可为空)
 @param areaID 定位城市id(可为空)
 */
- (void)getMallProductsProvinceID:(NSString *)provinceID areaID:(NSString *)areaID{
    currResult = @"MallNewProducts";
    NSString *method = @"Mall/new_products";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", provinceID, @"province_id",areaID, @"area_id", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 根据GPS获取定位
 
 @param lng 经度
 @param lat 纬度
 @param gpsType 经纬度标准(string，1-WGS-84(GPS) 2-GCJ-02(高德) 3-BD-09(百度))
 */
- (void)getUserLocationWithLng:(NSString *)lng lat:(NSString *)lat gpsType:(NSString *)gpsType{
    currResult = @"UserLocation";
    NSString *method = @"User/location";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", lng, @"lng",lat, @"lat",gpsType, @"gps_type", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 推荐店铺列表
 
 @param provinceId 定位省份ID(可为空)
 @param areaId 定位城市id(可为空)
 @param type 门店类型（1-维修保养 2-救援门店 3-年检代办站点）
 */
- (void)getStoreFineStoresWithProvinceId: (NSString *)provinceId areaId: (NSString *)areaId type:(NSString *)type{
    currResult = @"StoreFineStores";
    NSString *method = @"Store/fine_stores";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", provinceId, @"province_id",areaId, @"area_id",type, @"type", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 首页合作伙伴列表
 
 @param provinceID 定位省份ID(可为空)
 @param areaID 定位城市id(可为空)
 */
- (void)getIndexPartnersWithProvinceID:(NSString *)provinceID areaID:(NSString *)areaID{
    currResult = @"IndexPartners";
    NSString *method = @"Index/partners";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", provinceID, @"province_id",areaID, @"area_id", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆总数据统计
 
 @param carNo 车牌号
 */
- (void)getCarAllStatWithCarNo: (NSString *)carNo{
    currResult = @"CarAllStat";
    NSString *method = @"Car/all_stat";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆行驶日数据统计
 
 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几日(默认7日)
 */
- (void)getCarDayStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit{
    currResult = @"CarDayStat";
    NSString *method = @"Car/day_stat";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no",page, @"page",limit, @"limit", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 车辆行驶周数据
 
 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几日(默认4周)
 */
- (void)getCarWeekStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit{
    currResult = @"CarWeekStat";
    NSString *method = @"Car/week_stat";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no",page, @"page",limit, @"limit", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆行驶月数据
 
 @param date 日期(默认今天)
 @param carNo 车牌号
 @param page 第几页(默认第一页)
 @param limit 向上每页几月(默认4月)
 */
- (void)getCarMonthStatWithDate: (NSString *)date carNo: (NSString *)carNo page: (NSString *)page limit: (NSString *)limit{
    currResult = @"CarMonthStat";
    NSString *method = @"Car/month_stat";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no",page, @"page",limit, @"limit", date, @"date", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 C端用户反馈
 
 @param type 1:车况反馈 2:个人中心
 @param msg 反馈信息(不可为空)
 */
- (void)postUserAdviseAddsWithType: (NSString *)type msg: (NSString *)msg{
    currResult = @"UserAdviseAdds";
    NSString *method = @"User/advise_adds";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", type, @"type",msg, @"msg", nil];
    NSLog(@"params == %@",params);
    [self postRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车况检测
 
 @param carNo 车牌号
 */
- (void)getCarStatusWithCarNo: (NSString *)carNo{
    currResult = @"CarStatus";
    NSString *method = @"Car/status";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 车辆行驶轨迹
 
 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 */
- (void)getCarObdTravelWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo{
    currResult = @"CarObdTravel";
    NSString *method = @"Car/obd_travel";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", obdId, @"obdid",date, @"date",carNo, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}


/**
 车辆行驶时间轨迹
 
 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 */
- (void)getCarObdTravelTimeWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo{
    currResult = @"CarObdTravelTime";
    NSString *method = @"Car/obd_travel_time";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", obdId, @"obdid",date, @"date",carNo, @"car_no", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 C端获取里程宝月信息
 
 @param carNo 车牌号
 @param startDate 开始日期
 */
- (void)getCarMileMonthingWithCarNo: (NSString *)carNo startDate:(NSString *)startDate{
    currResult = @"CarMileMonthing";
    NSString *method = @"Car/mile_monthing";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no",startDate, @"start_date", nil];
//    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆月碳排统计
 
 @param carId 车辆ID（string）
 @param month 日期（默认今天,格式：年-月-日）
 */
- (void)getMonthCarbonWithCarId: (NSString *)carId month: (NSString *)month{
    currResult = @"Car/monthCarbon";
    NSString *method = @"CarMonthCarbon";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carId, @"car_id",month, @"month", nil];
//    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆碳排节省
 
 @param carNo 车牌号
 */
- (void)getSaveCarbonWithCarNo: (NSString *)carNo{
    currResult = @"Car/saveCarbon";
    NSString *method = @"CarSaveCarbon";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", nil];
    //    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 车辆耗油分布统计
 
 @param obdId OBD编号（string）
 @param date 日期（默认今天）（string）
 @param carNo 车牌号（string
 @param listsType 列表类型（1-天 2-月，默认为1）
 */
- (void)getOilListsWithObdId: (NSString *)obdId date: (NSString *)date carNo: (NSString *)carNo listsType: (NSString *)listsType{
    currResult = @"CarOilLists";
    NSString *method = @"Car/oil_lists";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", obdId, @"obdid", date, @"date", listsType, @"lists_type", nil];
    NSLog(@"params == %@",params);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}

/**
 C端首页收益信息
 
 @param carNO 车牌号（string）
 */
- (void)getProfitCarInfoWithCarNo: (NSString *)carNo{
    currResult = @"ProfitCarInfo";
    NSString *method = @"Profit/car_info";
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"],@"token", carNo, @"car_no", nil];
//    NSLog(@"params == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"]);
    [self getRequestAction:params URL:[ServerUrl stringByAppendingString:method]];
}
@end
