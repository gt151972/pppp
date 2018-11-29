
//  MainViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
// 热门

#import "MainViewController.h"
#import "NetWorkTools.h"
#import "InKeCell.h"
#import "InKeModel.h"
#import "LiveViewController.h"
#import "NetUtils.h"
#import "MJAnimHeader.h"
#import "BaseViewController.h"

#import "NSString+Common.h"
#import <AFNetworking.h>
#import "MBProgressHUD+MJ.h"
#import "CommonAPIDefines.h"

#import "DPK_NW_Application.h"
#import "SDCycleScrollView.h"
#import "CommonAPIDefines.h"
#import "GTAFNData.h"
#import <Reachability.h>
@interface MainViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, GTAFNDataDelegate>
{
//    UITableViewCell *cell;
    BOOL ishide;
}
//数据源
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *mainTableView;
@property(nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic, strong)NSArray *array;
@property (nonatomic, strong)NSArray *arrayBanner;
@property (nonatomic, strong)InKeModel *roomObj;
@property (nonatomic, strong)TempJoinRoomInfo* joinRoomInfo;
@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_mainTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"tag == %d",_tag);
    self.view.backgroundColor = [UIColor blueColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"isNotReachable" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"noNotReachable" object:nil];

    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.mainTableView.mj_header = header;
}
-(void)changeColor:(NSNotification *)notification{
    NSString *str = @"0";
    if([str isEqualToString:notification.userInfo[@"status"]]) {
        self.view.backgroundColor = [UIColor redColor];
    }else{
        self.view.backgroundColor = [UIColor yellowColor];
    }
}


- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == NotReachable) {
        NSDictionary *dic = @{@"status":@"0"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isNotReachable" object:nil userInfo:dic];
    }else{
        NSDictionary *dic = @{@"status":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noNotReachable" object:nil userInfo:dic];
    }
}

-(void)showLoadingHud {
    //======================
    //圆形进度条
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.hud = [[MBProgressHUD alloc]initWithFrame:frame];
    //全屏禁止
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    //[self.view addSubview:hud];
    //当前view背景颜色暗下去
    self.hud.minShowTime= 10000;
    self.hud.dimBackground =YES;
    self.hud.labelText = @"获取数据...";
    [self.hud showAnimated:YES whileExecutingBlock:^{
        //sleep(2);
    } completionBlock:^{
        //[hud removeFromSuperview];
    }];
    //=====================
}

-(void)hideLoadingHud {
    [self.hud removeFromSuperview];
}
-(void)getMainList{
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    NSString *key = [[_arrData objectAtIndex:self.tag - 500] objectForKey:@"key"];
    [data mainListData:key];
}

/**
 请求直播间数据(当有两部手机时，一个创建开启直播，另一个就能获取到直播间数据，点击进入直播页，则为直播数据，否则为假数据)
 */
- (void)getData{
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"0" forKey:@"startPos"];
    [parameters setObject:@"100" forKey:@"pageCount"];
     [self showLoadingHud];
    WEAKSELF;
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_HotPlayerList];
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success: %@", responseObject);
        if(weakSelf !=nil) {
            [weakSelf hideLoadingHud];
            NSDictionary *appDic =(NSDictionary*)responseObject;
            NSString* errorCode= appDic[@"errorCode"];
            NSString* errorMsg = appDic[@"errorMsg"];
            
            if([errorCode isEqualToString:@"0"]) {
                
                NSArray* item_arr = (NSArray*)appDic[@"data"];
                _array = [NSArray arrayWithArray:item_arr];
                NSLog(@"item count:%lu", (unsigned long)item_arr.count);
                [self.dataArr removeAllObjects];
                
                for(NSDictionary* dic2 in item_arr) {
                    InKeModel* inkItem = [[InKeModel alloc]init];
                    inkItem.roomId = [dic2[@"room_id"] intValue];
                    inkItem.userId =[dic2[@"user_id"] intValue];
                    inkItem.roomUserCount = [dic2[@"room_usercount"] intValue];
                    inkItem.roomPic = dic2[@"room_pic"];
                    inkItem.userstarPic = dic2[@"user_starpic"];
                    inkItem.roomName = dic2[@"room_name"];
                    inkItem.userAlias =dic2[@"user_alias"];
                    inkItem.gateAddr = dic2[@"room_gateaddr"];
                    inkItem.roomAttrId = [dic2[@"room_attrid"] intValue];
                    inkItem.roomCreatorId = [dic2[@"room_creatorid"] intValue];
                    if(inkItem.userId !=0)
                        inkItem.modelType =1;
                    else
                        inkItem.modelType =2;
                    //
                    [self.dataArr addObject:inkItem];
                }
            }
            
            [weakSelf.mainTableView reloadData];
            [weakSelf.mainTableView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if(weakSelf !=nil)
            [weakSelf hideLoadingHud];
        [weakSelf.mainTableView.mj_header endRefreshing];
    }];
}

- (void) getBanner{
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_BANNER;
    parameters[@"flag"] = IOS_REQUEST_FLAG;
    NSString* strAPIUrl = URL_GiftInfo;
    NSLog(@"url:%@", strAPIUrl);
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSLog(@"task: %@",task);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        if ([appDic[@"code"] intValue] == 0) {
            _arrayBanner = [NSArray arrayWithArray:appDic[@"List"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

-(void)getRecommendList{
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data RecommendRoom];
}

- (void)loadData{
    //刷新数据
//    [self getData];
    
    [self getMainList];
    [self getBanner];
}

#pragma   UITableViewDataSource  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
//    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifierId = @"InKeCellId";
    InKeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
//    if (cell == nil) {
//        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
//    }
        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InKeModel *model = [self.dataArr objectAtIndex:indexPath.row];
        [cell updateCell:model];
    [cell setBtnHideClicked:^{
        [self goRoom:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.roomObj = [self.dataArr objectAtIndex:indexPath.row];
    ishide = NO;
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data getRoomInfoWithRid:[NSString stringWithFormat:@"%d",_roomObj.roomId]];

    //LiveViewController *live = [[LiveViewController alloc]init];
    //[live initURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"] fileList:nil];
    //if (self.livingDataArray.count > 0) {
    //    //默认只开启一个直播（开启多个可自行判断添加）
    //    LivingItem *item = [self.livingDataArray objectAtIndex:0];
    //    live.livingItem = item;
    //}
    //[self.navigationController pushViewController:live animated:YES];
    self.joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    [self.joinRoomInfo reset];
    self.joinRoomInfo.isHide = NO;
    self.joinRoomInfo.roomId = _roomObj.roomId;
    self.joinRoomInfo.lookUserId = _roomObj.userId;
    self.joinRoomInfo.roomName = _roomObj.roomName;
    self.joinRoomInfo.dicRoomInfo = [_array objectAtIndex:indexPath.row];
    NSLog(@"dicRoomInfo == %@",self.joinRoomInfo.dicRoomInfo);

    
}
- (void)goRoom:(NSIndexPath *)indexPath{
    NSLog(@"goroom");
    ishide = YES;
    self.roomObj = [self.dataArr objectAtIndex:indexPath.row];
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data getRoomInfoWithRid:[NSString stringWithFormat:@"%d",_roomObj.roomId]];
    
    //LiveViewController *live = [[LiveViewController alloc]init];
    //[live initURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"] fileList:nil];
    //if (self.livingDataArray.count > 0) {
    //    //默认只开启一个直播（开启多个可自行判断添加）
    //    LivingItem *item = [self.livingDataArray objectAtIndex:0];
    //    live.livingItem = item;
    //}
    //[self.navigationController pushViewController:live animated:YES];
    self.joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    [self.joinRoomInfo reset];
    self.joinRoomInfo.isHide = YES;
    self.joinRoomInfo.roomId = _roomObj.roomId;
    self.joinRoomInfo.lookUserId = _roomObj.userId;
    self.joinRoomInfo.roomName = _roomObj.roomName;
    self.joinRoomInfo.dicRoomInfo = [_array objectAtIndex:indexPath.row];
    NSLog(@"dicRoomInfo == %@",self.joinRoomInfo.dicRoomInfo);

}



- (void)writeData{
    
    
////    //获取应用程序沙盒的Documents目录
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"test.plist"];
//    //输入写入
//    [data writeToFile:filename atomically:YES];
//
//    //那怎么证明我的数据写入了呢？读出来看看
//    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
//    NSLog(@"%@", data1);
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headView = [[UIView alloc] init];
    [self viewpager];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 78*SCREEN_WIDTH/320;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 78*SCREEN_WIDTH/320;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}

#pragma 加载
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-113) style:UITableViewStylePlain];
        _mainTableView.delegate  = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = SCREEN_WIDTH*245/312 + 51;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _mainTableView;
}

- (void)viewpager{
    // 网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78*SCREEN_WIDTH/320) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    cycleScrollView2.titlesGroup = titles;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [_headView addSubview:_cycleScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_cycleScrollView setImageURLStringsGroup:[self imagesURLStrings]];
    });
    
    //     block监听点击方式
    
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        NSLog(@">>>>>  %ld", (long)index);
    };
    
    
}
/**
 轮播图数组
 
 @return <#return value description#>
 */
- (NSArray *)imagesURLStrings{
    NSMutableArray *array = [NSMutableArray array];
    NSArray*array2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array2[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    for (int index = 0; index < _arrayBanner.count; index ++ ) {
        NSString *strImagePath = [NSString stringWithFormat:@"%@web/%@",[dict objectForKey:@"res"], [[_arrayBanner objectAtIndex:index] objectForKey:@"img"]];
        [array addObject:strImagePath];
    }
    return array;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark GTAFNDataDelegate
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_RECOMMEND_ROOM_LIST]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            NSArray* item_arr = (NSArray*)data[@"List"];
            _array = [NSArray arrayWithArray:item_arr];
            NSLog(@"item count:%lu", (unsigned long)item_arr.count);
            [self.dataArr removeAllObjects];
            NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString*cachePath = array[0];
            NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
            NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
            NSString *strRes = [dict objectForKey:@"res"];
            for(NSDictionary* dic2 in item_arr) {
                InKeModel* inkItem = [[InKeModel alloc]init];
                inkItem.roomId = [dic2[@"rId"] intValue];
                inkItem.userId =[dic2[@"uId"] intValue];
                inkItem.roomUserCount = [dic2[@"online"] intValue];
                inkItem.roomPic = [NSString stringWithFormat:@"%@room/%@",strRes,dic2[@"img"]];
                inkItem.userstarPic = [NSString stringWithFormat:@"%@room/%@",strRes,dic2[@"img"]];
                inkItem.roomName = dic2[@"Title"];
                if(inkItem.userId !=0)
                    inkItem.modelType =1;
                else
                    inkItem.modelType =2;
                [self.dataArr addObject:inkItem];
            }
        
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        }else{
            NSLog(@"msg == %@",[data objectForKey:@"msg"]);
        }
    }else if ([cmd isEqualToString:CMD_REQUEST_ADDTESS]){
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            [self.joinRoomInfo setGateAddr:data[@"GateAddr"]]; //6位地址

            //测试代码 testcode
            NSLog(@"加入房间信息, model.roomId=%d, joinRoomInfo.roomId=%d", _roomObj.roomId, _joinRoomInfo.roomId);

            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if([DPK_NW_Application sharedInstance].isLogon == NO) {
                [appDelegate doLogon];
                return;
            }else {
                [appDelegate showLiveRoom:NO CameraFront:YES hide:ishide];
            }
        }else{
            NSLog(@"msg == %@",[data objectForKey:@"msg"]);
        }
    }
}

- (void)dealloc{
    self.mainTableView.dataSource = nil;
    self.mainTableView.delegate = nil;
}

@end
