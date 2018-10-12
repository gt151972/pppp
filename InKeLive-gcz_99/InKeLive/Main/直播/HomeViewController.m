//
//  HomeViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"
//#import "AttentionController.h"
//#import "NearbyController.h"
#import "RecommendViewController.h"
#import "MobileViewController.h"
#import "RoomViewController.h"
#import "ServiceViewController.h"
#import "BaseViewController.h"
#import "SearchViewController.h"
#import "HistoryViewController.h"
#import "GTAFNData.h"


@interface HomeViewController ()<UIScrollViewDelegate, GTAFNDataDelegate>
@property (nonatomic, strong)NSArray *arrayTitle;

@end

@implementation HomeViewController{
    NSMutableArray *_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayTitle = [NSArray array];
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data MainListGroup];
    // Do any additional setup after loading the view.
    
    
    UIImage *leftImg = [UIImage imageNamed:@"home_search"];
    leftImg = [leftImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchClick)];
    
    UIImage *rightImg = [UIImage imageNamed:@"home_record"];
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(btnHistoryClicked)];
     [self.view addSubview:self.homeScrollView];
    
    [self searchView];
    
    
//    [self.view addSubview:_searchView];
//    _searchView.hidden = YES;
}

- (void)initChildViewControllers:(NSArray *)arrayData{
    
    
    
    //手机
//    MobileViewController*mobileVC = [[MobileViewController alloc]init];
//    [self addChildViewController:mobileVC];
//
//
//    //房间
//    RoomViewController *roomVC = [[RoomViewController alloc]init];
//    [self addChildViewController:roomVC];
//
//    //客服
//    ServiceViewController *serviceVC = [[ServiceViewController alloc] init];
//    [self addChildViewController:serviceVC];
    _arr = [NSMutableArray array];
    for (int index = 0; index < _arrayTitle.count; index ++) {
        //推荐
        MainViewController*mainVC = [[MainViewController alloc]init];
        mainVC.tag = 500+index;
        mainVC.arrData = arrayData;
        [self addChildViewController:mainVC];
        [_arr addObject:mainVC];
    }
    for (NSInteger i=0; i<self.childViewControllers.count; i++) {
        //调成子VC中view(root_view)的位置，然后都加入到scrollView中
        UIViewController *cls = self.childViewControllers[i];
        cls.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49 - 64);
        [self.homeScrollView addSubview:cls.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.titleView scrollMove:(scrollView.contentOffset.x/SCREEN_WIDTH + 50)];
}
//搜索栏
- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:self.view.bounds];
    }
    return _searchView;
}

- (void)enterSearchClick{
    [_searchView popToView];
}

- (void)btnHistoryClicked{
    HistoryViewController *historyVC = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}


#pragma  加载
- (TopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[TopTitleView alloc]initWithFrame:CGRectMake(0, 0, 240, 44)];
        NSMutableArray *array = [NSMutableArray array];
        for (int index = 0; index<_arrayTitle.count; index++) {
            [array addObject:[[_arrayTitle objectAtIndex:index] objectForKey:@"title"]];
        }
        self.titleView.titleArr = array;
        [self.titleView CreatUI];
        WEAKSELF;
        [_titleView setTitleClick:^(NSInteger tag, NSInteger lastTag) {
            CGPoint point = CGPointMake((tag - 50) * SCREEN_WIDTH ,weakSelf.homeScrollView.contentOffset.y);
            [weakSelf.homeScrollView setContentOffset:point animated:YES];
            UIButton *button1 = (UIButton *)[_titleView viewWithTag:lastTag];
            UIButton *button2 = (UIButton *)[_titleView viewWithTag:tag];
            button1.selected = NO;
            button2.selected = YES;
        }];
//        [_titleView setBtnTitleClicked:^(NSInteger tag) {
//            GTAFNData *data = [[GTAFNData alloc] init];
//            data.delegate = weakSelf;
//            NSString *key = [[weakSelf.arrayTitle objectAtIndex:(tag - 50)] objectForKey:@"key"];
//            [data mainListData:key];
//        }];
        
    }
    return _titleView;
}

- (UIScrollView *)homeScrollView{
    if (!_homeScrollView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _homeScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds]; //当前内容区域大小
        _homeScrollView.contentSize = CGSizeMake(4 * SCREEN_WIDTH, 0); //4个屏幕宽度
        _homeScrollView.contentOffset = CGPointMake(0, 0);  //一次性移动多少??
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.bounces = NO;
        _homeScrollView.delegate = self;
        _homeScrollView.userInteractionEnabled = YES;
        _homeScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _homeScrollView;
}

- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_MAINLIST_GROUP]) {
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            self.arrayTitle = data[@"List"];
           self.navigationItem.titleView = self.titleView;
            [self initChildViewControllers:self.arrayTitle];
        }else{
            [[GTAlertTool shareInstance] showAlert:@"网络异常" message:@"请重新请求" cancelTitle:@"确认" titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                GTAFNData *data = [[GTAFNData alloc] init];
                data.delegate = self;
                [data MainListGroup];
            }];
        }
    }else if ([cmd isEqualToString:CMD_RECOMMEND_ROOM_LIST]){
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
        }
    }
}

@end
