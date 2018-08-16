//
//  LiveUserInfoView.h
//  InKeLive
//
//  Created by gu  on 17/8/15.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClientUserModel.h"

@interface LiveUserInfoView : UIView

/** 点击关闭 */
@property (nonatomic, copy) void (^closeBlock)();   //关闭回调函数
/** 点击关注 */
@property (nonatomic, copy) void (^guanzhuBlock)();  //关注回调函数

/** 用户信息 */
@property (nonatomic, strong) ClientUserModel* userModel;

+ (instancetype)userView;

-(void) updateInfo;

@end
