//
//  SendDynamicViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/20.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SendDynamicViewController.h"

@interface SendDynamicViewController ()

@end

@implementation SendDynamicViewController

- (void)awakeFromNib{
    [super awakeFromNib];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发状态";
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnLeft setTitle:@"取消" forState:UIControlStateNormal];
    [btnLeft setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnLeft addTarget:self action:@selector(btnCancleClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationController.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnRight setTitle:@"发送" forState:UIControlStateNormal];
    [btnRight setTitleColor:RGB(23, 23, 23) forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnRight addTarget:self action:@selector(btnSendClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark ---------Clicked---------
- (void)btnCancleClicked{
    
}

- (void)btnSendClicked{
    
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
