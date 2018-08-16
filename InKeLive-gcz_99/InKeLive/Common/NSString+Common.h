//
//  NSString+Common.h
//  DPKGame
//
//  Created by gu  on 16/9/23.
//  Copyright © 2016年 王征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

+(NSString *)md5:(NSString *)str;

+ (NSString *)countNumAndChangeformat:(NSString *)num;

//html 去除标签
+(NSString *)filterHTML:(NSString *)html;

@end
