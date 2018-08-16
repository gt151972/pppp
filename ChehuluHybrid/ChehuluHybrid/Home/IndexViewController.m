       //
//  IndexViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/6/6.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "IndexViewController.h"
#import "HomeBusView.h"
#import "HomeAdView.h"
#import "HomeBuyTypeView.h"
#import "HomeGoodsView.h"
#import "HomeShopView.h"
#import "HomePartnerView.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "CarLocationViewController.h"
//#import "CarLocationViewController.h"
@interface IndexViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>{
    NSArray *arrayAdvertisement;//轮播页数据
    UIImageView *imageHeadBar;
    UIButton *btnRight;//杭州市
    
    NSArray *arrayLcnNo;//车牌
    NSArray *arrayCarList;//车牌数组
    NSMutableArray *arrayAllCarList; //车辆列表总数据
    HomeBusView *busView;
    NSArray *arrayBus;
    HomeAdView *adView;
    NSArray *arrayAd;
    HomeBuyTypeView *typeView;
    NSArray *arrayType;
    HomeGoodsView *goodsView;
    NSArray *arrayGoods;
    HomeShopView *shopView;
    NSArray *arrayShop;
    HomePartnerView *partnerView;
    NSArray *arrayPartner;
    NSDictionary *dicProfitCarInfo;
    int type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectView1;
@property (strong, nonatomic) CLLocationManager *lacationManage;
@end
@implementation IndexViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"Location = %@",gtLocation);
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL loginToken];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNoti:) name:@"DefaultCar" object:nil];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self initData];
    [self initView];
    
}
- (void)initData{
    arrayLcnNo = [[NSArray alloc] init];
    arrayCarList = [[NSArray alloc] init];
    arrayAllCarList = [[NSMutableArray alloc] init];
    busView = [[HomeBusView alloc] init];
    arrayBus = [[NSArray alloc]init];
    adView = [[HomeAdView alloc] init];
    arrayAd = [[NSArray alloc] init];
    typeView = [[HomeBuyTypeView alloc] init];
    arrayType = [[NSArray alloc] init];
    goodsView = [[HomeGoodsView alloc] init];
    arrayGoods = [[NSArray alloc] init];
    shopView = [[HomeShopView alloc] init];
    arrayShop = [[NSArray alloc] init];
    partnerView = [[HomePartnerView alloc] init];
    arrayPartner = [[NSArray alloc] init];
    dicProfitCarInfo = [[NSDictionary alloc] init];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, gtWIDTH,gtHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"IndexTableViewCell"];
    [self.view addSubview:self.tableView];
    imageHeadBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 20)];
    imageHeadBar.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.view addSubview:imageHeadBar];
}



- (void)returnNoti:(NSNotification *)notification{
    NSLog(@"object == %@",notification.object);
    if ([notification.name isEqualToString:@"DefaultCar"]) {
        [self initData];
        [self initView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath *path =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    if (_tableView.contentOffset.y <= 0) {
        _tableView.bounces = NO;
    }
    if (path.section == 0 && path.row == 0) {
        [imageHeadBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }else{
        [imageHeadBar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//头
            if ([dicProfitCarInfo count] == 0) {
                return 190;
            }else{
                return 243;
            }
        }else if (indexPath.row == 1){//模块
            return 103;
        }else{//轮播
            if (arrayAd.count == 0) {
                return 0;
            }else{
               return 100;
            }
        }
    }else if (indexPath.section == 1){//险种
        if (arrayType.count == 0) {
            return 0;
        }else if (arrayType.count < 3){
            return 100;
        }else{
            return 200;
        }
    }else if (indexPath.section == 2){//商品
        if (arrayGoods.count == 0) {
            return 0;
        }else{
            if (indexPath.row == 0) {
                return 40;
            }else{
                return 166;
            }
        }
    }else if (indexPath.section == 3){//店铺
        if (arrayShop.count == 0) {
            return 0;
        }else{
            if (indexPath.row == 0) {
                return 40;
            }else{
                return 145;
            }
        }
    }else{
        if (arrayPartner.count == 0) {
            return 0;
        }else{
            if (indexPath.row == 0) {//合作伙伴
                return 40;
            }else{
                return 109;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else{
//         return 8;
//    }
    if (section == 0) {
        return 0;
    }else if (section == 1){//险种
        if (arrayType.count == 0) {
            return 0;
        }else {
            return 8;
        }
    }else if (section == 2){//商品
        if (arrayGoods.count == 0) {
            return 0;
        }else{
            return 8;
        }
    }else if (section == 3){//店铺
        if (arrayShop.count == 0) {
            return 0;
        }else{
            return 8;
        }
    }else{
        if (arrayPartner.count == 0) {
            return 0;
        }else{
            return 8;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        [tableView removeObjectAtIndex:indexPath.row];
////        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
////        [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"Bookmarks"];
////        [self.tableView reloadData];
//    }
//}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"热门商品", @"优质店铺",  @"合作伙伴", nil];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 190)];
            if ([[dicProfitCarInfo objectForKey:@"ptype"] intValue] == 3 || [[dicProfitCarInfo objectForKey:@"ptype"] intValue] == 4) {
                imageViewBg.frame = CGRectMake(0, 0, gtWIDTH, 243);
            }
            imageViewBg.image = [UIImage imageNamed:@"homeBg"];
            [cell.contentView addSubview:imageViewBg];
            
            UIButton *btnSearchCar = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, 40, 40)];
            UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            animatedImageView.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"1"],
                                                 [UIImage imageNamed:@"2"],
                                                 [UIImage imageNamed:@"3"],
                                                 [UIImage imageNamed:@"4"],
                                                 [UIImage imageNamed:@"5"],
                                                 [UIImage imageNamed:@"6"],
                                                 [UIImage imageNamed:@"7"],
                                                 [UIImage imageNamed:@"8"],
                                                 [UIImage imageNamed:@"9"],
                                                 [UIImage imageNamed:@"10"],
                                                 [UIImage imageNamed:@"11"],
                                                 [UIImage imageNamed:@"12"],
                                                 [UIImage imageNamed:@"13"],nil];
            animatedImageView.animationDuration = 1.0f;
            animatedImageView.animationRepeatCount = 0;
            [animatedImageView startAnimating];
            [btnSearchCar addSubview: animatedImageView];
            [btnSearchCar setTag:203];
            [btnSearchCar addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnSearchCar];
            
            
            UIImage*imgGo = [UIImage imageNamed:@"btnGo"];
            UIImageView *imageGo = [[UIImageView alloc] initWithImage:imgGo];
            imageGo.frame = CGRectMake(gtWIDTH - 16, 37, 7, 12);
//            imageGo.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:imageGo];
//            [imageGo mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(imgGo.size);
//                make.top.mas_equalTo(37);
//                make.right.mas_equalTo(16);
//            }];
            
            UIButton *btnLogo = [[UIButton alloc] init];
            [cell.contentView addSubview:btnLogo];
            [btnLogo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.top.mas_equalTo(61);
            }];
            UIButton *btnCarNo = [[UIButton alloc] init];
            [btnCarNo.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [btnCarNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnCarNo];
            [btnCarNo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnLogo.mas_bottom);
                make.centerX.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(120, 30));
            }];
            if (gtCarInfo) {
                if (![[gtCarInfo objectForKey:@"brand_logo"] isEqualToString:@""]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage *image = [super getImageForUrl:[gtCarInfo objectForKey:@"brand_logo"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btnLogo setImage:image forState:UIControlStateNormal];
                        });   
                    });
                   
                }else{
                    [btnLogo setBackgroundImage:[UIImage imageNamed:@"carDefault"] forState:UIControlStateNormal];
                }
                btnCarNo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btnCarNo setImage:[UIImage imageNamed:@"btnPullDown"] forState:UIControlStateNormal];
                [btnCarNo setTitle:[gtCarInfo objectForKey:@"car_no"] forState:UIControlStateNormal];
                [btnCarNo setTag:202];
                [btnCarNo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btnLogo setImage:[UIImage imageNamed:@"chooseCar"] forState:UIControlStateNormal];
                [btnCarNo setTitle:@"添加车辆" forState:UIControlStateNormal];
                [btnLogo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //里程宝环境吧数据
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 170, gtWIDTH/2, 73)];
            [cell.contentView addSubview:view];
            UILabel *labData = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, gtWIDTH/2, 16)];
            labData.textColor = [UIColor whiteColor];
            labData.font = [UIFont systemFontOfSize:12];
            labData.textAlignment = NSTextAlignmentCenter;
            [view addSubview:labData];
            UILabel *labDataDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, gtWIDTH/2, 18)];
            labDataDetail.textColor = [UIColor whiteColor];
            labDataDetail.font = [UIFont systemFontOfSize:18];
            labDataDetail.textAlignment = NSTextAlignmentCenter;
            [view addSubview:labDataDetail];
            
            UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/2, 170, gtWIDTH/2, 73)];
            [cell.contentView addSubview:view2];
            UILabel *labData2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, gtWIDTH/2, 16)];
            labData2.textColor = [UIColor whiteColor];
            labData2.font = [UIFont systemFontOfSize:12];
            labData2.textAlignment = NSTextAlignmentCenter;
            [view2 addSubview:labData2];
            UILabel *labDataDetail2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, gtWIDTH/2, 18)];
            labDataDetail2.textColor = [UIColor whiteColor];
            labDataDetail2.font = [UIFont systemFontOfSize:18];
            labDataDetail2.textAlignment = NSTextAlignmentCenter;
            [view2 addSubview:labDataDetail2];
            
            if ([[dicProfitCarInfo objectForKey:@"ptype"] intValue] == 4) {
                labData.text = @"本月里程";
                labDataDetail.text = [NSString stringWithFormat:@"%@",[[dicProfitCarInfo objectForKey:@"mile_info"] objectForKey:@"mileage"]];
                labData2.text = @"预计收益";
                labDataDetail2.text = [NSString stringWithFormat:@"%@",[[dicProfitCarInfo objectForKey:@"mile_info"] objectForKey:@"profit"]];
            }else if ([[dicProfitCarInfo objectForKey:@"ptype"] intValue] == 4) {
                labData.text = @"停车天数";
                labDataDetail.text = [NSString stringWithFormat:@"%@",[[dicProfitCarInfo objectForKey:@"envir_info"] objectForKey:@"stop_num"]];
                labData2.text = @"已获收益";
                labDataDetail2.text = [NSString stringWithFormat:@"%@",[[dicProfitCarInfo objectForKey:@"envir_info"] objectForKey:@"profit"]];
            }
            
        }else if (indexPath.row == 1){
            if (arrayBus.count != 0) {
                [busView showViewWithView:cell.contentView array:arrayBus];
            }else{
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 103)];
                
                //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
                scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 190);
                scrollView.tag = 801;
                //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
                scrollView.pagingEnabled = YES;
                scrollView.bounces = NO;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.delegate = self;
                //            //在UIScrollView 上加入 UIImageView
                //            for (int i = 0 ; i < 4; i ++) {
                //                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, 103)];
                //                //将要加载的图片放入imageView 中
                //                UIImage *image = [UIImage imageNamed:@"mineBg"];
                //                imageView.image = image;
                //                [_scrollView addSubview:imageView];
                //            }
                UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 103)];
                page.numberOfPages = 2;
                page.tag = 701;
                [cell.contentView addSubview:scrollView];
                [cell.contentView addSubview:page];
                //
                UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
                flowLayout.minimumInteritemSpacing = 0;//间距
                flowLayout.minimumLineSpacing = 1;
                self.collectView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH , 103) collectionViewLayout:flowLayout];
                self.automaticallyAdjustsScrollViewInsets = false;
                self.collectView1.delegate = self;
                self.collectView1.dataSource = self;
                self.collectView1.scrollEnabled = NO;
                self.collectView1.tag = 401;
                [self.collectView1 setBackgroundColor:[UIColor whiteColor]];
                [self.collectView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gtIndexOneCollectionViewCell"];
                [cell.contentView addSubview:self.collectView1];

            }
        }else{
            if (arrayAd.count != 0) {
                [adView showViewWithView:cell.contentView array:arrayAd];
            }else{
                [self advertisementView:cell];
            }
        }
    }else if (indexPath.section == 1){
        //车险种类
//        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//        flowLayout.minimumInteritemSpacing = 0;//间距
//        flowLayout.minimumLineSpacing = 1;
//        self.collectView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH , 200) collectionViewLayout:flowLayout];
//        self.automaticallyAdjustsScrollViewInsets = false;
//        self.collectView1.delegate = self;
//        self.collectView1.dataSource = self;
//        self.collectView1.scrollEnabled = NO;
//        self.collectView1.tag = 402;
//        [self.collectView1 setBackgroundColor:COLOR_BG_GRAY2];
//        [self.collectView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gtIndexTwoCollectionViewCell"];
//        [cell.contentView addSubview:self.collectView1];
        [typeView showViewWithView:cell.contentView array:arrayType];
    }else if (indexPath.section == 2){
        //热门商品
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"sectionHot"];
            cell.textLabel.text = [arrayName objectAtIndex:indexPath.section - 2];
            if (arrayGoods.count == 0) {
                cell.textLabel.textColor = [UIColor clearColor];
            }else{
                cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }else{
            if (arrayGoods.count != 0) {
                [goodsView showViewWithView:cell.contentView array:arrayGoods];
            }
        }
    }else if (indexPath.section == 3){
        //优质店铺
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"sectionGood"];
            cell.textLabel.text = [arrayName objectAtIndex:indexPath.section - 2];
            if (arrayShop.count == 0) {
                cell.textLabel.textColor = [UIColor clearColor];
            }else{
                cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }else{
            if (arrayShop.count != 0) {
                [shopView showViewWithView:cell.contentView array:arrayShop];
            }
        }
    }else{
        //合作伙伴
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"sectionGood"];
            cell.textLabel.text = [arrayName objectAtIndex:indexPath.section - 2];
            if (arrayPartner.count == 0) {
                cell.textLabel.textColor = [UIColor clearColor];
            }else{
                cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }else{
            if (arrayPartner.count != 0) {
                [partnerView showViewWithView:cell.contentView array:arrayPartner];
            }
        }
    }

    return cell;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 401) {
        return 6;
    }else if (collectionView.tag == 402){
        return 4;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView.tag == 401) {
       cell = [self.collectView1 dequeueReusableCellWithReuseIdentifier:@"gtIndexOneCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrayIcon = [[NSArray alloc] initWithObjects:@"trial",@"violation", @"service", @"sectionShop", @"rescue", @"annual", nil];
        NSArray *arrayName = [[NSArray alloc] initWithObjects:@"车险试算", @"违章代办", @"维修保养", @"精品商城", @"道路救援", @"年检代办", nil];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayIcon objectAtIndex:indexPath.row]]];
        [cell.contentView addSubview:imageViewIcon];
        [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(24);
            make.centerX.equalTo(cell.contentView);
        }];
        UILabel *labName = [[UILabel alloc] init];
        labName.text = [arrayName objectAtIndex:indexPath.row];
        labName.textAlignment = NSTextAlignmentCenter;
        labName.textColor = COLOR_TEXT_GARY_DEEP;
        labName.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.centerX.equalTo(cell.contentView);
            make.top.mas_equalTo(68);
            make.height.mas_equalTo(12);
        }];
    }else if (collectionView.tag == 402){
        cell = [self.collectView1 dequeueReusableCellWithReuseIdentifier:@"gtIndexTwoCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrayIcon = [[NSArray alloc] initWithObjects:@"iconEnv",@"iconSafe", @"iconMileage", @"iconTradition", nil];
        NSArray *arrayName = [[NSArray alloc] initWithObjects:@"环境宝车险", @"安全宝车险", @"里程宝车险", @"传统车险", nil];
        NSArray *arrayDetail = [[NSArray alloc] initWithObjects:@"不开不要钱", @"不开不要钱", @"不开不要钱", @"不开不要钱", nil];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayIcon objectAtIndex:indexPath.row]]];
        [cell.contentView addSubview:imageViewIcon];
        [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(48, 48));
            make.left.mas_equalTo(16);
        }];
        UILabel *labName = [[UILabel alloc] init];
        labName.text = [arrayName objectAtIndex:indexPath.row];
        labName.textColor = COLOR_TEXT_GARY_DEEP;
        labName.textAlignment = NSTextAlignmentLeft;
        labName.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.top.mas_equalTo(32);
            make.right.equalTo(cell.contentView);
            make.height.mas_equalTo(15);
        }];
        UILabel *labDetail = [[UILabel alloc] init];
        labDetail.text = [arrayDetail objectAtIndex:indexPath.row];
        labDetail.textColor = COLOR_TEXT_GARY;
        labDetail.textAlignment = NSTextAlignmentLeft;
        labDetail.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(labName);
            make.height.mas_equalTo(12);
            make.bottom.mas_equalTo(-32);
        }];
    }
    return cell;
}

#pragma mark -- UICollectionDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 401) {
        return CGSizeMake(gtWIDTH/4-2, 102);
    }else{
        return CGSizeMake(gtWIDTH/2-1, 99);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (collectionView.tag == 401) {
        ViewController *vc = [[ViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];

        }else{

    }
}

/**
 *  轮播页
 *
 *  @param cell <#cell description#>
 */
- (void)advertisementView :(UITableViewCell *)cell{
//    [self.view setBackgroundColor:[UIColor brownColor]];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    CGRect bounds = self.view.frame;  //获取界面区域
    
    
    
    //加载蒙板图片，限于篇幅，这里仅显示一张图片的加载方法
    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, bounds.origin.y, bounds.size.width, 300)];  //创建UIImageView，位置大小与主界面一样。
    [imageView1 setImage:[UIImage imageNamed:@"mineBg"]];  //加载图片help01.png到imageView1中。
    //imageView1.alpha = 0.5f;  //将透明度设为50%。
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(1*bounds.size.width, bounds.origin.y, bounds.size.width, 300)];  //创建UIImageView，位置大小与主界面一样。
    [imageView2 setImage:[UIImage imageNamed:@"Default"]];
    //继续加载图片
    //。。。。
    
    //创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 300)];  //创建UIScrollView，位置大小与主界面一样。
    [scrollView setContentSize:CGSizeMake(bounds.size.width * 6, 300)];  //设置全部内容的尺寸，这里帮助图片是3张，所以宽度设为界面宽度*3，高度和界面一致。
    scrollView.pagingEnabled = YES;  //设为YES时，会按页滑动
    scrollView.bounces = NO; //取消UIScrollView的弹性属性，这个可以按个人喜好来定
    [scrollView setDelegate:self];//UIScrollView的delegate函数在本类中定义
    scrollView.showsHorizontalScrollIndicator = NO;  //因为我们使用UIPageControl表示页面进度，所以取消UIScrollView自己的进度条。
    for (int index = 0; index < arrayAdvertisement.count ; index ++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.origin.y, bounds.size.width, 103)];
//        view.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, gtWIDTH*index + 8, gtWIDTH-16, 87)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [super getImageForUrl:[[arrayAdvertisement objectAtIndex:index] objectForKey:@"img_url"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        });
//        imageView.image = [UIImage imageNamed:@"Default"];
        [scrollView addSubview:imageView];
//        [scrollView addSubview:view];
    }
//    [scrollView addSubview:imageView1];
//    [scrollView addSubview:imageView1];
    [cell.contentView addSubview:scrollView]; //将UIScrollView添加到主界面上。
    
    //创建UIPageControl
    int num = (int)arrayAdvertisement.count;
    UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(gtWIDTH - 30 - num *10, 65,num* 10, 30)];  //创建UIPageControl，位置在屏幕最下方。
    pageCtrl.numberOfPages = 2;//总的图片页数
    pageCtrl.currentPage = 0; //当前页
    //    pageCtrl.hidesForSinglePage = YES;
    pageCtrl.tag = 701;
    [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [cell.contentView addSubview:pageCtrl];  //将UIPageControl添加到主界面上。
}

#pragma mark - Action
- (void) btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        //选择城市
    }else if (button.tag == 202){
        int count = 0;
        for (int index = 0; index < arrayCarList.count; index ++) {
            if ([[arrayCarList objectAtIndex:index] isEqualToString:[gtCarInfo objectForKey:@"car_no"]]) {
                count = index;
            }
        }
        //切换车辆
        BaseAlertSheet2 *alert = [[BaseAlertSheet2 alloc] init];
        alert.delegate = self;
        [alert initWithArray:arrayCarList ArrayImage:nil name:@"changeDefaultCar" selectIndex:count buttonTitle:@"添加车辆"];
        [alert showInView:self.view];
    }else if (button.tag == 203){
        CarLocationViewController *carLocationVC = [[CarLocationViewController alloc] init];
        [self.navigationController pushViewController:carLocationVC animated:YES];
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    if (sender.tag == 701) {
        //令UIScrollView做出相应的滑动显示
        CGSize viewSize = CGSizeMake(gtWIDTH, 103);
        UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:801];
        CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

#pragma mark -- CLLocationManagerDelegate
- (void) startLocation : (int)isAlert{
    self.lacationManage = [[CLLocationManager alloc] init];
    self.lacationManage.delegate = self;
    self.lacationManage.desiredAccuracy = kCLLocationAccuracyBest;
    self.lacationManage.distanceFilter = 10.0f;
    [self.lacationManage requestWhenInUseAuthorization];
    [self.lacationManage startUpdatingLocation];
    NSLog(@"lacationManage == %f",self.lacationManage.location.coordinate.latitude);
    NSLog(@"lacationManage == %f",self.lacationManage.location.coordinate.longitude);
//    latitude = self.lacationManage.location.coordinate.latitude;
//    longitude = self.lacationManage.location.coordinate.longitude;
    NSDictionary *dicLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"dicLocation"];
    float lat = self.lacationManage.location.coordinate.latitude;
    float lon = self.lacationManage.location.coordinate.longitude;
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (type != kCLAuthorizationStatusAuthorizedWhenInUse && type != kCLAuthorizationStatusNotDetermined && isAlert == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未打开定位,请前往设置打开定位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"坚决不去" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionGo = [UIAlertAction actionWithTitle:@"去定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __block int timeout=0; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                });
                timeout++;
            });
            dispatch_resume(_timer);
            //            [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.viewReload"] completionHandler:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:actionCancle];
        [alertController addAction:actionGo];
        
    }
    if (lon == 0) {
        [indexDAL getUserLocationWithLng:@"" lat:@"" gpsType:@"1"];
    }else{
        [indexDAL getUserLocationWithLng:[NSString stringWithFormat:@"%f",lon] lat:[NSString stringWithFormat:@"%f",lat] gpsType:@"1"];
    }
//    CLLocationCoordinate2D location;
//    if (latitude == 0 || longitude == 0) {
//        location.latitude = lat;
//        location.longitude = lon;
//    }
//    else{
//        location.latitude = latitude;
//        location.longitude = longitude;
//    }
//    NSLog(@"location == %f",location.longitude);
    
}


- (void)login: (NSDictionary *)dic{
    NSDictionary *info = [dic objectForKey:@"info"];
    NSDictionary *dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [info objectForKey:@"usertoken"], @"usertoken",
                             [info objectForKey:@"mobile" ], @"mobile",
                             [info objectForKey:@"expire" ], @"expire",
                             [info objectForKey:@"has_buy_safety" ], @"has_buy_safety",
                             [info objectForKey:@"has_last_safety" ], @"has_last_safety",
                             [info objectForKey:@"is_fakecar" ], @"is_fakecar",
                             [info objectForKey:@"is_obd" ], @"is_obd",
                             [info objectForKey:@"traff_status" ], @"traff_status",
                             nil];
    if ([[info objectForKey:@"area_info"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicArea = [[NSDictionary alloc] initWithDictionary:[info objectForKey:@"area_info"]];
        NSDictionary *dicArea2 = [self nullToEmpty:dicArea];
        [[NSUserDefaults standardUserDefaults] setObject:dicArea2 forKey:@"DicArea"];
        
    }
    NSDictionary *dicInfo2 = [super nullToEmpty:dicInfo];
    NSLog(@"dicInfo2 == %@",dicInfo2);
    [[NSUserDefaults standardUserDefaults] setObject:dicInfo2  forKey:@"DicUserInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"usertoken"] forKey:@"usertoken"];
    NSLog(@"userToken == %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)carList: (NSDictionary *)dic{
    NSArray *arrData = [[NSArray alloc] initWithArray:[[dic objectForKey:@"info"] objectForKey:@"data"]];
    int count = [[[dic objectForKey:@"info"] objectForKey:@"count"] intValue];
    NSMutableArray *arrayIcnNo = [[NSMutableArray alloc] init];
    for (int index = 0; index < [[[dic objectForKey:@"info"] objectForKey:@"data"] count]; index++) {
        [arrayIcnNo addObject:[[arrData objectAtIndex:index] objectForKey:@"car_no"]];
    }
    arrayLcnNo = [NSArray arrayWithArray:arrayIcnNo];
    NSLog(@"arrayLcnNo == %@",arrayLcnNo);
    NSLog(@"gtCarInfo == %@",gtCarInfo);

    [arrayAllCarList addObjectsFromArray:[[dic objectForKey:@"info"] objectForKey:@"data"]];
    NSLog(@"arrayAllCarList == %lu",(unsigned long)arrayAllCarList.count);
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int index = 0; index < arrayAllCarList.count; index ++ ) {
        [array addObject:[[arrayAllCarList objectAtIndex:index] objectForKey:@"car_no"]];
    }
    arrayCarList = [NSArray arrayWithArray:array];
    //请求数据
    if (arrayAllCarList.count < [[[dic objectForKey:@"info"] objectForKey:@"count"] intValue]) {
        int count = (int)arrayAllCarList.count/10;
        [indexDAL getCarListsWithPage:[NSString stringWithFormat:@"%d",count+1] limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:GTisFake];
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int index = 0; index < arrayAllCarList.count; index ++ ) {
            [array addObject:[[arrayAllCarList objectAtIndex:index] objectForKey:@"car_no"]];
        }
        arrayCarList = [NSArray arrayWithArray:array];
        NSLog(@"arrCarlist == %@",arrayCarList);
        for (int index = 0; index < count; index ++ ) {
            int isDefault = [[[arrayAllCarList objectAtIndex:index] objectForKey:@"is_default"] intValue];
            if (isDefault == 1) {
                NSDictionary *dicCar = [NSDictionary dictionaryWithDictionary:[arrayAllCarList objectAtIndex:index]];
                dicCar = [super nullToEmpty:dicCar];
                [[NSUserDefaults standardUserDefaults] setObject:dicCar forKey:@"dicCar"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        [indexDAL getCarAllStatWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
    }
}


#pragma mark -- BaseActionSheet2Delegate
- (void)alertSheet2:(int)index name:(NSString*)name{
    if ([name isEqualToString:@"changeDefaultCar"]) {
        if (index == -1) {
            //添加新车
            NSLog(@"添加新车");
        }else{
            NSDictionary *dicCar = [NSDictionary dictionaryWithDictionary:[arrayAllCarList objectAtIndex:index]];
            dicCar = [super nullToEmpty:dicCar];
            [[NSUserDefaults standardUserDefaults] setObject:dicCar forKey:@"dicCar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"gtCarInfo == %@",gtCarInfo);
            [indexDAL postCarUpdateWithCarID:[gtCarInfo objectForKey:@"car_id"] carNo:@"" drvOwner:@"" vhlFrm:@"" engNo:@"" fstRegDte:@"" operating:@"" brandId:@"" carSeries:@"" img:@"" updateType:@"2"];
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil] withRowAnimation:UITableViewRowAnimationNone];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"DefaultCar"  object:[gtCarInfo objectForKey:@"car_no"]];
        }
    }
}


#pragma mark -- IndexRequestDelegate
- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"SlidesImagesLists"]){//轮播图
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:2 inSection:0]; //刷新第0段第2行
            if (![[dic objectForKey:@"info"]isKindOfClass:[NSNull class]]) {
                arrayAd = [dic objectForKey:@"info"];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA ,nil] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView deselectRowAtIndexPath:indexPathA animated:NO];
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        if (gtLocation) {
            [indexDAL getIndexBusWithAreaID:[gtLocation objectForKey:@"area_id"] provinceId:[gtLocation objectForKey:@"province_id"] showType:@"1" source:@""];
        }else{
            [indexDAL getIndexBusWithAreaID:@"" provinceId:@"" showType:@"1" source:@""];
        }
        type = 1;
    }else if ([cmd isEqualToString:@"IndexBus"]){
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:1 inSection:0]; //刷新第0段第1行
            NSIndexPath *indexPathB = [NSIndexPath indexPathForRow:0 inSection:1]; //刷新第0段第1行
            if ([dic objectForKey:@"info"]) {
                if ([[[dic objectForKey:@"info"] objectAtIndex:0] objectForKey:@"show_type"]) {
                    NSMutableArray *arrBus = [[NSMutableArray alloc] init];
                    NSMutableArray *arrType = [[NSMutableArray alloc] init];
                    for (int index = 0; index < [[dic objectForKey:@"info"] count]; index ++) {
                        if ([[[[dic objectForKey:@"info"] objectAtIndex:index] objectForKey:@"show_type"] intValue] == 1) {
                            [arrBus addObject:[[dic objectForKey:@"info"] objectAtIndex:index]];
                        }else{
                            [arrType addObject:[[dic objectForKey:@"info"] objectAtIndex:index]];
                        }
                    }
                    arrayBus = [NSArray arrayWithArray:arrBus];
                    NSLog(@"arrayBus == %@",arrayBus);
                    arrayType = [NSArray arrayWithArray:arrType];
                    NSLog(@"arrayType == %@",arrayType);
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA, indexPathB,nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                    
//                    if ([[[[dic objectForKey:@"info"] objectAtIndex:0] objectForKey:@"show_type"] intValue] == 1) {
//                        arrayBus = [dic objectForKey:@"info"];
//                        NSLog(@"arrayBus == %@",arrayBus);
//                        
//                    }else{
//                        arrayType = [dic objectForKey:@"info"];
//                        NSLog(@"arrayType == %@",arrayType);
//                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathB ,nil] withRowAnimation:UITableViewRowAnimationNone];
//                    }
                }
            }else{
//                [self.tableView deselectRowAtIndexPath:indexPathA animated:NO];
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        if (type == 1) {
            if (gtLocation) {
                [indexDAL getMallProductsProvinceID:[gtLocation objectForKey:@"province_id"] areaID:[gtLocation objectForKey:@"area_id"]];
            }else{
                [indexDAL getMallProductsProvinceID:@"" areaID:@""];
            }
        }
    }else if ([cmd isEqualToString:@"MallNewProducts"]){//热门商品
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if (![[dic objectForKey:@"info"] isKindOfClass:[NSNull class]]) {
                arrayGoods = [dic objectForKey:@"info"];
                NSIndexSet *indexSetA = [NSIndexSet indexSetWithIndex:2];
                [self.tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationNone];
            }else{
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        if (gtLocation) {
            [indexDAL getStoreFineStoresWithProvinceId:[gtLocation objectForKey:@"province_id"] areaId:[gtLocation objectForKey:@"area_id"] type:@"1"];
        }else{
            [indexDAL getStoreFineStoresWithProvinceId:@"" areaId:@"" type:@"1"];
        }
    }else if ([cmd isEqualToString:@"UserLocation"]){//定位
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if (![dic objectForKey:@"info"]) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[super nullToEmpty:[NSDictionary dictionaryWithDictionary:dic]]];
                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"info"] forKey:@"Location"];
                [btnRight setTitle:[gtLocation objectForKey:@"area_name"] forState:UIControlStateNormal];
            }else{
                
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        if (gtLocation) {
            [indexDAL getSlidesImagesLists:@"2" provinceId:[gtLocation objectForKey:@"province_id"] areaId:[gtLocation objectForKey:@"area_id"]];
        }else{
            [indexDAL getSlidesImagesLists:@"2" provinceId:@"" areaId:@""];
        }
    }
    else if ([cmd isEqualToString:@"StoreFineStores"]){//店铺
        NSLog(@"dic == %@",dic);
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if ([[dic objectForKey:@"info"] count] != 0) {
                arrayShop = [dic objectForKey:@"info"];
//                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:3];
                NSIndexSet *indexSetA = [NSIndexSet indexSetWithIndex:3];
                [self.tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationNone];
            }else{
//                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:3];
//                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        [indexDAL getIndexPartnersWithProvinceID:[gtLocation objectForKey:@"province_id"] areaID:[gtLocation objectForKey:@"area_id"]];
    }else if ([cmd isEqualToString:@"IndexPartners"]){//合作伙伴
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if ([[dic objectForKey:@"info"] count] != 0) {
                arrayPartner = [dic objectForKey:@"info"];
//                NSIndexSet *indexPathA = [NSIndexPath indexPathForRow:0 inSection:4];
                NSIndexSet *indexSetA = [NSIndexSet indexSetWithIndex:4];

                [self.tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationNone];
            }else{
                
            }
        }
        [indexDAL getProfitCarInfoWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
    }else if ([cmd isEqualToString:@"loginToken"]){
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [self login:dic];
        }
        [self startLocation:0];
    }else if ([cmd isEqualToString:@"CarLists"]){
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [self carList:dic];
//            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexSet *indexSetA = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationNone];
        }
//        if (gtLocation) {
//            [indexDAL getIndexBusWithAreaID:[gtLocation objectForKey:@"area_id"] provinceId:[gtLocation objectForKey:@"province_id"] showType:@"1" source:@""];
//        }else{
//            [indexDAL getIndexBusWithAreaID:@"" provinceId:@"" showType:@"1" source:@""];
//        }
//        type = 2;
    }else if ([cmd isEqualToString:@"ProfitCarInfo"]){
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            NSLog(@"dic == %@",[dic objectForKey:@"info"]);
//            if ([[[dic objectForKey:@"info"] objectForKey:@"ptype"] intValue] == 4) {
//                dicProfitCarInfo = [NSDictionary dictionaryWithDictionary:[[dic objectForKey:@"info"] objectForKey:@"mile_info"]];
//            }else if ([[[dic objectForKey:@"info"] objectForKey:@"ptype"] intValue] == 3){
//                dicProfitCarInfo = [NSDictionary dictionaryWithDictionary:[[dic objectForKey:@"info"] objectForKey:@"mile_info"]];
//            }
            dicProfitCarInfo = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"info"]];
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0]; //刷新第0段第0行
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        [indexDAL getCarListsWithPage:@"1" limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:@"0"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
