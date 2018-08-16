//
//  MoneyViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/11/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MoneyViewController.h"
#import "WithDrawViewController.h"
#import "TurnoveriListViewController.h"

#import "RingView.h"

#define COLOR  [UIColor colorWithRed:104/255.0 green:189/255.0 blue:166/255.0 alpha:1.0]
#define YELLOW  [UIColor colorWithRed:239/255.0 green:236/255.0 blue:97/255.0 alpha:1.0]

@interface MoneyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RingView *ringView;
@property (nonatomic, strong) UITableViewCell *cell;
@end

@implementation MoneyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:nil];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addRightItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InfoTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)addRightItem{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [btnRight setTitle:@"收支明细" forState:UIControlStateNormal];
    [btnRight setTitleColor:COLOR_TEXT_GARY forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnRight addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140;
        }else if (indexPath.row == 1){
            return 40;
        }else{
            return 42;
        }
    }else{
        return gtHEIGHT - 286;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InfoTableViewCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!_cell) {
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:gtDicMoney];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [_cell.contentView addSubview:[self ringView:100]];
            CGFloat halfWidth = 63;
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                                   radius:25
                                               startAngle:-M_PI
                                                 endAngle:M_PI
                                                clockwise:YES];
            path.lineCapStyle = kCGLineCapButt;
            path.lineJoinStyle = kCGLineJoinBevel;
            
            CAShapeLayer *progressLayer = [CAShapeLayer layer];
            CGFloat layerWidth = 25;
            CGFloat layerX = (gtWIDTH - layerWidth)/2;
            progressLayer.frame = CGRectMake(layerX, 0, layerWidth, layerWidth);
            progressLayer.fillColor = [UIColor clearColor].CGColor;
            progressLayer.strokeColor = YELLOW.CGColor;
            progressLayer.lineCap = kCALineCapButt;
            progressLayer.lineWidth = 25;
            progressLayer.path = path.CGPath;
            progressLayer.strokeEnd = 0;
            progressLayer.lineCap = kCALineCapButt;
            [_cell.contentView.layer addSublayer:progressLayer];
            
            UILabel *labTitle = [[UILabel alloc] init];
            labTitle.text = @"账户余额";
            labTitle.textColor = COLOR;
            labTitle.textAlignment = NSTextAlignmentCenter;
            labTitle.font = [UIFont systemFontOfSize:12];
            [_cell.contentView addSubview:labTitle];
            [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_cell.contentView.mas_centerX);
                make.centerY.equalTo(_cell.contentView).offset(-6);
                make.size.mas_equalTo(CGSizeMake(100, 12));
            }];
            UILabel *labData = [[UILabel alloc] init];
            float data = [[dic objectForKey:@"cash_money"] floatValue] + [[dic objectForKey:@"freeze_money"] floatValue];
            labData.text = [NSString stringWithFormat:@"%.2f",data];
            labData.textColor = COLOR;
            labData.textAlignment = NSTextAlignmentCenter;
            labData.font = [UIFont systemFontOfSize:14];
            [_cell.contentView addSubview:labData];
            [labData mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_cell.contentView.mas_centerX);
                make.centerY.equalTo(_cell.contentView).offset(6);
                make.size.mas_equalTo(CGSizeMake(100, 14));
            }];
        }else if (indexPath.row == 1){
            UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/2, _cell.contentView.frame.size.height)];
            [_cell.contentView addSubview:viewLeft];
            UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/2, 0, gtWIDTH/2, _cell.contentView.frame.size.height)];
            [_cell.contentView addSubview:viewRight];
            UILabel *labLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/2, _cell.contentView.frame.size.height)];
            labLeft.text = [NSString stringWithFormat:@"可用  %@车币",[dic objectForKey:@"cash_money"]];
            labLeft.textColor = COLOR_TEXT_GARY;
            labLeft.textAlignment = NSTextAlignmentCenter;
            labLeft.font = [UIFont systemFontOfSize:14];
            [viewLeft addSubview:labLeft];
            UILabel *labRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH/2, _cell.contentView.frame.size.height)];
            labRight.text = [NSString stringWithFormat:@"冻结 %@车币",[dic objectForKey:@"freeze_money"]];
            labRight.textColor = COLOR_TEXT_GARY;
            labRight.textAlignment = NSTextAlignmentCenter;
            labRight.font = [UIFont systemFontOfSize:14];
            [viewRight addSubview:labRight];
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/2, 2, 1, 36)];
            viewLine.backgroundColor = COLOR_TEXT_GARY;
            [_cell.contentView addSubview:viewLine];
        }else{
            UIButton *btnWithdraw = [[UIButton alloc] init];
            [btnWithdraw.layer setCornerRadius:5];
            [btnWithdraw.layer setMasksToBounds:YES];
            [btnWithdraw.layer setBorderColor:COLOR.CGColor];
            [btnWithdraw.layer setBorderWidth:1];
            [btnWithdraw setTitle:@"提现" forState:UIControlStateNormal];
            [btnWithdraw setTitleColor:COLOR forState:UIControlStateNormal];
            [btnWithdraw.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btnWithdraw addTarget:self action:@selector(btnWithdrawClicked) forControlEvents:UIControlEventTouchUpInside];
            [_cell.contentView addSubview:btnWithdraw];
            [btnWithdraw mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_cell.contentView);
                make.size.mas_equalTo(CGSizeMake(53, 21));
            }];
        }
    }else{
//        _cell.contentView.backgroundColor = [UIColor yellowColor];
    }
    return _cell;
}

- (RingView *)ringView :(CGFloat)percent{
    if (!_ringView) {
        CGFloat width = 115;
        _ringView = [[RingView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 12, width, width)];
        //        _blueRingView.backgroundColor = [UIColor redColor];
        [_ringView updatePercent:percent animation:YES];
        [_cell.contentView addSubview:_ringView];
    }
    return _ringView;
}
- (void)btnRightClicked{
    TurnoveriListViewController *listVC = [[TurnoveriListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)btnWithdrawClicked{
    WithDrawViewController *withDrawVC = [[WithDrawViewController alloc] init];
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)doClickRightButton{
    
}

@end
