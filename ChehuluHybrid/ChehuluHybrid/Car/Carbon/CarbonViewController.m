//
//  CarbonViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarbonViewController.h"

@interface CarbonViewController ()

@end

@implementation CarbonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"碳排"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
//    NSLog(@"strDate == %@",_strDate);
//    indexDAL = [[IndexRequestDAL alloc] init];
//    indexDAL.delegate = self;
////    indexDAL getMonthCarbonWithCarId:[gtCarInfo objectForKey:@"car_id"] month:
}

- (void)initView{
    
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 145)];
    [self.view addSubview:viewHead];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 145, gtWIDTH, 2)];
    
    UIImage *imgMileage = [UIImage imageNamed:@"carbonBig"];
    UIImageView *imageMileage = [[UIImageView alloc] initWithImage:imgMileage];
    //        imageMileage.frame = CGRectMake(0, 0, gtWIDTH, 145);
    [viewHead addSubview:imageMileage];
    [imageMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewHead.mas_centerX);
        make.size.mas_equalTo(imgMileage.size);
        make.top.mas_equalTo(34);
    }];
    
    UILabel *labData = [[UILabel alloc] init];
    labData.text = [NSString stringWithFormat:@"%@kg",_strCarbon];
    labData.textColor = COLOR_TEXT_GARY_DEEP;
    labData.textAlignment = NSTextAlignmentCenter;
    labData.font = [UIFont systemFontOfSize:24];
    [viewHead addSubview:labData];
    [labData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.equalTo(viewHead);
        make.height.mas_equalTo(24);
        make.top.equalTo(imageMileage.mas_bottom).offset(20);
    }];
    
    UILabel *labDay = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH-20, 10)];
    labDay.text = _strDate;
    labDay.textColor = COLOR_TEXT_GARY;
    labDay.textAlignment = NSTextAlignmentRight;
    labDay.font = [UIFont systemFontOfSize:10];
    [viewHead addSubview:labDay];

    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, gtWIDTH, 22)];
    if (_strProfit) {
        labTitle.text = [NSString stringWithFormat:@"您已累计兑换环保收益金%@元",_strProfit];
    }else{
        labTitle.text = [NSString stringWithFormat:@"您已累计兑换环保收益金0元"];
    }
    
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(50, 243, gtWIDTH - 100, 50)];
    labDetail.text = @"日碳排量低于5kg,智驾科技将出资捐助环保公益项目1元";
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.textAlignment = NSTextAlignmentLeft;
    labDetail.numberOfLines = 0;
    labDetail.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:labDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
