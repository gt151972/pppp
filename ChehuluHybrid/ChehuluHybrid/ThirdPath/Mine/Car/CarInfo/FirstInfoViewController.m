//
//  FirstInfoViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/23.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "FirstInfoViewController.h"
#import "CarEditViewController.h"

@interface FirstInfoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dic;
    BaseButton *btn;
}
@property (nonatomic, strong) UITableView *tableView;
@end

extern NSDictionary *dicCar;
@implementation FirstInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    [self initData];
    [self initView];
}

- (void)initNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNotification:) name:@"dicCar" object:nil];
}

- (void)returnNotification:(NSNotification *)notification{
    NSLog(@"object == %@",notification.object);
    if ([notification.name isEqualToString:@"dicCar"]) {
        dic = notification.object;
    }
    [self.view addSubview:self.tableView];
}


- (void)initData{
    btn = [[BaseButton alloc] init];
    if (![dicCar isEqual:[NSNull null]]) {
        dic = [super nullToEmpty:[dicCar objectForKey:@"info"]];
    }
    NSLog(@"dic23 == %@",dic);
//    dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"车牌号",@"car_no",@"车主姓名", @"drv_owner", @"车辆识别代码", @"vhl_frm", @"发动机号", @"eng_no", @"注册日期", @"fst_reg_dte", @"1", @"operating", @"奥迪", @"car_brand", @"A4", @"car_series",@"http://jh.buyubi.com/Public/Images/brands/93.jpg", @"img_url",@"http://jh.buyubi.com/Public/Images/brands/93.jpg",@"brand_logo", nil];

}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 104)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FirstInfoTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 120;
    }else if (indexPath.row == 8){
        return 88;
    }else{
        return 52;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"车牌号", @"车主姓名", @"车辆识别代号", @"发动机号码", @"注册日期", @"使用性质", @"品牌型号", nil];
    NSMutableArray *arrDetail = [[NSMutableArray alloc] initWithObjects:[dic objectForKey:@"car_no"], [dic objectForKey:@"drv_owner"], [dic objectForKey:@"vhl_frm"], [dic objectForKey:@"eng_no"], [dic objectForKey:@"fst_reg_dte"], [dic objectForKey:@"operating"], [dic objectForKey:@"car_series"], nil];
    if (indexPath.row < 5 ) {
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = [arrDetail objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }else if (indexPath.row == 5){
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if ([[dic objectForKey:@"operating"] intValue] == 1) {
            cell.detailTextLabel.text = @"营利";
        }else{
            cell.detailTextLabel.text = @"非营利";
        }
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
//        if ([dic objectForKey:@"brand_logo"]) {
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"brand_logo"]]]];
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.image = image;
//            [cell.contentView addSubview:imageView];
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(85);
//                make.width.mas_equalTo(cell.frame.size.height);
//                make.height.equalTo(imageView.mas_width);
//                make.centerY.equalTo(cell.contentView.mas_centerY);
//            }];
//        }
        UIButton *btnCar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH - 10, 52)];
        [btnCar setImage:[super getImageForUrl:[dic objectForKey:@"brand_logo"]] forState:UIControlStateNormal];
        [btnCar.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnCar setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnCar setTitle:[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"car_brand"],[dic objectForKey:@"car_series"]] forState:UIControlStateNormal];
        [btnCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnCar];
    }
    if (indexPath.row == 7) {
        if ([dic objectForKey:@"img_url"]) {
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"img_url"]]]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 108, 72)];
            imageView.image = image;
            [cell.contentView addSubview:imageView];
        }
    }
    if (indexPath.row == 8) {
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, gtWIDTH - 40, 48)];
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnEdit setBackgroundColor:COLOR_MAIN_GREEN];
        [btnEdit addTarget:self action:@selector(btnEdit) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:6];
        [cell.contentView addSubview:btnEdit];
    }
    return cell;
}

- (void)btnEdit{
    CarEditViewController *carEditVC = [[CarEditViewController alloc] init];
    carEditVC.dic = dic;
    [self.navigationController pushViewController:carEditVC animated:YES];
}

//- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
//    NSLog(@"dic == %@",dic);
//    NSLog(@"cmd == %@",cmd);
//    if ([[dic objectForKey:@"status"] intValue] == 1) {
//        if ([cmd isEqualToString:@"CarDetail"]) {
//            [self.view addSubview:self.tableView];
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
