//
//  CarTimeViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarTimeViewController.h"

@interface CarTimeViewController (){
    NSArray *arrayData;
    NSDictionary *dicTime;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CarTimeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"时长"];
    [super addRightButtonForImage:@"moreBlack"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [HUD loadingHUD];
}

- (void)initData{
    arrayData = [[NSArray alloc] init];
    dicTime = [[NSDictionary alloc] init];
    
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getCarObdTravelTimeWithObdId:[gtCarInfo objectForKey:@"obdid"] date:self.strDate carNo:[gtCarInfo objectForKey:@"car_no"]];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    if (arrayData.count*248 + 205 < gtWIDTH - 64) {
        self.tableView.frame = CGRectMake(0, 0, gtWIDTH, arrayData.count*248+ 205);
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)doClickRightButton :(UIButton *)sender{
    
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 205;
    }else{
        return 60;
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
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    if (indexPath.section == 0) {
        UIImage *imgMileage = [UIImage imageNamed:@"timeBig"];
        UIImageView *imageMileage = [[UIImageView alloc] initWithImage:imgMileage];
        [cell.contentView addSubview:imageMileage];
        [imageMileage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(imgMileage.size);
            make.top.mas_equalTo(34);
        }];
//        int second = [[dicTime objectForKey:@"travel_time_all"] intValue];
//        NSString *strUnit = @"min";
//        if (second>60) {
//            second = second/60;
//            strUnit = @"h";
//        }
        float second = [[dicTime objectForKey:@"travel_time_all"] floatValue];
        //                NSLog(@"second == %d",second);
        NSString *strUnit = @"min";
        if (second>60) {
            second = second/60;
            strUnit = @"h";
        }else if (second >0){
            second = 1;
        }
        UILabel *labData = [[UILabel alloc] init];
        if ([dicTime objectForKey:@"travel_time_all"]) {
            labData.text = [NSString stringWithFormat:@"%0.1f%@",second,strUnit];
            if (second <= 0) {
                labData.text = @"0min";
            }
        }else{
            labData.text = @"0min";
        }
        labData.textColor = COLOR_TEXT_GARY_DEEP;
        labData.textAlignment = NSTextAlignmentCenter;
        labData.font = [UIFont systemFontOfSize:24];
        [cell.contentView addSubview:labData];
        [labData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.centerX.equalTo(cell.contentView);
            make.height.mas_equalTo(24);
            make.top.equalTo(imageMileage.mas_bottom);
        }];
        
        UILabel *labDetail = [[UILabel alloc] init];
        
        labDetail.text = [NSString stringWithFormat:@"%@时的平均油耗达到最高%@L/100km高于%@用户", [dicTime objectForKey:@"max_time"], [dicTime objectForKey:@"max_oil_use"], [dicTime objectForKey:@"over"]];
        labDetail.textColor = COLOR_TEXT_GARY;
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.font = [UIFont systemFontOfSize:15];
        labDetail.numberOfLines = 2;
        [cell.contentView addSubview:labDetail];
        [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView);
            make.width.mas_equalTo(gtWIDTH - 40);
            make.height.mas_equalTo(40);
            make.top.equalTo(labData.mas_bottom).offset(20);
        }];
        
        UILabel *labDay = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH-20, 10)];
        labDay.text = _strDate;
        labDay.textColor = COLOR_TEXT_GARY;
        labDay.textAlignment = NSTextAlignmentRight;
        labDay.font = [UIFont systemFontOfSize:10];
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"里程%ld : %@--%@", (long)indexPath.section ,[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"start_time"],[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"end_time"]];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            int second = [[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"run_time"] intValue];
            NSString *strUnit = @"s";
            if (second>60) {
                second = second/60;
                strUnit = @"min";
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%@", second, strUnit];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"急加速";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@次", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"fast_add_num"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"急减速";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@次", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"fast_dec_num"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"油耗";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@L", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"oiluse"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY_DEEP;
        }
    }
    return cell;
}


- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@", dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarObdTravelTime"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            if ([[dic objectForKey:@"info"] objectForKey:@"detail"] != [NSNull null]) {
                arrayData = [[dic objectForKey:@"info"] objectForKey:@"detail"];
            }
            dicTime = [dic objectForKey:@"info"];
        }else{
            [super alert:[dic objectForKey:@"info"]];
        }
        [self initView];
        [HUD hidHUD];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
