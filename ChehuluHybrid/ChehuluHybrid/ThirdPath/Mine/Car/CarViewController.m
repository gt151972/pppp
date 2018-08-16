//
//  CarViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/11/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarViewController.h"
#import "BaseButton.h"
#import "CarInfoViewController.h"
#import "CarEditViewController.h"

@interface CarViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BaseButton *btn;
    NSArray *arrCar;
}
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation CarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"我的车辆"];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getCarListsWithPage:@"1" limit:@"10" listType:@"4" provinceId:@"" areaId:@"" isFake:GTisFake];
}

- (void)initData{
    btn = [[BaseButton alloc] init];
    arrCar = [[NSArray alloc] init];
}

- (void)carList{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    viewBg.backgroundColor = COLOR_BG_GRAY;
    [self.view addSubview:viewBg];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT-64) style:UITableViewStylePlain];
    if (arrCar.count*68 < gtHEIGHT - 64) {
        self.tableView.frame = CGRectMake(0, 0, gtWIDTH, arrCar.count*68);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCarTableViewCell"];
    [viewBg addSubview:self.tableView];
}

- (void)carListNull{
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"您还未添加车辆";
    labTitle.textColor = COLOR_TEXT_GARY;
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SW);
        make.centerY.equalTo(SW).offset(-40);
        make.size.mas_equalTo(CGSizeMake(gtWIDTH, 20));
    }];
    
    UIButton *btnAdd = [[UIButton alloc] init];
    btnAdd = [btn btnWhite:@"添加"];
    [self.view addSubview:btnAdd];
    [btnAdd setTag:204];
    [btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(SW);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}


#pragma mark -- action
- (void)btnClicked: (UIButton *)button{
    if (button.tag == 204) {
        //添加车辆
        CarInfoViewController *carInfoVC = [[CarInfoViewController alloc] init];
        [self.navigationController pushViewController:carInfoVC animated:YES];
    }
}

- (void)doClickRightButton :(UIButton *)sender{
    CarEditViewController *carEditVC = [[CarEditViewController alloc] init];
    [self.navigationController pushViewController:carEditVC animated:YES];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"carID"  object:[[[arrCar objectAtIndex:indexPath.section] objectForKey:@"info"] objectForKey:@"car_id"]];
    [center postNotificationName:@"policyid"  object:[[[arrCar objectAtIndex:indexPath.section] objectForKey:@"info"] objectForKey:@"policyid"]];
    CarInfoViewController *carInfoVC = [[CarInfoViewController alloc]init];
    carInfoVC.dic = [arrCar objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:carInfoVC animated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrCar.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
//    if ([[[arrCar objectAtIndex:indexPath.section] objectForKey:@"brand_logo"] isEqualToString:@""]) {
//        NSLog(@"brand_logo == %@",[[arrCar objectAtIndex:indexPath.row] objectForKey:@"brand_logo"]);
//        cell.imageView.image = [UIImage imageNamed:@"carLogo"];
//    }else{
//        NSString *url = [[arrCar objectAtIndex:indexPath.section] objectForKey:@"brand_logo"];
//        NSLog(@"all == %@",[arrCar objectAtIndex:indexPath.section]);
//        NSLog(@"url == %@",url);
//        cell.imageView.image = [super getImageForUrl:url];
//    }
    NSString *strUrl =  [[arrCar objectAtIndex:indexPath.section] objectForKey:@"brand_logo"];
    UIImageView *imageViewIcon = [[UIImageView alloc] init];
    if (![strUrl isEqualToString:@""]) {
        imageViewIcon.image = [super getImageForUrl:strUrl];
    }else{
        imageViewIcon.image = [UIImage imageNamed:@"carLogo"];
    }
    [cell.contentView addSubview:imageViewIcon];
    [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(cell.contentView);
        make.left.mas_equalTo(20);
    }];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, gtWIDTH - 100, 60)];
    labTitle.text = [[arrCar objectAtIndex:indexPath.section] objectForKey:@"car_no"];
    labTitle.textColor = [UIColor blackColor];
    labTitle.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labTitle];

    UIImageView *imageViewVIP = [[UIImageView alloc] init];
    UIImage *imageVIP = [UIImage imageNamed:@"vip"];
    imageViewVIP.image = imageVIP;
    [cell.contentView addSubview:imageViewVIP];
    [imageViewVIP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageVIP.size);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(130);
    }];
    cell.detailTextLabel.text= [NSString stringWithFormat:@"距离保险到期还有365天"];
    cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if ([[arrCar objectAtIndex:indexPath.section] objectForKey:@"policy_last_day"]) {
        int day= [[[arrCar objectAtIndex:indexPath.section] objectForKey:@"policy_last_day"] intValue];
        if (day > 0) {
            cell.detailTextLabel.text= [NSString stringWithFormat:@"距离保险到期还有%d天",day];
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            
            UIImageView *imageViewVIP = [[UIImageView alloc] init];
            UIImage *imageVIP = [UIImage imageNamed:@"vip"];
            imageViewVIP.image = imageVIP;
            [cell.contentView addSubview:imageViewVIP];
            [imageViewVIP mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(imageVIP.size);
                make.top.mas_equalTo(15);
                make.left.mas_equalTo(130);
            }];
        }else if (day == -1){//无车险
            
        }else if(day == 0){//已到期
            cell.detailTextLabel.text= @"保险已到期";
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    
    return cell;
}


- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1) {
        if ([dic objectForKey:@"info"]){
            NSDictionary *dict = [super nullToEmpty:dic];
            NSLog(@"dic == %@",dic); 
            arrCar = [[NSArray alloc] initWithArray:[[dict objectForKey:@"info"] objectForKey:@"data"]];
            if (arrCar.count != 0) {
                [self carList];
                //rightItem
                [super addRightButtonForImage:@"addCar"];
            }else{
                [self carListNull];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
