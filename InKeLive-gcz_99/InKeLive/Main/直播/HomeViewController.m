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




@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIViewController *currentVC;

@end

@implementation HomeViewController{
    NSMutableArray *_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.titleView;
    
    UIImage *leftImg = [UIImage imageNamed:@"home_search"];
    leftImg = [leftImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchClick)];
    
    UIImage *rightImg = [UIImage imageNamed:@"home_record"];
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.view addSubview:self.homeScrollView];
    [self searchView];
    
    [self initChildViewControllers];
//    [self.view addSubview:_searchView];
//    _searchView.hidden = YES;
}

- (void)initChildViewControllers{
    
    //推荐
    RecommendViewController *recommendVC = [[RecommendViewController alloc]init];
    [self addChildViewController:recommendVC];
    
    //手机
//    MobileViewController*mobileVC = [[MobileViewController alloc]init];
//    [self addChildViewController:mobileVC];
    MainViewController*mobileVC = [[MainViewController alloc]init];
    [self addChildViewController:mobileVC];
    
    //房间
    RoomViewController *roomVC = [[RoomViewController alloc]init];
    [self addChildViewController:roomVC];
    
    //客服
    ServiceViewController *serviceVC = [[ServiceViewController alloc] init];
    
    _arr = [NSMutableArray arrayWithObjects:recommendVC,mobileVC,roomVC,serviceVC,nil];
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


#pragma  加载
- (TopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[TopTitleView alloc]initWithFrame:CGRectMake(0, 0, 240, 44)];
        WEAKSELF;
        [_titleView setTitleClick:^(NSInteger tag) {
            CGPoint point = CGPointMake((tag - 50) * SCREEN_WIDTH ,weakSelf.homeScrollView.contentOffset.y);
            
            [weakSelf.homeScrollView setContentOffset:point animated:YES];
        }];
    }
    return _titleView;
}

- (UIScrollView *)homeScrollView{
    if (!_homeScrollView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _homeScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds]; //当前内容区域大小
        _homeScrollView.contentSize = CGSizeMake(4 * SCREEN_WIDTH, 0); //4个屏幕宽度
        _homeScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);  //一次性移动多少??
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.bounces = NO;
        _homeScrollView.delegate = self;
        _homeScrollView.userInteractionEnabled = YES;
        _homeScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _homeScrollView;
}

@end
