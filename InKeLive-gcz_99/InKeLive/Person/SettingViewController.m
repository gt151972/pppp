//
//  SettingViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/31.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SettingViewController.h"
#import "ServideViewController.h"
#import "AppDelegate.h"
#import "DPK_NW_Application.h"
#import "MBProgressHUD+MJ.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrayTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnExitLogin;

@end

@implementation SettingViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arrayTitle = @[@[@"隐身进入",@"点赞消息通知",@"评论消息通知"],@[@"清理缓存",@"客服中心",@"检查更新",@"关于我们"]];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.separatorColor = RGB(239, 239, 239);
    
    _btnExitLogin.layer.cornerRadius = 5;
    _btnExitLogin.layer.masksToBounds = YES;
    
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.textLabel.text = [[arrayTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    if (indexPath.section == 0) {
        UISwitch *switch0 = [[UISwitch alloc] init];
        switch0.onTintColor= MAIN_COLOR;
        switch0.transform= CGAffineTransformMakeScale(1.0,1.0);
        switch0.frame=CGRectMake(SCREEN_WIDTH - 65, 10, 50, 20);
//        switch0.tintColor=RGB(169, 169, 169);
//        switch0.thumbTintColor=[UIColor whiteColor];
        [switch0 addTarget:self action:@selector(getValueForSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switch0];
        
        if (indexPath.row == 0) {
            //隐身进入
            [switch0 setOn:YES animated:YES];
        }else if (indexPath.row == 1){
            //点赞通知
        }else if (indexPath.row == 2){
            //评论通知
        }
    }
    
    if (indexPath.section == 1) {
        UIButton *btnGo = [[UIButton alloc] init];
        [btnGo setImage:[UIImage imageNamed:@"btn_go"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnGo];
        [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(@11);
            make.height.equalTo(@17);
            make.right.equalTo(cell.contentView).offset(-13);
        }];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //清理缓存
            
        }else if (indexPath.row == 1){
            //客服中心
            ServideViewController *servideVC = [[ServideViewController alloc] init];
            [self.navigationController pushViewController:servideVC animated:YES];
        }else if (indexPath.row == 2){
            //检查更新
        }else if (indexPath.row == 3){
            //关于我们
            [self requestData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 4;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 10;
    }else{
        return 0;
    }
}

#pragma mark Action
- (void)getValueForSwitch: (UISwitch *)swi{
    
}
- (IBAction)btnExitLoginClicked:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([DPK_NW_Application sharedInstance].isLogon == YES) {
        [appDelegate logout];
        return;
    }else {
        [MBProgressHUD showAlertMessage:@"用户未登陆"];
    }
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestData{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_WEB_ADDRESS;
    parameters[@"flag"] = IOS_REQUEST_FLAG;
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        if (appDic[@"code"] == 0) {
            
        }else{
            NSLog(@"%@",appDic[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

@end
