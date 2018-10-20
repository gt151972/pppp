//
//  SelectGiftUserView.h
//  InKeLive
//
//  Created by gu  on 17/9/17.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientUserModel.h"

@interface SelectGiftUserView : UIView

@property(nonatomic, copy)NSString* userId;
//用户数组
@property(nonatomic, copy)NSArray* userArray;

@property (nonatomic, assign)BOOL ishide;
//选择用户
@property (nonatomic,copy)void (^userClick)(NSInteger userId, NSString* userAlias);

//弹出窗口
- (void)popShow;

-(void)hide ;

@end
