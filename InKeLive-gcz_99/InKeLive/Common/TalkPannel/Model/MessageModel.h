//
//  MessageModel.h
//  MessageLivingDemo
//
//  Created by jianqiangzhang on 16/5/12.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CellType){
    CellBanType,                  // 禁号
    CellNewChatMessageType,       // 新消息
    CellNewGiftType,              // 礼品
    CellNewUserEnterType,         // 消息进入
    CellDeserveType,              //
    CellHomType,                  // 喇叭
    CellNoticeType,               // 公告
    CellSystemHomType,            // 系统公告(喇叭)
    CellEnterType,                //进入房间
    CellLeaveType,                //离开房间
};

@class TYTextContainer;

@interface MessageModel : NSObject

@property (nonatomic,strong)TYTextContainer *textContainer;
@property (nonatomic,copy)NSString *unColoredMsg;
@property (nonatomic,assign)CellType cellType;   //消息类型??
@property (nonatomic,strong)NSArray *gift;
@property (nonatomic,copy)NSString *dataString;
@property (nonatomic,assign) int userId;

- (void)setModelFromStirng:(NSString *)string;

- (void)setModel:(NSString*)userID withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withMessage:(NSString*)message toUserAlias:(NSString *)toUserAlias toId:(int)toId level: (int)level;

//设置系统提示:系统:xxxx
-(void) setModel:(NSString*)sysTipText;

//赠送礼物提示信息
-(void) setModel:(NSString*)userId withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withGiftId:(NSString*)giftId withGiftName:(NSString*)giftName withGiftNum:(NSString*)giftNum withToId:(NSString *)toId withToName:(NSString*)strToName  level:(int)level hide:(BOOL)hide;


/**
 进出房间通知

 @param userId <#userId description#>
 @param name <#name description#>
 @param type <#type description#>
 @param level <#level description#>
 */
-(void)setModelWithId:(NSString *)userId name:(NSString *)name type:(CellType)type level:(int)level;

@end
