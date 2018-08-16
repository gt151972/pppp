//
//  SecondInfoViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/23.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "SecondInfoViewController.h"
#import "OBDPickerView.h"
#import "SecondInfoAlertSheet.h"
@interface SecondInfoViewController ()<UITableViewDelegate, UITableViewDataSource,SecondInfoAlertSheetDelegate>{
    NSDictionary *dic;
    BaseButton *baseBtn;
    OBDPickerView *obdPickerView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

extern NSDictionary *dicOBD;
@implementation SecondInfoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initData];
}

- (void)initNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNotification:) name:@"dicOBD" object:nil];
}

- (void)returnNotification:(NSNotification *)notification{
    NSLog(@"object == %@",notification.object);
    if ([notification.name isEqualToString:@"dicOBD"]) {
        dic = notification.object;
        [self.view addSubview:self.tableView];
    }
}

-(void) initData{
    baseBtn = [[BaseButton alloc] init];
    obdPickerView = [[OBDPickerView alloc] init];
    NSLog(@"dicOBD == %@",dicOBD);
    if (![[dicOBD objectForKey:@"info"] isEqual: [NSNull null]]) {
        dic = [super nullToEmpty:[dicOBD objectForKey:@"info"]];
        [self initView];
    }else{
        [self nullView];
    }
    NSLog(@"dic == %@",dic);
}

-(void)initView{
    UIButton *btnDate = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    [btnDate setTitle:[NSString stringWithFormat:@"%@-%@",[[[dic objectForKey:@"policys"] objectAtIndex:0] objectForKey:@"start_date"], [[[dic objectForKey:@"policys"] objectAtIndex:0] objectForKey:@"end_date"]] forState:UIControlStateNormal];
    [btnDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDate addTarget:self action:@selector(btnCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDate setTag:202];
    [btnDate.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btnDate];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 62, gtWIDTH, 2)];
    view.backgroundColor = COLOR_TEXT_GARY;
    [self.view addSubview:view];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH,gtHEIGHT - 168)];
    if (gtHEIGHT - 168 > 340) {
        self.tableView.frame = CGRectMake(0, 64, gtWIDTH, 340);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SecondInfoTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)nullView{
    UILabel *labNoOBD = [[UILabel alloc] init];
    labNoOBD.text = @"您尚未购买车险";
    labNoOBD.textColor = COLOR_TEXT_GARY;
    labNoOBD.font = [UIFont systemFontOfSize:14];
    labNoOBD.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labNoOBD];
    
    UIButton *btnGoBuy = [[UIButton alloc] init];
    btnGoBuy = [baseBtn btnWhite:@"去购险"];
    btnGoBuy.tag = 201;
    [btnGoBuy addTarget:self action:@selector(btnCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoBuy];
    [btnGoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(SW);
        make.size.mas_equalTo(CGSizeMake(95, 40));
    }];
    [labNoOBD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(SW);
        make.height.mas_equalTo(14);
        make.bottom.equalTo(btnGoBuy.mas_top).offset(-20);
    }];

}
#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH, 64)];
    
    lable.text = [NSString stringWithFormat:@"共享受%@天环保奖励",[[dic objectForKey:@"stat"] objectForKey:@"stop_num"]];
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:16];
    [headView addSubview:lable];
    return headView;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SecondInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"停车天数", @"行驶天数", @"离线天数", @"总里程", @"总时间", @"总油耗", @"总碳排", nil];
    NSDictionary *dicStat = [dic objectForKey:@"stat"];
    NSMutableArray *arrDetail = [[NSMutableArray alloc] initWithObjects:[dicStat objectForKey:@"stop_num"], [dicStat objectForKey:@"run_num"], [dicStat objectForKey:@"lost_day"], [dicStat objectForKey:@"mileage"], [dicStat objectForKey:@"run_time"], [dicStat objectForKey:@"oiluse"], [dicStat objectForKey:@"oil_cost"], [dicStat objectForKey:@"carbon"], nil];
    NSLog(@"arrDetail == %@",arrDetail);
    NSArray *arrayUnit = [[NSArray alloc] initWithObjects:@"天", @"天", @"天",@"km", @"h", @"L", @"¥", @"kg", nil];
    if (indexPath.row < arrayName.count ) {
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (indexPath.row == 6) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",[arrayUnit objectAtIndex:indexPath.row], [arrDetail objectAtIndex:indexPath.row]];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",[arrDetail objectAtIndex:indexPath.row],[arrayUnit objectAtIndex:indexPath.row]];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
        
    }
    return cell;
}

- (void)btnEdit{
    
}


- (void)btnCilcked: (UIButton *)button{
    if (button.tag == 201) {
        //去购险
        
    }else if (button.tag == 202){
        //选择开始结束日期
        
//        UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 180 - 168, gtWIDTH, 180)];
//        [viewBottom setBackgroundColor:[UIColor redColor]];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int index = 0; index < [[dic objectForKey:@"policys"] count]; index ++ ) {
            [array addObject:[NSString stringWithFormat:@"%@-%@",[[[dic objectForKey:@"policys"] objectAtIndex:index] objectForKey:@"start_date"], [[[dic objectForKey:@"policys"] objectAtIndex:index] objectForKey:@"end_date"]]];
        }
//        [self.view addSubview:[obdPickerView pickerViewWithArray:array color:COLOR_MAIN_GREEN]];
        SecondInfoAlertSheet *actionSheet = [[SecondInfoAlertSheet alloc] init];
        [actionSheet setDelegate:self];
        [actionSheet initWithData:array];
        [actionSheet showInView:self.view];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
