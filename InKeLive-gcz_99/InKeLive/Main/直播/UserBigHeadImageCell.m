//
//  UserBigHeadImageCell.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "UserBigHeadImageCell.h"

@implementation UserBigHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView*)tableView {
    static NSString* cell_id = @"UserBigHeadImageCell";
    UserBigHeadImageCell* cell =[tableView dequeueReusableCellWithIdentifier:cell_id];
    if(cell == nil) {
        cell = [[UserBigHeadImageCell alloc] init ];
        cell.backgroundColor =[UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initUIControl];
    }
    return cell;
}

-(void) initUIControl {
    //用户头像
    _userHeadImageView = [[UIImageView alloc]init];
    _userHeadImageView.frame = CGRectMake(0,0, 65, 65);
//    _userHeadImageView.backgroundColor =[UIColor redColor];
//    _userHeadImageView.image =[UIImage imageNamed:@"default_head"];
    _userHeadImageView.layer.masksToBounds = YES;
    _userHeadImageView.layer.cornerRadius = 32.5;
    [self.contentView addSubview:_userHeadImageView];
    
//    //MIC标志
//    _userMicStatusImageView = [[UIImageView alloc]init];
//    _userMicStatusImageView.frame = CGRectMake(4, 50, 28, 13);
//    _userMicStatusImageView.image =[UIImage imageNamed:@"icon_msimic"];
//    [self.contentView addSubview:_userMicStatusImageView];
    
    //主播名字
    _labAnchorName = [[UILabel alloc] init];
    _labAnchorName.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 10);
    _labAnchorName.textAlignment = NSTextAlignmentCenter;
    _labAnchorName.font = [UIFont systemFontOfSize:10];
    _labAnchorName.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_labAnchorName];
}

@end

