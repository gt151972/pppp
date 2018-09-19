//
//  AttentionViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "AttentionViewController.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "LocalUserModel.h"
#import "DPK_NW_Application.h"
#import "MBProgressHUD+MJ.h"
#import "EmptyView.h"
#import "GTAFNData.h"
#import "AppDelegate.h"
@interface AttentionViewController ()<UITableViewDataSource, UITableViewDelegate, GTAFNDataDelegate>
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)EmptyView *emptyView;
@end

@implementation AttentionViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"关注";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([DPK_NW_Application sharedInstance].isLogon == NO) {
        [appDelegate doLogon];
    }
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _arrData = [NSArray array];
    [self getData];
    [self.view addSubview:self.emptyView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.separatorColor = RGB(218, 218, 218);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    NSString *strImgPath = @"";
    NSString *strName = @"美女世家";
    NSString *strId = @"101100";
    cell.imageView.size = CGSizeMake(43, 43);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:strImgPath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",strName,strId]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(32, 32, 32) range:NSMakeRange(0, strName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(214, 214, 214) range:NSMakeRange(strName.length, strId.length + 2)];
    [cell.textLabel setAttributedText:attrStr];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    UIButton *btnAttention = [[UIButton alloc] init];
    [btnAttention setTitle:@"取消关注" forState:UIControlStateNormal];
    btnAttention.layer.masksToBounds = YES;
    btnAttention.layer.cornerRadius = 3;
    btnAttention.layer.borderColor = MAIN_COLOR.CGColor;
    btnAttention.layer.borderWidth = 1;
    [btnAttention setBackgroundColor:[UIColor whiteColor]];
    btnAttention.titleLabel.font = [UIFont systemFontOfSize:10];
    [btnAttention setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btnAttention setTag:200+indexPath.row];
    [btnAttention addTarget:self action:@selector(btnCancelAttention:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnAttention];
    [btnAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-16);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.centerY.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)btnCancelAttention:(UIButton *)button{
    NSString *pid = [[_arrData objectAtIndex:button.tag - 200] objectForKey:@"pid"];
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data DeteleAttentionWithPid:pid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getData{
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data AttentionList];
}

- (EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:self.view.bounds];
    }
    return _emptyView;
}
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_ATTENTION_ROOM_LIST]) {
        NSLog(@"data == %@",data);
        if ([[data objectForKey:@"code"] intValue] == 0) {
            NSArray *array = [NSArray arrayWithArray:[data objectForKey:@"List"]];
            if (array.count != 0) {
                self.arrData = array;
                [self.emptyView setHidden:YES];
                [self.tableView reloadData];
            }
        }else{
            [[GTAlertTool shareInstance] showAlert:[data objectForKey:@"msg"] message:@"请刷新重试" cancelTitle:@"取消" titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                if (buttonTag == 0) {
                    [self getData];
                }
            }];
        }
    }else if ([cmd isEqualToString:CMD_ATTENTION_DELETE]){
        NSLog(@"data == %@",data);
        if ([[data objectForKey:@"code"] intValue] == 0) {
//            NSArray *array = [NSArray arrayWithArray:[data objectForKey:@"List"]];
//            if (array.count != 0) {
//                self.arrData = array;
//
//            }
//            [self.tableView reloadData];
        }else{
            [[GTAlertTool shareInstance] showAlert:[data objectForKey:@"msg"] message:@"请重试" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
            }];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
