//
//  UserSmallHeadImageCell.m
//  InKeLive
//
//  Created by gu  on 17/8/14.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "UserSmallHeadImageCell.h"

@implementation UserSmallHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView*)tableView {
    static NSString* cell_id = @"UserSmallHeadImageCell";
    UserSmallHeadImageCell* cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if(cell == nil) {
        cell =[[UserSmallHeadImageCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        //将单元格视图顺时针旋转90度
        cell.contentView.transform =CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initUIControl];
    }
    return cell;
}

-(void) initUIControl {
    //用户头像
    _userHeadImageView = [[UIImageView alloc] init];
    _userHeadImageView.frame = CGRectMake(0, 0, 36, 36);
    _userHeadImageView.layer.masksToBounds = YES;
    _userHeadImageView.layer.cornerRadius = 18;
    [self.contentView addSubview:_userHeadImageView];
    
    //等级标志
#if 1
    _userLevelImageView = [[UIImageView alloc]init];
    _userLevelImageView.frame = CGRectMake(36-13, 36-13, 13, 13);
    //_userLevelImgView.backgroundColor=[UIColor greenColor];
    //_userLevelImageView.image =[UIImage imageNamed:@"lv10_22x22_"];
    _userLevelImageView.image = [UIImage imageNamed:@"icon_guan"];
    [self.contentView addSubview:_userLevelImageView];
#endif
}

@end


