//
//  InKeCell.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "InKeCell.h"

@implementation InKeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(8);
        make.height.width.equalTo(@36);
    }];
    _iconImageView.layer.cornerRadius = 18;
    _iconImageView.layer.masksToBounds = YES;
    
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.numberOfLines = 1;
    _nameLabel.textColor = TEXT_COLOR;
//    _nameLabel.font = [UIFont fontWithName:@"Candara" size:14];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(3);
        make.height.equalTo(@14);
        make.width.equalTo(@200);
    }];
    
    
//    _cityLabel = [[UILabel alloc]init];
//    _cityLabel.textColor = [UIColor grayColor];
//    _cityLabel.font = [UIFont fontWithName:@"Candara" size:13];
//    [self.contentView addSubview:_cityLabel];
//    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_nameLabel.mas_bottom).offset(3);
//        make.left.equalTo(_nameLabel.mas_left);
//        make.height.equalTo(_nameLabel.mas_height);
//        make.width.equalTo(@100);
//    }];

    _btnOnline = [[UIButton alloc]init];
    [_btnOnline setImage:[UIImage imageNamed:@"home_people"] forState:UIControlStateNormal];
    [_btnOnline.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_btnOnline setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
//    [_btnOnline setBackgroundColor: [UIColor redColor]];
    [self.contentView addSubview:_btnOnline];
    [_btnOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.width.equalTo(@70);
        make.height.equalTo(@45);
    }];

    _coverImageView = [[UIImageView alloc]init];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = true;
    [self.contentView addSubview:_coverImageView];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(3);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.contentView.mas_left).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
    }];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _logoImageView = [[UIImageView alloc]init];
    _logoImageView.image = [UIImage imageNamed:@"live_tag_live"];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_coverImageView.mas_right).offset(-10);
        make.top.equalTo(_coverImageView.mas_top).offset(10);
        make.width.mas_equalTo(_logoImageView.mas_height).multipliedBy(1.3);
    }];
}

-(void)updateCell:(InKeModel*)inKeModel{
    //有些没有前缀（需要判断）
    //if ([inKeModel.portrait rangeOfString:@"http://img2.inke.cn/"].location == NSNotFound) {
    //    inKeModel.portrait = [NSString stringWithFormat:@"http://img2.inke.cn/%@",inKeModel.portrait];
    //}
    
    NSString* strImage = (inKeModel.userId !=0) ? inKeModel.userstarPic : inKeModel.roomPic;
    NSString* strNick = (inKeModel.userId !=0) ?inKeModel.userAlias : inKeModel.roomName;
    NSString *strID = (inKeModel.userId !=0) ?inKeModel.userAlias : [NSString stringWithFormat:@"%d",inKeModel.roomId];
    NSString* strCity = @"难道在火星？";
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)",strNick,strID];
    _cityLabel.text = [NSString stringWithFormat:@"%@ >",strCity];
//    NSLog(@"%d 人",inKeModel.roomUserCount);
//    _btnOnline.titleLabel.text = [NSString stringWithFormat:@"%d",inKeModel.roomUserCount];
    [_btnOnline setTitle:[NSString stringWithFormat:@"%d ",inKeModel.roomUserCount] forState:UIControlStateNormal];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:@"live_empty_bg"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
