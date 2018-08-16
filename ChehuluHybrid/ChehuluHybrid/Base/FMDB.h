//
//  FMDB.h
//  ChehuluHybrid
//
//  Created by GT mac on 2016/11/16.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface FMDB : NSObject

//创建数据库
- (void)saveData: (NSDictionary *)dic: (NSString *)pathName;
@end
