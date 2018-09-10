//
//  SecurityViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/7.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SecurityViewController.h"
#import "ChangePwdViewController.h"

@interface SecurityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSArray *arrTitle;
@end

@implementation SecurityViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrTitle = @[@"修改密码",@"找回密保"];
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"安全中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    
}

- (UITableView *)tableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 80)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    _tableView.separatorColor = RGB(239, 239, 239);
    _tableView.backgroundColor = [UIColor redColor];
    return _tableView;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"SafeTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.contentView.backgroundColor = MAIN_COLOR;
    cell.textLabel.text = [_arrTitle objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //修改密码
        ChangePwdViewController *changePwdVC = [[ChangePwdViewController alloc] init];
        [self.navigationController pushViewController:changePwdVC animated:YES];
    }else if (indexPath.row == 1){
        //找回密保
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark Action
-(void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
