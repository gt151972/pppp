//
//  LiveViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomView.h"
#import "LivingItem.h"
#import "KeyBoardInputView.h"
#import "MessageTableView.h"
#import "DanmuLaunchView.h"
#import "DanmuItemView.h"
#import "AnchorView.h"
#import "PresentView.h"
#import "GIftCell.h"
#import "PresentModel.h"
#import "SendGiftView.h"
#import "TopToolView.h"
#import "PrivateChatView.h"

#import "KSYMoviePlayerController.h"
#import <libksygpulive/KSYGPUStreamerKit.h>

#import "ClientRoomModel.h"
//#import "ClientRoomModel.h"
#import "RoomMembersView.h"
#import "RoomOnMicUsersView.h"
#import "LiveUserInfoView.h"
#import "SelectGiftUserView.h"

@interface LiveViewController : UIViewController


@property (nonatomic,assign)int playerId;  //当前观看的主播ID

@property (nonatomic, strong) NSDictionary *dicInfo;//房间信息

@property(nonatomic, assign) BOOL createFlag;  //创建标志,是否是主播端

@property(nonatomic, assign) BOOL caremaIsFront;  //摄像头是不是前端?

@property(nonatomic, strong) ClientRoomModel* roomObj;   //房间对象

@property(nonatomic, strong) ClientUserModel *userObj;//用户对象;

@property (strong, nonatomic) KSYMoviePlayerController *player;  //拉流端

@property (strong, nonatomic)KSYGPUStreamerKit *kit;  //推流端
@property (strong, nonatomic)GPUImageOutput<GPUImageInput>* curFilter; //视频过滤器(美颜)

//底部工具栏
@property (nonatomic ,strong)BottomView *bottomTool;


@property (nonatomic, strong)LivingItem *livingItem;   //主播间数据

//顶部区域
@property (nonatomic,strong)AnchorView *anchorView;    //主播信息区

//RTMP推流和拉流状态信息去
@property (nonatomic, strong) UIView * KSYstreamerStatusBK;
@property (nonatomic, strong) UILabel* KSYstreamerStatusLabel;

//房间成员头像列表(弃用)
//@property (nonatomic, strong)RoomMembersView *membersHeadView;

//头部工具栏(特效,分享,用户列表,关闭)
@property (nonatomic, strong)TopToolView *topToolView;

//在麦用户列表
@property (nonatomic, strong)RoomOnMicUsersView *onMicUsersHeadView;

//用户信息(弹窗)
@property (nonatomic, strong)LiveUserInfoView *userView;


//显示连击动画区域
@property (nonatomic,strong)PresentView *presentView;

//连击样式视图
@property (nonatomic,strong)GIftCell *giftCell;

//礼物数组
@property (nonatomic,strong)NSMutableArray *giftArr;

//礼物栏
@property (nonatomic, strong)SendGiftView *giftView;

//赠送礼物用户选择
//@property(nonatomic, strong)SelectGiftUserView *selectGiftUserView;

//聊天输入框
@property (nonatomic, strong) KeyBoardInputView *keyBoardView;

// 聊天面板
@property (nonatomic, strong) MessageTableView *messageTableView;

@property (nonatomic, strong) DanmuLaunchView *danmuView;

//现实动画
@property(nonatomic ,strong)UIDynamicAnimator * dynamicAnimator;
//现实行为
@property(nonatomic ,strong)UIDynamicItemBehavior * dynamicItemBehavior;
//重力行为
@property(nonatomic ,strong)UIGravityBehavior * gravityBehavior;
//碰撞行为
@property(nonatomic ,strong)UICollisionBehavior * collisionBehavior;


//函数
- (void)initURL:(NSURL *)url fileList:(NSArray *)fileList;
- (void)initPushURL:(NSString*)rtmpUrl;


@end
