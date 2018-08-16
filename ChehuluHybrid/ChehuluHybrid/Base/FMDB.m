//
//  FMDB.m
//  ChehuluHybrid
//
//  Created by GT mac on 2016/11/16.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "FMDB.h"

@implementation FMDB

//创建数据库
- (void)saveData: (NSDictionary *)dic: (NSString *)pathName{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",pathName]];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if (![db open]) {
        db = nil;
        return;
    }
//    FMResultSet *set = [db executeQuery:@"CREAT table mytable ()"]
}
@end
