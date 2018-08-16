//
//  ShowView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/1/11.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "ShowView.h"
#import "CommendFile.h"
#import <Masonry.h>

@implementation ShowView
- (UIView *)shareViewWithFrame: (CGFloat)height{
    _viewShare = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - height, gtWIDTH, height)];
    [_viewShare setHidden:YES];
    _viewShare.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_viewShare];
    
    
    UIView *viewFriend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/2, _viewShare.frame.size.height)];
    viewFriend.backgroundColor = [UIColor clearColor];
    [_viewShare addSubview:viewFriend];
    UIView *viewCircle = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/2, 0, gtWIDTH/2, _viewShare.frame.size.height)];
    [_viewShare addSubview:viewCircle];
    UIImage *imageFriend = [UIImage imageNamed:@"shareFriend"];
    UIButton *btnFriends = [[UIButton alloc] init];
    [btnFriends setImage:imageFriend forState:UIControlStateNormal];
    [btnFriends setTag:201];
    [btnFriends addTarget:self action:@selector(btnShare:) forControlEvents:UIControlEventTouchUpInside];
    [viewFriend addSubview:btnFriends];
    UIImage *imageCircle = [UIImage imageNamed:@"shareCircle"];
    UIButton *btnCircle = [[UIButton alloc] init];
    [btnCircle setImage:imageCircle forState:UIControlStateNormal];
    [btnCircle setTag:202];
    [btnCircle addTarget:self action:@selector(btnShare:) forControlEvents:UIControlEventTouchUpInside];
    [viewCircle addSubview:btnCircle];
    [btnFriends mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageFriend.size);
        make.centerY.equalTo(_viewShare.mas_centerY);
        make.centerX.equalTo(viewFriend.mas_centerX);
    }];
    [btnCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageCircle.size);
        make.centerY.equalTo(_viewShare.mas_centerY);
        make.centerX.equalTo(viewCircle.mas_centerX);
    }];
    return _viewShare;
}


@end
