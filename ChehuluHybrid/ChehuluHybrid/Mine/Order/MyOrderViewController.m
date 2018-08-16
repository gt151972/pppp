//
//  MyOrderViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/28.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MyOrderViewController.h"
#import "AQBOrderListViewController.h"
#import "JYBOrderListViewController.h"
#import "HJBOrderListViewController.h"

@interface MyOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation MyOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [super navigationTypeWhite:@"我的订单"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_BG_GRAY2;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    [self.view addSubview:_tableView];
    
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MyOrderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    cell.backgroundColor = COLOR_BG_GRAY2;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"浙A12345", @"plateNO", @"2016012208120000111", @"orderNO", @"2015-06-30", @"startTime", @"2017-06-30", @"endTime", @"3400", @"money", @"安全宝", @"type", @"去支付", @"status", nil];
    
    UIView *viewBg = [[UIView alloc] init];
    viewBg.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:viewBg];
    [viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(cell.contentView).offset(20);
        make.bottom.equalTo(cell.contentView);
    }];
    
    NSString *strType = [dic objectForKey:@"type"];
    UIImage *imageHJB = [UIImage imageNamed:@"icon_mountain"];
    UIImage *imageAQB = [UIImage imageNamed:@"icon_safety"];
    UIImage *imageJYB = [UIImage imageNamed:@"icon_refuel"];
    UIImageView *imgViewIcon = [[UIImageView alloc] init];
    [cell.contentView addSubview:imgViewIcon];
    
    if ([strType isEqualToString:@"环境宝"]) {
        imgViewIcon.image = imageHJB;
        [imgViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewBg.mas_top);
            make.size.mas_equalTo(imageHJB.size);
            make.left.equalTo(viewBg.mas_left).offset(5);
        }];
    }else if ([strType isEqualToString:@"安全宝"]){
        imgViewIcon.image = imageAQB;
        [imgViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewBg.mas_top);
            make.size.mas_equalTo(imageAQB.size);
            make.centerX.equalTo(viewBg);
        }];
    }else if ([strType isEqualToString:@"加油宝"]){
        imgViewIcon.image = imageJYB;
        [imgViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewBg.mas_top);
            make.size.mas_equalTo(imageJYB.size);
            make.left.equalTo(viewBg.mas_left).offset(5);
        }];
    }
    //车牌号
    UILabel *labPlateNo = [[UILabel alloc] init];
    labPlateNo.text = [dic objectForKey:@"plateNO"];
    labPlateNo.textColor = COLOR_MAIN_GRAY;
    labPlateNo.textAlignment = NSTextAlignmentLeft;
    labPlateNo.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:labPlateNo];
    [labPlateNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg.mas_top).offset(20);
        make.left.equalTo(viewBg.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    
    //订单号
    UILabel *labOrderID = [[UILabel alloc] init];
    labOrderID.text = [dic objectForKey:@"orderNO"];
    labOrderID.textAlignment = NSTextAlignmentLeft;
    labOrderID.textColor = COLOR_TEXT_GARY;
    labOrderID.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labOrderID];
    [labOrderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labPlateNo);
        make.left.equalTo(labPlateNo.mas_right);
        make.size.mas_equalTo(CGSizeMake(200, 14));
    }];
    
    //时间
    UILabel *labTime = [[UILabel alloc] init];
    labTime.text = [NSString stringWithFormat:@"%@至%@",[dic objectForKey:@"startTime"],[dic objectForKey:@"endTime"]];
    labTime.textAlignment = NSTextAlignmentLeft;
    labTime.textColor = COLOR_TEXT_GARY;
    labTime.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPlateNo.mas_bottom).offset(5);
        make.left.equalTo(labPlateNo);
        make.size.mas_equalTo(CGSizeMake(300, 14));
    }];
    
    //金额
    UILabel *labMoney = [[UILabel alloc] init];
    labMoney.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"money"]];
    labMoney.textColor = COLOR_MAIN_GRAY;
    labMoney.textAlignment = NSTextAlignmentLeft;
    labMoney.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:labMoney];
    [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labPlateNo);
        make.top.equalTo(viewBg).offset(75);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    
    //订单状态
    UIImageView *imageViewStatus= [[UIImageView alloc] init];
    [cell.contentView addSubview:imageViewStatus];
    UIButton *btnStatus = [[UIButton alloc] init];
    [cell.contentView addSubview:btnStatus];
    if ([[dic objectForKey:@"status"] isEqualToString:@"驳回"]) {
        //驳回
        UIImage *imageProject = [UIImage imageNamed:@"base"];
        imageViewStatus.image = imageProject;
        [imageViewStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageProject.size);
            make.left.equalTo(labMoney.mas_right);
            make.centerY.equalTo(labMoney);
        }];
        [btnStatus setTitle:@"驳回" forState:UIControlStateNormal];
        [btnStatus.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnStatus addTarget:self action:@selector(btnProjectClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerX.and.centerY.equalTo(imageViewStatus);
        }];
    }else if ([[dic objectForKey:@"status"] isEqualToString:@"去支付"]){
        UIImage *imageGo = [UIImage imageNamed:@"btnGoSelect"];
        imageViewStatus.image = imageGo;
        [btnStatus setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
        [imageViewStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageGo.size);
            make.right.equalTo(viewBg).offset(-10);
            make.centerY.equalTo(labMoney);
        }];
        [btnStatus setTitle:@"去支付" forState:UIControlStateNormal];
        [btnStatus addTarget:self action:@selector(btnPayClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnStatus.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerY.equalTo(labMoney);
            make.right.equalTo(imageViewStatus.mas_left);
            make.width.mas_equalTo(50);
        }];
    }else if ([[dic objectForKey:@"status"] isEqualToString:@"处理中"]){
        UIImage *imageGo = [UIImage imageNamed:@"btnGoSelect"];
        imageViewStatus.image = imageGo;
        [imageViewStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageGo.size);
            make.right.equalTo(viewBg).offset(-10);
            make.centerY.equalTo(labMoney);
        }];
        [btnStatus setTitle:@"处理中" forState:UIControlStateNormal];
        [btnStatus setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
        [btnStatus.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerY.equalTo(labMoney);
            make.right.equalTo(imageViewStatus.mas_left);
            make.width.mas_equalTo(50);
        }];
    }
    
    //产品类型
    UIView *viewTypeBg = [[UIView alloc] init];
    viewTypeBg.backgroundColor = COLOR_MAIN_GREEN;
    [cell.contentView addSubview:viewTypeBg];
    [viewTypeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewBg);
        make.top.equalTo(viewBg).offset(14);
        make.size.mas_equalTo(CGSizeMake(33, 20));
    }];
    UIButton *btnType = [[UIButton alloc] init];
    [btnType setTitle:[dic objectForKey:@"type"] forState:UIControlStateNormal];
    [btnType.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [btnType setBackgroundColor:COLOR_MAIN_GREEN];
    [btnType.layer setMasksToBounds:YES];
    [btnType.layer setCornerRadius:10];
    if ([strType isEqualToString:@"环境宝"]) {
        btnType.tag = 201;
    }else if ([strType isEqualToString:@"安全宝"]){
        btnType.tag = 202;
    }else if ([strType isEqualToString:@"加油宝"]){
        btnType.tag = 203;
    }
    [btnType addTarget:self action:@selector(btnTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnType];
    [btnType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41, 20));
        make.top.and.right.equalTo(viewTypeBg);
    }];
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = COLOR_TEXT_GARY;
    [cell.contentView addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg).offset(100);
        make.left.and.right.equalTo(viewBg);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *labAll = [[UILabel alloc] init];
    labAll.text = @"查看全部";
    labAll.textAlignment = NSTextAlignmentLeft;
    labAll.textColor = COLOR_MAIN_GREEN;
    labAll.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:labAll];
    [labAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labPlateNo);
        make.top.equalTo(viewLine.mas_bottom);
        make.bottom.equalTo(viewBg);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *labNO = [[UILabel alloc] init];
    labNO.layer.masksToBounds = YES;
    labNO.layer.cornerRadius = 8;
    labNO.layer.borderWidth = 1;
    labNO.layer.borderColor = COLOR_MAIN_GREEN.CGColor;
    labNO.text = @"3";
    labNO.textColor = COLOR_MAIN_GREEN;
    labNO.textAlignment = NSTextAlignmentCenter;
    labNO.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:labNO];
    [labNO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(labAll);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *btnOrder = [[UIButton alloc] init];
    btnOrder.backgroundColor = [UIColor clearColor];
    [btnOrder addTarget:self action:@selector(btnOrderClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnOrder];
    [btnOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(viewBg);
        make.bottom.equalTo(viewLine.mas_top);
    }];
    UIButton *btnAll = [[UIButton alloc] init];
    btnAll.backgroundColor = [UIColor clearColor];
    [btnAll addTarget:self action:@selector(btnAllClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnAll];
    [btnAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(viewBg);
        make.top.equalTo(viewLine.mas_bottom);
    }];
    
    return cell;
}

#pragma mark -- Action
/**
 *  产品说明
 */
- (void)btnTypeClicked: (UIButton *)btn{
    
}

/**
 *  查看全部
 */
- (void)btnProjectClicked{
    
}

/**
 *  去支付
 */
- (void)btnPayClicked{
    
}

/**
 *  订单详情
 */
- (void)btnOrderClicked{
    
}

/**
 *  查看全部
 */
- (void)btnAllClicked{
    AQBOrderListViewController *AQBOrderListVC = [[AQBOrderListViewController alloc] init];
    [self.navigationController pushViewController:AQBOrderListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
