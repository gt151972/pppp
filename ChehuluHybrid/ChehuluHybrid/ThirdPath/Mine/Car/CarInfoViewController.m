//
//  CarInfoViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/22.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarInfoViewController.h"
#import "FirstInfoViewController.h"
#import "SecondInfoViewController.h"
#import "ThirdInfoViewController.h"

@interface CarInfoViewController (){
//    NSDictionary *dicCar;
//    NSDictionary *dicOBD;
//    NSDictionary *dicPolicy;
}

@property (nonatomic, strong) FirstInfoViewController *firstVC;//车辆
@property (nonatomic, strong) SecondInfoViewController *secondVC;//OBD
@property (nonatomic, strong) ThirdInfoViewController *thirdVC;//保单
@property (nonatomic, strong) UIScrollView *headScrollView;//头部标签栏
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) UIButton *btnItem;
@property (nonatomic, strong) UIImageView *imageViewItemBg;


@property (nonatomic, strong) NSMutableArray *arrItem;//标题

@end
NSDictionary *dicCar;
NSDictionary *dicOBD;
NSDictionary *dicPolicy;
@implementation CarInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"车辆信息"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"dic == %@",_dic);
    
}

- (void)loadView{
    [super loadView];
    [self initData];
}

- (void)initData{
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getCarDetailWithCarID:[_dic objectForKey:@"car_id"] isVio:@"0" isMot:@"0" casualty:@"0"];
    _arrItem = [[NSMutableArray alloc] initWithObjects:@"车辆", @"OBD", @"保单", nil];
    NSLog(@"dic == %@",_dic);
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"carID"  object:[[_dic objectForKey:@"info"] objectForKey:@"car_id"]];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNotification:) name:@"dicPolicy" object:nil];
}

- (void)initView{
    _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 40)];
    _headScrollView.backgroundColor = [UIColor whiteColor];
//    _imageViewItemBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/3, 40)];
//    _imageViewItemBg.image = [UIImage imageNamed:@"CarInfoBtnBg"];
//    [_headScrollView addSubview:_imageViewItemBg];
    for (int index = 0; index<_arrItem.count; index++) {
        _btnItem = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH*index/_arrItem.count, 0, gtWIDTH/_arrItem.count, 40)];
        _btnItem.tag = 210+index;
        if (_btnItem.tag == 210) {
            _btnItem.selected = YES;
        }
        _btnItem.backgroundColor = [UIColor clearColor];
        [_btnItem addTarget:self action:@selector(btnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnItem setTitle:[_arrItem objectAtIndex:index] forState:UIControlStateNormal];
        [_btnItem setBackgroundImage:[UIImage imageNamed:@"CarInfoBtnBg"] forState:UIControlStateSelected];
        [_btnItem setTitleColor:COLOR_TEXT_GARY forState:UIControlStateNormal];
        [_headScrollView addSubview:_btnItem];
        
    }
    _headScrollView.showsHorizontalScrollIndicator = NO;
    _headScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_headScrollView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, gtWIDTH, gtHEIGHT - 104)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    [self addSubController];
}

- (void)addSubController{
    _firstVC = [[FirstInfoViewController alloc] init];
    _secondVC = [[SecondInfoViewController alloc] init];
    _thirdVC = [[ThirdInfoViewController alloc] init];
    [self addChildViewController:_firstVC];
    [self addChildViewController:_secondVC];
    [self addChildViewController:_thirdVC];

    [self fitFrameChildViewController:_firstVC];
    [self.contentView addSubview:_firstVC.view];
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"%@",NSStringFromCGRect(_firstVC.view.frame));
    
    _currentVC = _firstVC;
}

- (void)fitFrameChildViewController: (UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//转换childVC
- (void)transitionFromOldViewController: (UIViewController *)oldViewController newViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}

//移除childVC
- (void)removeAllChildViewController{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

- (void)btnItemClicked: (UIButton *)sender{
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:210 + i];
        //选中当前按钮时
        if (sender.tag == btn.tag) {
            if (sender.selected == NO) {
                sender.selected = !sender.selected;
            }
        }else{
            
            [btn setSelected:NO];
        }
    }
    if ((sender.tag == 210 && _currentVC == _firstVC) || (sender.tag == 211 && _currentVC == _secondVC) || (sender.tag == 212 && _currentVC == _thirdVC)) {
        return;
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    switch (sender.tag) {
        case 210:{
            [self fitFrameChildViewController:_firstVC];
            [self transitionFromOldViewController:_currentVC newViewController:_firstVC];
            [center postNotificationName:@"dicCar"  object:dicCar];
        }
            break;
        case 211:{
            [self fitFrameChildViewController:_secondVC];
            [self transitionFromOldViewController:_currentVC newViewController:_secondVC];
            [center postNotificationName:@"dicOBD"  object:dicOBD];
        }
            break;
        case 212:{
//            [center postNotificationName:@"dicPolicy"  object:dicPolicy];
//            NSLog(@"dicPolicy == %@",dicPolicy);
            [self fitFrameChildViewController:_thirdVC];
            [self transitionFromOldViewController:_currentVC newViewController:_thirdVC];
        }
            break;
    }
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    int state = [[dic objectForKey:@"status"] intValue];
    if ([cmd isEqualToString:@"CarDetail"]) {
        if (state == 1) {
            dicCar = dic;
            NSLog(@"dicCar == %@",dicCar);
        }else{
            [self alert:[dic objectForKey:@"info"]];
        }
        [self initView];
         [indexDAL postCarPolicyObdInfoWithPolicyid:[_dic objectForKey:@"policyid"] carNo:[_dic objectForKey:@"car_no"]];
    }else if ([cmd isEqualToString:@"CarPolicyObdinfo"]){
        if (state == 1) {
            dicOBD = dic;
        }else{
            [self alert:[dic objectForKey:@"info"]];
        }
         [indexDAL postOrderDetailWithPolicyid:[_dic objectForKey:@"policyid"]];
    }else if ([cmd isEqualToString:@"OrderDetail"]){
        if (state == 1) {
            dicPolicy = dic;
        }else{
            [self alert:[dic objectForKey:@"info"]];
        }
    }
}

- (void)alert: (NSString *)strTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
