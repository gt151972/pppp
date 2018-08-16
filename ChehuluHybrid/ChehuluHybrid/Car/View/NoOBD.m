//
//  NoOBD.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/27.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "NoOBD.h"
#import "BaseButton.h"


@implementation NoOBD


/**
 <#Description#>

 @param view <#view description#>
 */
- (void)addViewNoCar:(UIView *)view{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT - 49)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.backGroundView.layer setShadowColor:[UIColor clearColor].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    UILabel *labNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, gtWIDTH, 44)];
    labNavTitle.text = @"车况";
    labNavTitle.font = [UIFont systemFontOfSize:18];
    labNavTitle.textAlignment = NSTextAlignmentCenter;
    labNavTitle.textColor = COLOR_BG_BLACK_DEEP;
    [self.backGroundView addSubview:labNavTitle];


    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, 1)];
    viewLine.backgroundColor = COLOR_MAIN_GRAY;
    [self.backGroundView addSubview:viewLine];
    
    UIImage *imgBox = [UIImage imageNamed:@"iconBox"];
    UIImageView *imageBox = [[UIImageView alloc] init];
    imageBox.image = imgBox;
    [_backGroundView addSubview:imageBox];
    [imageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundView);
        make.size.mas_equalTo(imgBox.size);
        make.top.mas_equalTo(146);
    }];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"尚未安装车葫芦盒子";
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:14];
    [_backGroundView addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.centerX.and.width.equalTo(self.backGroundView);
        make.top.equalTo(imageBox.mas_bottom).offset(20);
    }];
    
    UILabel *labDetail = [[UILabel alloc] init];
    labDetail.text = @"购买UBI车险即可免费获得车葫芦盒子";
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.font = [UIFont systemFontOfSize:14];
    [_backGroundView addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerX.and.width.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(14);
    }];
    
    UIButton *btnGo = [[UIButton alloc] init];
    [btnGo setTitle:@"了解UBI车险" forState:UIControlStateNormal];
    [btnGo setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
    [btnGo.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnGo setTag:205];
    [btnGo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:btnGo];
    [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerX.and.width.equalTo(labTitle);
        make.top.equalTo(labDetail.mas_bottom).offset(14);
    }];
    
    UIImage *imgExperience = [UIImage imageNamed:@"btnExperience"];
    UIButton *btnExperience = [[UIButton alloc] init];
    [btnExperience setImage:imgExperience forState:UIControlStateNormal];
    [btnExperience setTag:202];
    [btnExperience addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:btnExperience];
    [btnExperience mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgExperience.size);
        make.centerX.equalTo(self.backGroundView);
        make.top.equalTo(btnGo.mas_bottom).offset(103);
    }];
    [view addSubview:self];
}

- (void)addViewNoOBD:(UIView *)view strCarNo:(NSString *)strCarNo{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT - 49)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.backGroundView.layer setShadowColor:[UIColor clearColor].CGColor]; //000000
    [self.backGroundView.layer setShadowOffset:CGSizeMake(0, -0.05)];
    [self.backGroundView.layer setShadowOpacity:0.1];
    [self.backGroundView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.backGroundView.layer.bounds].CGPath];
    [self addSubview:self.backGroundView];
    
    UILabel *labNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, gtWIDTH, 44)];
    labNavTitle.text = @"车况";
    labNavTitle.font = [UIFont systemFontOfSize:18];
    labNavTitle.textAlignment = NSTextAlignmentCenter;
    labNavTitle.textColor = COLOR_BG_BLACK_DEEP;
    [self.backGroundView addSubview:labNavTitle];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, 1)];
    viewLine.backgroundColor = COLOR_MAIN_GRAY;
    [self.backGroundView addSubview:viewLine];
    UIImage *imgBox = [UIImage imageNamed:@"iconBox"];
    UIImageView *imageBox = [[UIImageView alloc] init];
    imageBox.image = imgBox;
    [_backGroundView addSubview:imageBox];
    [imageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(imgBox.size);
        make.top.mas_equalTo(146);
    }];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = strCarNo;
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:14];
    [_backGroundView addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.centerX.and.width.equalTo(self);
        make.top.equalTo(imageBox.mas_bottom).offset(20);
    }];
    
    UILabel *labDetail = [[UILabel alloc] init];
    labDetail.text = @"尚未安装车葫芦盒子";
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.font = [UIFont systemFontOfSize:14];
    [_backGroundView addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerX.and.width.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(14);
    }];
    
    BaseButton *button = [[BaseButton alloc] init];
    UIButton *btnChangeCar = [button btnWhite:@"切换车辆"];
    [btnChangeCar.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnChangeCar setTag:201];
    [btnChangeCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:btnChangeCar];
    [btnChangeCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 40));
        make.centerY.equalTo(self).offset(150);
        make.centerX.equalTo(self);
    }];
    [view addSubview:self];
}
- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        [_delegate didNoOBDName:@"noOBD"];
    }else if (button.tag == 202){
        [_delegate didNoOBDName:@"noCar"];
    }
//    [self removeView];
}

- (void)showInView:(UIView *)view
{
   
}

/**
 <#Description#>
 */
- (void)removeView {
    [self removeFromSuperview];
}

@end
