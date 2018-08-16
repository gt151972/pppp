//
//  SecretViewController.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "SecretViewController.h"

@interface SecretViewController (){
    UIButton *btnIcon;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SecretViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"隐私设置"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData{
    
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SecretTableViewCell"];
    [self.view addSubview:self.tableView];

}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (btnIcon.selected == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"Secret"];
        btnIcon.selected = NO;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Secret"];
        btnIcon.selected = YES;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 40)];
    UILabel *lable = [[UILabel alloc] initWithFrame:view.frame];
    [view addSubview:lable];
    lable.text = @"关闭后将无法查看里程详情,总里程数不受影响";
    lable.textColor = COLOR_TEXT_GARY;
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:14];
    return view;
}

#pragma mark -- UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SecretTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    cell.textLabel.text = @"里程详情";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = COLOR_TEXT_GARY_DEEP;
    
    
    btnIcon = [[UIButton alloc] init];
    if ([gtSecret intValue] == 1) {
        btnIcon.selected = YES;
    }else{
        btnIcon.selected = NO;
    }
    [btnIcon setImage:[UIImage imageNamed:@"privacyHighlight"] forState:UIControlStateNormal];
    [btnIcon setImage:[UIImage imageNamed:@"privacyNormal"] forState:UIControlStateSelected];
    [btnIcon setTag:201];
    [btnIcon addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnIcon];
    [btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.size.mas_equalTo([UIImage imageNamed:@"privacyNormal"].size);
        make.right.mas_equalTo(-10);
    }];
    return cell;
}

- (void)btnClicked: (UIButton *)button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
