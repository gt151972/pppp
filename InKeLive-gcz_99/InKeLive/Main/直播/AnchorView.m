//
//  AnchorView.m
//  InKeLive
//
//  Created by 1 on 2016/12/20.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "AnchorView.h"
#import "UIImageView+WebCache.h"

@implementation AnchorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.2); //背景透明
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    //创建子View
    self.layer.cornerRadius = 18;
    self.layer.masksToBounds = YES;   //圆角
    [self addSubview:self.iconImageView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.payButton];
    
    //约束代码
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(3);
        make.width.height.equalTo(@30);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-3);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@35);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.payButton.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.right.equalTo(self.payButton.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

//连麦按钮
- (void)payButtonClick{
    if (self.anchorClick) {
        if (_payButton.selected) {
            self.anchorClick(1);
        }else{
            self.anchorClick(2);
        }
    }
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        //从网上读图片
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 15;
        _iconImageView.layer.masksToBounds = YES;
//        NSString *urlStr = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTcwOTgyNTIyNCM3OTcjanBn.jpg"];
//        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        //设置默认头像
        _iconImageView.image = [UIImage imageNamed:@"default_head"];
    }
    return _iconImageView;
}

- (UILabel *)userIdLabel{
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc]init];
        _userIdLabel.textColor = [UIColor whiteColor];
        _userIdLabel.text = @"ID:0";
        _userIdLabel.textAlignment = NSTextAlignmentLeft;
        _userIdLabel.font = [UIFont systemFontOfSize:8];
    }
    return _userIdLabel;
}

- (UIButton *)payButton{
    if (!_payButton) {
        //关注按钮
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_payButton.layer.borderWidth = 1;
        //_payButton.layer.borderColor = RGB(36, 216, 200).CGColor;
        //_payButton.layer.cornerRadius = 16;
        //_payButton.layer.masksToBounds = YES;
        [_payButton setImage:[UIImage imageNamed:@"living_attention"] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_payButton setTitle:@"取消关注" forState:UIControlStateSelected];
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.text = @"无观看主播";
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _userNameLabel;
}

-(void) setAnchorInfo:(int)userId UserName:(NSString*)userName UserHeadPic:(NSString*)userHeadPic
{
    NSString* strUserID =[NSString stringWithFormat:@"ID:%d", userId];
    _userNameLabel.text = userName;
    _userIdLabel.text = strUserID;
    NSURL *url =[NSURL URLWithString:userHeadPic];
    [_iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    }

-(void) reset
{
    _userNameLabel.text = @"无观看主播";
    _userIdLabel.text = @"用户ID:0";
    _iconImageView.image = [UIImage imageNamed:@"default_head"];
}


@end
