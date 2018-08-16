//
//  TodayViewController.m
//  Widget
//
//  Created by 高婷婷 on 2017/4/10.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
//    //App写入数据
//    NSString *groupID = @"group.com.chehulu.widget";
//    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupID];
//    [shared setObject:[NSNumber numberWithInt:1000] forKey:@"number"];
//    [shared synchronize];
    
    //widget读取数据
    NSString *groupID = @"group.com.chehulu.widget";
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:groupID];
    NSString *string = [NSString stringWithFormat:@"%@",[shared objectForKey:@"number"]];
}

- (void)initView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
