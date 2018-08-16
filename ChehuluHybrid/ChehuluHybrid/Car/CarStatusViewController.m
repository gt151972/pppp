

//  CarStatusViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/6/6.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarStatusViewController.h"
//#import "BluePieChartView.h"
//#import "YellowPieChartView.h"
//#import "GreenPieChartView.h"
//#import "CircleBg.h"
//#import "MileageView.h"
//#import "TimeView.h"
//#import "OIlView.h"
//#import "CarbonView.h"
//#import "CalendarViewController.h"
//#import "CarbonViewController.h"
#import "CarDetectionViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import "ShowView.h"
#import "DayChange.h"

#import "SecretViewController.h"

#import "WeekDataSource.h"
#import "Calender.h"
#import "HistoryAllViewController.h"
#import "OpinionViewController.h"
#import "CarMileageViewController.h"
#import "CarTimeViewController.h"
#import "OilViewController.h"
#import "CarbonViewController.h"
#import "NoOBD.h"
#import "StopView.h"
#import "CarStatuesShareView.h"
#import "CarShareView.h"
#import "Share.h"
//#define CarNO @"1301"
@interface CarStatusViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, CalenderDelegate, NoOBDDelegate>{
//    CircleBg *circleBg;
//    MileageView *mileage;
//    TimeView *time;
//    OIlView *oil;
//    CarbonView *carbon;
    
    UIButton *btnTitle; //标题车辆车牌
    UIView *viewPickerBg; //pickerView
    
    NSMutableArray *arrayLcnNo;//车牌
    NSArray *arrayCarID;//车辆id
    
    NSString *strCarId; //当前车辆id
    
    NSMutableArray *arrDetailNumber;//footer
    
    NSArray *arrayOil;//油耗
    NSArray *arrayTime;//时间
    NSString *strOilSum;//油耗总和
    NSString *strTimeSum;//时间总和
    NSString *strCarbon;//碳排
    NSString *strMileage;//里程
    NSString *strRunTime;//时间
    
    NSMutableArray *arrWeekStop;//停行数据
    NSMutableArray *arrWeekDate;//
    
    ShowView *showView;
    DayChange *dayChange;
    StopView *stopView;
    
    NSMutableArray *arrayCarList;//车牌数组
    NSMutableArray *arrayAllCarList; //车辆列表总数据
    NSMutableArray *arrayCarInfo;//有obd车辆
    
    NSDictionary *dicCarAllStat;//总数据
    NSArray *arrayCarDayStat;//日数据
    NSDictionary *dicCarDayStat;//日数据
    NSArray *arrayFooter; //底部数据
    NSArray *arrayHead; //顶部数据
    NoOBD *noObd;
    Share *share;
    
    NSString *aYear;
    NSString *aMonth;
    NSString *aDay;
    NSString *strDate;
    
    int theLoc;//篮圈位置
    BOOL isStop;//是否停车;
}
@property (nonatomic, strong)UICollectionView *collectionViewHeader;
@property (nonatomic, strong)UICollectionView *collectionViewMiddle;
@property (nonatomic, strong)UICollectionView *collectionViewFooter;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableViewCell *cell;
@property (nonatomic, strong)UIPickerView *pickerView;
//@property (nonatomic, strong) CircleBg *circleBg;
//@property (nonatomic, strong) BluePieChartView *blueRingView;
//@property (nonatomic, strong) YellowPieChartView *yellowRingView;
//@property (nonatomic, strong) GreenPieChartView *greenRingView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) UIView *viewShare;//分享View;

@property (nonatomic, strong) WeekDataSource *weekDataSource;

@end

@implementation CarStatusViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
//    [self.navigationController.navigationBar setBarTintColor:COLOR_BG_BLACK];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if ([[gtCarInfo objectForKey:@"obd_info"] count] == 0) {
        [noObd addViewNoOBD:self.view strCarNo:[gtCarInfo objectForKey:@"car_no"]];
    }
}

- (void)returnNoti:(NSNotification *)notification{
    NSLog(@"object == %@",notification.object);
    if ([notification.name isEqualToString:@"DefaultCar"]) {
        [_tableView removeFromSuperview];
        [self initData];
        [self initVC];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNoti:) name:@"DefaultCar" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        
    }
    

    [self initData];
    [self initVC];
    
//    arrayLcnNo = @[@"1",@"2",@"3"];
    
//    [self showViewPickerBg];
    
//    _viewShare = [[UIView alloc] init];
//    _viewShare = [showView shareViewWithFrame:200];
//    [self.view addSubview:_viewShare];
//    [self viewShareInit];
    
    NSLog(@"arrayLcnNo = %@",arrayLcnNo);
}


- (void)initData{
    if (gtCarInfo) {
        indexDAL = [[IndexRequestDAL alloc] init];
        indexDAL.delegate = self;
        [indexDAL getCarListsWithPage:@"1" limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:@"0"];
        if ([[gtCarInfo objectForKey:@"obd_info"] count] == 0) {
            [noObd addViewNoOBD:self.view strCarNo:[gtCarInfo objectForKey:@"car_no"]];
        }
    }else{
        [noObd addViewNoCar:self.view];
    }
    arrayLcnNo = [[NSMutableArray alloc] init]; //车牌列表
    arrayAllCarList = [[NSMutableArray alloc] init];//车辆列表数据
    arrayCarList = [[NSMutableArray alloc] init];
    arrayCarInfo = [[NSMutableArray alloc] init];
    dicCarAllStat = [[NSDictionary alloc] init];//总数据
    arrayCarDayStat = [[NSArray alloc] init];//日数据
    dicCarDayStat = [[NSDictionary alloc] init];//日数据
    arrayFooter = [[NSArray alloc] init];//底部数据
    arrayHead = [[NSArray alloc] init];//顶部数据
    noObd = [[NoOBD alloc] init];
    noObd.delegate = self;
    aYear = @"";
    aMonth = @"";
    aDay = @"";
    strDate = @"";
    
    theLoc = (int) [self getNowWeekday] -1;
    isStop = 0;
    // 集成刷新控件
//    [self setupRefresh];
    
    share = [[Share alloc] init];
    
}



- (void)initVC{
    [self.view setBackgroundColor:COLOR_BG_GRAY];
    [self initNavigation];
    [self initHeadView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, gtWIDTH, gtHEIGHT - 35 - 49-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG_BLACK_DEEP;
    self.tableView.separatorColor = COLOR_BG_BLACK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarStatusTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tableView];
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(refreshView:)
              forControlEvents:UIControlEventValueChanged];
//    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];       
    [_tableView addSubview:_refreshControl];
//    [HUD loadingHUD];
    
    [self initGrade];
}

-(void)refreshView:(UIRefreshControl *)refresh{
    [HUD loadingHUD];
    [refresh beginRefreshing];
    
//    [HUD hidHUDbg];
    [indexDAL getCarDayLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] date:[NSString stringWithFormat:@"%@-%@-%@",aYear,aMonth,aDay] isFake:GTisFake];
    [refresh endRefreshing];
    [HUD hidHUD];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [HUD loadingHUD];
}

- (void)showViewPickerBg{
    viewPickerBg = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 200, gtWIDTH, 200)];
    [viewPickerBg setHidden:YES];
    viewPickerBg.backgroundColor = COLOR_BG_BLACK_DEEP;
    [self.view addSubview:viewPickerBg];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, gtWIDTH, 170)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = COLOR_BG_BLACK_DEEP;
    [viewPickerBg addSubview:_pickerView];
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:COLOR_BG_GRAY forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont: [UIFont systemFontOfSize:16]];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewPickerBg addSubview:btnCancel];
    UIButton *btnOk = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 50, 10, 40, 20)];
    [btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [btnOk setTitleColor:COLOR_BG_GRAY forState:UIControlStateNormal];
    [btnOk.titleLabel setFont: [UIFont systemFontOfSize:16]];
    [btnOk addTarget:self action:@selector(btnOkClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewPickerBg addSubview:btnOk];
}

- (void)viewShareInit{
    
    _viewShare = [[UIView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, gtHEIGHT-64-49)];
    [_viewShare setHidden:YES];
    _viewShare.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewShare];
    
    UIButton *btnCancle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    [btnCancle setBackgroundColor:[UIColor clearColor]];
    [btnCancle addTarget:self action:@selector(viewShareRemove) forControlEvents:UIControlEventTouchUpInside];
    [_viewShare addSubview:btnCancle];
    
    UIView *shareBG = [[UIView alloc] init];
    shareBG.backgroundColor = COLOR_BG_GRAY;
    [_viewShare addSubview:shareBG];
    [shareBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_viewShare.mas_bottom);
        make.height.mas_equalTo(100);
        make.centerX.and.width.equalTo(SW);
    }];
    
    UIView *viewFriend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/2, shareBG.frame.size.height)];
    viewFriend.backgroundColor = [UIColor clearColor];
    [shareBG addSubview:viewFriend];
    
    UIImage *imageFriend = [UIImage imageNamed:@"shareFriend"];
    UIButton *btnFriends = [[UIButton alloc] init];
    [btnFriends setImage:imageFriend forState:UIControlStateNormal];
    [btnFriends setTag:201];
    [btnFriends addTarget:self action:@selector(btnShareWXClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewFriend addSubview:btnFriends];
    [btnFriends mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageFriend.size);
        make.centerY.equalTo(shareBG.mas_centerY);
        make.centerX.equalTo(viewFriend.mas_centerX);
    }];
    
    UIView *viewCircle = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/2, 0, gtWIDTH/2, shareBG.frame.size.height)];
    [shareBG addSubview:viewCircle];
    UIImage *imageCircle = [UIImage imageNamed:@"shareCircle"];
    UIButton *btnCircle = [[UIButton alloc] init];
    [btnCircle setImage:imageCircle forState:UIControlStateNormal];
    [btnCircle setTag:202];
    [btnCircle addTarget:self action:@selector(btnShareWXClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewCircle addSubview:btnCircle];
    [btnCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageCircle.size);
        make.centerY.equalTo(shareBG.mas_centerY);
        make.centerX.equalTo(viewCircle.mas_centerX);
    }];
}


/**
 *  navigation
 */
- (void)initNavigation{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    navView.backgroundColor = COLOR_MAIN_WHITE;
    [self.view addSubview:navView];
    //left 车辆检测
    UIButton *btnNavLeft = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
    [btnNavLeft setImage:[UIImage imageNamed:@"detection"] forState:UIControlStateNormal];
    NSString *strBack = [NSString stringWithFormat:@"%@月",[self GetNowMoon]];
    [btnNavLeft setTitle:strBack forState:UIControlStateNormal];
    [btnNavLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNavLeft setTag:204];
    [btnNavLeft addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    self.tabBarController.navigationItem.leftBarButtonItem = backItem;
    [navView addSubview:btnNavLeft];
    
    //title
    NSString *strCarNo = [gtCarInfo objectForKey:@"car_no"];
    UIImage *image = [UIImage imageNamed:@"pullDownBlack"];
    btnTitle = [[UIButton alloc] init];
    [btnTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width)];
//    NSLog(@"btnTitle.titleLabel.bounds.size.width == %f",btnTitle.titleLabel.bounds.size.width);
    [btnTitle setImageEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
    [btnTitle setTitle:[gtCarInfo objectForKey:@"car_no"] forState:UIControlStateNormal];
    [btnTitle setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [btnTitle setImage:image forState:UIControlStateNormal];
    [btnTitle setTag:201];
    [btnTitle addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnTitle];
    [btnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.top.mas_equalTo(20);
    }];
//    self.tabBarController.navigationItem.titleView = btnTitle;
    
    //right
    UIButton *btnNavRight = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 49, 20, 44, 44)];
    [btnNavRight setImage:[UIImage imageNamed:@"moreBlack"] forState:UIControlStateNormal];
    [btnNavRight setTag:202];
    [btnNavRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnNavRight];
}

/**
 *  日期选择
 
 */
- (void)initHeadView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;//间距
    flowLayout.minimumLineSpacing = 1;
    self.collectionViewHeader = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH*7/8 , 35) collectionViewLayout:flowLayout];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.collectionViewHeader.delegate = self;
    self.collectionViewHeader.dataSource = self;
    self.collectionViewHeader.scrollEnabled = NO;
    self.collectionViewHeader.tag = 401;
    [self.collectionViewHeader setBackgroundColor:[UIColor whiteColor]];
    [self.collectionViewHeader registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CarHeadCollectionViewCell"];
    [self.view addSubview:self.collectionViewHeader];
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH*7/8, 64, gtWIDTH/8, 35)];
    [btnDetail setBackgroundColor:[UIColor whiteColor]];
    [btnDetail setImage:[UIImage imageNamed:@"dateDetail"] forState:UIControlStateNormal];
    [btnDetail addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail setTag:203];
    [self.view addSubview:btnDetail];
}

- (void)dateChoose: (NSString *)day{
    [_collectionViewHeader removeFromSuperview];
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH*7/8 , 35)];
    viewBg.tag = 1001;
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    
    UIButton *btnToday = [[UIButton alloc] initWithFrame:CGRectMake(16, 8, 24, 24)];
    [btnToday setImage:[UIImage imageNamed:@"today"] forState:UIControlStateNormal];
    [btnToday addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnToday setTag:208];
    [viewBg addSubview:btnToday];
    
    UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 35)];
//    labDate.text = [NSString stringWithFormat:@"%@年%@月%@日",aYear, aMonth, aDay];
    labDate.text = day;
    labDate.textColor = COLOR_TEXT_GARY_DEEP;
    labDate.textAlignment = NSTextAlignmentCenter;
    labDate.font = [UIFont systemFontOfSize:16];
    [viewBg addSubview:labDate];
    
    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH*7/8, 64, gtWIDTH/8, 35)];
    [btnDetail setImage:[UIImage imageNamed:@"dateDetail"] forState:UIControlStateNormal];
    [btnDetail addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail setTag:203];
    [self.view addSubview:btnDetail];
}

- (void)initGrade{
    UIButton *btnGrade = [[UIButton alloc] initWithFrame:CGRectMake(6, 117, 50, 50)];
//    [btnGrade setImage:[UIImage imageNamed:@"gradeBg"] forState:UIControlStateNormal];
    btnGrade.tag = 209;
    [btnGrade addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGrade];
}

/**
 *  获取月份
 *
 *  @return 当前月份
 
 */
- (NSString *)GetNowMoon{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *dateWeekDay = [formatter stringFromDate:[NSDate date]];
    int moon = [dateWeekDay intValue];
    if (moon < 10) {
        dateWeekDay = [dateWeekDay substringFromIndex:1];
    }
//    NSLog(@"dataMoon == %@",dateWeekDay);
    return dateWeekDay;
}

/**
 *  星期
 *
 *  @return <#return value description#>
 */
- (NSInteger)getNowWeekday{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
//    NSLog(@"comps == %ld",(long)[comps weekday]);
    return [comps weekday];
}

#pragma mark -- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_BG_GRAY2;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 290;
    }else {
        return 160;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row == 0) {
        CarbonViewController *carbonVC = [[CarbonViewController alloc] init];
        [self.navigationController pushViewController:carbonVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        OilViewController *oilVC = [[OilViewController alloc] init];
        [self.navigationController pushViewController:oilVC animated:YES];
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CarStatusTableViewCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!_cell) {
    }
    _cell.backgroundColor = COLOR_BG_BLACK_DEEP;
    if (indexPath.section == 0) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;//间距
        flowLayout.minimumLineSpacing = 1;
        self.collectionViewMiddle = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 290) collectionViewLayout:flowLayout];
        self.automaticallyAdjustsScrollViewInsets = false;
        self.collectionViewMiddle.delegate = self;
        self.collectionViewMiddle.dataSource = self;
        self.collectionViewMiddle.scrollEnabled = NO;
        self.collectionViewMiddle.tag = 402;
        [self.collectionViewMiddle setBackgroundColor:COLOR_BG_GRAY2];
        [self.collectionViewMiddle registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CarMiddleCollectionViewCell"];
        [_cell.contentView addSubview:self.collectionViewMiddle];

    }else{
        //footer
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;//间距
        flowLayout.minimumLineSpacing = 1;
        self.collectionViewFooter = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH , 160) collectionViewLayout:flowLayout];
        self.automaticallyAdjustsScrollViewInsets = false;
        self.collectionViewFooter.delegate = self;
        self.collectionViewFooter.dataSource = self;
        self.collectionViewFooter.scrollEnabled = NO;
        self.collectionViewFooter.tag = 403;
        [self.collectionViewFooter setBackgroundColor:COLOR_BG_GRAY2];
        [self.collectionViewFooter registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gtFooterCollectionViewCell"];
        [_cell.contentView addSubview:self.collectionViewFooter];
    }
    return _cell;
}
#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 401) {
        return 7;
    }else if (collectionView.tag == 402){
        return 4;
    }
    else{
        return 5;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    if (collectionView.tag == 401) {
        cell = [self.collectionViewHeader dequeueReusableCellWithReuseIdentifier:@"CarHeadCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrayDay = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        NSLog(@"weekday == %ld",(long)[self getNowWeekday]);

         UILabel *labDay = [[UILabel alloc] init];
        UIView *viewRing1 = [[UIView alloc] init];
        viewRing1.layer.masksToBounds = YES;
        viewRing1.layer.cornerRadius = 17;
        viewRing1.tag = 1000+indexPath.row;
        [cell.contentView addSubview:viewRing1];
        [viewRing1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
//        if ([self getNowWeekday] == (indexPath.row +1)) {
        if (theLoc == indexPath.row) {
            viewRing1.backgroundColor = COLOR_MAIN_GREEN;
        }else{
            viewRing1.backgroundColor = [UIColor clearColor];
        }
        
        
//        if ([self getNowWeekday] == indexPath.row + 1) {
        if ([self getNowWeekday] == indexPath.row + 1) {
            labDay.text = @"今";
        }
        if (theLoc == indexPath.row) {
            labDay.textColor = [UIColor whiteColor];
        }else{
            if ([self getNowWeekday] > indexPath.row + 1) {
//            if (theLoc > indexPath.row) {
                labDay.textColor = COLOR_TEXT_GARY_DEEP;
            }else{
                labDay.textColor = COLOR_TEXT_GARY;
            }
            labDay.text = [arrayDay objectAtIndex:indexPath.row];
        }
        labDay.textAlignment = NSTextAlignmentCenter;
        labDay.font = [UIFont systemFontOfSize:14];
        labDay.tag = 100+indexPath.row;
        [cell.contentView addSubview:labDay];
        [labDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3;
        
        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.top.equalTo(labDay.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        
        NSLog(@"arrWeekStop == %@",arrWeekStop);
        if (arrWeekStop.count > indexPath.row+1) {
            int statues = [[arrWeekStop objectAtIndex:indexPath.row] intValue];
            if (statues == 1) {
                view.backgroundColor = COLOR_SHADE_YELLOW_DEEP;
            }else if (statues == 0){
                view.backgroundColor = COLOR_SHADE_GREEN_DEEP;
            }else{
                view.backgroundColor = [UIColor clearColor];
            }
        }
    }else if (collectionView.tag == 402){
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell = [self.collectionViewMiddle dequeueReusableCellWithReuseIdentifier:@"CarMiddleCollectionViewCell" forIndexPath:indexPath];
        NSArray *arrayImage = [NSArray arrayWithObjects:@"milleageBig", @"timeBig", @"oilBig", @"carbonBig", nil];
        NSArray *arrayUnit = [NSArray arrayWithObjects:@"km", @"h", @"L", @"kg", nil];
        NSArray *arrayDetail = [NSArray arrayWithObjects:@"里程", @"时间", @"油耗", @"碳排", nil];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayImage objectAtIndex:indexPath.row]]];
        [cell.contentView addSubview:imageViewIcon];
        [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.top.mas_equalTo(21);
            make.centerX.equalTo(cell.contentView);
        }];
        
        UILabel *labData = [[UILabel alloc] init];
        
        labData.textColor = COLOR_TEXT_GARY_DEEP;
        labData.textAlignment = NSTextAlignmentCenter;
        labData.font = [UIFont systemFontOfSize:22];
        labData.tag = 101+indexPath.row;
        NSLog(@"tag = %ld",(long)labData.tag);
        [cell.contentView addSubview:labData];
        [labData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageViewIcon.mas_bottom).offset(5);
            make.centerX.and.width.equalTo(cell.contentView);
            make.height.mas_offset(22);
        }];
        
        UILabel *labDetail = [[UILabel alloc] init];
        labDetail.text = [arrayDetail objectAtIndex:indexPath.row];
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.textColor = COLOR_TEXT_GARY;
        labDetail.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.equalTo(cell.contentView);
            make.top.equalTo(labData.mas_bottom).offset(7);
            make.height.mas_offset(13);
        }];
        if (arrayHead.count == 0) {
            labData.text = [NSString stringWithFormat:@"0%@",[arrayUnit objectAtIndex:indexPath.row]];
        }else{
            labData.text = [NSString stringWithFormat:@"%.2f%@", [[arrayHead objectAtIndex:indexPath.row] floatValue], [arrayUnit objectAtIndex:indexPath.row]];
            if ([[arrayHead objectAtIndex:indexPath.row] floatValue] == 0) {
                labData.text = [NSString stringWithFormat:@"0%@", [arrayUnit objectAtIndex:indexPath.row]];
            }
            if (indexPath.row == 1) {
                float second = [[arrayHead objectAtIndex:1] floatValue];
//                NSLog(@"second == %d",second);
                NSString *strUnit = @"min";
                if (second>60 && second < 3600) {
                    second = second/60;
                    strUnit = @"min";
                }else if (second > 3600){
                    second = second / 3600;
                    strUnit = @"h";
                }else if (second > 0 && second < 60){
                    second = 1;
                }
                labData.text = [NSString stringWithFormat:@"%.1f%@", second, strUnit];
                if (second <= 0) {
                    labData.text = @"0min";
                }
            }
        }
    }
    else{
        cell = [self.collectionViewFooter dequeueReusableCellWithReuseIdentifier:@"gtFooterCollectionViewCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        NSArray *arrayDetail = [[NSArray alloc] initWithObjects:@"平均油耗", @"急加速/减速/转弯", @"最高速度", @"平均速度", nil];
    
        UILabel *labDetail = [[UILabel alloc] init];
        labDetail.text = [arrayDetail objectAtIndex:indexPath.row];
        labDetail.textColor = [UIColor grayColor];
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.width.equalTo(cell.contentView);
            make.height.mas_equalTo(13);
            make.top.mas_equalTo(46);
        }];
        UILabel *labDetailNumber = [[UILabel alloc] init];
        if (arrayFooter.count != 0) {
            if ([[arrayFooter objectAtIndex:indexPath.row] isEqualToString:@""]) {
                labDetailNumber.text = 0;
            }else{
                labDetailNumber.text = [arrayFooter objectAtIndex:indexPath.row];
            }
        }else{
            
        }
        labDetailNumber.textColor = COLOR_TEXT_GARY_DEEP;
        labDetailNumber.textAlignment = NSTextAlignmentCenter;
        labDetailNumber.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:labDetailNumber];
        [labDetailNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(labDetail);
            make.bottom.equalTo(labDetail.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(gtWIDTH/2, 16));
        }];
        
    }
    return cell;
}
#pragma mark -- UICollectionDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 401) {
        return CGSizeMake(gtWIDTH/8, 35);
    }else if(collectionView.tag == 402){
        return CGSizeMake(gtWIDTH/2-1, 144);
    }else{
        return CGSizeMake(gtWIDTH/2-1, 79);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (collectionView.tag == 401) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if (collectionView.tag == 402){
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }else{
        return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }
    
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (collectionView.tag == 401) {
        //header
        NSLog(@"indexPath == %ld",(long)indexPath.row);
        if ([self getNowWeekday] >= (indexPath.row +1)) {
//        if (theLoc >indexPath.row) {
            NSLog(@"%ld",(long)[self getNowWeekday]);
            dayChange = [[DateChange alloc] init];
//            int day = (int)([[[dayChange todayData] objectForKey:@"day"] intValue]+ ([self getNowWeekday] - indexPath.row - 2));
            int day = (int)([[[dayChange todayData] objectForKey:@"day"] intValue]+ indexPath.row - [self getNowWeekday] + 1);
//            NSLog(@"day == %d",[[[dayChange todayData] objectForKey:@"day"] intValue]);
//            NSLog(@"week == %d",(int)[self getNowWeekday]);
//            NSLog(@"row == %ld",(long)indexPath.row);
            NSArray *arrBigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
            NSArray *arrSmallMonth = @[@"4",@"6",@"9",@"11"];
            
//            NSLog(@"today == %@",[dateChange todayData]);
            //        theYear = [[[dateChange todayData] objectForKey:@"year"] intValue];
            int theMonth = [[[dayChange todayData] objectForKey:@"month"] intValue];
            int theYear = [[[dayChange todayData] objectForKey:@"year"] intValue];
            int dayNO;
            //非大月
            if ([arrBigMonth indexOfObject:[NSString stringWithFormat:@"%d",theMonth]] == NSNotFound) {
                dayNO = 30;
                if ([arrSmallMonth indexOfObject:[NSString stringWithFormat:@"%d",theMonth]] == NSNotFound) {
                    //2月
                    if (theYear%400 == 0) {
                        dayNO = 29;
                    }else if (theYear%100 != 0 && theYear%4 == 0){
                        dayNO = 29;
                    }else{
                        dayNO = 28;
                    }
                }
            }else{
                //大月
                dayNO = 31;
            }
            if (day < 1) {
                dayNO = dayNO-1+day;
                theMonth --;
                if (theMonth == 0) {
                    theMonth = 12;
                    theYear --;
                }
            }
            NSLog(@"%@",[NSString stringWithFormat:@"%d-%d-%d",theYear,theMonth,day]);
            aYear = [NSString stringWithFormat:@"%d",theYear];
            aMonth = [NSString stringWithFormat:@"%d",theMonth];
            aDay = [NSString stringWithFormat:@"%d",day];
            [indexDAL getCarDayLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] date:[NSString stringWithFormat:@"%d-%d-%d",theYear,theMonth,day] isFake:GTisFake];
            if (theLoc != indexPath.row) {
                UIView *view = (UIView *)[collectionView viewWithTag:1000+indexPath.row];
                view.backgroundColor = COLOR_MAIN_GREEN;
                UILabel *lable = (UILabel *)[collectionView viewWithTag:100+indexPath.row];
                lable.textColor = [UIColor whiteColor];
                UIView *viewPast = (UIView *)[collectionView viewWithTag:1000+theLoc];
                viewPast.backgroundColor = [UIColor clearColor];
                UILabel *lablePast = (UILabel *)[collectionView viewWithTag:100+theLoc];
                lablePast.textColor = COLOR_TEXT_GARY_DEEP;
                theLoc = (int)indexPath.row;
            }
        }
//        [_tableView removeFromSuperview];
//        [self.view addSubview:_tableView];
    }else if (collectionView.tag == 402){
    
//        NSString *strDate = [NSString stringWithFormat:@"%@-%@-%@",[[super todayData] objectForKey:@"year"], [[super todayData] objectForKey:@"month"], [[super todayData] objectForKey:@"day"]];
        if ([strDate isEqualToString:@""]) {
            strDate = [NSString stringWithFormat:@"%@-%@-%@",aYear, aMonth, aDay];
            if ([aYear isEqualToString:@""]) {
                strDate = [NSString stringWithFormat:@"%@-%@-%@",[[self todayData] objectForKey:@"year"], [[self todayData] objectForKey:@"month"], [[self todayData] objectForKey:@"day"]];
            }
        }
        if (indexPath.row == 0) {
            //里程
            NSLog(@"secret == %@",gtSecret);
            if ([gtSecret intValue] == 0) {
                CarMileageViewController *mileageVC = [[CarMileageViewController alloc] init];
                mileageVC.strDate = strDate;
                [self.navigationController pushViewController:mileageVC animated:YES];
            }
        }else if (indexPath.row == 1){
            //时间
            CarTimeViewController *timeVC = [[CarTimeViewController alloc] init];
            timeVC.strDate = strDate;
            [self.navigationController pushViewController:timeVC animated:YES];
        }else if (indexPath.row == 2){
            //油耗
            OilViewController *oilVC = [[OilViewController alloc] init];
            oilVC.strDate = strDate;
            [self.navigationController pushViewController:oilVC animated:YES];
        }else if (indexPath.row == 3){
            //碳排
            CarbonViewController *carbonVC = [[CarbonViewController alloc] init];
            carbonVC.strDate = strDate;
            carbonVC.strCarbon = [dicCarDayStat objectForKey:@"carbon"];
            NSLog(@"strCarbon == %@",dicCarDayStat);
//            carbonVC.strProfit
            [self.navigationController pushViewController:carbonVC animated:YES];
        }
        strDate = @"";
    }
}



#pragma mark -- Action
- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        //选默认车辆
        BaseAlertSheet *alert = [[BaseAlertSheet alloc] init];
        alert.delegate = self;
        //        NSLog(@"count == %lu",(unsigned long)arrayCarList.count);
        [alert initWithArray:arrayCarList ArrayImage:nil name:@"CarList" selectIndex:0];
        [alert showInView:self.view];
    }else if (button.tag == 202){
        //更多
        NSArray *array = [NSArray arrayWithObjects:@"分享", @"隐私设置", @"意见反馈", nil];
        NSArray *arrayImage = [[NSArray alloc] initWithObjects:@"btnShare", @"privacyNormal", @"btnOpinion", nil];
        BaseAlertSheet *alert = [[BaseAlertSheet alloc] init];
        alert.delegate = self;
//        [alert initWithArray:array name:@"more" selectIndex:-1];
        [alert initWithArray:array ArrayImage:arrayImage name:@"more" selectIndex:-1];
        [alert showInView:self.view];
    }else if (button.tag == 203){
        //日历
        Calender *calender = [[Calender alloc] init];
        calender.delegate = self;
        [calender initWithToday:[dayChange dateChange:@"2017-03-11"]];
        [calender showInView:self.view];
    }else if (button.tag == 204){
        //车辆检测
        CarDetectionViewController *carDetectionVC = [[CarDetectionViewController alloc]init];
//        [self presentViewController:carDetectionVC animated:YES completion:nil];
        [self.navigationController pushViewController:carDetectionVC animated:YES];
    }else if (button.tag == 205) {
        //了解UBI车险
        
    }else if (button.tag == 206){
        //体验使用
        [noObd removeView];
    }else if (button.tag == 207){
        //切换车辆
        
    }else if (button.tag == 208){
        //今
        UIView *viewBg = (UIView *)[self.view viewWithTag:1001];
        [viewBg removeFromSuperview];
        theLoc = (int) [self getNowWeekday] -1;
        if (gtCarInfo) {
            [indexDAL getCarListsWithPage:@"1" limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:@"0"];
            if ([[gtCarInfo objectForKey:@"obd_info"] count] == 0) {
                [noObd addViewNoOBD:self.view strCarNo:[gtCarInfo objectForKey:@"car_no"]];
            }
        }else{
            [noObd addViewNoCar:self.view];
        }
        [self initHeadView];
        if (isStop == 1) {
            [stopView removeView];
        }
    }else if (button.tag == 209){
        
    }
}
- (void)btnNavClicked: (UIButton *)btn{
//    CalendarViewController *calendarVC = [[CalendarViewController alloc] init];
//    calendarVC.strStartDate = @"2015-09-10";
//    calendarVC.strEndDate = @"2016-09-09";
//    [self.navigationController pushViewController:calendarVC animated:NO];
}

- (void)btnTitleClicked{
    NSLog(@"选车辆");
    [viewPickerBg setHidden:NO];
}

- (void)btnOkClicked{
    NSLog(@"确定");
    [viewPickerBg setHidden:YES];
}

- (void)btnCancelClicked{
    [viewPickerBg setHidden:YES];
}
- (void)btnWarmClicked{
    CarDetectionViewController *carDetection = [[CarDetectionViewController alloc] init];
    [self.navigationController pushViewController:carDetection animated:YES];
}

- (void)btnShareClicked{
    [_viewShare setHidden:NO];
}

- (void)btnShareWXClicked: (UIButton *)btn{
    NSString *strScene;
    if (btn.tag == 201) {
        strScene = @"session";
    }else{
        strScene = @"timeline";
    }
    [_viewShare setHidden:YES];
    UIImage *image = [self cutImage];
     [super WXSendImageData:image target:strScene];
}

- (void)viewShareRemove{
    [_viewShare setHidden:YES];
}

- (UIImage *)cutImage{
    NSLog(@"分享");
    UIImage* image = nil;
    UIGraphicsBeginImageContext(self.tableView.contentSize);
    {
        CGPoint savedContentOffset = self.tableView.contentOffset;
        CGRect savedFrame = self.tableView.frame;
        self.tableView.contentOffset = CGPointZero;
        self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        
        [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.tableView.contentOffset = savedContentOffset;
        self.tableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"arrayLcnNo.count == %lu",(unsigned long)arrayLcnNo.count);
    return arrayLcnNo.count;
}

#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return gtWIDTH;
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return arrayLcnNo[row];
}



//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setTextColor:COLOR_SHADE_GREEN_DEEP];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@",arrayLcnNo[row]);
    [_pickerView selectedRowInComponent:0];
    [btnTitle setTitle:[NSString stringWithFormat:@"%@",arrayLcnNo[row]] forState:UIControlStateNormal];
//    [indexDAL getAreaWithSeachType:@"2" gpsArea:arrayLcnNo[row]];
//    NSLog(@"arrayPro[row] == %@",arrayLcnNo[row]);
}

/**
 *  获取当前 年 月 日
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)todayData{
    NSDate *now = [NSDate date];
    NSLog(@"now == %@",now);
    NSDictionary *dicToday;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"dd"];
    NSString *year = [dateFormatter stringFromDate:now];
    NSString *month = [dateFormatter2 stringFromDate:now];
    NSString *day = [dateFormatter3 stringFromDate:now];
    dicToday = [NSDictionary dictionaryWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", nil];
    return dicToday;
}

#pragma mark -- CalenderDelegate
- (void)calenderChooseDate:(NSString *)date name:(NSString *)name{
    if ([name isEqualToString:@"chooseDate"]) {//日历选择日
        NSLog(@"date == %@",date);
        [stopView removeView];
        [indexDAL getCarDayLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] date:date isFake:GTisFake];
        [self dateChoose:date];
        strDate = date;
    }else if ([name isEqualToString:@"allHistory"]){//历史总览
        HistoryAllViewController *historyVC = [[HistoryAllViewController alloc] init];
        historyVC.dicData = dicCarAllStat;
        [self.navigationController pushViewController:historyVC animated:YES];
    }
}

- (void)carList: (NSDictionary *)dic{
    NSArray *arrData = [[NSArray alloc] initWithArray:[[dic objectForKey:@"info"] objectForKey:@"data"]];
    int count = [[[dic objectForKey:@"info"] objectForKey:@"count"] intValue];
    NSMutableArray *arrayIcnNo = [[NSMutableArray alloc] init];
    for (int index = 0; index < [arrData count]; index++) {
        NSDictionary *dictionary = [super nullToEmpty:[arrData objectAtIndex:index]];
        NSLog(@"dic == %@",dic);
        if ([[dictionary objectForKey:@"obd_info"] count] != 0) {
            [arrayCarList addObject:[dictionary objectForKey:@"car_no"]];
            [arrayCarInfo addObject:dictionary];
        }
    }
//    [arrayLcnNo addObjectsFromArray:arrayIcnNo];
    [arrayAllCarList addObjectsFromArray:arrData];
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (int index = 0; index < arrayCarInfo.count; index ++ ) {
//        [array addObject:[[arrayCarInfo objectAtIndex:index] objectForKey:@"car_no"]];
//    }
//    arrayCarList = [NSArray arrayWithArray:array];
    //请求数据
    if (arrayAllCarList.count < count) {
        int num = (int)arrayAllCarList.count/10;
        [indexDAL getCarListsWithPage:[NSString stringWithFormat:@"%d",num+1] limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:GTisFake];
    }else{
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        for (int index = 0; index < arrayAllCarList.count; index ++ ) {
//            [arrayCarList addObject:[[arrayAllCarList objectAtIndex:index] objectForKey:@"car_no"]];
//        }
////        arrayCarList = [NSArray arrayWithArray:array];
//        NSLog(@"arrCarlist == %@",arrayCarList);
//        for (int index = 0; index < count; index ++ ) {
//            int isDefault = [[[arrayAllCarList objectAtIndex:index] objectForKey:@"is_default"] intValue];
//            if (isDefault == 1) {
//                NSDictionary *dicCar = [NSDictionary dictionaryWithDictionary:[arrayAllCarList objectAtIndex:index]];
//                dicCar = [super nullToEmpty:dicCar];
////                [[NSUserDefaults standardUserDefaults] setObject:dicCar forKey:@"dicCar"];
////                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
        [indexDAL getCarAllStatWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
    }
    
}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl{
    NSLog(@" == %d",refreshControl.refreshing);
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
//    NSDictionary *dicInfo = [super nullToEmpty:[dic objectForKey:@"info"]];
    NSDictionary *dicToday = [[NSDictionary alloc] initWithDictionary:[self todayData]];
//    NSLog(@"dd == %@ ",dicToday);
//    NSString *strToday = [NSString stringWithFormat:@"%@-%@-%@",[dicToday objectForKey:@"year"], [dicToday objectForKey:@"month"], [dicToday objectForKey:@"day"]];
    if ([cmd isEqualToString:@"CarLists"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [self carList:dic];
            if (arrayCarList.count == 0 && gtCarInfo) {
                [noObd addViewNoOBD:self.view strCarNo:[gtCarInfo objectForKey:@"car_no"]];
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
            [indexDAL getCarAllStatWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
        }
        NSLog(@"gtCarInfo == %@",gtCarInfo);
        
    }else if ([cmd isEqualToString:@"CarAllStat"]){
        if ([[dic objectForKey:@"status"] intValue] == 1){
            NSLog(@"dicInfo == %@",dic);
            //车辆总数据
            dicCarAllStat = [[NSDictionary alloc] initWithDictionary:[super nullToEmpty:[dic objectForKey:@"info"]]];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
//        [_tableView reloadData];
        
        [indexDAL getCarDayStatWithDate:@"" carNo:[gtCarInfo objectForKey:@"car_no"] page:@"1" limit:@"1"];
//        [indexDAL getWeekLogWithCarID:@"1031" date:strToday isFake:GTisFake];
    }else if ([cmd isEqualToString:@"CarDayStat"]){
        if ([[dic objectForKey:@"status"] intValue] == 1){
            if ([dic objectForKey:@"info"] != 0) {
                NSDictionary *dicInfo = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"info"]];
                dicCarDayStat = dicInfo;
                arrayCarDayStat = [NSArray arrayWithObjects:[dicInfo objectForKey:@"mileage"], [dicInfo objectForKey:@"run_time"], [dicInfo objectForKey:@"oil_cost"], [dicInfo objectForKey:@"carbon"], [dic objectForKey:@"stop_info"], nil];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }

        }else{
            
        }
        [indexDAL getCarDayLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] date:@"" isFake:GTisFake];
    }else if ([cmd isEqualToString:@"CarDayLog"]){
        if (isStop == 1) {
            [stopView removeView];
        }
        if ([[dic objectForKey:@"status"] intValue] == 1){
            if ([[dic objectForKey:@"info"] count] != 0) {
                NSLog(@"%@",[dic objectForKey:@"info"]);
                NSDictionary *dicInfo = [super nullToEmptyZero:[dic objectForKey:@"info"]];
                NSLog(@"dicInfo == %@",dicInfo);
                dicCarDayStat = [dic objectForKey:@"info"];
                if ([[dicInfo objectForKey:@"car_status"]isEqualToString:@"-1"]) {
                    arrayFooter = [NSArray arrayWithObjects:@"0L/100km",@"0/0/0次",@"0km/h",@"0km/L", nil];
                    arrayHead = [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];
                }else if ([[dicInfo objectForKey:@"car_status"]isEqualToString:@"0"]){//停车
                    if ([[dicInfo objectForKey:@"stop_info"] count] == 0) {
                        stopView = [[StopView alloc] init];
                        [stopView initViewWithDay:0 superView:self.view money:0];
                        isStop = 1;
                    }else{
                        stopView = [[StopView alloc] init];
                        [stopView initViewWithDay:[[[dicInfo objectForKey:@"stop_info"] objectForKey:@"stop_no"] intValue] superView:self.view money:[[dicInfo objectForKey:@"stop_info"] objectForKey:@"profit_title"]];
                        isStop = 1;
                    }
                }
                else{
                    arrayFooter = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@L/100km",[dicInfo objectForKey:@"avg_oiluse_prm"]], [NSString stringWithFormat:@"%@/%@/%@次",[dicInfo objectForKey:@"fast_add_num"], [dicInfo objectForKey:@"fast_dec_num"], [dicInfo objectForKey:@"fast_turn_num"]], [NSString stringWithFormat:@"%@km/h",[dicInfo objectForKey:@"max_speed"]], [NSString stringWithFormat:@"%@km/h",[dicInfo objectForKey:@"avg_speed"]], nil];
                    
                    arrayHead = [NSArray arrayWithObjects:[dicInfo objectForKey:@"mileage"], [dicInfo objectForKey:@"run_time"], [dicInfo objectForKey:@"oiluse"], [dicInfo objectForKey:@"carbon"], nil];
                }
                NSLog(@"arrayFooter == %@",arrayFooter);
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                UIButton *button = (UIButton *)[self.view viewWithTag:209];
                if ([[dic objectForKey:@"info"] objectForKey:@"score_info"]) {
                    if ([[[[dic objectForKey:@"info"] objectForKey:@"score_info"] objectForKey:@"score_status"] intValue] == 1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"gradeBg"] forState:UIControlStateNormal];
                        [button setTitle:[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"info"] objectForKey:@"score_info"] objectForKey:@"score"]] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
                    }else{
                        [button setImage:[UIImage imageNamed:@"noGrade"] forState:UIControlStateNormal];
                    }
                }
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
//        
//        [_refreshControl endRefreshing];
//        [HUD hidHUD];
    }else if ([cmd isEqualToString:@"CarUpdate"]){
        if ([[dic objectForKey:@"status"] intValue] == 1){
            NSLog(@"%@",[dic objectForKey:@"info"]);
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        [indexDAL getCarDayLogWithCarNo:[gtCarInfo objectForKey:@"car_no"] date:@"" isFake:GTisFake];
    }
}

/**
 *  BaseAlertSheet Delegate
 *
 *  @param index 选中行
 *  @param name  识别名
 */
- (void)didChoseIndex:(int)index name:(NSString *)name{
//    NSLog(@"index == %d",index);
//    NSLog(@"name == %@",name);
    if ([name isEqualToString:@"CarList"]) {//车辆列表
        [btnTitle setTitle:[arrayCarList objectAtIndex:index] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:[arrayCarInfo objectAtIndex:index] forKey:@"dicCar"];
        NSLog(@"car == %@",gtCarInfo);
        [[NSUserDefaults standardUserDefaults] synchronize];
        [indexDAL postCarUpdateWithCarID:[gtCarInfo objectForKey:@"car_id"] carNo:@"" drvOwner:@"" vhlFrm:@"" engNo:@"" fstRegDte:@"" operating:@"" brandId:@"" carSeries:@"" img:@"" updateType:@"2"];
        [noObd removeView];
    }else if ([name isEqualToString:@"more"]){//rightItem
        if (index == 0) {
            //分享
            CarShareView *carShare = [[CarShareView alloc] init];
            [carShare initViewStatuesWithArrayHead:arrayHead arrayFooter:arrayFooter date:strDate surperView:self.view];
//            ShareAlertSheet *shareAS = [[ShareAlertSheet alloc] init];
//            [shareAS initViewWithView:self.view];
//            [shareAS showInView:self.view];
            
            [share WXSendImageData:[super captureView:carShare frame:carShare.frame] target:@"timeline"];
        }else if (index == 1){
            //隐私设置
            SecretViewController *secretVC = [[SecretViewController alloc] init];
            [self.navigationController pushViewController:secretVC animated:YES];
            
        }else if (index == 2){
            //意见反馈
            OpinionViewController *opinionVC = [[OpinionViewController alloc] init];
            opinionVC.type = 1;
            [self.navigationController pushViewController:opinionVC animated:YES];
        }
    }
}

- (void)didNoOBDName:(NSString *)name{
    if ([name isEqualToString:@"noOBD"]) {
        BaseAlertSheet *alert = [[BaseAlertSheet alloc] init];
        alert.delegate = self;
        //        NSLog(@"count == %lu",(unsigned long)arrayCarList.count);
        [alert initWithArray:arrayCarList ArrayImage:nil name:@"CarList" selectIndex:0];
        [alert showInView:self.view];
    }else if ([name isEqualToString:@"noCar"]){
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
