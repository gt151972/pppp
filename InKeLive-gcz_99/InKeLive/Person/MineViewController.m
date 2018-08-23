//
//  MineViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/15.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeadView.h"
#import "DPK_NW_Application.h"
#import "LocalUserModel.h"
#import "EditInfoViewController.h"

#define BG_COLOR RGB(239, 239, 239)

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MineHeadView *headView;
@property (nonatomic, strong)NSArray *arrTitle;
@property (nonatomic, strong)NSArray *arrVC;
@property (nonatomic, strong) LocalUserModel *userModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MineViewController
- (void)initData{
    _arrTitle = @[@"我的收益", @"安全中心", @"积分兑换", @"活动中心", @"设置"];
    BOOL bLogon = [DPK_NW_Application sharedInstance].isLogon;
    _userModel = [DPK_NW_Application sharedInstance].localUserModel;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainVCReload) name:@"hzmsg_reload_me_data" object:nil];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = BG_COLOR;
    [self.navigationController.navigationBar setHidden:YES];
    [self initData];
    [self.view addSubview:_headView];
    
}

- (void)mainVCReload{
    if (self.tableView != nil) {
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled =NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    return _tableView;
}

//- (MineHeadView *)headView{
//    if (!_headView) {
//        //头 视图
//        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 169);
//        _headView = [[[NSBundle mainBundle]loadNibNamed:@"MineHeadView" owner:self options:nil]lastObject];
//    }
//    return _headView;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellWithIdentifier = @"MineTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    viewLine.backgroundColor = BG_COLOR;
    [cell.contentView addSubview:viewLine];
    cell.textLabel.text = [_arrTitle objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = TEXT_COLOR;
    cell.accessoryType = UITableViewCellStyleValue1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *objs = [[NSBundle mainBundle]loadNibNamed:@"MineHeadView" owner:nil options:nil];
    UIView *xibView = objs[0];
    xibView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255);
    xibView.backgroundColor = [UIColor clearColor];
//    MineHeadView *mineView = [[[NSBundle mainBundle]loadNibNamed:@"MineHeadView" owner:self options:nil]lastObject];
//
//    [self.view addSubview:brightView];

    return xibView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 255;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
