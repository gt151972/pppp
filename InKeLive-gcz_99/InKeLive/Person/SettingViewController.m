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
#import "WebViewController.h"
#import "GTAFNData.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource,GTAFNDataDelegate>{
    NSArray *arrayTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *labDetail;
//@property (weak, nonatomic) IBOutlet UIButton *btnExitLogin;

@end

@implementation SettingViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arrayTitle = @[@[@"点赞消息通知",@"评论消息通知"],@[@"清理缓存",@"客服中心",@"检查更新",@"关于我们"]];
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
    _tableView.scrollEnabled = NO;
//    [self calculateCache];
//    _btnExitLogin.layer.cornerRadius = 5;
//    _btnExitLogin.layer.masksToBounds = YES;
    
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[arrayTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0) {
        UISwitch *switch0 = [[UISwitch alloc] init];
        switch0.onTintColor= MAIN_COLOR;
        switch0.transform= CGAffineTransformMakeScale(1.0,1.0);
        switch0.frame=CGRectMake(SCREEN_WIDTH - 65, 10, 50, 20);
//        switch0.tintColor=RGB(169, 169, 169);
//        switch0.thumbTintColor=[UIColor whiteColor];
        [switch0 addTarget:self action:@selector(getValueForSwitch:) forControlEvents:UIControlEventValueChanged];
        switch0.tag = indexPath.row + 2000;
        [cell.contentView addSubview:switch0];
        
//        if (indexPath.row == 0) {
//            //隐身进入
//            [switch0 setOn:model.isHiding animated:YES];
//        }else
            if (indexPath.row == 0){
            //点赞通知
        }else if (indexPath.row == 1){
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
        if (indexPath.row == 0) {
            _labDetail = [[UILabel alloc] init];
            _labDetail.text = @"正在计算...";
            _labDetail.font = [UIFont systemFontOfSize:13];
            _labDetail.textAlignment = NSTextAlignmentRight;
            _labDetail.textColor = GRAY_COLOR;
            [cell.contentView addSubview:_labDetail];
            [_labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btnGo.mas_left).offset(-10);
                make.width.equalTo(@100);
                make.centerY.equalTo(cell.contentView);
                make.height.equalTo(@17);
            }];
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //清理缓存
            if ([_labDetail.text isEqualToString:@"正在计算..."]){
                [[GTAlertTool shareInstance] showAlert:@"缓存尚未计算完" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:nil];
            }else{
                [[GTAlertTool shareInstance] showAlert:@"确定清除本地缓存" message:nil cancelTitle:@"取消" titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                    if (buttonTag == 0) {
                        [self removeCache];
                    }
                }];
            }
        }else if (indexPath.row == 1){
            //客服中心
            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString*cachePath = array[0];
            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
            NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
            NSString *strUrl = [dict objectForKey:@"customer"];
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.strUrl = strUrl;
            webVC.strTitle = @"客服中心";
            [self.navigationController pushViewController:webVC animated:YES];
        }else if (indexPath.row == 2){
            //检查更新
            GTAFNData *data = [[GTAFNData alloc] init];
            data.delegate = self;
            [data versionUpdate];
        }else if (indexPath.row == 3){
            //关于我们
            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString*cachePath = array[0];
            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
            NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
            NSString *strUrl = [dict objectForKey:@"about"];
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.strUrl = strUrl;
            webVC.strTitle = @"关于我们";
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            unsigned long long size = [SDImageCache sharedImageCache].getSize;   //CustomFile + SDWebImage 缓存
            
            //设置文件大小格式
            NSString *sizeText = nil;
            if (size >= pow(10, 9)) {
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            }else if (size >= pow(10, 6)) {
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            }else if (size >= pow(10, 3)) {
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            }else {
                sizeText = [NSString stringWithFormat:@"%.2lluB", size];
            }
            _labDetail.text = sizeText;
            
        });
        
    }
    
}

#pragma mark 计算清除缓存
- (void)removeCache{
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置文字
                [MBProgressHUD showAlertMessage:@"清理完毕"];
                _labDetail.text = @"0.00MB";
            });
        });
    }];
}

#pragma mark Action
- (void)getValueForSwitch: (UISwitch *)swi{
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    if (swi.tag == 2000) {
        model.isHiding = swi.on;
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
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:@"text/html"forHTTPHeaderField:@"Content-Type"];
    
    session.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"image/png",@"image/jpeg",nil];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_WEB_ADDRESS;
    parameters[@"flag"] = IOS_REQUEST_FLAG;
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"parameters:%@", parameters);
//    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success: %@", responseObject);

        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSLog(@"mConfig: %@", appDic[@"mConfig"]);
        if (appDic[@"mConfig"] == 0) {

        }else{
            NSLog(@"%@",appDic[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}

#pragma mark GTAFNDataDelegate
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_VERSION_UPDATE]) {
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
            int apkcode = [[dict objectForKey:@"apkcode"] intValue];
            NSLog(@"apkcode == %d",apkcode);
            if ([data[@"apkcode"] intValue] > apkcode) {
                [[GTAlertTool shareInstance] showAlert:@"当前版本不是最新版本" message:@"请前往商店下载更新" cancelTitle:@"取消" titleArray:@[@"去更新"] viewController:self confirm:^(NSInteger buttonTag) {
                    if (buttonTag != -1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_PATH]];
                    }
                }];
            }
        }else{
            [MBProgressHUD showAlertMessage:data[@"msg"]];
        }
    }
}

@end
