//
//  EditInfoViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/21.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "EditInfoViewController.h"
#import "TakePhoto.h"
#import "DPK_NW_Application.h"
#import "EditNameViewController.h"
#import "SignatureViewController.h"

@interface EditInfoViewController ()<UITableViewDelegate, UITableViewDataSource,TakePhotoDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EditInfoViewController

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _arrayTitle = @[@[@"账号"],@[@"头像",@"昵称",@"个性签名"],@[@"性别",@"QQ",@"微信"]];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"修改资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(btnSaveClicked)];
    self.navigationItem.rightBarButtonItem.tintColor = RGB(24, 24, 24);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(243, 243, 243);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 365) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = RGB(243, 243, 243);
    _tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}


#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = [[_arrayTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    labTitle.textColor = TEXT_COLOR;
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(@12);
        make.width.equalTo(@100);
        make.height.equalTo(@14);
    }];
    
    UIButton *btnGo = [[UIButton alloc] init];
    [btnGo setImage:[UIImage imageNamed:@"btn_go"] forState:UIControlStateNormal];
    [cell.contentView addSubview:btnGo];
    [btnGo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@11);
        make.height.equalTo(@17);
        make.right.equalTo(cell.contentView).offset(-13);
    }];
    
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 40, 40)];
        imgHead.layer.cornerRadius = 20;
        imgHead.layer.masksToBounds = YES;
        NSString *str = model.userBigHeadPic;
        [imgHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [cell.contentView addSubview:imgHead];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 134, 13, 100, 14)];
        labName.text = model.userName;
        labName.textColor = RGB(110, 110, 110);
        labName.textAlignment = NSTextAlignmentRight;
        labName.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labName];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        UILabel *labID = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 134, 13, 100, 14)];
        labID.text = [NSString stringWithFormat:@"%d",model.userID];
        labID.textColor = RGB(110, 110, 110);
        labID.textAlignment = NSTextAlignmentRight;
        labID.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labID];
        btnGo.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        UIButton *btnMale = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, 40, 40)];
        [btnMale setTitle:@"男" forState:UIControlStateNormal];
        [btnMale setTitleColor:RGB(110, 110, 110) forState:UIControlStateNormal];
        [btnMale setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btnMale addTarget:self action:@selector(btnbtnSexClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnMale.titleLabel.font = [UIFont systemFontOfSize:14];
        btnMale.tag = 301;
        [cell.contentView addSubview:btnMale];
        
        UIButton *btnFemale= [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+60, 0, 40, 40)];
        [btnFemale setTitle:@"女" forState:UIControlStateNormal];
        [btnFemale setTitleColor:RGB(110, 110, 110) forState:UIControlStateNormal];
        [btnFemale setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btnFemale addTarget:self action:@selector(btnbtnSexClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnFemale.titleLabel.font = [UIFont systemFontOfSize:14];
        btnFemale.tag = 301;
        [cell.contentView addSubview:btnFemale];
        
        btnGo.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+13, 10, SCREEN_WIDTH/3*2 - 20, 30)];
//        textField.text =
        textField.placeholder = @"请输入QQ号";
        textField.textColor = RGB(110, 110, 110);
        textField.font = [UIFont systemFontOfSize:14];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.delegate = self;
        textField.tag = 401;
        [cell.contentView addSubview:textField];
        btnGo.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+13, 10, SCREEN_WIDTH/3*2 - 20, 30)];
        //        textField.text =
        textField.placeholder = @"请输入微信号";
        textField.textColor = RGB(110, 110, 110);
        textField.font = [UIFont systemFontOfSize:14];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.delegate = self;
        textField.tag = 402;
        [cell.contentView addSubview:textField];
        btnGo.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 3;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 50;
    }else{
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        //改头像
    }else if (indexPath.section == 1 && indexPath.row == 1){
        //改昵称
        LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
        EditNameViewController *editNameVC = [[EditNameViewController alloc] init];
        editNameVC.strOldName = model.userName;
        [self.navigationController pushViewController:editNameVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        //个性签名
        SignatureViewController *signatureVC = [[SignatureViewController alloc] init];
        [self.navigationController pushViewController:signatureVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = RGB(243, 243, 243);
    return view;
}

#pragma mark Action
- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnbtnSexClicked: (UIButton *)button{
    
}

@end
