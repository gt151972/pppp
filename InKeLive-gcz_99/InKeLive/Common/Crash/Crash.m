//
//  Crash.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/20.
//  Copyright © 2018 jh. All rights reserved.
//

#import "Crash.h"
@implementation Crash
void uncaughtExceptionHandler(NSException *exception){
    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name:%@\nException reatoin:%@\nException stack :%@",name,reason,stackArry];
    NSLog(@"%@",exceptionInfo);
    NSArray *documentsPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documentsPathArr lastObject];
    // 拼接要写入文件的路径
    NSString *path = [documentsPath stringByAppendingPathComponent:@"Exception.txt"];
    [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[stackArry componentsJoinedByString:@"\n"]];
//    //保存到本地沙盒中
//    NSString * path = [applicationDocumentsDirectory()stringByAppendingPathComponent:@"Exception.txt"];
//    // 将一个txt文件写入沙盒
//    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [exceptionInfo writeToFile:[NSString stringWithFormat:@"Exception.txt",NSHomeDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
