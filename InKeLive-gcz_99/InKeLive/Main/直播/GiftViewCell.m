//
//  GiftViewCell.m
//  InKeLive
//
//  Created by 1 on 2017/1/4.
//  Copyright © 2017年 jh. All rights reserved.
//礼物cell

#import "GiftViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GiftViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //整个背景半透明
        //self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.backgroundColor = [UIColor clearColor];
//        self.giftImageView.image = [UIImage imageNamed:@"1"];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self addSubview:self.giftImageView];
    [self addSubview:self.hitButton]; //连击标志
    [self addSubview:self.giftNameView];
//    [self addSubview:self.giftPriceView];
    //和自己一样大
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.right.equalTo(self).offset(-13);
        make.top.equalTo(self).offset (9);
        make.bottom.equalTo(self).offset(-23);
    }];
//
//    [self.hitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.equalTo(self);
//        make.height.width.equalTo(@25);
//    }];
    
    [self.giftNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@12);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
//    [self.giftPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_bottom).offset(-18);
//        make.height.equalTo(@18);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//    }];
}

- (void)getDataFromPlist: (NSString *)plistName{
}

-(void) setGiftInfo:(int)giftId GiftImage:(NSString*)giftImage GiftName:(NSString*)giftName GiftPrice:(int)giftPrice
{
    //self.giftImageView
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];

//    NSURL *url = [NSURL URLWithString:giftImage];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[dict objectForKey:@"res"],giftImage];
    NSURL *url =[NSURL URLWithString:strUrl];
    NSLog(@"strUrl == %@",strUrl);
    [self.giftImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    self.giftNameView.text = giftName;
    
    NSString* strGiftPrice;
    if(giftPrice >100000) {
        strGiftPrice = [NSString stringWithFormat:@"%d万",giftPrice/10000 ];
    }
    else {
        strGiftPrice = [NSString stringWithFormat:@"%d", giftPrice];
    }
    self.giftPriceView.text = strGiftPrice;
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UIButton *)hitButton{
    if (!_hitButton) {
        _hitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //根据状态设置不同的图片
        [_hitButton setImage:[UIImage imageNamed:@"pop_gift_lian"] forState:UIControlStateNormal];
        [_hitButton setImage:[UIImage imageNamed:@"button_choose-on"] forState:UIControlStateSelected];
    }
    return _hitButton;
}

-(UILabel*)giftNameView {
    if(!_giftNameView) {
        _giftNameView = [[UILabel alloc]init];
        _giftNameView.backgroundColor = [UIColor clearColor];
        _giftNameView.text = @"礼物名称";
        _giftNameView.textColor = [UIColor whiteColor];
        _giftNameView.textAlignment = NSTextAlignmentCenter;
        _giftNameView.font = [UIFont systemFontOfSize:12];
    }
    return _giftNameView;
}

-(UILabel*)giftPriceView {
    if(!_giftPriceView) {
        _giftPriceView = [[UILabel alloc]init];
        _giftPriceView.backgroundColor =RGBA(0, 0,0, 0.5);
        _giftPriceView.text = @"礼物价格";
        _giftPriceView.textColor = [UIColor whiteColor];
        _giftPriceView.textAlignment = NSTextAlignmentCenter;
        _giftPriceView.font = [UIFont systemFontOfSize:12];
    }
    return _giftPriceView;
}


@end
