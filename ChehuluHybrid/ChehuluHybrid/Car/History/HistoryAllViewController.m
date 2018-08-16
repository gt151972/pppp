//
//  HistoryAllViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/24.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "HistoryAllViewController.h"

#define LINE_COLOR  [super colorWithHexString:@"#252731"]

@interface HistoryAllViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrayMonthData;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewFoot;
@end

@implementation HistoryAllViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
//    [super navigationTypeBlack:_strTitle];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
//    NSLog(@"data == %@",_dicData);
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
//    [indexDAL getCarMonthStatWithDate:@"" carNo:[gtCarInfo objectForKey:@"car_no"] page:@"1" limit:@""];
    [indexDAL getCarAllStatWithCarNo:[gtCarInfo objectForKey:@"car_no"]];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,319) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_MAIN_BLACK;
    self.tableView.scrollEnabled = NO;
    self.tableView.tag = 501;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HIstoryHeadTableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.tableViewFoot = [[UITableView alloc] initWithFrame:CGRectMake(0, 319, gtWIDTH,gtHEIGHT - 319) style:UITableViewStylePlain];
    self.tableViewFoot.delegate = self;
    self.tableViewFoot.dataSource = self;
    self.tableViewFoot.backgroundColor = COLOR_BG_GRAY2;
    self.tableViewFoot.scrollEnabled = YES;
    self.tableViewFoot.tag = 502;
    self.tableViewFoot.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewFoot.allowsSelection = NO;
    [self.tableViewFoot registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HIstoryFootTableViewCell"];
    
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 501) {
        if (indexPath.section == 1) {
            return 54;
        }else if (indexPath.section == 0){
            return 44;
        }
        else{
            return 64;
        }
    }else{
        if (indexPath.row == 0) {
            return 47;
        }else{
            return 76;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        if (section > 1) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 16;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (tableView.tag == 501) {
        view.frame = CGRectMake(0, 0, gtWIDTH, 1);
        view.backgroundColor = LINE_COLOR;
    }else{
        view.frame = CGRectMake(0, 0, gtWIDTH, 16);
        view.backgroundColor = COLOR_BG_GRAY2;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        return 1;
    }else{
        return 3;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 501) {
        return 5;
    }else{
        return arrayMonthData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView.tag == 501) {
        static NSString *cellIdentifier = @"HIstoryHeadTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        if (!cell) {
        }
        cell.backgroundColor = COLOR_MAIN_BLACK;
        if (indexPath.section == 0) {//nav
            UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
            [btnBack setImage:[UIImage imageNamed:@"backArrowWhite"] forState:UIControlStateNormal];
            [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnBack];
            
            UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 64, 0, 44, 44)];
            [btnRight setImage:[UIImage imageNamed:@"moreWhite"] forState:UIControlStateNormal];
            [btnRight setTag:201];
            [btnRight addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnRight];
            
            UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, gtWIDTH - 128, 44)];
            
            labTitle.text = [NSString stringWithFormat:@"%@至今",[_dicData objectForKey:@"start_date"]];
            labTitle.textColor = [UIColor whiteColor];
            labTitle.textAlignment = NSTextAlignmentCenter;
            labTitle.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:labTitle];
            
            
        }else if (indexPath.section == 1){//停行离线
            NSArray *array = [NSArray arrayWithObjects:@"行驶", @"停车", @"离线", nil];
            NSArray *arrayData = [NSArray arrayWithObjects:[_dicData objectForKey:@"run_num"], [_dicData objectForKey:@"stop_num"], [_dicData objectForKey:@"lost_num"], nil];
            
            for (int index = 0; index<array.count; index++) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(index*(gtWIDTH/3), 0, gtWIDTH/3, 54)];
                lable.text = [NSString stringWithFormat:@"%@%@天",[array objectAtIndex:index], [arrayData objectAtIndex:index]];
                lable.textColor = [UIColor whiteColor];
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:lable];
            }
            
        }else if (indexPath.section == 2){//里程时间
            NSArray *array = [NSArray arrayWithObjects:@"里程", @"时间", nil];
            int second = [[_dicData objectForKey:@"run_time"] intValue];
            NSString *strUnit = @"s";
            if (second>60 && second < 3600) {
                second = second/60;
                strUnit = @"min";
            }else if (second > 3600){
                second = second / 60;
                strUnit = @"h";
            }
            NSArray *arrayData = [NSArray arrayWithObjects:[_dicData objectForKey:@"mileage"], [NSString stringWithFormat:@"%d",second], nil];
            NSArray *arrayUnit = [NSArray arrayWithObjects:@"km", strUnit, nil];
            for (int index = 0; index<array.count; index++) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(index*(gtWIDTH/2), 0, gtWIDTH/2, 54)];
                lable.text = [NSString stringWithFormat:@"%@  %@%@",[array objectAtIndex:index], [arrayData objectAtIndex:index], [arrayUnit objectAtIndex:index]];
                lable.textColor = COLOR_MAIN_WHITE;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:18];
                [cell.contentView addSubview:lable];
            }
        }else if (indexPath.section == 3){//油耗碳排
            NSArray *array = [NSArray arrayWithObjects:@"油耗", @"碳排", nil];
            NSArray *arrayData = [NSArray arrayWithObjects:[_dicData objectForKey:@"oiluse"], [_dicData objectForKey:@"carbon"], nil];
            NSArray *arrayUnit = [NSArray arrayWithObjects:@"L", @"kg", nil];
            for (int index = 0; index<array.count; index++) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(index*(gtWIDTH/2), 0, gtWIDTH/2, 54)];
                lable.text = [NSString stringWithFormat:@"%@  %@%@",[array objectAtIndex:index], [arrayData objectAtIndex:index], [arrayUnit objectAtIndex:index]];
                lable.textColor = COLOR_MAIN_WHITE;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:18];
                [cell.contentView addSubview:lable];
            }
        }else if (indexPath.section == 4){//邮费
            NSArray *array = [NSArray arrayWithObjects:@"油费", nil];
            NSArray *arrayData = [NSArray arrayWithObjects:[_dicData objectForKey:@"oil_cost"], nil];
            NSArray *arrayUnit = [NSArray arrayWithObjects:@"¥", nil];
            for (int index = 0; index<array.count; index++) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(index*(gtWIDTH/2), 0, gtWIDTH/2, 54)];
                lable.text = [NSString stringWithFormat:@"%@  %@%@",[array objectAtIndex:index], [arrayUnit objectAtIndex:index], [arrayData objectAtIndex:index]];
                lable.textColor = COLOR_MAIN_WHITE;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:18];
                [cell.contentView addSubview:lable];
            }
        }
    }else{
        //foot
        static NSString *cellIdentifier = @"HIstoryFootTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        NSDictionary *dicMonth = [arrayMonthData objectAtIndex:indexPath.section];
        if (!cell) {
        }
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(140.5, 350, 94, 25);
            label.text = @"2017年03月";
            label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
            label.textColor = COLOR_TEXT_GARY_DEEP;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }else if (indexPath.row == 1){
            for (int index = 0; index < 2; index ++ ) {
                NSArray *arrImage = [NSArray arrayWithObjects:@"IconMilleage", @"iconTime", nil];
                NSArray *arrData = [NSArray arrayWithObjects:[dicMonth objectForKey:@"mileage"], [dicMonth objectForKey:@"run_time"], nil];
                NSArray *arrUnit = [NSArray arrayWithObjects:@"km", @"h", nil];
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index * (gtWIDTH/2), 0, gtWIDTH/2, 76)];
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrImage objectAtIndex:index]]] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"%@%@",[arrData objectAtIndex:index], [arrUnit objectAtIndex:index]] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn];
            }
        }else{
            for (int index = 0; index < 2; index ++ ) {
                NSArray *arrImage = [NSArray arrayWithObjects:@"iconOil", @"iconCarbon", nil];
                NSArray *arrData = [NSArray arrayWithObjects:[dicMonth objectForKey:@"oiluse"], [dicMonth objectForKey:@"carbon"], nil];
                NSArray *arrUnit = [NSArray arrayWithObjects:@"L", @"kg", nil];
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(index * (gtWIDTH/2), 0, gtWIDTH/2, 76)];
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrImage objectAtIndex:index]]] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"%@%@",[arrData objectAtIndex:index], [arrUnit objectAtIndex:index]] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn];
            }
        }
    }
    return cell;
}

- (void)btnClicked: (UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarMonthStat"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if ([[dic objectForKey:@"info"] count] == 0) {
            }else{
                arrayMonthData = [dic objectForKey:@"info"];
                [self.view addSubview:self.tableView];
            }
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
    }
}

@end
