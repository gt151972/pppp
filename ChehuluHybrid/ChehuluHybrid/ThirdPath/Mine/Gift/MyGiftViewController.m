//
//  MyGiftViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/11/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MyGiftViewController.h"

@interface MyGiftViewController ()

@end

@implementation MyGiftViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"我的卡券"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
