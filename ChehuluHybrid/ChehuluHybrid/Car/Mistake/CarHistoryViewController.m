//
//  CarHistoryViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2016/12/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "CarHistoryViewController.h"

@interface CarHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *arrDate;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CarHistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationTypeWhite:@"历史故障"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getHistoryFalteWithCarNo:[gtCarInfo objectForKey:@"car_no"] page:nil limit:nil start:nil];
    [self initData];
    [self initView];
}
- (void)initData{
    
}

- (void)initView{
    
    [self initNavgation:@"历史故障"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_BG_BLACK_DEEP;
    self.tableView.separatorColor = COLOR_BG_BLACK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarStatusTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

}

- (void)initNavgation: (NSString *)title{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 64)];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"btnBackSelect"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:btnBack];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, gtWIDTH, 44)];
    labTitle.text = title;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.textColor = COLOR_TEXT_GARY_DEEP;
    labTitle.font = [UIFont systemFontOfSize:18];
    [viewBg addSubview:labTitle];
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
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (arrDate) {
//        return [[arrDate objectAtIndex:section] count];
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (arrDate) {
        return arrDate.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
//    cell.textLabel.frame.size = CGSizeMake(gtWIDTH - 30, cell.contentView.frame.size.height);
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, gtWIDTH - 73, cell.contentView.frame.size.height)];
    labText.text = [NSString stringWithFormat:@"%@(%@)",[[arrDate objectAtIndex:indexPath.section] objectForKey:@"code"], [[arrDate objectAtIndex:indexPath.section] objectForKey:@"content"]];
    labText.textColor = COLOR_TEXT_GARY_DEEP;
    labText.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labText];
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(gtWIDTH - 16 - 40, 0, 40, cell.contentView.frame.size.height)];
    labDetail.text = [[[arrDate objectAtIndex:indexPath.section] objectForKey:@"create_time"] substringWithRange:NSMakeRange(5, 5)];
    labDetail.textColor = COLOR_TEXT_GARY;
    labDetail.textAlignment = NSTextAlignmentRight;
    labDetail.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:labDetail];
    return cell;
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1) {
        arrDate = [[NSArray alloc] initWithArray:[dic objectForKey:@"info"]];
    }else{
        [super alert:[dic objectForKey:@"info"]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
