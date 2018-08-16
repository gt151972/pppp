//
//  CarDetectionViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/22.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarDetectionViewController.h"
#import "CarMistakeAnimation.h"
#import "CarMistakeViewController.h"
#import "CarMistakeDetailViewController.h"
#import "CarHistoryViewController.h"
#import <POP.h>


@interface CarDetectionViewController (){
    NSTimer *timer;
    NSArray *arrayError;
    NSArray *arrayFault;
    BOOL isError;
    CarMistakeAnimation *animation;
    NSDictionary *dicData;
}
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation CarDetectionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [super navigationTypeWhite:@"车况检测"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initData{
    arrayError = [[NSArray alloc] init];
    arrayFault = [[NSArray alloc] init];
    isError = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_MAIN_WHITE;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, gtWIDTH, 44)];
    labTitle.text = @"车辆检测";
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:labTitle];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btnClose setImage:[UIImage imageNamed:@"misScanClose"] forState:UIControlStateNormal];
    [btnClose setTag:201];
    [btnClose addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getCarStatusWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
    
    animation = [[CarMistakeAnimation alloc] init];
    [animation initViewWithSuperView:self.view];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:5.6 target:self selector:@selector(MouseMove1) userInfo:nil repeats:YES];
    
}

- (void)MouseMove1{
    if (timer.isValid) {
        [timer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        timer=nil;            // 将销毁定时器
    }
    [self initView];
    [self addItem];
}

- (void)addItem{
    UIButton *btnRe = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 44, 20, 44, 44)];
    [btnRe setImage:[UIImage imageNamed:@"historyMistake"] forState:UIControlStateNormal];
    [btnRe setTag:202];
    [btnRe addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRe];
}

- (void)initView{
    UILabel *labStatues = [[UILabel alloc] initWithFrame:CGRectMake(0, 284, gtWIDTH, 22)];
    labStatues.textAlignment = NSTextAlignmentCenter;
    labStatues.font = [UIFont systemFontOfSize:16];
    labStatues.tag = 101;
    labStatues.text = [[dicData objectForKey:@"info"] objectForKey:@"status"];
    if ([[dicData objectForKey:@"info"] objectForKey:@"is_error"] == 0) {
        labStatues.textColor = COLOR_MAIN_RED;
    }else{
        labStatues.textColor = COLOR_MAIN_GREEN;
    }
    [self.view addSubview:labStatues];
    
    UILabel *labTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 314, gtWIDTH, 17)];
    labTime.textColor = COLOR_TEXT_GARY;
    labTime.textAlignment = NSTextAlignmentCenter;
    labTime.font = [UIFont systemFontOfSize:12];
    labTime.tag = 102;
    labTime.text = [NSString stringWithFormat:@"数据获取时间  %@",[[dicData objectForKey:@"info"] objectForKey:@"last_time"]];
    [self.view addSubview:labTime];
    
//    UILabel *labStatues = (UILabel *)[self.view viewWithTag:101];
//    labStatues.text = [[dic objectForKey:@"info"] objectForKey:@"status"];
//    if ([[dic objectForKey:@"info"] objectForKey:@"is_error"] == 0) {
//        labStatues.textColor = COLOR_MAIN_RED;
//    }else{
//        labStatues.textColor = COLOR_MAIN_GREEN;
//    }
//    
//    UILabel *labTime = (UILabel *)[self.view viewWithTag:102];
//    labTime.text = [NSString stringWithFormat:@"数据获取时间  %@",[[dic objectForKey:@"info"] objectForKey:@"last_time"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 379, gtWIDTH,gtHEIGHT - 400) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FaultTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (isError == 1 && indexPath.row >= arrayError.count) {
        CarMistakeDetailViewController *detailVC = [[CarMistakeDetailViewController alloc] init];
        detailVC.dicData = [arrayFault objectAtIndex:(indexPath.row - arrayError.count)];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isError == 0) {
        return 5;
    }else{
        return arrayError.count + arrayFault.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FaultTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    if (isError == 0) {
        NSArray *arrayName = [NSArray arrayWithObjects:@"冷却液温度", @"电池电压", @"点火提前角", @"进气管压力", @"引擎转速", nil];
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UIImage *imgYes = [UIImage imageNamed:@"misScanRight"];
        UIImageView *imageYes = [[UIImageView alloc] initWithImage:imgYes];
        [cell.contentView addSubview:imageYes];
        [imageYes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imgYes.size);
            make.right.mas_offset(-22);
            make.centerY.equalTo(cell.contentView);
        }];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"misError"];
        cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        if (indexPath.row < arrayError.count) {
            cell.textLabel.text = [[arrayError objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"故障码: %@",[[arrayFault objectAtIndex:(indexPath.row - arrayError.count)] objectForKey:@"code"]];
        }
        
    }
    return cell;
}


- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarStatus"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            dicData = [[NSDictionary alloc] initWithDictionary:dic];
            if ([[[dic objectForKey:@"info"] objectForKey:@"is_error"] intValue] == 0) {
                //无故障
                isError = NO;
                
            }else{
                isError = YES;
                arrayError = [[dic objectForKey:@"info"] objectForKey:@"error_info"];
                arrayFault = [[dic objectForKey:@"info"] objectForKey:@"fault_info"];
            }
            
            
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
    }
}

- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (button.tag == 202){
//        //重新检测
//        indexDAL = [[IndexRequestDAL alloc] init];
//        indexDAL.delegate = self;
//        [indexDAL getCarStatusWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
//        [self.tableView setHidden:YES];
//        [animation MouseMove];
//        timer=[NSTimer scheduledTimerWithTimeInterval:5.6 target:self selector:@selector(MouseMove1) userInfo:nil repeats:YES];
        
        //历史故障
        CarHistoryViewController *historyVC = [[CarHistoryViewController alloc] init];
        [historyVC.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:historyVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
