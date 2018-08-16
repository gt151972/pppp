//
//  UserBigHeadImageCell.h
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBigHeadImageCell : UITableViewCell
//用一个tableView来创建一个cell
+(instancetype) cellWithTableView:(UITableView*)tableView;

@property(nonatomic,strong) UIImageView* userHeadImageView;//主播头像
@property(nonatomic,strong) UIImageView* userMicStatusImageView;
@property(nonatomic,strong) UILabel *labAnchorName;//主播名字

@end
