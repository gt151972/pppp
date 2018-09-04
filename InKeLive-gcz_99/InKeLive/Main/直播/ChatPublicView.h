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

@property (nonatomic, strong) UIButton *btnUserChoose;

@property (nonatomic,copy)void (^publicChatSend)(NSString *messageInfo, int toId ,NSString *toUserAlias);
@property (nonatomic,copy)void (^chooseUserClick)(NSArray *array);


- (void)sendMessage:(NSString *)strInfo receiverID:(int)receiverId ToUserAlias: (NSString *)ToUserAlias;


//弹出窗口
- (void)popShow;

-(void)hide ;
@end
