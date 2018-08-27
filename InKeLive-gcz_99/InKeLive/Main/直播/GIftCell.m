//
//  GIftCell.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "GIftCell.h"
#import "LocalUserModel.h"
#import "DPK_NW_Application.h"

@implementation GIftCell

- (instancetype)initWithRow:(NSInteger)row{
    if (self = [super initWithRow:row]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    [self addSubview:self.imgBg];
    [self.imgBg addSubview:self.iconImageView];
    [self.imgBg addSubview:self.giftImageView];
    [self.imgBg addSubview:self.senderLabel];
    [self.imgBg addSubview:self.lineLabel];
    
    [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(2);
        make.width.height.equalTo(@32);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.bottom.equalTo(self).offset(-2);
        make.width.height.equalTo(@32);
    }];
    
    [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.senderLabel.mas_bottom);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.masksToBounds = YES;
//        [_iconImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
//        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return _iconImageView;
}

- (UILabel *)lineLabel{
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc]init];
        _giftLabel.textColor = MAIN_COLOR;
        _giftLabel.textAlignment = NSTextAlignmentLeft;
        _giftLabel.font = [UIFont systemFontOfSize:12];
    }
    return _giftLabel;
}


- (UILabel *)senderLabel{
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc]init];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.textAlignment = NSTextAlignmentLeft;
        _senderLabel.font = [UIFont systemFontOfSize:10];
    }
    return _senderLabel;
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]init];
    }
    return _giftImageView;
}

- (UIImageView *)imgBg{
    if (!_imgBg) {
        _imgBg = [[UIImageView alloc]init];
        _imgBg.image = [UIImage imageNamed:@"giftBackground"];
//        _imgBg.backgroundColor = RGBA(0, 0, 0, 0.3);
//        //圆角
//        _imgBg.layer.cornerRadius = 20;
//        _imgBg.clipsToBounds = YES;
    }
    return _imgBg;
}


- (void)setPresentmodel:(PresentModel *)presentmodel{
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    _presentmodel = presentmodel;
    NSLog(@"userData == %@",userData.userSmallHeadPic);
    
    NSURL *url =[NSURL URLWithString:userData.userSmallHeadPic];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.senderLabel.text = presentmodel.sender;
    
    NSLog(@"giftImageName == %@",presentmodel.giftImageName);
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
//    NSArray*array2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
//    NSString*cachePath2 = array[0];
    NSString*filePathName2 = [cachePath stringByAppendingPathComponent:@"livingUserInfo.plist"];
    NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:filePathName2];
    self.giftLabel.text = [NSString stringWithFormat:@"送给%@",[dicUser objectForKey:@"userAlias"]];
    //    NSURL *url = [NSURL URLWithString:giftImage];
    NSString *strUrl = [NSString stringWithFormat:@"%@gift/%@",[dict objectForKey:@"res"],presentmodel.giftImageName];
    NSURL *urlGiftImage =[NSURL URLWithString:strUrl];
    [self.giftImageView sd_setImageWithURL:urlGiftImage];
}



@end
