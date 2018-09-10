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
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditInfoViewController ()<UITableViewDelegate, UITableViewDataSource,TakePhotoDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *imgHead;//头像
@property (nonatomic, strong) UITextField *textFieldQQ;
@property (nonatomic, strong) UITextField *textFieldWechat;
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
        _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 5, 40, 40)];
        _imgHead.layer.cornerRadius = 20;
        _imgHead.layer.masksToBounds = YES;
        NSString *str = model.userBigHeadPic;
        [_imgHead sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"]];
        [cell.contentView addSubview:_imgHead];
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
        [btnMale addTarget:self action:@selector(btnSexClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnMale.titleLabel.font = [UIFont systemFontOfSize:14];
        btnMale.tag = 301;
        [cell.contentView addSubview:btnMale];
        
        UIButton *btnFemale= [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+60, 0, 40, 40)];
        [btnFemale setTitle:@"女" forState:UIControlStateNormal];
        [btnFemale setTitleColor:RGB(110, 110, 110) forState:UIControlStateNormal];
        [btnFemale setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btnFemale addTarget:self action:@selector(btnSexClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnFemale.titleLabel.font = [UIFont systemFontOfSize:14];
        btnFemale.tag = 302;
        [cell.contentView addSubview:btnFemale];
        
        btnGo.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        _textFieldQQ = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+13, 10, SCREEN_WIDTH/3*2 - 20, 30)];
//        textField.text =
        _textFieldQQ.placeholder = @"请输入QQ号";
        _textFieldQQ.textColor = RGB(110, 110, 110);
        _textFieldQQ.font = [UIFont systemFontOfSize:14];
        _textFieldQQ.textAlignment = NSTextAlignmentLeft;
        _textFieldQQ.delegate = self;
        _textFieldQQ.tag = 401;
        _textFieldQQ.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:_textFieldQQ];
        btnGo.hidden = YES;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        _textFieldWechat = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+13, 10, SCREEN_WIDTH/3*2 - 20, 30)];
        //        textField.text =
        _textFieldWechat.placeholder = @"请输入微信号";
        _textFieldWechat.textColor = RGB(110, 110, 110);
        _textFieldWechat.font = [UIFont systemFontOfSize:14];
        _textFieldWechat.textAlignment = NSTextAlignmentLeft;
        _textFieldWechat.delegate = self;
        _textFieldWechat.tag = 402;
        _textFieldWechat.keyboardType = UIKeyboardTypeDefault;
        [cell.contentView addSubview:_textFieldWechat];
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
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePicker.allowsEditing = YES;
        [[GTAlertTool shareInstance] showAlert:@"" message:@"" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
            if (buttonTag == 0) {
                [self selectImageFromCamera];
            }else if (buttonTag == 1){
                [self selectImageFromAlbum];
            }
        } buttonTitles:@"拍摄", @"从手机相册选择", nil];
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

- (void)btnSexClicked: (UIButton *)button{
    UIButton *btnMale = (UIButton *)[self.view viewWithTag:301];
    UIButton *btnFemale = (UIButton *)[self.view viewWithTag:302];
    if (button.tag == 301) {
        btnMale.selected = YES;
        btnFemale.selected = NO;
    }else{
        btnMale.selected = NO;
        btnFemale.selected = YES;
    }
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePicker.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        self.imgHead.image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        NSData *fileData = UIImageJPEGRepresentation(self.imgHead.image, 1.0);
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(self.imgHead.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //上传图片
//        [self uploadImageWithData:fileData];
        
    }else{
//        //如果是视频
//        NSURL *url = info[UIImagePickerControllerMediaURL];
//        //播放视频
//        _moviePlayer.contentURL = url;
//        [_moviePlayer play];
//        //保存视频至相册（异步线程）
//        NSString *urlStr = [url path];
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//        });
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
//        //视频上传
////        [self uploadVideoWithData:videoData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

//#pragma mark 视频保存完毕的回调
//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
//    if (error) {
//        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
//    }else{
//        NSLog(@"视频保存成功.");
//    }
//}

@end
