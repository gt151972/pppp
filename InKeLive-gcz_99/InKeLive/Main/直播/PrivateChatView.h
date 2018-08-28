//
//  PrivateChatView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/13.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientUserModel.h"
@protocol privateChatViewDelegate <NSObject>
@required
// 发送消息
- (void)SendPrivateMessage:(NSString*)message receiverId: (int) receiverId;
@optional
//// 键盘打开弹幕
//- (void)keyBoardDanmuOpen;
//// 键盘关闭弹幕
//- (void)keyBoardDanmuClose;


@end

@interface PrivateChatView : UIView
@property (nonatomic,weak)id<privateChatViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *chatBgView;
@property (weak, nonatomic) IBOutlet UILabel *labNameAndID;
@property (weak, nonatomic) IBOutlet UITableView *HeadTableView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *arrUserInfo;//记录所有私聊对象信息
@property (nonatomic, strong) NSArray *arrHead;//
@property (nonatomic, strong) NSArray *arrChatMessage;

//弹出窗口
- (void)popShow;

-(void)hide ;
@end
