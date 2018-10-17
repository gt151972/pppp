//
//  InKeCell.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InKeModel.h"

//大厅热门列表的cell
@interface InKeCell : UITableViewCell

//头像
@property (nonatomic,strong)UIImageView *iconImageView;
//名字
@property (nonatomic,strong)UILabel *nameLabel;
//所在城市
@property (nonatomic,strong)UILabel *cityLabel;
//隐身按钮
@property (nonatomic,strong)UIButton *btnHide;
//在线人数
@property (nonatomic,strong)UIButton *btnOnline;
//封面
@property (nonatomic,strong)UIImageView *coverImageView;
//心情？？
@property (nonatomic,strong)UILabel *moodLabel;
//直播logo
@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic, copy) void (^btnHideClicked)();
-(void)updateCell:(InKeModel*)model;

@end
