//
//  AttentionController.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "AttentionController.h"
#import "EmptyView.h"


@interface AttentionController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)EmptyView *emptyView;

@end

@implementation AttentionController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.view addSubview:self.emptyView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.separatorColor = RGB(218, 218, 218);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (void)requestDate{
//    
//    // 获得请求管理者
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    
//    // 设置请求格式
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//    parameters[@"cmd"] = @"20001";
//    parameters[@"flag"] = @"0";
//    NSString* strAPIUrl = URL_GiftInfo;
//    NSLog(@"url:%@", strAPIUrl);
//    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
//    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        NSLog(@"task: %@",task);
//        NSDictionary *appDic =(NSDictionary*)responseObject;
//        if(1){
//            //            NSString *plistPath = [[NSBundle mainBundle]pathForResource:APP_info ofType:@"plist"];
//            //            NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] objectForKey:@"giftInfo"];
//            //            NSLog(@"%@",dataDic);//直接打印数据
//            //            dataDic[@"imageUrl"] = [appDic objectForKey:@"res"];
//            //            dataDic[@"uDown"] = [appDic objectForKey:@"uDown"];
//            //            dataDic[@"uUp"] = [appDic objectForKey:@"uUp"];
//            //            dataDic[@"version"] = [appDic objectForKey:@"GiftVersion"];
//            //            [dataDic writeToFile:plistPath atomically:YES];
//            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
//            NSString*cachePath = array[0];
//            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
//            NSDictionary*dict =@{@"res": [appDic objectForKey:@"res"],@"uDown":[appDic objectForKey:@"uDown"],@"uUp":[appDic objectForKey:@"uUp"],@"GiftVersion":[NSString stringWithFormat:@"%@",[appDic objectForKey:@"GiftVersion"]]};
//            [dict writeToFile:filePathName atomically:YES];
//            [self loadGiftConf];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error: %@", error);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:self.view.bounds];
    }
    return _emptyView;
}

@end
