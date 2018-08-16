//
//  NSString +AES256.h
//  WisInsur
//
//  Created by GooCan on 15/8/26.
//  Copyright (c) 2015年 cardriver.WisInsur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+AES256.h"

@interface NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end
