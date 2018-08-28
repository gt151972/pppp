//
//  HistoryViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/28.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "HistoryViewController.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "LocalUserModel.h"
#import "DPK_NW_Application.h"

@interface HistoryViewController ()
@property (nonatomic, strong) NSArray *arrData;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void) getData{
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_ENTER_ROOM_RECORD;
    parameters[@"uid"] = [NSString stringWithFormat:@"%d",userData.userID];
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        List =     (
//                    {
//                        Title = "\U9a8f\U81e8\U5929\U4e0b";
//                        img = "20170912011920_658.jpg";
//                        mLevel = 0;
//                        max = 300;
//                        online = 219;
//                        rId = 177777;
//                        uId = 0;
//                    },
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        if ([appDic[@"code"] intValue] == 0) {
            _arrData = appDic[@"List"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
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
