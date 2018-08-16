
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


@interface MainViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
//    UITableViewCell *cell;
}
//数据源
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *mainTableView;
@property(nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIView *headView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.mainTableView.mj_header = header;
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

/**
 请求直播间数据(当有两部手机时，一个创建开启直播，另一个就能获取到直播间数据，点击进入直播页，则为直播数据，否则为假数据)
 */
- (void)getData{
    //网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"0" forKey:@"startPos"];
    [parameters setObject:@"100" forKey:@"pageCount"];
     [self showLoadingHud];
    WEAKSELF;
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_HotPlayerList];
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do nothing
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        if(weakSelf !=nil) {
            [weakSelf hideLoadingHud];
            NSDictionary *appDic =(NSDictionary*)responseObject;
            NSString* errorCode= appDic[@"errorCode"];
            NSString* errorMsg = appDic[@"errorMsg"];
            
            if([errorCode isEqualToString:@"0"]) {
                
                NSArray* item_arr = (NSArray*)appDic[@"data"];
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
//                    NSLog(@"%@", dic2);
                }
            }
            
            [weakSelf.mainTableView reloadData];
            [weakSelf.mainTableView.mj_header endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(weakSelf !=nil)
        [weakSelf hideLoadingHud];
        [weakSelf.mainTableView.mj_header endRefreshing];
    }];
}

- (void)loadData{
    //刷新数据
     [self getData];
    
}

#pragma   UITableViewDataSource  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifierId = @"InKeCellId";
    InKeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (cell == nil) {
        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
    }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InKeModel *model = [self.dataArr objectAtIndex:indexPath.row];
        [cell updateCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //LiveViewController *live = [[LiveViewController alloc]init];
    //[live initURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"] fileList:nil];
    //if (self.livingDataArray.count > 0) {
    //    //默认只开启一个直播（开启多个可自行判断添加）
    //    LivingItem *item = [self.livingDataArray objectAtIndex:0];
    //    live.livingItem = item;
    //}
    //[self.navigationController pushViewController:live animated:YES];
    
    InKeModel *model = [self.dataArr objectAtIndex:indexPath.row];
    TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    [joinRoomInfo reset];
    joinRoomInfo.roomId = model.roomId;
    joinRoomInfo.lookUserId = model.userId;
    joinRoomInfo.roomName = model.roomName;
    [joinRoomInfo setGateAddr:model.gateAddr]; //6位地址
    
    //测试代码 testcode
    NSLog(@"加入房间信息, model.roomId=%d, joinRoomInfo.roomId=%d", model.roomId, joinRoomInfo.roomId);

    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([DPK_NW_Application sharedInstance].isLogon == NO) {
        [appDelegate doLogon];
        return;
    }else {
        [appDelegate showLiveRoom:NO CameraFront:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headView = [[UIView alloc] init];
    [self viewpager];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 78*SCREEN_WIDTH/320;
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
    return @[
             @"http://b.hiphotos.baidu.com/image/pic/item/d52a2834349b033bda94010519ce36d3d439bdd5.jpg",
             @"http://h.hiphotos.baidu.com/image/pic/item/5243fbf2b2119313b705987069380cd790238daf.jpg",
             @"http://h.hiphotos.baidu.com/image/pic/item/267f9e2f07082838304837cfb499a9014d08f1a0.jpg"
             ];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    self.mainTableView.dataSource = nil;
    self.mainTableView.delegate = nil;
}

@end
