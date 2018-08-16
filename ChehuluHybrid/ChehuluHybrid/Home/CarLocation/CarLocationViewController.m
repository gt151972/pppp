//
//  CarLocationViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/2.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarLocationViewController.h"

@interface CarLocationViewController ()

@end

@implementation CarLocationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"车辆定位"];
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
    
}

- (void)initView{
    
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 148, gtWIDTH, 146)];
    viewFooter.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewFooter];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 94)];
    [viewFooter addSubview:view1];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, 94, gtWIDTH - 10, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
