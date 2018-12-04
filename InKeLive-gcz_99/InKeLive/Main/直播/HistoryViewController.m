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
#import "MJAnimHeader.h"
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
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
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
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        if (kIs_iPhoneX) {
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-34);
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"historyTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strRes = [dict objectForKey:@"res"];
    NSString *strImg =  [[_arrData objectAtIndex:indexPath.row] objectForKey:@"img"];
    NSString *str = [NSString stringWithFormat:@"%@room/%@",strRes,strImg];
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
    UILabel *labId = [[UILabel alloc] initWithFrame:CGRectMake(57, 37, SCREEN_WIDTH - 80, 12)];
    labId.text = [NSString stringWithFormat:@"ID:%@",[[_arrData objectAtIndex:indexPath.row] objectForKey:@"rId"]];
    labId.textColor =  RGB(110, 110, 110);
    labId.textAlignment = NSTextAlignmentLeft;
    labId.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:labId];
    if (indexPath.row == 0) {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        viewLine.backgroundColor = RGB(223, 223, 223);
        [cell.contentView addSubview:viewLine];
   }
    
    UIButton *btnHide = [[UIButton alloc] init];
    [btnHide setBackgroundColor:MAIN_COLOR];
    [btnHide setTitle:@"隐身" forState:UIControlStateNormal];
    [btnHide setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHide addTarget:self action:@selector(btnHideClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnHide setTag:800+indexPath.row];
    [btnHide setHidden:YES];
    [btnHide.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:btnHide];
    [btnHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 22));
        make.right.equalTo(btnGo.mas_left).offset(-5);
    }];
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    NSArray *arrLevel = @[@"6",@"7",@"8",@"9",@"203",@"204",@"205",@"206",@"207",@"208",@"209",@"210",@"211"];
    NSString *strVipLevel = [NSString stringWithFormat:@"%d",model.viplevel];
    if (model.userID != 0) {
        for (NSString *str in arrLevel) {
            if ([str isEqualToString:strVipLevel]) {
                btnHide.hidden = NO;
            }
        }
    }

    return cell;
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnHideClicked:(UIButton *)button{
    [self getRoomInfo:button.tag - 800 hide:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getRoomInfo:indexPath.row hide:NO];
}

- (void)getRoomInfo:(NSInteger)row hide:(BOOL)hide{
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
                [appDelegate showLiveRoom:NO CameraFront:YES hide:hide];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}


@end
