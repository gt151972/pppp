//
//  NoObdViewController.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/16.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "NoObdViewController.h"

@interface NoObdViewController ()

@end

@implementation NoObdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *imgBox = [UIImage imageNamed:@"iconBox"];
    UIImageView *imageBox = [[UIImageView alloc] init];
    imageBox.image = imgBox;
    [self.view addSubview:imageBox];
    [imageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(imgBox.size);
        make.top.mas_equalTo(146);
    }];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"尚未安装车葫芦盒子";
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.centerX.and.width.equalTo(self.view);
        make.top.equalTo(imageBox.mas_bottom).offset(20);
    }];
    
    UILabel *labDetail = [[UILabel alloc] init];
    labDetail.text = @"购买UBI车险即可免费获得车葫芦盒子";
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labDetail];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerX.and.width.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(14);
    }];
    
    UIButton *btnGo = [[UIButton alloc] init];
    [btnGo setTitle:@"了解UBI车险" forState:UIControlStateNormal];
    [btnGo setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
    [btnGo.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnGo setTag:201];
    [btnGo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGo];
    [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerX.and.width.equalTo(labTitle);
        make.top.equalTo(labDetail.mas_bottom).offset(14);
    }];
    
    UIImage *imgExperience = [UIImage imageNamed:@"btnExperience"];
    UIButton *btnExperience = [[UIButton alloc] init];
    [btnExperience setImage:imgExperience forState:UIControlStateNormal];
    [btnExperience setTag:202];
    [btnExperience addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnExperience addSubview:btnExperience];
    [btnExperience mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgExperience.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(btnGo.mas_bottom).offset(103);
    }];
}

- (void)btnClicked:(UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
