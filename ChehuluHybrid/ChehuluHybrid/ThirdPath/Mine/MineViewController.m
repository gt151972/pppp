//
//  MineViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/6/6.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MineViewController.h"
#import "MyOrderViewController.h"
#import "NewInfoViewController.h"
#import "MoneyViewController.h"
#import "CarViewController.h"
#import "OilCardViewController.h"
#import "AddressViewController.h"
#import "MyGiftViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
@interface MineViewController()<UITableViewDelegate, UITableViewDataSource>{
    UIView *viewInfo;
    UIView *viewLogin;
    NSDictionary *dictinfo;//个人信息
    NSDictionary *dictMoney;//车币信息
    
//    UILabel *labName;
//    UILabel *labPhone;
    UIButton *btnHead;
    UILabel *labNumber;
    UILabel *labMoneyData;
}
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:COLOR_BG_GRAY];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, 0, gtWIDTH, gtHEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getInfo];
    [self initView];
//    [self initNavigation];
}

- (void)initNavigation{
    UIImage *imageCode = [UIImage imageNamed:@"Top_Bar_button_code"];
    UIButton *btnCode = [[UIButton alloc] init];
    [btnCode setImage:imageCode forState:UIControlStateNormal];
    [btnCode addTarget:self action:@selector(btnCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCode];
    UIImage *imageChat = [UIImage imageNamed:@"Top_Bar_button_notice"];
    UIButton *btnChat = [[UIButton alloc] init];
    [btnChat setImage:imageChat forState:UIControlStateNormal];
    [btnChat addTarget:self action:@selector(btnChatClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChat];
    [btnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(btnChat.mas_left).offset(-20);
    }];
    [btnChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(btnCode);
        make.right.mas_equalTo(-10);
    }];
}

- (void)initView{
    //header
    UIImageView *viewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 218)];
    viewHeader.image = [UIImage imageNamed:@"mineBg"];
    [self.view addSubview:viewHeader];
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0,  0, gtWIDTH, 132)];
    viewInfo.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:viewInfo];
    if (gtUserInfo) {
        //车币
        UILabel *labMoneyKey = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, gtWIDTH, 16)];
        labMoneyKey.text = @"我的收益(车币)";
        labMoneyKey.textColor = [UIColor whiteColor];
        labMoneyKey.textAlignment = NSTextAlignmentCenter;
        labMoneyKey.font = [UIFont systemFontOfSize:13];
        [viewInfo addSubview:labMoneyKey];
        
        labMoneyData = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, gtWIDTH, 56)];
        if (gtDicMoney) {
            labMoneyData.text = [NSString stringWithFormat:@"%.2f",[[gtDicMoney objectForKey:@"cash_money"] floatValue]];
        }else{
            labMoneyData.text = @"0";
        }
        labMoneyData.textColor = [UIColor whiteColor];
        labMoneyData.textAlignment = NSTextAlignmentCenter;
        labMoneyData.font = [UIFont systemFontOfSize:56];
        [viewInfo addSubview:labMoneyData];
        
        UIButton *btnMoney = [[UIButton alloc] init];
        [btnMoney setBackgroundColor:[UIColor clearColor]];
        [btnMoney addTarget:self action:@selector(btnMoneyClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewInfo addSubview:btnMoney];
        [btnMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.top.equalTo(viewInfo);
        }];
        //头像
        btnHead = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 36, 36)];
        btnHead.layer.masksToBounds = YES;
        btnHead.layer.cornerRadius = 18;
//        btnHead.backgroundColor = [super colorWithHexString:@"#d8ede4"];
        [btnHead setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateNormal];
        UIImage *imgHead = [super getImageWithName:@"head"];
        if (imgHead) {
            [btnHead setImage:imgHead forState:UIControlStateNormal];
        }
        [btnHead addTarget:self action:@selector(btnInfoClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnHead];
    }else{
        viewLogin = [[UIView alloc] initWithFrame:CGRectMake(0,  64, gtWIDTH, 75)];
        viewLogin.backgroundColor = [UIColor clearColor];
        [viewHeader addSubview:viewLogin];
        UILabel *labLogin = [[UILabel alloc] init];
        labLogin.text = @"登录";
        labLogin.textColor = [UIColor whiteColor];
        labLogin.textAlignment = NSTextAlignmentLeft;
        labLogin.font = [UIFont systemFontOfSize:16];
        [viewLogin addSubview:labLogin];
        [labLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewLogin).offset(15);
            make.height.and.centerX.and.centerY.equalTo(viewLogin);
        }];
        UIButton *btnLogin = [[UIButton alloc] initWithFrame:viewInfo.frame];
        [btnLogin setBackgroundColor: [UIColor clearColor]];
        [btnLogin addTarget:self action:@selector(btnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewLogin addSubview:btnLogin];                
    }
    //消息中心
    UIButton *btnNoti = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 36, 36, 20, 20)];
    [btnNoti setImage:[UIImage imageNamed:@"mine_noti"] forState:UIControlStateNormal];
    [btnNoti addTarget:self action:@selector(btnChatClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNoti];
    
//    //meddle
//    
//    //footer
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 218, gtWIDTH,gtHEIGHT - 267) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    if (gtHEIGHT - 267 > 304) {
        self.tableView.frame = CGRectMake(0, 218, gtWIDTH, 304);
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (gtUserInfo) {
        if (indexPath.section == 0){
            //我的车辆
            CarViewController *carVC = [[CarViewController alloc] init];
            [self.navigationController pushViewController:carVC animated:YES];
        }else if (indexPath.section == 1){
            //我的订单
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }else if (indexPath.section == 2){
            //我的卡券
            MyGiftViewController *myGift = [[MyGiftViewController alloc] init];
            [self.navigationController pushViewController:myGift animated:YES];
        }else if (indexPath.section == 3){
            //地址管理
            AddressViewController *addressVC = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }else if (indexPath.section == 4){
            //设置
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"我的车辆", @"我的订单",  @"我的卡券", @"地址管理",@"设置", nil];
    NSArray *arrayImage = [NSArray arrayWithObjects:@"mine_car", @"mine_order_icon", @"mine_card", @"mine_location", @"mine_setting", nil];
    cell.imageView.image = [UIImage imageNamed:[arrayImage objectAtIndex:indexPath.section]];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [arrayName objectAtIndex:indexPath.section];
    return cell;
}


#pragma mark -- Action


/**
 *  登录
 */
- (void)btnLoginClicked{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}
//
///**
// *  二维码
// */
//- (void)btnCodeClicked{
//    
//}

/**
 *  通知
 */
- (void)btnChatClicked{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

/**
 *  个人信息
 */
- (void)btnInfoClicked{
    NewInfoViewController *infoVC = [[NewInfoViewController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

/**
 *  车币
 */
- (void)btnMoneyClicked{
    MoneyViewController *moneyVC = [[MoneyViewController alloc] init];
    [self.navigationController pushViewController:moneyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1) {
        if ([cmd isEqualToString:@"info"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dictinfo = [NSDictionary dictionaryWithDictionary:[super nullToEmpty:[dic objectForKey:@"info"]]];
                UIImage *imageHead = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictinfo objectForKey:@"headimg_url"]]]];
                NSDictionary *dicUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[dictinfo objectForKey:@"nickname"], @"nickname",[dictinfo objectForKey:@"mobile"], @"mobile", [dictinfo objectForKey:@"realname"], @"realname", [dictinfo objectForKey:@"headimg_url"], @"headimg_url", [dictinfo objectForKey:@"sex"], @"sex",[[dictinfo objectForKey:@"area_info"] objectForKey:@"area_name"], @"area_name",[dictinfo objectForKey:@"score"], @"score",nil];
                [[NSUserDefaults standardUserDefaults] setObject:dicUserInfo forKey:@"dicMyInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [super saveImage:imageHead WithName:@"head"];
                
                [btnHead setImage:imageHead forState:UIControlStateNormal];
                labNumber.text = [NSString stringWithFormat:@"总积分  %@",[gtDicMyInfo objectForKey:@"score"]];
            });
           
            [indexDAL MoneyInfo];
        }else if ([cmd isEqualToString:@"MoneyInfo"]){
            dictMoney = [NSDictionary dictionaryWithDictionary:[super nullToEmpty:[dic objectForKey:@"info"]]];
            NSLog(@"cash_money == %@",dictMoney);
            [[NSUserDefaults standardUserDefaults] setObject:dictMoney forKey:@"dictMoney"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            labMoneyData.text = [NSString stringWithFormat:@"%@",[dictMoney objectForKey:@"cash_money"]];
        }
        else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    }else{
        
    }
}

@end
