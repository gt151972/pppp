//
//  CarMistakeViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2016/12/28.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarMistakeViewController.h"
#import "CarHistoryViewController.h"

@interface CarMistakeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)CAShapeLayer *shapeLayer;
@property (nonatomic, strong)UIBezierPath *path;
@property (nonatomic, strong)CAGradientLayer *gradientLayer;
@end

@implementation CarMistakeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeBlack:@"监测数据"];
    [self.view setBackgroundColor:COLOR_BG_BLACK_DEEP];
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MistakeTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)initNav{
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnRight setImage:[UIImage imageNamed:@"historyFault"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTag:201];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnShare setImage:[UIImage imageNamed:@"shareNormal"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTag:202];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItems = @[rightItem, shareItem];
}

- (void)btnBackClicked{
    NSArray *controllerArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[controllerArr objectAtIndex:0] animated:YES];
}

- (void)btnRightClicked: (UIButton *)btn{
    if (btn.tag == 201) {
        CarHistoryViewController *historyVC = [[CarHistoryViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"分享到微信" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            UIButton *btnCircle = [[UIButton alloc] init];
            [btnCircle setImage:[UIImage imageNamed:@"shareCircle"] forState:UIControlStateNormal];
            [btnCircle setTitle:@"朋友圈" forState:UIControlStateNormal];
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:cancle];
    }
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 34;
        }
    }else{
        return gtHEIGHT - 168;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
       
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 4){
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 10)];
    view.backgroundColor = COLOR_BG_BLACK_DEEP;
    return view;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    cell.backgroundColor = COLOR_BG_BLACK_DEEP;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *strTime = @"06:13";
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",strTime,strTime];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
        }else{
            cell.textLabel.text = @"等我过去反复";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor whiteColor];
            UIButton *btnVIP = [[UIButton alloc] init];
            [btnVIP setTitle:@"优惠券" forState:UIControlStateNormal];
            [btnVIP setTitleColor:COLOR_SHADE_YELLOW forState:UIControlStateNormal];
            [btnVIP.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btnVIP.layer setMasksToBounds:YES];
            [btnVIP.layer setCornerRadius:10];
            [btnVIP.layer setBorderColor:COLOR_SHADE_YELLOW.CGColor];//边框颜色
            [btnVIP.layer setBorderWidth:1.0]; //边框宽度
            [cell.contentView addSubview:btnVIP];
            [btnVIP mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(51, 20));
                make.centerY.equalTo(cell.mas_centerY);
                make.right.mas_equalTo(-20);
            }];
        }
    }else{
        [self shapeLayer];
    }
    return cell;
}

- (CAShapeLayer *)shapeLayer{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, gtWIDTH-30, 70);
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = COLOR_SHADE_GREEN.CGColor;
    //        [self loadLayer:_pointLayer WithColor:self.pointColor];
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.path = self.path.CGPath;
    _shapeLayer.lineWidth = 3;
    return _shapeLayer;
}

- (UIBezierPath *)path{
    _path.lineWidth = 7;
    [_path setLineCapStyle: kCALineCapRound];
    _path.lineJoinStyle = kCALineJoinRound;
    [_path moveToPoint:CGPointMake(0, 0)];
    [_path addLineToPoint:CGPointMake(0, 300)];
    [_path stroke];
    UIColor *color = COLOR_SHADE_GREEN;
    [color set];
    return _path;
}

- (CAGradientLayer *)gradientLayer{
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, 7, 300);
    //颜色
    _gradientLayer.colors = @[(id)[UIColor colorWithRed:38/255.0 green:226/255.0 blue:160/255.0 alpha:1.000].CGColor,
                              (id)[UIColor colorWithRed:43/255.0 green:184/255.0 blue:116/255.0 alpha:1.0].CGColor];

    [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
    [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
    
    [_gradientLayer setMask:self.shapeLayer];
    
    return _gradientLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
