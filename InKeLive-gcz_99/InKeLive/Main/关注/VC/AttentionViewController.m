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
#import "MJAnimHeader.h"
@interface AttentionViewController ()<UITableViewDataSource, UITableViewDelegate, GTAFNDataDelegate>
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)EmptyView *emptyView;
@property (nonatomic, assign) int index;
@end

@implementation AttentionViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"关注";
    _arrData = [NSArray array];
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    if (kIs_iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, SCREEN_WIDTH, 0);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    _tableView.separatorColor = RGB(218, 218, 218);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"AttentionTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *strImgPath = [[_arrData objectAtIndex:indexPath.row] objectForKey:@"img"];
    NSString *strName = [[_arrData objectAtIndex:indexPath.row] objectForKey:@"Title"];
    NSString *strId = [NSString stringWithFormat:@"%@",[[_arrData objectAtIndex:indexPath.row] objectForKey:@"uId"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:strImgPath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    CGSize itemSize = CGSizeMake(43, 43);//希望显示的大小
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",strName,strId]];
    NSLog(@"strName.length == %lu",(unsigned long)strName.length);
    NSLog(@"strId.length == %lu",(unsigned long)strId.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(32, 32, 32) range:NSMakeRange(0, strName.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(214, 214, 214) range:NSMakeRange(strName.length, strId.length+2)];
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
    if (!_arrData) {
        return 0;
    }else{
        return _arrData.count;
    }
    
//    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)btnCancelAttention:(UIButton *)button{
    NSString *pid = [[_arrData objectAtIndex:button.tag - 200] objectForKey:@"pid"];
    [[GTAlertTool shareInstance]showAlert:@"是否取消关注此歌手" message:nil cancelTitle:@"确定" titleArray:@[@"取消"] viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == -1) {
            NSLog(@"确定");
            GTAFNData *data = [[GTAFNData alloc] init];
            data.delegate = self;
            [data DeteleAttentionWithPid:pid];
            _index = (int)button.tag - 200;
        }else{
            NSLog(@"取消");
        }
    }];
    
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
                [self.emptyView removeFromSuperview];
                if (kIs_iPhoneX) {
                    if (55*array.count > SCREEN_HEIGHT-88-68) {
                        self.tableView.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88-68);
                    }else{
                        self.tableView.frame = CGRectMake(0, 88, SCREEN_WIDTH, 55*array.count);
                    }
                }else{
                    if (55*array.count > SCREEN_HEIGHT- 64-49) {
                        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
                    }else{
                        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 55*array.count);
                    }
                }
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
            NSMutableArray *array = [NSMutableArray arrayWithArray:_arrData];
            if (_index > -1) {
                [array removeObjectAtIndex:_index];
                [self.tableView reloadData];
                [MBProgressHUD showAlertMessage:@"取消关注成功"];
            }
            _index = -1;
        }else{
            [[GTAlertTool shareInstance] showAlert:[data objectForKey:@"msg"] message:@"请重试" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
            }];
        }
    }
    [self.tableView.mj_header endRefreshing];
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
