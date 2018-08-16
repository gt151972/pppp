//
//  ClientConfigParam.h
//  InKeLive
//
//  Created by gu  on 17/8/15.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientConfigParam : NSObject


//用户头像前缀，从服务器下发
@property(nonatomic, strong)NSString*  userHeadPicPrefix;
//房间头像前缀，从服务器下发
@property(nonatomic, strong)NSString*  roomPicPrefix;
//http API 前缀
@property(nonatomic, strong)NSString*  commonApiPrefix;
//礼物列表
@property(nonatomic, strong)NSString * giftList;

@end
