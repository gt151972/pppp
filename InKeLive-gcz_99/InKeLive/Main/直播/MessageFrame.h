//
//  MessageFrame.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/14.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Message;
@interface MessageFrame : NSObject
//聊天信息label
@property (nonatomic, assign, readonly) CGRect chatLabelF;

//聊天信息的背景图
@property (nonatomic, assign, readonly) CGRect bubbleViewF;

// topView   /***第一版***/
@property (nonatomic, assign, readonly) CGRect topViewF;

//计算总的高度
@property (nonatomic, assign) CGFloat cellHight;

//模型
@property (nonatomic, strong) Message *model;

@end
