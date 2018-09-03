//
//  AnchorView.h
//  InKeLive
//
//  Created by 1 on 2016/12/20.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

//左上角的主播间信息View
@interface AnchorView : UIView

//头像
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel * userNameLabel;
@property (nonatomic,strong)UILabel *userIdLabel;

//连麦按钮(换成关注按钮)
@property (nonatomic,strong)UIButton *payButton;

@property (nonatomic, copy) void (^anchorClick)(int flag); ////1标识增加，2表示删除
//设置主播信息和重置信息
-(void) setAnchorInfo:(int)userId UserName:(NSString*)userName UserHeadPic:(NSString*)userHeadPic;
-(void) reset;

@end
