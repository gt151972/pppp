//
//  MyUncaughtExceptionHandler.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/20.
//  Copyright © 2018 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyUncaughtExceptionHandler : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;
@end

NS_ASSUME_NONNULL_END
