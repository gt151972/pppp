//
//  MineViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/6/6.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "MineViewController.h"
#import "MyOrderViewController.h"
@interface MineViewController()<UITableViewDelegate, UITableViewDataSource>{
    UIView *viewInfo;
    UIView *viewLogin;
    NSDictionary *dict;
    
    UILabel *labName;
    UILabel *labPhone;
    UIImageView *imgViewHead;
}
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dict = [[NSDictionary alloc] init];
//    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, 0, gtWIDTH, gtHEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self initNavigation];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    [indexDAL getInfo];
    [self initView];
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
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 169)];
    viewHeader.backgroundColor = COLOR_MAIN_GREEN;
    [self.view addSubview:viewHeader];
    
    viewInfo = [[UIView alloc] initWithFrame:CGRectMake(0,  64, gtWIDTH, 75)];
    viewInfo.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:viewInfo];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) {
        imgViewHead = [[UIImageView alloc] init];
        imgViewHead.layer.masksToBounds = YES;
        imgViewHead.layer.cornerRadius = 20;
        imgViewHead.backgroundColor = [super colorWithHexString:@"#d8ede4"];
        [viewInfo addSubview:imgViewHead];
        [imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewInfo);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(13);
        }];
        labName  = [[UILabel alloc] init];
        labName.textColor = [UIColor whiteColor];
        labName.textAlignment = NSTextAlignmentLeft;
        labName.font = [UIFont systemFontOfSize:14];
        [viewInfo addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgViewHead.mas_right).offset(10);
            make.top.equalTo(imgViewHead);
            make.size.mas_equalTo(CGSizeMake(200, 14));
        }];
        labPhone = [[UILabel alloc] init];
        labPhone.textColor = [UIColor whiteColor];
        labPhone.textAlignment = NSTextAlignmentLeft;
        labPhone.font = [UIFont systemFontOfSize:14];
        [viewInfo addSubview:labPhone];
        [labPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.left.equalTo(labName);
            make.bottom.equalTo(imgViewHead);
        }];
        
        UIImage *imageNext = [UIImage imageNamed:@"icon_button_click"];
        UIImageView *imageViewNext = [[UIImageView alloc] init];
        imageViewNext.image = imageNext;
        [viewInfo addSubview:imageViewNext];
        [imageViewNext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageNext.size);
            make.centerY.equalTo(viewInfo);
            make.right.equalTo(SW).offset(-10);
        }];
        
        UIButton *btnInfo = [[UIButton alloc] init];
        [btnInfo setBackgroundColor:[UIColor clearColor]];
        [btnInfo addTarget:self action:@selector(btnInfoClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewInfo addSubview:btnInfo];
        [btnInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.top.equalTo(viewInfo);
        }];
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
        UIButton *btnLogin = [[UIButton alloc] initWithFrame:viewLogin.frame];
        [btnLogin setBackgroundColor: [UIColor redColor]];
        [btnLogin addTarget:self action:@selector(btnLoginClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewLogin addSubview:btnLogin];
    }
    
    
    UIView *viewLine = [[UIView alloc] init];
//    [viewLine setBackgroundColor:[UIColor blueColor]];
    viewLine.backgroundColor = [super colorWithHexString:@"52b388"];
    [viewInfo addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewInfo.mas_bottom);
        make.width.equalTo(SW);
        make.height.mas_equalTo(1.0);
    }];
    
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
    [viewHeader addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewLine.mas_bottom);
        make.bottom.equalTo(viewHeader);
        make.width.equalTo(SW);
    }];

    UIView *viewLine2 = [[UIView alloc] init];
    viewLine2.backgroundColor = [super colorWithHexString:@"52b388"];
    [view addSubview:viewLine2];
    [viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(5);
        make.bottom.equalTo(view).offset(-5);
        make.width.mas_equalTo(1);
        make.centerX.and.centerY.equalTo(view);
    }];
    UILabel *labMoney = [[UILabel alloc] init];
    labMoney.text = @"总车币";
    labMoney.textColor = [UIColor whiteColor];
    labMoney.textAlignment = NSTextAlignmentLeft;
    labMoney.font = [UIFont systemFontOfSize:10];
    [view addSubview:labMoney];
    [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SW).offset(10);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(100, 10));
    }];
    UILabel *labMoneyCount = [[UILabel alloc] init];
    labMoneyCount.text = @"10000000.00";
    labMoneyCount.textAlignment = NSTextAlignmentRight;
    labMoneyCount.textColor = [UIColor whiteColor];
    labMoneyCount.font = [UIFont systemFontOfSize:12];
    [view addSubview:labMoneyCount];
    [labMoneyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewLine2.mas_left).offset(-10);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(200, 12));
    }];
    UILabel *labNumber = [[UILabel alloc] init];
    labNumber.text = @"总积分";
    labNumber.textColor = [UIColor whiteColor];
    labNumber.textAlignment = NSTextAlignmentLeft;
    labNumber.font = [UIFont systemFontOfSize:10];
    [view addSubview:labNumber];
    [labNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLine2.mas_right).offset(10);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(100, 10));
    }];
    UILabel *labNumberCount = [[UILabel alloc] init];
    labNumberCount.text = @"1000000";
    labNumberCount.textAlignment = NSTextAlignmentRight;
    labNumberCount.textColor = [UIColor whiteColor];
    labNumberCount.font = [UIFont systemFontOfSize:12];
    [view addSubview:labNumberCount];
    [labNumberCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(100, 10));
    }];
    
//    UIButton *btnInfo = [[UIButton alloc] init];
    
//    //meddle
//    
//    //footer
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 169, gtWIDTH,199) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.number = 5;
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }
    }else{
        
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MineTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayIcon = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_search"], [UIImage imageNamed:@"icon_car"], [UIImage imageNamed:@"icon_youka"], [UIImage imageNamed:@"icon_location"], [UIImage imageNamed:@"icon_settings"], nil];
    NSArray *arrayName = [NSArray arrayWithObjects:@"我的订单", @"我的车辆", @"我的油卡", @"地址管理", @"设置", nil];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.section == 0) {
        cell.imageView.image = [arrayIcon objectAtIndex:indexPath.row];
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
    }else if (indexPath.section == 1){
        cell.imageView.image = [arrayIcon objectAtIndex:indexPath.row+3];
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row+3];
    }else{
        cell.imageView.image = [arrayIcon objectAtIndex:indexPath.row +4];
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.row+4];
    }
    
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

/**
 *  二维码
 */
- (void)btnCodeClicked{
    
}

/**
 *  通知
 */
- (void)btnChatClicked{
    
}

/**
 *  个人信息
 */
- (void)btnInfoClicked{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
//    {
//        info =     {
//            address = "<null>";
//            "area_id" = 0;
//            "b_frist_login" = "2016-06-17 11:09:43";
//            "bang_intime" = 0;
//            birthday = "0000-00-00";
//            "c_frist_login" = "2015-09-21 10:47:37";
//            "cash_passwd_isset" = 0;
//            email = "18815287521@qq.com";
//            "from_source" = "B&C";
//            headimg = 1175;
//            "headimg_url" = "http://jh2.buyubi.com/ZhiBao/Uploads/CarImg/2016-06-27/5770f82c87531940579265.jpeg";
//            "ident_face" = 0;
//            "ident_img" = 1366;
//            "ident_no" = 1;
//            "ident_oppo" = 0;
//            "is_cert" = 0;
//            "last_login_ip" = 1942921391;
//            "last_login_time" = 1470278533;
//            level = 1;
//            login = 231;
//            "login_passwd_isset" = 1;
//            loginname = 18815287521;
//            menus =         {
//                car =             (
//                                   GridUserCar,
//                                   "ZH_OBD",
//                                   GridSim,
//                                   GridDepot
//                                   );
//                channel =             (
//                                       GridAgent,
//                                       GridBang
//                                       );
//                gain =             (
//                                    GridUserAccount,
//                                    GridDeptAccount,
//                                    GridAgentAccount,
//                                    GridBangAccount
//                                    );
//                index =             (
//                );
//                market =             (
//                                      GridGoods,
//                                      GridWithdraw,
//                                      GridUserExchange
//                                      );
//                order =             (
//                                     GridInsurerPolicy,
//                                     GridExpressLog,
//                                     GridPriceLog,
//                                     PanelBuy
//                                     );
//                product =             (
//                                       GridProduct,
//                                       "ZH_Insurer"
//                                       );
//                set =             (
//                                   "ZH_Province",
//                                   GridExpress
//                                   );
//                user =             (
//                                    GridUser
//                                    );
//            };
//            mobile = 18815287521;
//            nickname = "GT\U2006q";
//            qq = "";
//            realname = "\U9ad8\U5a77\U5a77";
//            "reg_ip" = 979752704;
//            "reg_time" = "2015-09-21 10:47:37";
//            "role_id" = 0;
//            salesman = "<null>";
//            score = 50;
//            sex = 0;
//            "source_desc" = "";
//            sourceid = "<null>";
//            srcid = "<null>";
//            status = 1;
//            stypeid = "<null>";
//            "total_amt" = 0;
//            "total_inte" = 0;
//            uid = 30;
//            weixin = "";
//            wximg = "<null>";
//        };
//        status = 1;
//        url = "";
//    }
    if ([cmd isEqualToString:@"info"]) {
        NSLog(@"dic == %@",dic);
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            dict = [dic objectForKey:@"info"];
            labName.text = [dict objectForKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"nickname"] forKey:@"nickname"];
            labPhone.text = [dict objectForKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"mobile"] forKey:@"mobile"];
            imgViewHead.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"headimg_url"]]]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headimg_url"];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
    }
}

@end
