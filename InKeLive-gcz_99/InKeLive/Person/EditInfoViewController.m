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
#import "MBProgressHUD+MJ.h"
#import <AFNetworking.h>
#import "CommonAPIDefines.h"
#import "GTAFNData.h"
@interface EditInfoViewController ()<UITableViewDelegate, UITableViewDataSource,TakePhotoDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GTAFNDataDelegate,signDelegate,EditNameViewControllerDelegate>
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *imgHead;//头像
@property (nonatomic, strong) UITextField *textFieldQQ;
@property (nonatomic, strong) UITextField *textFieldWechat;
@property (nonatomic, strong) NSDictionary *dicData;
@property (nonatomic, strong) UILabel *labName;//昵称
@property (nonatomic, strong) NSString *strSign;//签名
@property (nonatomic, strong) NSString *strSex;//性别
@end

@implementation EditInfoViewController

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _arrayTitle = @[@[@"账号"],@[@"头像",@"昵称",@"个性签名"],@[@"性别",@"QQ",@"微信"]];
        _strSign = @"";
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
    if (kIs_iPhoneX) {
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = RGB(243, 243, 243);
    _tableView.scrollEnabled = NO;
    _tableView.sectionIndexColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"EditInfoTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 134, 13, 100, 14)];
        _labName.text = model.userName;
        _labName.textColor = RGB(110, 110, 110);
        _labName.textAlignment = NSTextAlignmentRight;
        _labName.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:_labName];
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
        if (model.gender == 0) {
            btnFemale.selected = YES;
            btnMale.selected = NO;
            self.strSex = @"0";
        }else{
            btnMale.selected = YES;
            btnFemale.selected = NO;
            self.strSex = @"1";
        }
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
        _textFieldQQ.text = model.qq;
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
        _textFieldWechat.text = model.wechat;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    if (indexPath.section == 1 && indexPath.row == 0) {
        //改头像
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePicker.allowsEditing = YES;
        [[GTAlertTool shareInstance] showSheet:@"修改头像" message:@"" cancelTitle:nil viewController:self confirm:^(NSInteger buttonTag) {
            if (buttonTag == 0) {
                [self selectImageFromCamera];
            }else if (buttonTag == 1){
                [self selectImageFromAlbum];
            }
        } buttonTitles:@"拍摄", @"从手机相册选择", nil];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        //改昵称
        EditNameViewController *editNameVC = [[EditNameViewController alloc] init];
        editNameVC.strOldName = model.userName;
        editNameVC.delegate = self;
        [self.navigationController pushViewController:editNameVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        //个性签名
        SignatureViewController *signatureVC = [[SignatureViewController alloc] init];
        signatureVC.delegate = self;
        signatureVC.strInfo = model.sign;
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

- (void)btnSaveClicked{
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
    
    [data changeUserInfoWithUid:[NSString stringWithFormat:@"%d",model.userID]
                          uNick:_labName.text
                           head:@""
                           sign:_strSign
                         gender:_strSex
                             qq:_textFieldQQ.text
                         wechat:_textFieldWechat.text];
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
    if (btnMale.selected == 1) {
        self.strSex = @"1";
    }else{
        self.strSex = @"0";
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
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [editingInfo objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"found an image");
    [self.imgHead setImage:image];
    
    //保存文件到沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"userheadpic1.png"]];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(image) writeToFile: filePath atomically:YES]; // 保存成功会返回YES
    NSLog(@"save userHeadPic file result:%d", result);
    NSLog(@"file path:%@", filePath);
    
    //文件2
    UIImage* image2 = [DPK_NW_Application scaleImage:image toSize:CGSizeMake(64, 64)];
    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"userheadpic2.png"]];   // 保存文件的名称
    result = [UIImagePNGRepresentation(image2) writeToFile: filePath2 atomically:YES]; // 保存成功会返回YES
    NSLog(@"save userHeadPic2 file result:%d", result);
    NSLog(@"file2 path:%@", filePath2);
    
    
    //上传数据
    //[UIImageJPEGRepresentation(image, 1.0f) writeToFile:[self findUniqueSavePath] atomically:YES];
    //NSData *imageData = UIImageJPEGRepresentation(image, COMPRESSED_RATE);
    //UIImage *compressedImage = [UIImage imageWithData:imageData];
    //[HttpRequestManager uploadImage:compressedImage httpClient:self.httpClient delegate:self];
    
    //测试进度条View
    /*
     UIProgressView* uploadFileProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
     uploadFileProgressView.center = CGPointMake(self.view.center.x, 100);
     uploadFileProgressView.progress = 0;
     uploadFileProgressView.progressTintColor = [UIColor blueColor];
     uploadFileProgressView.trackTintColor = [UIColor grayColor];
     [self.view addSubview:uploadFileProgressView];
     [uploadFileProgressView removeFromSuperview];
     */
    
    //圆形进度条
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithFrame:frame];
    //全屏禁止
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //[self.view addSubview:hud];
    //当前view背景颜色暗下去
    hud.minShowTime= 10000;
    hud.dimBackground =YES;
    hud.labelText = @"更新数据...";
    [hud showAnimated:YES whileExecutingBlock:^{
        //sleep(2);
    } completionBlock:^{
        //[hud removeFromSuperview];
    }];
    
    //用户本地数据
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    
    //上传文件
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    NSString* strUserId = [NSString stringWithFormat:@"%d", userData.userID];
    [parameters setObject:strUserId forKey:@"userid"];
    [parameters setObject:strUserId forKey:@"sessionmask"];
    [parameters setObject:@"PNG" forKey:@"filetype"];
    [parameters setObject:@"" forKey:@"uploadtime"];
    
    //NSDictionary *parameters = @{@"foo": @"bar"};
    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_UploadUserHead];
    
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath isDirectory:NO] name:@"file1" error:nil];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath2 isDirectory:NO] name:@"file2" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSString* errorCode= appDic[@"errCode"];
        NSString* errorMsg = appDic[@"errMsg"];
        NSLog(@" return, errCode=%@, errMsg=%@", errorCode, errorMsg);
        
        NSLog(@"Success: %@", responseObject);
        [hud removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [hud removeFromSuperview];
    }];
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
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_GET_USER_INFO]) {
        if ([data[@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
            model.userID = [dic[@"uId"] intValue];
            model.userName = dic[@"uNick"];
            model.userBigHeadPic = dic[@"Head"];
            model.userSmallHeadPic = dic[@"Head"];
            model.gender = [dic[@"Gender"] intValue];
            model.sign = dic[@"Sign"];
            model.qq = dic[@"QQ"];
            model.wechat = dic[@"WeChat"];
            [self.tableView reloadData];
        }else{
            NSLog(@"msg == %@",data[@"msg"]);
        }
    }else if ([cmd isEqualToString:CMD_CHANGE_USER_INFO]){
        if ([data[@"code"] intValue] == 0) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
            model.userName = dict[@"uNick"];
            model.userBigHeadPic = dict[@"Head"];
            model.userSmallHeadPic = dict[@"Head"];
            model.gender = [dict[@"Gender"] intValue];
            model.sign = dict[@"Sign"];
            model.qq = dict[@"QQ"];
            model.wechat = dict[@"WeChat"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showAlertMessage:data[@"msg"]];
        }
    }
}

#pragma mark signDelegate
- (void)addItemViewController:(UIViewController *)controller didFinishEnteringItem:(NSString *)item{
    self.strSign = item;
}

#pragma mark EditNameViewControllerDelegate
- (void)addNameViewController:(UIViewController *)controller didFinishEnteringName:(NSString *)Name{
    _labName.text = Name;
}
@end
