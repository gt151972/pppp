//
//  EditNameViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/30.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "EditNameViewController.h"
#import "GTAFNData.h"
#import "MBProgressHUD+MJ.h"

@interface EditNameViewController ()<UITextFieldDelegate, GTAFNDataDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UILabel *labOldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewName;

@end

@implementation EditNameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"修改昵称";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnBackClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = RGB(110, 110, 110);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _labOldName.text = [NSString stringWithFormat:@"当前昵称: %@",_strOldName];
    _btnSure.layer.cornerRadius = 20;
    _btnSure.layer.masksToBounds = YES;
    _textFieldNewName.delegate = self;
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSureChangeClicked:(id)sender {
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    LocalUserModel *model = [[LocalUserModel alloc] init];
    [data changeUserInfoWithUid:[NSString stringWithFormat:@"%d",model.userID] uNick:_textFieldNewName.text head:@"" sign:model.sign gender:[NSString stringWithFormat:@"%d",model.gender] qq:model.qq wechat:model.wechat];
}

- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_CHANGE_USER_INFO]) {
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
            model.userName = [data[@"data"] objectForKey:@"uNick"];
            if ([data[@"msg"] isEqualToString:@"ok"]) {
                [MBProgressHUD showAlertMessage:@"修改昵称成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [MBProgressHUD showAlertMessage:data[@"msg"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
