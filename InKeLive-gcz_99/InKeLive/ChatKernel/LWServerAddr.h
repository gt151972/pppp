//
//  LWServerAddr.h
//  InKeLive
//
//  Created by gu  on 17/8/16.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWServerAddr : NSObject

@property(nonatomic, strong)NSString* addr;
@property(nonatomic, assign)int port;
@property(nonatomic, assign)int addrType;

@end
