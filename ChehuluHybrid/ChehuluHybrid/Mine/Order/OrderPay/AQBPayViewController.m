//
//  AQBPayViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/29.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "AQBPayViewController.h"

@interface AQBPayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation AQBPayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"确认支付"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 291) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_BG_GRAY2;
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        view.backgroundColor = COLOR_MAIN_GREEN;
        NSString *strNO = @"719046734210647321";
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, gtWIDTH-20, 25)];
        labTitle.text = [NSString stringWithFormat:@"保单号:%@",strNO];
        labTitle.textColor = [UIColor whiteColor];
        labTitle.textAlignment = NSTextAlignmentLeft;
        labTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labTitle];

    }else{
        view.backgroundColor = COLOR_BG_GRAY2;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1){
            return 37;
        }else if (indexPath.row == 2){
            return 37;
        }else{
            return 40;
        }
    }else{
        return 83;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 25;
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
        return 4;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"浙A12345";
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = COLOR_MAIN_GRAY;
            cell.detailTextLabel.text = @"¥8888";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textColor = COLOR_MAIN_GREEN;
            UILabel *labDate = [[UILabel alloc] init];
            labDate.textColor = COLOR_TEXT_GARY;
            labDate.text = @"2015-06-30至2016-06-30";
            labDate.font = [UIFont systemFontOfSize:12];
            labDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:labDate];
            [labDate mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView).offset(-3);
                make.left.equalTo(cell.contentView).offset(15);
                make.width.equalTo(cell.contentView);
                make.height.mas_equalTo(12);
            }];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"保障详情";
            cell.textLabel.textColor = COLOR_TEXT_GARY;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = @"4m²";
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"可赔次数";
            cell.textLabel.textColor = COLOR_TEXT_GARY;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = @"4";
            cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }else{
            UIButton *btnCancel = [[UIButton alloc] init];
            [btnCancel setTitle:@"取消订单" forState:UIControlStateNormal];
            [btnCancel setTitleColor:COLOR_TEXT_GARY forState:UIControlStateNormal];
            [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btnCancel.layer setMasksToBounds:YES];
            [btnCancel.layer setCornerRadius:3];
            [btnCancel.layer setBorderColor:COLOR_TEXT_GARY.CGColor];
            [btnCancel.layer setBorderWidth:1];
            [btnCancel setTag:201];
            [btnCancel addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
            [btnCancel addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnCancel];
            
            UIButton *btnSubmit = [[UIButton alloc] init];
            [btnSubmit setTitle:@"确认支付" forState:UIControlStateNormal];
            [btnSubmit setTitleColor:COLOR_MAIN_GREEN forState:UIControlStateNormal];
            [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btnSubmit.layer setMasksToBounds:YES];
            [btnSubmit.layer setCornerRadius:3];
            [btnSubmit.layer setBorderColor:COLOR_MAIN_GREEN.CGColor];
            [btnSubmit.layer setBorderWidth:1];
            [btnSubmit setTag:202];
            [btnSubmit addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
            [btnSubmit addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnSubmit];
            
            [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(58, 22));
            }];
            [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btnSubmit.mas_left).offset(-15);
                make.centerY.equalTo(cell.contentView);
                make.size.equalTo(btnSubmit);
            }];
        }
    }else{
        NSArray *arrDetail = [NSArray arrayWithObjects:@"王小华", @"15888888888", @"1016-07-07-24", nil];
        UILabel *labName = [[UILabel alloc] init];
        labName.font = [UIFont systemFontOfSize:12];
        labName.textAlignment = NSTextAlignmentLeft;
        labName.textColor = COLOR_TEXT_GARY;
        labName.numberOfLines = 3;
        labName.text = [NSString stringWithFormat:@"车主姓名: %@\n手机号码: %@\n下单时间: %@",[arrDetail objectAtIndex:0],[arrDetail objectAtIndex:1],[arrDetail objectAtIndex:2]];
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(gtWIDTH-30, 60));
        }];
    }

    return cell;
}

//  button1普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender
{
    if (sender.tag == 201) {//取消订单
        sender.backgroundColor = [UIColor whiteColor];
    }else if (sender.tag == 202){//确认支付
        sender.backgroundColor = [UIColor whiteColor];
    }
}
//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    if (sender.tag == 201) {//取消订单
        sender.backgroundColor = COLOR_TEXT_GARY;
    }else if (sender.tag == 202){//确认支付
        sender.backgroundColor = COLOR_MAIN_GREEN;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
