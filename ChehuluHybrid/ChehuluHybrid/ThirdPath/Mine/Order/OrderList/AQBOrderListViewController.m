//
//  AQBOrderListViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/29.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "AQBOrderListViewController.h"
#import "AQBPayViewController.h"

@interface AQBOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation AQBOrderListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"安全宝订单"];
    [self.view setBackgroundColor:COLOR_BG_GRAY2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _number = 3;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT-60) style:UITableViewStylePlain];
    _tableView.tag = 501;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_BG_GRAY2;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AQBListTableViewCell"];
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 501) {
        return 107;
    }else{
        if (indexPath.row == 0) {
            return 39;
        }else if (indexPath.row == 1){
            return 12;
        }else{
            return 54;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 501) {
        return 10;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 501) {
        
    }else{
        if (indexPath.row == 2) {
            AQBPayViewController *AQBPayVC = [[AQBPayViewController alloc] init];
            [self.navigationController pushViewController:AQBPayVC animated:YES];
        }
    }
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
        return _number;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView.tag == 501) {
        static NSString *cellIdentifier = @"AQBListTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        if (!cell) {
        }
        cell.backgroundColor = COLOR_BG_GRAY2;
        UITableView *tableViewDetail = [[UITableView alloc] init];
        tableViewDetail.delegate = self;
        tableViewDetail.dataSource = self;
        tableViewDetail.backgroundColor = [UIColor whiteColor];
        [tableViewDetail registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AQBListDetailTableViewCell"];
        tableViewDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell.contentView addSubview:tableViewDetail];
        [tableViewDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
            make.center.and.height.equalTo(cell.contentView);
        }];
    }else{
        static NSString *cellIdentifier = @"AQBListDetailTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        if (!cell) {
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"浙A12345";
            cell.textLabel.textColor = COLOR_MAIN_GRAY;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = @"58612546574835461845";
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }else if (indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"2015-06-30至2017-06-30";
            cell.textLabel.textColor = COLOR_TEXT_GARY;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }else if (indexPath.row == 2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"¥600.00";
            cell.textLabel.textColor = COLOR_MAIN_GRAY;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = @"去支付";
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
