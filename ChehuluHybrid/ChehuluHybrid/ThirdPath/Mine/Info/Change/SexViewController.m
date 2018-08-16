//
//  SexViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/12/1.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UIImageView *imageSelect;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SexViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"个人信息"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,98) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SexTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     [indexDAL updateWithHeadImgID:nil sex:[NSString stringWithFormat:@"%ld",(long)indexPath.row] realname:nil];
    [imageSelect removeFromSuperview];
    NSMutableDictionary *dicInfo = [NSMutableDictionary dictionaryWithDictionary:gtDicMyInfo];
    [dicInfo setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"sex"];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dicInfo];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dicMyInfo"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SexTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrTitle = @[@"女", @"男"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    
    UIImage *imgSelect = [UIImage imageNamed:@"select"];
    imageSelect = [[UIImageView alloc] init];
    imageSelect.image = imgSelect;
    if (indexPath.row ==  _sex) {
        [cell.contentView addSubview:imageSelect];
        [imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imgSelect.size);
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(-5);
        }];
    }
    return cell;
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1){
        if ([cmd isEqualToString:@"Update"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改性别成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:alertSure];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"info"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionSure];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
