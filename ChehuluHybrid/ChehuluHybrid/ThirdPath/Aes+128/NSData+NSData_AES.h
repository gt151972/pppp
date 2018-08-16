//
//  NSData+NSData_AES.h
//  WisInsur
//
//  Created by GooCan on 15/8/30.
//  Copyright (c) 2015年 cardriver.WisInsur. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSString;
@interface NSData (NSData_AES)


- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

@end