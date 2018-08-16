//
//  CarMileageViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarMileageViewController.h"

@interface CarMileageViewController (){
    NSArray *arrayData;
    NSString *strTravel;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CarMileageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"里程"];
    [super addRightButtonForImage:@"moreBlack"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData{
    arrayData = [[NSArray alloc] init];
    strTravel = @"";
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
//    NSLog(@"gtCarInfo == %@",gtCarInfo);
    [indexDAL getCarObdTravelWithObdId:[gtCarInfo objectForKey:@"obdid"] date:self.strDate carNo:[gtCarInfo objectForKey:@"car_no"]];
    [HUD loadingHUD];
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsSelection = NO;
    if (arrayData.count*188 +145 < gtWIDTH - 64) {
        self.tableView.frame = CGRectMake(0, 0, gtWIDTH, arrayData.count*188 +145);
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)doClickRightButton :(UIButton *)sender{
    
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 145;
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
        return 3;
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
//        cell.backgroundColor = [UIColor redColor];
        UIImage *imgMileage = [UIImage imageNamed:@"milleageBig"];
        UIImageView *imageMileage = [[UIImageView alloc] initWithImage:imgMileage];
//        imageMileage.frame = CGRectMake(0, 0, gtWIDTH, 145);
        [cell.contentView addSubview:imageMileage];
        [imageMileage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.size.mas_equalTo(imgMileage.size);
            make.top.mas_equalTo(34);
        }];
        
        UILabel *labData = [[UILabel alloc] init];
        NSLog(@"strTravel == %@",strTravel);
        if (![strTravel isEqualToString:@""]) {
            if ([strTravel floatValue]>1000) {
                float travel = [strTravel floatValue]/1000;
                labData.text = [NSString stringWithFormat:@"%0.2fkm",travel];
            }else{
                labData.text = [NSString stringWithFormat:@"%@m",strTravel];
            }
        }else{
            labData.text = @"0km";
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
        
        UILabel *labDay = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH-20, 10)];
        labDay.text = _strDate;
        labDay.textColor = COLOR_TEXT_GARY;
        labDay.textAlignment = NSTextAlignmentRight;
        labDay.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:labDay];
    }else{
        if (indexPath.row == 0) {
            if ([[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"distance"]) {
                if ([[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"distance"] floatValue]>1000) {
                    float travel = [[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"distance"] floatValue]/1000;
                    cell.textLabel.text = [NSString stringWithFormat:@"里程%ld : %0.2fkm", (long)indexPath.section ,travel];
                }else{
                    cell.textLabel.text = [NSString stringWithFormat:@"里程%ld : %@m", (long)indexPath.section,[[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"distance"]];
                }
            }else{
                cell.textLabel.text = @"0km";
            }
//            cell.textLabel.text = [NSString stringWithFormat:@"里程1 : %@km", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"distance"]];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"btnStart"];
            
            UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, gtWIDTH - 120, cell.frame.size.height)];
            labText.text = [NSString stringWithFormat:@"%@", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"start_addr"]];
            labText.font = [UIFont systemFontOfSize:15];
            labText.textColor = COLOR_TEXT_GARY_DEEP;
            labText.numberOfLines = 0;
            [cell.contentView addSubview:labText];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"start_time"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
        }else if (indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"btnStop"];
            
            UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, gtWIDTH - 120, cell.frame.size.height)];
            labText.text = [NSString stringWithFormat:@"%@", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"end_addr"]];
            labText.font = [UIFont systemFontOfSize:15];
            labText.textColor = COLOR_TEXT_GARY_DEEP;
            labText.numberOfLines = 0;
            [cell.contentView addSubview:labText];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[arrayData objectAtIndex:indexPath.section-1] objectForKey:@"end_time"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
        }
    }
    return cell;
}


- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@", dic);
    NSLog(@"cmd == %@",cmd);
    if ([cmd isEqualToString:@"CarObdTravel"]) {
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            arrayData = [[dic objectForKey:@"info"] objectForKey:@"detail"];
            strTravel = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"info"] objectForKey:@"travel_all"]];
//            NSLog(@"strTravel == %lu",(unsigned long)arrayData.count);
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
