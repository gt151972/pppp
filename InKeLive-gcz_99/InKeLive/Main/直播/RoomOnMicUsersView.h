//
//  RoomOnMicUsersView.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomOnMicUsersView : UITableView
@property (nonatomic, strong)UILabel *labName;
@property (nonatomic, strong)UILabel *labID;
@property (nonatomic, strong)UIImageView *imgViewUP;

@property (nonatomic, strong) UIButton *btnRoomName;//房间名按钮
@property (nonatomic, strong) UILabel *labRoomId;

@property (nonatomic,copy)void (^btnRoomNameClicked)(BOOL isSpread);
@end
