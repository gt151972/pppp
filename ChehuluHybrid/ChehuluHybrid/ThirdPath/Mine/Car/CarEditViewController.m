//
//  CarEditViewController.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/23.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "CarEditViewController.h"
#import "CarBrandViewController.h"
#import "TakePhoto.h"

@interface CarEditViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate>{
    NSDictionary *dic;
    BaseButton *btn;
    UIImageView *imageViewDriving;
    NSString *strState;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIDatePicker *datePicker;
@end

@implementation CarEditViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"车辆信息"];
    [super addRightButtonForImage:@"delete"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    [self initData];
    [self initView];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
//    tapGesture.delegate = self;
    //[self addGestureRecognizer:tapGesture];
}

- (void)initNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(returnNotification:) name:@"carSeries" object:nil];
}

- (void)returnNotification:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"carSeries"]) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:7];
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexpath];
        UILabel *lab=(UILabel *)[cell viewWithTag:101];
        NSLog(@" == %@",notification.userInfo);
        lab.text = [NSString stringWithFormat:@"%@ %@",[notification.userInfo objectForKey:@"brand_name"], [notification.userInfo objectForKey:@"car_series"]];
        NSLog(@"text == %@",[NSString stringWithFormat:@"%@ %@",[notification.userInfo objectForKey:@"brand_name"], [notification.userInfo objectForKey:@"car_series"]]);
    }
}

- (void)initData{
    dic = [super nullToEmpty:_dic];
    btn = [[BaseButton alloc] init];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,gtHEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CarEditTableViewCell"];
    [self.view addSubview:_tableView];
    
    [super packUpKeyboard];
}

- (void)btnClicked: (UIButton *)button{
    if (button.tag == 203) {
        TakePhoto *takePhoto = [[TakePhoto alloc] init];
        imageViewDriving.image = [takePhoto takePhotoWithVC:self];
        NSString *strImage = [super image2DataURL:[takePhoto takePhotoWithVC:self]];
        NSLog(@"strImage == %@",strImage);
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 300)];
        image.image = [takePhoto takePhotoWithVC:self];
        [self.view addSubview:image];
    }
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 8){
        return 140;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==  0 || section == 8) {
        return 0;
    }
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 5) {
        [self datePicker];
    }else if (indexPath.section == 7){
        CarBrandViewController *carBrandVC = [[CarBrandViewController alloc] init];
        [self.navigationController pushViewController:carBrandVC animated:YES];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CarEditTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrayName = [NSArray arrayWithObjects:@"车牌号", @"车主姓名", @"车辆识别代号", @"发动机号码", @"注册日期", @"使用性质", @"品牌型号", nil];
    NSMutableArray *arrDetail = [[NSMutableArray alloc] init];
    NSLog(@"dic == %@",dic);
    if ([dic objectForKey:@"car_no"]) {
        [arrDetail addObjectsFromArray:[NSArray arrayWithObjects:[dic objectForKey:@"car_no"], [dic objectForKey:@"drv_owner"], [dic objectForKey:@"vhl_frm"], [dic objectForKey:@"eng_no"], [dic objectForKey:@"fst_reg_dte"], [dic objectForKey:@"operating"], [dic objectForKey:@"car_series"], nil]];

    }else{
         [arrDetail addObjectsFromArray:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil]];
    }
    NSLog(@"arrDetail == %@",arrDetail);
    if (indexPath.section == 0) {
        UIImage *image;
        if ([dic objectForKey:@"img_url"]) {
            image = [super getImageForUrl:[dic objectForKey:@"img_url"]];
        }else{
            image = [UIImage imageNamed:@"example"];
        }
        imageViewDriving = [[UIImageView alloc] initWithImage:image];
        imageViewDriving.tag = 601;
        [cell.contentView addSubview:imageViewDriving];
        [imageViewDriving mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
            make.centerX.and.centerY.equalTo(cell);
        }];
        
        UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 120)];
        viewBg.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [cell.contentView addSubview:viewBg];
        
        UIButton *btnCamera = [[UIButton alloc] init];
        UIImage *imageCamera = [UIImage imageNamed:@"camera"];
        [btnCamera setImage:imageCamera forState:UIControlStateNormal];
        [btnCamera addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnCamera setTag:203];
        [cell.contentView addSubview:btnCamera];
        [btnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageCamera.size);
            make.center.equalTo(cell);
        }];
        
    }else if (indexPath.section < 8 ) {
        cell.textLabel.text = [arrayName objectAtIndex:indexPath.section - 1];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
                
        if (indexPath.section == 5) {//选择日期
            UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, gtWIDTH - 150, 60)];
            labDate.text = [arrDetail objectAtIndex:indexPath.section-1];
            labDate.font = [UIFont systemFontOfSize:14];
            labDate.textColor = COLOR_TEXT_GARY;
            labDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:labDate];
        }else if (indexPath.section == 6){//使用性质
            float btnW = (gtWIDTH-160)/2;
            NSString *type = [arrDetail objectAtIndex:indexPath.section-1];
            for (int index = 0; index < 2; index ++ ) {
                UIButton *btnType = [[UIButton alloc] initWithFrame:CGRectMake(btnW*index + 140, 0, btnW, 60)];
                [btnType setTag:200+index];
                [btnType setImage:[UIImage imageNamed:@"chooseNormal"] forState:UIControlStateNormal];
                [btnType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnType.titleLabel setFont:[UIFont systemFontOfSize:14]];
                if (index == 0) {
                    [btnType setTitle:@"营运" forState:UIControlStateNormal];
                    strState = @"非营运";
                }else{
                    [btnType setTitle:@"非营运" forState:UIControlStateNormal];
                    strState = @"营运";
                }
                [btnType addTarget:self action:@selector(btnTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
                if ((index == 0 && [type isEqualToString:@"1"]) || (index == 1 || [type isEqualToString:@"0"])) {
                    [btnType setImage:[UIImage imageNamed:@"chooseSelect"] forState:UIControlStateNormal];
                }
                [cell.contentView addSubview:btnType];
            }
        }else if (indexPath.section == 7){//品牌型号
            UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, gtWIDTH - 150, 60)];
            labDate.text = [arrDetail objectAtIndex:indexPath.section-1];
            labDate.font = [UIFont systemFontOfSize:14];
            labDate.textColor = COLOR_TEXT_GARY;
            labDate.tag = 101;
            labDate.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:labDate];
        }else{
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 0, gtWIDTH - 150, 60)];
            _textField.delegate = self;
            _textField.textColor = COLOR_TEXT_GARY;
            _textField.textAlignment = NSTextAlignmentLeft;
            _textField.font = [UIFont systemFontOfSize:14];
            _textField.tag = 301 + indexPath.section;
            //    _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textField.clearsOnBeginEditing = YES;
            [cell.contentView addSubview:_textField];
            if (arrDetail.count != 0) {
                 _textField.text = [arrDetail objectAtIndex:indexPath.section - 1];
            }
        }
    }
    if (indexPath.section == 8) {
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, gtWIDTH - 40, 48)];
        btnEdit = [btn btnGreen:@"保存"];
        [btnEdit addTarget:self action:@selector(btnSubmit) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnEdit];
        [btnEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.height.mas_equalTo(48);
            make.left.mas_equalTo(20);
        }];
        UIButton *btnSafe = [[UIButton alloc] initWithFrame:CGRectMake(20, 88, gtWIDTH - 40, 48)];
        [btnSafe setImage:[UIImage imageNamed:@"safe"] forState:UIControlStateNormal];
        [btnSafe.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btnSafe setTitle:@"智驾科技将始终保证您的隐私安全" forState:UIControlStateNormal];
        [btnSafe setTitleColor:COLOR_TEXT_GARY forState:UIControlStateNormal];
        [cell.contentView addSubview:btnSafe];
        
        [cell.contentView setBackgroundColor:[super colorWithHexString:@"#f3f4f6"]];
    }
    return cell;
}

- (void)btnTypeClicked: (UIButton *)btnState{
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:6];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexpath];
    UIButton  *button1=(UIButton *)[cell viewWithTag:200];
    UIButton  *button2=(UIButton *)[cell viewWithTag:201];
    if (btnState.tag == 200) {
        strState = @"营运";
        [button1 setImage:[UIImage imageNamed:@"chooseSelect"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"chooseNomal"] forState:UIControlStateNormal];
    }else if (btnState.tag == 201){
        strState = @"非营运";
        [button1 setImage:[UIImage imageNamed:@"chooseNomal"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"chooseSelect"] forState:UIControlStateNormal];
    }
}

- (void)datePicker{
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 180, gtWIDTH, 180)];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    UIDatePicker *dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 180)];
    dataPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    dataPicker.datePickerMode = UIDatePickerModeDate;
//    [dataPicker setValue:COLOR_MAIN_GREEN forKey:@"textColor"];
    [viewBg addSubview:dataPicker];
}

- (void)btnSubmit{
    NSString *strCarID ;
    NSString *strCarNo = [(UITextField *)[self.view viewWithTag:302] text];
    NSString *strDrvOwner = [(UITextField *)[self.view viewWithTag:303] text];
    NSString *strVhlFrm = [(UITextField *)[self.view viewWithTag:304] text];
    NSString *strEngNo = [(UITextField *)[self.view viewWithTag:305] text];
    NSString *strFstRegDte = [(UITextField *)[self.view viewWithTag:305] text];
    NSString *strOperating = [(UITextField *)[self.view viewWithTag:305] text];
    NSString *strBrandId = [(UITextField *)[self.view viewWithTag:305] text];
    NSString *strCarSeries = [(UITextField *)[self.view viewWithTag:305] text];
//    NSString *strEngNo = [(UITextField *)[self.view viewWithTag:305] text];
    
//    indexDAL postCarUpdateWithCarID:<#(NSString *)#> carNo:<#(NSString *)#> drvOwner:<#(NSString *)#> vhlFrm:<#(NSString *)#> engNo:<#(NSString *)#> fstRegDte:<#(NSString *)#> operating:<#(NSString *)#> brandId:<#(NSString *)#> carSeries:<#(NSString *)#> img:<#(NSString *)#>
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1) {
        if ([dic objectForKey:@"info"]){
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
