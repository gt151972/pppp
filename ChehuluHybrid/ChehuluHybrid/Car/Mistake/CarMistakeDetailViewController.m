//
//  CarMistakeDetailViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarMistakeDetailViewController.h"

@interface CarMistakeDetailViewController ()

@end

@implementation CarMistakeDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"故障详情"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initData{
    
}

- (void)initView{
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, gtWIDTH - 60, 100)];
    lableTitle.text = [_dicData objectForKey:@"desc"];
    lableTitle.textColor = COLOR_TEXT_GARY_DEEP;
    lableTitle.font = [UIFont systemFontOfSize:16];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableTitle];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(5, 145, gtWIDTH-10, 1)];
    viewLine.backgroundColor = COLOR_BG_GRAY;
    [self.view addSubview:viewLine];
    
    UILabel *labWay = [[UILabel alloc] initWithFrame:CGRectMake(24, 175, gtWIDTH - 48, 22)];
    labWay.text = @"解决方法";
    labWay.textColor = COLOR_TEXT_GARY_DEEP;
    labWay.font = [UIFont systemFontOfSize:16];
    labWay.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:labWay];
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(24, 180, gtWIDTH - 48, 50)];
    labDetail.textAlignment = NSTextAlignmentLeft;
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.text = [_dicData objectForKey:@"solve"];
    labDetail.font = [UIFont systemFontOfSize:14];
    labDetail.numberOfLines = 0;
    [self.view addSubview:labDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
