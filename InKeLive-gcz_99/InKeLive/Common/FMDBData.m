//
//  FMDBData.m
//  InKeLive
//
//  Created by 高天的Mac on 2018/8/18.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "FMDBData.h"
#import <FMDB.h>
#import "GTGiftListModel.h"

static FMDBData *_DBCtl = nil;

@interface FMDBData()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end
@implementation FMDBData
+(instancetype)sharedDataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[FMDBData alloc] init];
        [_DBCtl initDataBase];
    }
    return _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    return _DBCtl;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *giftListSql = @"CREATE TABLE 'GiftList' (ctype int,flag int,giftId int,name VARCHAR(255),note VARCHAR(255),pic_original VARCHAR(255),pic_s VARCHAR(255),pic_thumb VARCHAR(255),price int,sname VARCHAR(255),sort int) ";
    [_db executeUpdate:giftListSql];
    [_db close];
}

#pragma mark  接口
- (void)addGiftList:(GTGiftListModel *)objects{
    [_db open];
    NSNumber *maxID = @(0);
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM GiftList "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"person_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"person_id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
//    [_db executeUpdate:@"INSERT INTO person(person_id,person_name,person_age,person_number)VALUES(?,?,?,?)",maxID,person.name,@(person.age),@(person.number)];
    [_db close];
}
@end
