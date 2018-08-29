//
//  ChatPrivateView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/29.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatPrivateView : UIView
@property (nonatomic, strong) NSMutableArray *arrUserInfo;//记录所有私聊对象信息
@property (nonatomic, strong) NSMutableDictionary *dicMessage;//所有数据
@property (nonatomic, assign) int theUserId;//当前聊天页的id
@property (nonatomic, strong) NSMutableArray *arrChatMessage;
@property (nonatomic, strong) UILabel *labNameAndId;

@property (nonatomic,copy)void (^privateChatSend)(NSString *messageInfo, int toId);
- (void)sendMessage:(NSString *)strInfo sendID:(int)sendId receiverID: (int)receiverId;

//弹出窗口
- (void)popShow;

-(void)hide ;
@end
