//
//  ChangePwdViewController.m
//  InKeLive
//
//  Created by 高天的Mac on 2018/8/31.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "MBProgressHUD+MJ.h"
#import "GTAFNData.h"
#import "AppDelegate.h"
#import "DPK_NW_Application.h"
#import "NSString+Common.h"

@interface ChangePwdViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GTAFNDataDelegate>{
    NSArray *arrayTitle;
    
    NSString * strOldPwd;
    NSString *strNewPwd1;
    NSString *strNewPwd2;
}
@property (weak, nonatomic) IBOutlet UITableView *tavleView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation ChangePwdViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        arrayTitle = @[@"输入旧密码", @"输入新密码",@"输入新密码"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tavleView.delegate = self;
    _tavleView.dataSource = self;
    _tavleView.separatorColor = [UIColor clearColor];
    _tavleView.allowsSelection = NO;
    _btnSubmit.layer.cornerRadius = 15;
    _btnSubmit.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark Action
- (IBAction)btnSubmitClicked:(id)sender {
    //判断两个新的是否相同
    UITextField *textFieldOld = (UITextField *)[self.view  viewWithTag:900] ;
    UITextField *textFieldNew1 = (UITextField *)[self.view  viewWithTag:901] ;
    UITextField *textFieldNew2 = (UITextField *)[self.view  viewWithTag:902] ;
    //新密码两次输入不统一
    if (![textFieldNew1.text isEqualToString:textFieldNew2.text]) {
//        [MBProgressHUD showAlertMessage:@"新密码两次输入不统一"];
        [[GTAlertTool shareInstance] showAlert:@"新密码两次输入不统一" message:@"请重新输入" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
        }];
    }else  if([textFieldOld.text isEqualToString:textFieldNew1.text]) {
//        [MBProgressHUD showAlertMessage:@"新老密码不能相同"];
        [[GTAlertTool shareInstance] showAlert:@"新老密码不能相同" message:@"请重新输入" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
        }];
    }else{
        GTAFNData *data = [[GTAFNData alloc] init];
        data.delegate = self;
        [data changePwdWithOldPwd:textFieldOld.text newPwd:textFieldNew1.text];
     }
//    [self btnBackClicked];xxxxxxxx
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"ChangePwdTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.textLabel.text = [arrayTitle objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(32, 32, 32);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = RGB(110, 110, 110);
    [cell.contentView addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.height.equalTo(@1);
        make.left.equalTo(cell.textLabel.mas_right).offset(7);
        make.top.equalTo(@44);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.placeholder = @"";
    textField.textColor = RGB(110, 110, 110);
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont systemFontOfSize:14];
    textField.tag = 900 + indexPath.row;
    textField.secureTextEntry = YES;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewLine.mas_top);
        make.top.equalTo(cell.contentView).offset(8);
        make.left.equalTo(viewLine.mas_left);
        make.width.equalTo(viewLine.mas_width);
    }];
    
    if (indexPath.row == 0) {
        viewLine.backgroundColor = MAIN_COLOR;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_PASSWORD_CHANGE]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            UITextField *textFieldNew1 = (UITextField *)[self.view  viewWithTag:901] ;
            LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
            model.userLogonPwd = [NSString md5:textFieldNew1.text];
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString md5:textFieldNew1.text] forKey:@"DPK_USERLOGONPWD"];
            [appDelegate autoLogin];
            [[GTAlertTool shareInstance] showAlert:@"提示" message:@"修改密码成功" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                [self btnBackClicked];
            }];
        }else{
            [[GTAlertTool shareInstance] showAlert:@"提示" message:[data objectForKey:@"msg"] cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
