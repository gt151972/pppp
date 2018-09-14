//
//  BindingViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/7.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "BindingViewController.h"
#import "Time.h"
#import "DPK_NW_Application.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "GTAFNData.h"

@interface BindingViewController ()<GTAFNDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIButton *btnBinding;

@end

@implementation BindingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"绑定手机";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnCode.layer.masksToBounds = YES;
    _btnCode.layer.cornerRadius = 2;
    _btnBinding.layer.masksToBounds = YES;
    _btnBinding.layer.cornerRadius = 19;
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [[GTAFNData shareInstance] requestSecurityReadWithUid:@"1259"];
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCodeClicked:(id)sender {
    //验证码
    [Time setTheCountdownButton:sender startWithTime:45 title:@"获取验证码" countDownTitle:@"s" mainColor:MAIN_COLOR countColor:MAIN_COLOR];
}
- (IBAction)btnBindingClicked:(id)sender {
}

-(void)requestData: (NSString *)strPhone{
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_SECURITY_READ;
    parameters[@"uid"] = strPhone;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    NSLog(@"cmd");
}

@end
