//
//  NewInfoViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/6/27.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "NewInfoViewController.h"

@interface NewInfoViewController (){
    TakePhoto *photo;
    UIImage *imageHead;
}

@end

@implementation NewInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self infoView];
    [self initNav];
    
}

- (void)initData{
    photo = [[TakePhoto alloc] init];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
}

- (void)initNav{
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"btnBackNormal"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 64, 20, 44, 44)];
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEdit.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnEdit.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnEdit setTag:201];
    [btnEdit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEdit];
}

- (void)initView{
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    [imageBg setImage:[UIImage imageNamed:@"mine_bg"]];
    [self.view addSubview:imageBg];
    
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/5, 306, gtWIDTH*3/5, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/5, 373, gtWIDTH*3/5, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:line2];
    
    
}

- (void)infoView{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = 1001;
    [self.view addSubview:view];
    //头像
    UIImageView *imageHead = [[UIImageView alloc] init];
    imageHead.layer.masksToBounds = YES;
    imageHead.layer.cornerRadius = 30;
    //        btnHead.backgroundColor = [super colorWithHexString:@"#d8ede4"];
    //    [UIImageView *imageHead = [UIImageView alloc] init]; setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateNormal];
    UIImage *imgHead = [super getImageWithName:@"head"];
    if (imgHead) {
        [imageHead setImage:imgHead];
    }else{
        [imageHead setImage:[UIImage imageNamed:@"mine_head_default"]];
    }
    [view addSubview:imageHead];
    [imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(121);
    }];
    
    UILabel *labTel = [[UILabel alloc] init];
    labTel.text = [gtDicMyInfo objectForKey:@"mobile"];
    labTel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    labTel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    labTel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTel];
    [labTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageHead.mas_bottom).offset(10);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labName = [[UILabel alloc] init];
    labName.text = @"姓名未知";
    labName.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    labName.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    labName.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTel.mas_bottom).offset(67);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labSex = [[UILabel alloc] init];
    labSex.text = @"性别未知";
    labSex.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    labSex.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    labSex.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labSex];
    [labSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labName.mas_bottom).offset(52);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labAddr = [[UILabel alloc] init];
    labAddr.text = @"地址";
    labAddr.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    labAddr.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    labAddr.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labAddr];
    [labAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labSex.mas_bottom).offset(52);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(gtWIDTH/5, 440, gtWIDTH*3/5, 1)];
    line3.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [view addSubview:line3];
}

- (void)editView{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = 1002;
    [self.view addSubview:view];
    //头像
    UIButton *btnHead = [[UIButton alloc] init];
    btnHead.layer.masksToBounds = YES;
    btnHead.layer.cornerRadius = 30;
    btnHead.tag = 206;
    //        btnHead.backgroundColor = [super colorWithHexString:@"#d8ede4"];
    //    [UIImageView *imageHead = [UIImageView alloc] init]; setBackgroundImage:[UIImage imageNamed:@"defaultHead"] forState:UIControlStateNormal];
    UIImage *imgHead = [super getImageWithName:@"head"];
    if (imgHead) {
        [btnHead setImage:imgHead forState:UIControlStateNormal];
    }else{
        [btnHead setImage:[UIImage imageNamed:@"mine_head_default"] forState:UIControlStateNormal];
    }
    [btnHead addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnHead];
    [btnHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(121);
    }];
    
    UILabel *labTel = [[UILabel alloc] init];
    labTel.text = [gtDicMyInfo objectForKey:@"mobile"];
    labTel.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    labTel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    labTel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTel];
    [labTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnHead.mas_bottom).offset(10);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UITextView *textName = [[UITextView alloc] init];
    textName.backgroundColor = [UIColor clearColor];
    if ([gtDicMyInfo objectForKey:@"nickname"]) {
        textName.text = [gtDicMyInfo objectForKey:@"nickname"];
    }
    textName.font = [UIFont fontWithName:@".PingFangSC-Medium" size:15];
    textName.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    textName.textAlignment = NSTextAlignmentCenter;
    [view addSubview:textName];
    [textName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTel.mas_bottom).offset(67);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *btnAddr = [[UIButton alloc] init];
    NSLog(@"gtDicMyInfo == %@",gtDicMyInfo);
    [btnAddr setTitle:[gtDicMyInfo objectForKey:@"area_name"] forState:UIControlStateNormal];
    [btnAddr.titleLabel setFont:[UIFont fontWithName:@".PingFangSC-Medium" size:15]];
    [btnAddr.titleLabel setTextColor:[UIColor whiteColor]];
    [btnAddr.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnAddr addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnAddr];
    [btnAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textName.mas_bottom).offset(52);
        make.width.and.centerX.equalTo(self.view);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *btnMale = [[UIButton alloc] init];
    if ([[gtDicMyInfo objectForKey:@"sex"] isEqualToString:@"1"]) {
        btnMale.selected = YES;
    }
    [btnMale setTag:203];
    [btnMale setImage:[UIImage imageNamed:@"mine_shape_gray"] forState:UIControlStateNormal];
    [btnMale setImage:[UIImage imageNamed:@"mine_shape_white"] forState:UIControlStateSelected];
    [btnMale setTitle:@"  男"forState:UIControlStateNormal];
    [btnMale.titleLabel setFont:[UIFont fontWithName:@".PingFangSC-Medium" size:15]];
    [btnMale.titleLabel setTextColor:[UIColor whiteColor]];
    [btnMale.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnMale addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnMale];
    [btnMale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnAddr.mas_bottom).offset(52);
        make.width.mas_offset(gtWIDTH/2);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.view);
    }];

    UIButton *btnFemale = [[UIButton alloc] init];
    if ([[gtDicMyInfo objectForKey:@"sex"] isEqualToString:@"0"]) {
        btnFemale.selected = YES;
    }
    [btnFemale setTag:204];
    [btnFemale setImage:[UIImage imageNamed:@"mine_shape_gray"] forState:UIControlStateNormal];
    [btnFemale setImage:[UIImage imageNamed:@"mine_shape_white"] forState:UIControlStateSelected];
    [btnFemale setTitle:@"  女"forState:UIControlStateNormal];
    [btnFemale.titleLabel setFont:[UIFont fontWithName:@".PingFangSC-Medium" size:15]];
    [btnFemale.titleLabel setTextColor:[UIColor whiteColor]];
    [btnFemale.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnFemale addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnFemale];
    [btnFemale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnAddr.mas_bottom).offset(52);
        make.left.and.width.mas_offset(gtWIDTH/2);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *btnSubmit = [[UIButton alloc] init];
    if ([[gtDicMyInfo objectForKey:@"sex"] isEqualToString:@"0"]) {
        btnSubmit.selected = YES;
    }
    [btnSubmit setTitle:@"保存"forState:UIControlStateNormal];
    [btnSubmit.layer setCornerRadius:24];
    [btnSubmit.layer setMasksToBounds:YES];
    [btnSubmit.layer setBorderWidth:1.0];
    [btnSubmit.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor];
    [btnSubmit.titleLabel setFont:[UIFont fontWithName:@".PingFangSC-Medium" size:15]];
    [btnSubmit.titleLabel setTextColor:[UIColor whiteColor]];
    [btnSubmit.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnSubmit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSubmit];
    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnFemale.mas_bottom).offset(52);
        make.width.mas_equalTo(gtWIDTH*3/5);
        make.height.mas_equalTo(48);
        make.left.mas_equalTo(gtWIDTH/5);
    }];
}

#pragma mark -- action
- (void)btnClicked: (UIButton *)button{
    //编辑
    if (button.tag == 201) {
        UIView *view = (UIView *)[self.view viewWithTag:1001];
        [view removeFromSuperview];
        [self editView];
    }else if (button.tag == 202){//选择常住地
        
    }else if (button.tag == 203){//选择男
        if (button.selected != YES) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:204];
            btn.selected = NO;
            button.selected = YES;
        }
    }else if (button.tag == 204){//选择女
        if (button.selected != YES) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:203];
            btn.selected = NO;
            button.selected = YES;
        }
    }else if (button.tag == 205){//保存
        [self doSubmit];
    }else if (button.tag == 206){//修改头像
        imageHead = [photo takePhotoWithVC:self];
        [button setImage:[super imageByScalingToMaxSize:imageHead] forState:UIControlStateNormal];

    }
}

- (void)doSubmit{
    [indexDAL uploadimgWithPicture:[super image2DataURL:[super imageByScalingToMaxSize:imageHead]]];
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    if ([cmd isEqualToString:@"Uploadimg"]) {
        [indexDAL updateWithHeadImgID:[[dic objectForKey:@"info"] objectForKey:@"id"] sex:nil realname:nil];
    }else if ([cmd isEqualToString:@"Update"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertSure];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
