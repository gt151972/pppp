//
//  GTRequestManager.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/22.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "GTRequestManager.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "LogonViewController.h"

@implementation GTRequestManager
+(GTRequestManager *)shareSingletonClasss{
    static GTRequestManager * singletonClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            singletonClass = [[GTRequestManager alloc]init];
    });
    return singletonClass;
}

#pragma mark -  get 请求数据 Method

-(void)GetParsingDataSourceWithUrl:(NSString *)url WithVC:(UIViewController * )VC success:(void(^)(id responseObject))success fail:(void(^)())fail{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSMutableDictionary * dic = [self getWillPOSTData];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {//请求成功
        //删除转义字符
        NSData *jsonData = [self deleteEscapeStringWithResponseObject:responseObject];
        //令牌异常的情况下跳转到登录界面
        [self JudgeTokenToLoginViewWithJsonData:jsonData WithVC:VC];
        //---------正常输入数据
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        success(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {//请求失败
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        fail(error);
    }];
    
}

#pragma mark  - post 请求/上传数据  Method

- (void)PostParsingDataSourceWithUrl:(NSString *)url parameters:(NSDictionary *)parameters  WithVC:(UIViewController * )VC success:(void(^)(id responseObject))success fail:(void(^)())fail{
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSMutableDictionary * dic = [self getWillPOSTData];
    [dic addEntriesFromDictionary:parameters];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"--responseObjectStr----%@",str);
        //删除转义字符
        NSData *jsonData = [self deleteEscapeStringWithResponseObject:responseObject];
        //令牌异常的情况下跳转到登录界面
        [self JudgeTokenToLoginViewWithJsonData:jsonData WithVC:VC];
        //---------正常输入数据
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        fail(error);
    }];
}

#pragma mark - 上传 Method

- (void)uploadWithUser:(NSString *)userId UrlString:(NSString *)urlString upImg:(UIImage *)upImg

{
    // 创建管理者对象
    AFHTTPSessionManager * manager  =[AFHTTPSessionManager manager];
    // 参数
    NSDictionary * param = @{@"user_id":userId};
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        NSData * data = UIImagePNGRepresentation(upImg);
        // 拼接数据到请求题中
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 打印上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark - 下载 Method

- (void)downLoadWithUrlString:(NSString * )urlString{
    // 1.创建管理者对象
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    // 2.设置请求的URL地址
    NSURL * url = [NSURL URLWithString:urlString];
    // 3.创建请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    // 4.下载任务
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址%@",targetPath);
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成调用的方法
        NSLog(@"%@---%@", response, filePath);
    }];
    //启动下载任务
    [task resume];
}

#pragma mark - 删除转义字符
- (NSData * )deleteEscapeStringWithResponseObject:(NSData * )responseObject{
    NSString * str_Json = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"\t" withString:@"   "];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"   "];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    str_Json = [str_Json stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    NSData * data = [str_Json dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

#pragma mark - 令牌异常的情况下跳转到登录界面

- (void)JudgeTokenToLoginViewWithJsonData:(NSData * )jsonData WithVC:(UIViewController * )VC{
    
    //令牌异常
    
    NSString * str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"令牌错误!"] || [str isEqualToString:@"令牌过期!"]) {
        LogonViewController *login = [[LogonViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [VC presentViewController:nav animated:YES completion:nil];
        return;
    }
}

#pragma mark - POST请求需要传入的参数
- (NSMutableDictionary * )getWillPOSTData{
//    NSString * ipStr = [GetIPAddress getIPAddress:NO];
    NSDictionary * infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//当前版本号
    //     NSDictionary * parameters = @{@"qcmn_os":@"系统ios/android",@"qcmn_version":@"app版本号",@"qcmn_client_ip":@"客户端IP地址",@"qcmn_ts":@"测试数据/线上数据"};
//    NSDictionary * parameters = @{@"qcmn_os":@"ios",@"qcmn_version":currentVersion,@"qcmn_client_ip":ipStr,@"qcmn_ts":TESTORONLINE};
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic addEntriesFromDictionary:parameters];
    return dic;
}

#pragma mark  GET  请求数据

- (void)GetParsingDataSoucrceWithUrl:(NSString * )url success:(void(^)(id responseObject))success fail:(void(^)())fail
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {//请求成功
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {//请求失败
//        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        fail(error);
    }];
}


@end
