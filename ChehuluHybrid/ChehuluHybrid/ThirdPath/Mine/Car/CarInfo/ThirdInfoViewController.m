//
//  ThirdInfoViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/23.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "ThirdInfoViewController.h"
#import "BaseButton.h"

@interface ThirdInfoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dicDate;
    BaseButton *baseBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@end
extern NSDictionary *dicPolicy;
@implementation ThirdInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNotification];
    [self initData];
}

- (void)initNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNotification:) name:@"dicPolicy" object:nil];
}

- (void)returnNotification:(NSNotification *)notification{
    NSLog(@"object == %@",notification.object);
    if ([notification.name isEqualToString:@"dicPolicy"]) {
        dicDate = notification.object;
        [self.tableView reloadData];
    }
}

- (void)initData{
    baseBtn = [[BaseButton alloc] init];
    if (![[dicPolicy objectForKey:@"info"] isEqual: [NSNull null]]) {
        dicDate = [super nullToEmpty:[dicPolicy objectForKey:@"info"]];
        NSLog(@"dicData == %@",dicDate);
        [self initView];
    }else{
        [self noPolicy];
    }
}

- (void)initView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, gtWIDTH, 64)];
    lable.text = [NSString stringWithFormat:@"距离保险到期还有%@天",[dicDate objectForKey:@"last_day"]];
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:16];
    [headView addSubview:lable];
    
    UIButton *btnGoBuy = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 100, 19, 85, 26)];
    UIColor *color;
    if ([[dicDate objectForKey:@"renew_remind"] intValue] == 1) {
        color =COLOR_MAIN_GREEN;
        [btnGoBuy addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        color = COLOR_TEXT_GARY;
    }
    [btnGoBuy setTitle:@"一键续保" forState:UIControlStateNormal];
    [btnGoBuy setTitleColor:color forState:UIControlStateNormal];
    [btnGoBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnGoBuy setBackgroundColor:[UIColor whiteColor]];
    [btnGoBuy setTag:202];
    [btnGoBuy.layer setMasksToBounds:YES];
    [btnGoBuy.layer setCornerRadius:13];
    [btnGoBuy.layer setBorderColor:color.CGColor];
    [btnGoBuy.layer setBorderWidth:1.0];
    [headView addSubview:btnGoBuy];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH,gtHEIGHT - 232)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ThirdInfoTableViewCell"];
    [self.view addSubview:self.tableView];
    
    UIView *viewFoot = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 168, gtWIDTH, 64)];
    viewFoot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewFoot];
    
    UILabel *labSum = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH - 10, 20)];
    labSum.text = @"合计";
    labSum.textColor = COLOR_MAIN_GREEN;
    labSum.textAlignment = NSTextAlignmentLeft;
    labSum.font = [UIFont systemFontOfSize:18];
    [viewFoot addSubview:labSum];
    
    UILabel *labSumDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, gtWIDTH - 20, 20)];
    labSumDetail.text = [NSString stringWithFormat:@"¥%@",[dicDate objectForKey:@"total_amt"]];
    labSumDetail.textColor = COLOR_MAIN_GREEN;
    labSumDetail.textAlignment = NSTextAlignmentRight;
    labSumDetail.font = [UIFont systemFontOfSize:18];
    [viewFoot addSubview:labSumDetail];
}

- (void)noPolicy{
    UILabel *labNoPolicy = [[UILabel alloc] init];
    labNoPolicy.text = @"您尚未购买车险";
    labNoPolicy.textColor = COLOR_TEXT_GARY;
    labNoPolicy.font = [UIFont systemFontOfSize:14];
    labNoPolicy.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labNoPolicy];
    
    UIButton *btnGoBuy = [[UIButton alloc] init];
    btnGoBuy = [baseBtn btnWhite:@"去购险"];
    btnGoBuy.tag = 201;
    [btnGoBuy addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGoBuy];
    [btnGoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(SW);
        make.size.mas_equalTo(CGSizeMake(95, 40));
    }];
    [labNoPolicy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(SW);
        make.height.mas_equalTo(14);
        make.bottom.equalTo(btnGoBuy.mas_top).offset(-20);
    }];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark -- UITableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(40, 20, gtWIDTH - 80, 1)];
    viewLine.backgroundColor = COLOR_TEXT_GARY;
    [view addSubview:viewLine];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        if ([dicDate objectForKey:@"detail"]) {
            NSLog(@"num == %lu",[[dicDate objectForKey:@"detail"] count]);
            return [[dicDate objectForKey:@"detail"] count];
        }else{
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ThirdInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"承保公司", @"投保人", @"投保区域", @"保险起止日期", nil];
    NSArray *arrDetail = [NSArray arrayWithObjects:[dicDate objectForKey:@"insurer_name"], [dicDate objectForKey:@"c_app_nme"], [dicDate objectForKey:@"country_name"], nil];
    NSArray *arrInfo = [[NSArray alloc] initWithArray:[dicDate objectForKey:@"detail"]];
    NSMutableArray *arrInfoName = [[NSMutableArray alloc] init];
    NSMutableArray *arrInfoDetail = [[NSMutableArray alloc] init];
    for (int index = 0; index < arrInfo.count; index ++ ) {
        [arrInfoName addObject:[[arrInfo objectAtIndex:index] objectForKey:@"c_kind_name"]];
        [arrInfoDetail addObject:[[arrInfo objectAtIndex:index] objectForKey:@"n_amt"]];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row == 3) {
            NSString *strStart;
            NSString *strEnd;
            if ([dicDate objectForKey:@"t_insrnc_bgn_tm"]) {
                strStart = [dicDate objectForKey:@"t_insrnc_bgn_tm"];
                strEnd = [dicDate objectForKey:@"t_insrnc_end_tm"];
                strStart = [strStart stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                strEnd = [strEnd stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            }else{
                strStart = [dicDate objectForKey:@"t_traff_bgn_tm"];
                strEnd = [dicDate objectForKey:@"t_traff_end_tm"];
                strStart = [strStart stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                strEnd = [strEnd stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",strStart,strEnd];
        }else{
            cell.detailTextLabel.text = [arrDetail objectAtIndex:indexPath.row];
        }
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
//    else{
//        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
//        cell.textLabel.textColor = COLOR_TEXT_GARY;
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//    }
    if (indexPath.section == 1 ) {
        NSLog(@"row == %ld",(long)indexPath.row);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[arrInfoName objectAtIndex:indexPath.row]];
        cell.textLabel.textColor = COLOR_TEXT_GARY;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%d",[[arrInfoDetail objectAtIndex:indexPath.row] intValue]];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        //去购险
        
    }else if (button.tag == 202){
        //一健续保
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
