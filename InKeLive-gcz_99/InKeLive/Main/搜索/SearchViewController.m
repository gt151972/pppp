//
//  SearchViewController.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SearchViewController.h"
#import "NetWorkTools.h"
#import "RecommendModel.h"
#import "MJExtension.h"
#import "LiveViewController.h"
#import "MoreViewController.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "SearchModel.h"

#import "AppDelegate.h"

@class User_Nodes,Users,User,Live_Nodes,Lives,Creator;

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *btnSearch;
@property (nonatomic, strong) NSMutableArray *arrayInfo;
@end

@implementation SearchViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        _arrayInfo = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchView;  //设置titleView
    [self.searchView addSubview:self.btnSearch];
    [self.view addSubview:self.recommdTableView];
    [self loadData];
}


- (void)loadData{
    [[NetWorkTools shareInstance]getWithURLString:SEARCHURL parameters:nil success:^(NSDictionary *dictionary) {
        //直接由json数据变成Object
        RecommendModel *model = [RecommendModel mj_objectWithKeyValues:dictionary];
        for (NSInteger i = 0; i < model.live_nodes.count; i++) {
            [self.sectionTitleArr addObject:model.live_nodes[i].title];   //几个secition抬头?
            [self.dataArr addObject:model.live_nodes[i]];
        }
        //今日推荐
        for (NSInteger i = 0; i < model.user_nodes[0].users.count; i++) {
            [self.recommdArr addObject:model.user_nodes[0].users[i]];
        }
        [self.recommdTableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //section中的num数目，除了最后一个是"今日推荐"若干条,其他只有横向一条
    return section == self.sectionTitleArr.count ? self.recommdArr.count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //titleArr的数组+1(今日推荐)
    return self.sectionTitleArr.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //每个Section的HeadView,并设置内容
    _recommendView = [[[NSBundle mainBundle]loadNibNamed:@"RecommendView" owner:self options:nil]lastObject];
    if (self.sectionTitleArr.count > 0) {
        if (section < self.sectionTitleArr.count) {
            _recommendView.recommedTitle.text = self.sectionTitleArr[section];
        } else {
            _recommendView.recommedTitle.text = @"今日推荐";
            _recommendView.recommendButton.hidden = YES;
        }
    }
    
    WEAKSELF;
    [_recommendView setRecommdMoreClick:^(NSString *keyStr) {
        MoreViewController *moreVc = [[MoreViewController alloc]init];
        moreVc.keywordStr = keyStr;
        [weakSelf.navigationController pushViewController:moreVc animated:YES];
    }];
    
    return _recommendView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == self.sectionTitleArr.count ? 60 : 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.sectionTitleArr.count){
        //好声音、小清新、搞笑达人
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:0].lastObject;
        }
        Live_Nodes *model = self.dataArr[indexPath.section];
        [cell updataCell:model];  //模型中有3个数据
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        //今日推荐
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCellID"];
        cell.addButton.tag = indexPath.row;
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RecommendCell" owner:self options:0].lastObject;
        }
        
        [cell setPayAttenBlock:^(NSInteger row) {
            //向服务器发起关注、取消关注请求
            //......
            
            //获取Users 改变 relation 刷新某一行状态
            Users *userModel = self.recommdArr[indexPath.row];
            if (userModel.relation.length == 0) {
                userModel.relation = @"following";
            } else {
                userModel.relation = @"";
            }
            
            //刷新点击关注、取消关注的那一行
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:self.sectionTitleArr.count];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        Users *userModel = self.recommdArr[indexPath.row];
        [cell updataCell:userModel.user relation:userModel.relation];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != self.sectionTitleArr.count) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showLiveRoom:NO CameraFront:FALSE];
        
        //LiveViewController *liveVC = [[LiveViewController alloc]init];
        //[liveVC initURL:[NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"] fileList:nil];
        //[self.navigationController pushViewController:liveVC animated:YES];
    }
}

#pragma 加载
- (UITableView *)recommdTableView{
    if (!_recommdTableView) {
        //带分组信息的UITableView
        _recommdTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _recommdTableView.delegate = self;
        _recommdTableView.dataSource = self;
        _recommdTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //没有间隔线
        [_recommdTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCellId"];
        [_recommdTableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"RecommendCellID"];
    }
    return _recommdTableView;
}

//搜索栏
- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        WEAKSELF;
        [_searchView setCancleBlock:^{
            //关闭键盘,销毁当前窗口
            [AutoCommon hideKeyBoard];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _searchView;
}

- (UIButton *)btnSearch{
    _btnSearch  = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 20)];
    [_btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [_btnSearch setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    return _btnSearch;
}

- (void)requestData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"cmd"] = CMD_REQUEST_SEARCH;
    parameters[@"uid"] = @"1259";
    parameters[@"sid"] = @"";
    parameters[@"rid"] = @"0";
    parameters[@"info"] = @"177777";
    NSString* strAPIUrl = URL_GiftInfo;
    [manager POST:strAPIUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response == %@",responseObject);
        NSArray *array = [responseObject objectForKey:@"List"];
        for (NSDictionary *dic in array) {
            SearchModel *model = [[SearchModel alloc] init];
            model.title = [dic objectForKey:@"Title"];
            model.img = [dic objectForKey:@"img"];
            model.mLevel = [[dic objectForKey:@"mLevel"] intValue];
            model.max = [[dic objectForKey:@"max"] intValue];
            model.online = [[dic objectForKey:@"online"] intValue];
            model.rId = [[dic objectForKey:@"rId"] intValue];
            model.uId = [[dic objectForKey:@"uId"] intValue];
            [_arrayInfo addObject:model];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//标题数组
- (NSMutableArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr = [NSMutableArray array];
    }
    return _sectionTitleArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

//今日热门
- (NSMutableArray *)recommdArr{
    if (!_recommdArr) {
        _recommdArr = [NSMutableArray array];
    }
    return _recommdArr;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
