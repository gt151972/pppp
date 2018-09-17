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
#import "AppDelegate.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [btnLeft setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [btnLeft addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
//    self.navigationController.navigationItem.leftBarButtonItems = @[leftItem];
    self.title = @"浏览记录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    _arrData = @[];
    [self getData];
    [self addView];
    // Do any additional setup after loading the view from its nib.
}

- (void)addView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 59;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
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
        int height = (int)_arrData.count*59;
        if (height < SCREEN_HEIGHT) {
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _arrData.count * 59);
        }else{
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"historyTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strRes = [dict objectForKey:@"res"];
    NSString *strImg =  [[_arrData objectAtIndex:indexPath.row] objectForKey:@"img"];
    NSString *str = [NSString stringWithFormat:@"%@user/%@",strRes,strImg];
//    NSLog(@"str == %@",str);
    UIImageView *imgHead = [[UIImageView alloc] init];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"]];
    imgHead.layer.masksToBounds = YES;
    imgHead.layer.cornerRadius = 19;
    [cell.contentView addSubview:imgHead];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(@11);
        make.width.height.equalTo(@38);
    }];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(57, 14, SCREEN_WIDTH - 80, 14)];
    labTitle.text =  [[_arrData objectAtIndex:indexPath.row] objectForKey:@"Title"];
    labTitle.textColor =  TEXT_COLOR;
    labTitle.textAlignment = NSTextAlignmentLeft;
    labTitle.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labTitle];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 1)];
    viewLine.backgroundColor = RGB(223, 223, 223);
    [cell.contentView addSubview:viewLine];
    
    UIButton *btnGo = [[UIButton alloc] init];
    [btnGo setImage:[UIImage imageNamed:@"btn_go"] forState:UIControlStateNormal];
    [cell.contentView addSubview:btnGo];
    [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@11);
        make.height.equalTo(@17);
        make.right.equalTo(cell.contentView).offset(-13);
        make.centerY.equalTo(cell.contentView);
    }];
    
    if (indexPath.row == 0) {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        viewLine.backgroundColor = RGB(223, 223, 223);
        [cell.contentView addSubview:viewLine];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(57, 37, SCREEN_WIDTH - 80, 12)];
        labTitle.text = [NSString stringWithFormat:@"ID:%@",[[_arrData objectAtIndex:indexPath.row] objectForKey:@"rId"]];
        labTitle.textColor =  RGB(110, 110, 110);
        labTitle.textAlignment = NSTextAlignmentLeft;
        labTitle.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:labTitle];
    }
    return cell;
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getRoomInfo:indexPath.row];
}

- (void)getRoomInfo:(NSInteger)row{
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_ADDTESS;
    parameters[@"rid"] = [[_arrData objectAtIndex:row] objectForKey:@"rId"];
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *dicApp = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dicApp[@"code"] intValue] == 0) {
            NSLog(@"success");
            TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
            [joinRoomInfo reset];
            joinRoomInfo.roomId = [[[_arrData objectAtIndex:row] objectForKey:@"rId"] intValue];
            joinRoomInfo.lookUserId = [[[_arrData objectAtIndex:row] objectForKey:@"uId"] intValue];
            joinRoomInfo.roomName = dicApp[@"rName"];
            [joinRoomInfo setGateAddr:dicApp[@"GateAddr"]]; //6位地址
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if([DPK_NW_Application sharedInstance].isLogon == NO) {
                [appDelegate doLogon];
                return;
            }else {
                [appDelegate showLiveRoom:NO CameraFront:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
