//
//  ChatPublicView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatPublicView : UIView

@property (nonatomic, strong) NSMutableArray *arrayUser;

@property (nonatomic, copy)NSString *strNanme;
@property (nonatomic, assign)int userId;

@property (nonatomic,copy)void (^publicChatSend)(NSString *messageInfo, int toId);
@property (nonatomic,copy)void (^chooseUserClick)(NSArray *array);


- (void)sendMessage:(NSString *)strInfo sendID:(int)sendId receiverID:(int)receiverId;


//弹出窗口
- (void)popShow;

-(void)hide ;
@end
