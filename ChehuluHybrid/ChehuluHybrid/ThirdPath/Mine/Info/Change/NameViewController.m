//
//  NameViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/12/1.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation NameViewController
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
    UIView *viewBg = [[UIView alloc] init];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    [viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.equalTo(SW);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(8);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.text = _strName;
    _textField.placeholder = @"姓名";
    _textField.textColor = [UIColor blackColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [UIFont systemFontOfSize:16];
//    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearsOnBeginEditing = YES;
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.top.and.height.equalTo(viewBg);
        make.left.mas_equalTo(10);
    }];
    
    UIButton *btnSubmit = [[UIButton alloc] init];
    [btnSubmit setBackgroundColor:COLOR_MAIN_GREEN];
    [btnSubmit setTitle:@"保存" forState:UIControlStateNormal];
    [btnSubmit.layer setMasksToBounds:YES];
    [btnSubmit.layer setCornerRadius:5];
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg.mas_bottom).offset(24);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(SW);
        make.left.mas_equalTo(10);
    }];
}

#pragma mark -- UIAction
- (void)btnSubmitClicked{
    [indexDAL updateWithHeadImgID:nil sex:nil realname:_textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1){
        if ([cmd isEqualToString:@"Update"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改姓名成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
}

@end
