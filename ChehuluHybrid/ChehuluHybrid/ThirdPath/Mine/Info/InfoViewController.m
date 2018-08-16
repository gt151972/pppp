//
//  InfoViewController.m
//  ChehuluHybrid
//
//  Created by GT mac on 16/8/8.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "InfoViewController.h"
#import "NameViewController.h"
#import "SexViewController.h"
#import "CommonAddressViewController.h"

@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate>{
    UIImageView *imageHead;
    NSString *strName;
    NSArray *arrayPro;
    NSArray *arrayProID;
    NSArray *arrayCity;
    int sex;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation InfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [super navigationTypeWhite:@"个人资料"];
    indexDAL = [[IndexRequestDAL alloc] init];
    indexDAL.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH,246) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InfoTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self pickPhoto:0];
        }];
        UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self pickPhoto:1];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:takePhotoAction];
        [alertController addAction:chooseAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 1){
        NameViewController *nameVC = [[NameViewController alloc] init];
        nameVC.strName = strName;
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if (indexPath.row == 2){
        SexViewController *sexVC = [[SexViewController alloc] init];
        sexVC.sex = sex;
        [self.navigationController pushViewController:sexVC animated:YES];
    }else if (indexPath.row == 4){
        [indexDAL getProvinceWithSearchType:@"2" gpsProvince:[gtLocation objectForKey:@"State"]];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (!cell) {
    }
    NSArray *arrTitle = @[@"头像", @"姓名", @"性别", @"手机号", @"常出没地"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.textColor = COLOR_TEXT_GARY;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if (indexPath.row == 0) {
        UIImage *imgHead = [super getImageWithName:@"head"];
        imageHead = [[UIImageView alloc] initWithImage:imgHead];
        imageHead.layer.masksToBounds = YES;
        imageHead.layer.cornerRadius = 25;
        [cell.contentView addSubview:imageHead];
        [imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(-5);
        }];
    }else if (indexPath.row == 1){
        if (![[gtDicMyInfo objectForKey:@"realname"] isEqualToString:@""]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[gtDicMyInfo objectForKey:@"realname"]];
        }else if (![[gtDicMyInfo objectForKey:@"nickname"] isEqualToString:@""]){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[gtDicMyInfo objectForKey:@"nickname"]];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[gtUserInfo objectForKey:@"mobile"]];
        }
        strName = cell.detailTextLabel.text;
    }else if (indexPath.row == 2){
        NSString *strSex = [NSString stringWithFormat:@"%@",[gtDicMyInfo objectForKey:@"sex"]];
        sex = [strSex intValue];
        if ([strSex isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"女";
        }else{
            cell.detailTextLabel.text = @"男";
        }
    }else if (indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[gtUserInfo objectForKey:@"mobile"]];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[gtDicArea objectForKey:@"area_name"]];
    }
    return cell;
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //如果是第一列
    if (component == 0) {
        //返回姓名数组的个数
        return arrayPro.count;
    }
    else
    {
        //返回表情数组的个数
        return arrayCity.count;
    }
    
}

#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return gtWIDTH/2;
    }
    else
    {
        return gtWIDTH/2;
    }
    
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0) {
        return 60;
    }
    else
    {
        return 60;
    }
}
//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return arrayPro[row];
    }
    else
    {
        return arrayCity[row];
    }
}



//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSLog(@"%@",arrayPro[row]);
        [_pickerView selectedRowInComponent:0];
        [indexDAL getAreaWithSeachType:@"2" gpsArea:arrayProID[row]];
        NSLog(@"arrayPro[row] == %@",arrayProID[row]);
    }
    else
    {
        NSLog(@"%@",arrayCity[row]);
    }
}


- (void)pickPhoto:(int)type{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (type) {
            case 0:
                //来源:相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                //来源:相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [super imageByScalingToMaxSize:image];
    [imageHead setImage:image];
    [indexDAL uploadimgWithPicture:[super image2DataURL:image]];
    
}

- (void)InfoCallBackDic:(NSMutableDictionary *)dic :(NSString *)cmd{
    NSLog(@"dic == %@",dic);
    NSLog(@"cmd == %@",cmd);
    if ([[dic objectForKey:@"status"] intValue] == 1){
        if ([cmd isEqualToString:@"Uploadimg"]) {
            [indexDAL updateWithHeadImgID:[[dic objectForKey:@"info"] objectForKey:@"id"] sex:nil realname:nil];
        }else if ([cmd isEqualToString:@"Update"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:alertSure];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if ([cmd isEqualToString:@"GetProvince"]){
            NSArray *array = [dic objectForKey:@"info"];
            NSMutableArray *arrPro = [[NSMutableArray alloc] init];
            NSMutableArray *arrProID = [[NSMutableArray alloc] init];
            for (int index = 0; index < [array count]; index ++) {
                [arrPro addObject:[[array objectAtIndex:index] objectForKey:@"province_name"]];
                [arrProID addObject:[[array objectAtIndex:index] objectForKey:@"province_id"]];
            }
            arrayPro = [[NSArray alloc] initWithArray:arrPro];
            arrayProID = [[NSArray alloc] initWithArray:arrProID];
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[arrayProID objectAtIndex:1]]);
            [indexDAL getAreaWithSeachType:@"2" gpsArea:[NSString stringWithFormat:@"%@",[arrayProID objectAtIndex:2]]];
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, gtHEIGHT - 300, gtWIDTH, 300)];
            _pickerView.delegate = self;
            _pickerView.dataSource = self;
            _pickerView.showsSelectionIndicator = YES;
            [self.view addSubview:_pickerView];
        }else if ([cmd isEqualToString:@"GetArea"]){
            NSLog(@"dic == %@",dic);
            NSLog(@"cmd == %@",cmd);
            NSArray *array = [dic objectForKey:@"info"];
            NSMutableArray *arrCity = [[NSMutableArray alloc] init];
            for (int index = 1; index < [array count]; index ++) {
                [arrCity addObject:[[array objectAtIndex:index] objectForKey:@"area_name"]];
            }
            arrayCity = [[NSArray alloc] initWithArray:arrCity];
            NSLog(@"arrayCity == %@",arrayCity);
            //重新加载指定列的数据
            [_pickerView reloadComponent:1];
        }
    }
}

#pragma Mark -- 地址选择器
- (void)AddressPicker{
    UIAlertController *addressController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:addressController animated:YES completion:nil];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancel)];
    [barItems addObject:cancelItem];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pickerSubmit)];
    [barItems addObject:submitItem];
}

#pragma mark -- Action
- (void)pickerCancel{
    
}

- (void)pickerSubmit{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
