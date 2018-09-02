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
#import "SettingViewController.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
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
    _tableView.tableHeaderView.userInteractionEnabled = YES;
    _tableView.allowsSelection = NO;
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
    if (indexPath.row == 4) {
        //设置
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    NSArray *objs = [[NSBundle mainBundle]loadNibNamed:@"MineHeadView" owner:nil options:nil];
//    UIView *xibView = objs[0];
//    xibView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255);
//    xibView.backgroundColor = [UIColor clearColor];
////    MineHeadView *mineView = [[[NSBundle mainBundle]loadNibNamed:@"MineHeadView" owner:self options:nil]lastObject];
////
////    [self.view addSubview:brightView];
//
//    return xibView;
    
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255)];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgInfo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 169)];
    imgInfo.image = [UIImage imageNamed:@"mine_head_bg"];
    [viewHead addSubview:imgInfo];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 16)];
    labTitle.text = @"我的";
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:16];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [imgInfo addSubview:labTitle];
    
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(13, 74, 60, 60)];
    NSString *strImgPath = model.userBigHeadPic;
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strImgPath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    imgHead.layer.masksToBounds = YES;
    imgHead.layer.cornerRadius = 30;
    [imgInfo addSubview:imgHead];
    
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(81, 84, SCREEN_WIDTH - 120, 15)];
    labName.text = model.userName;
    labName.textColor = [UIColor whiteColor];
    labName.textAlignment = NSTextAlignmentLeft;
    labName.font = [UIFont systemFontOfSize:15];
    [imgInfo addSubview:labName];
    
    UILabel *labLevel = [[UILabel alloc] initWithFrame:CGRectMake(84, 117, 38, 15)];
    labLevel.backgroundColor = MAIN_COLOR;
    labLevel.textAlignment = NSTextAlignmentCenter;
    labLevel.textColor = [UIColor whiteColor];
    labLevel.font = [UIFont systemFontOfSize:10];
    labLevel.text = [NSString stringWithFormat:@"level%d",model.viplevel];
    [imgInfo addSubview:labLevel];
    
    UILabel *labID = [[UILabel alloc] initWithFrame:CGRectMake(133, 119, 100, 12)];
    labID.text = [NSString stringWithFormat:@"ID:%d",model.userID];
    labID.textAlignment = NSTextAlignmentLeft;
    labID.textColor = [UIColor whiteColor];
    labID.font = [UIFont systemFontOfSize:12];
    [imgInfo addSubview:labID];
    
    UIButton *btnGo = [[UIButton alloc] init];
    [btnGo setImage:[UIImage imageNamed:@"btn_go_white"] forState:UIControlStateNormal];
    [imgInfo addSubview:btnGo];
    [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewHead).offset(-13);
        make.width.equalTo(@11);
        make.height.equalTo(@17);
        make.centerY.equalTo(imgInfo.mas_centerY).offset(30);
    }];
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100)];
    [btnEdit addTarget:self action:@selector(btnEditInfoClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewHead addSubview:btnEdit];
    
    
    UIView *viewMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 169, SCREEN_WIDTH, 255-169)];
    [viewHead addSubview:viewMoney];
    
    UILabel *labGold = [[UILabel alloc] initWithFrame:CGRectMake(13, 12, 200, 20)];
    labGold.text = [NSString stringWithFormat:@"%lld金币",model.nk];
    labGold.textColor = RGB(23, 23, 23);
    labGold.font = [UIFont systemFontOfSize:20];
    labGold.textAlignment = NSTextAlignmentLeft;
    [viewMoney addSubview:labGold];
    
    UIButton *btnRecharge = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 24, 76, 38)];
    [btnRecharge setTitle:@"充值" forState:UIControlStateNormal];
    [btnRecharge setBackgroundColor:MAIN_COLOR];
    [btnRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRecharge.layer.cornerRadius = 19;
    btnRecharge.layer.masksToBounds = YES;
    [viewMoney addSubview:btnRecharge];
    
    
    return viewHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 255;
}

#pragma mark Action
- (void)btnEditInfoClicked{
//    NSLog(@"btnEditInfoClicked");
    EditInfoViewController *editVC = [[EditInfoViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)btnRechargeClicked{
    
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
