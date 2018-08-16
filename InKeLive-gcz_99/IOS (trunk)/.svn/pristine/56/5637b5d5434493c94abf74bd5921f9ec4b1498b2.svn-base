//
//  PersonViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "PersonViewController.h"
#import "LogonViewController.h"
#import "BaseViewController.h"

#import "AppDelegate.h"

#import "DPK_NW_Application.h"
#import "CommonAPIDefines.h"

#import "MBProgressHUD.h"
#import "AFNetworking.h"

#import "UIButton+WebCache.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    //self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.personTableView];
    
    
    
    //注册通知(要求刷新)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBReloadData) name:@"hzmsg_reload_me_data" object:nil];
    //使用方式
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"hzmsg_reload_me_data" object:nil];
    
}

-(void)CBReloadData {
    if(self.personTableView !=nil) {
        [self.personTableView reloadData];
    }
}

#pragma UITableViewDelegate UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //第一个sectionHeadView, 后面的没有
    if (section == 0) {
        //return self.personHeadView;
        //设置数据
        BOOL bLogon = [DPK_NW_Application sharedInstance].isLogon;
        LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
        if(!bLogon) {
            self.personHeadView2.btnUserHead.hidden = YES;
            self.personHeadView2.lblUserAlias.hidden = YES;
            self.personHeadView2.lblUserID.hidden = YES;
            self.personHeadView2.btnLogon.hidden =NO;
        }
        else {
            self.personHeadView2.btnUserHead.hidden = NO;
            self.personHeadView2.lblUserAlias.hidden = NO;
            self.personHeadView2.lblUserID.hidden =NO;
            self.personHeadView2.btnLogon.hidden = YES;
            
            [self.personHeadView2.btnUserHead sd_setBackgroundImageWithURL:[NSURL URLWithString:userData.userBigHeadPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
            [self.personHeadView2.btnUserHead sd_setBackgroundImageWithURL:[NSURL URLWithString:userData.userBigHeadPic] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"default_head"]];
            
            self.personHeadView2.lblUserAlias.text = userData.userName;
            NSString* strUserId = [NSString stringWithFormat:@"用户号 %d", userData.userID];
            self.personHeadView2.lblUserID.text = strUserId;
        }
        
        return self.personHeadView2;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        //return SCREEN_HEIGHT/2;   //高度去掉屏幕一半?
        return 180;
    }
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //if (section == 2) {
    //    return 0.1;
    //}
    if(section == 4) {
        return 44 + 30;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //灰色间距矩形?
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    //view.backgroundColor = RGB(245, 251, 251);
    view.backgroundColor = RGB(246, 246, 246);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"personCenterCellId";
    //标准cell?
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        //创建一个标准Cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    cell.imageView.image = [UIImage imageNamed:@"home_contribute"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;   //选中方式
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    
    // [cell.contentView addSubview:label];   //还可以增加更多的View
    return cell;
}

/**
-(BOOL)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
**/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 4) {
        if(indexPath.row == 0) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate logout];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //滚动到顶部
                [self.personTableView setContentOffset:CGPointZero animated:YES];
            });
           
        }
    }
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    (self.personTableView.contentOffset.y > 0) ? (self.personTableView.backgroundView.hidden = YES):(self.personTableView.backgroundView.hidden = NO);
}


#pragma 加载
- (UITableView *)personTableView{
    if (!_personTableView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //分组方式的UITableView
        _personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        _personTableView.delegate = self;
        _personTableView.dataSource = self;
        _personTableView.showsVerticalScrollIndicator = NO;
        _personTableView.rowHeight = 50;   //这是cell的高度(70)吗?
        _personTableView.separatorColor = RGBA(0, 0, 0, 0.1);
        
        //backView下拉
        UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
        //backView.backgroundColor = RGB(36, 215, 200); //这个下拉的背景就是 HeadView的背景色??
        backView.backgroundColor = RGB(204, 204, 204); //这个下拉的背景就是 HeadView的背景色??
        _personTableView.backgroundView = backView;  //设置为背景图??
        
        [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        //分割线的间距
        //[[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
        //[[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
        
        if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
            [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
        }
    }
    return _personTableView;
}

#if 0
- (PersonHeadView *)personHeadView{
    if (!_personHeadView) {
        //头 视图
        _personHeadView = [[[NSBundle mainBundle]loadNibNamed:@"PersonHeadView" owner:self options:nil]lastObject];
    }
    return _personHeadView;
}
#endif

-(PersonHeadView2*)personHeadView2 {
    if(!_personHeadView2) {
        _personHeadView2 = [[[NSBundle mainBundle]loadNibNamed:@"PersonHeadView2" owner:self options:nil]lastObject];
    }
    //默认头像,不使用,会在reloadData时覆盖
    //UIImage* img = [UIImage imageNamed:@"head_default01"];
    //[_personHeadView2.btnUserHead setBackgroundImage:img forState:UIControlStateNormal];
    //[_personHeadView2.btnUserHead setBackgroundImage:img forState:UIControlStateSelected];
    
    [_personHeadView2.btnUserHead addTarget:self action:@selector(userHeadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_personHeadView2.btnLogon addTarget:self action:@selector(logonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _personHeadView2;
}

- (NSArray *)titleArr{
    if (!_titleArr) {
        //_titleArr = @[@[],@[@"映票贡献榜"],@[@"短视频",@"收益",@"账户"],@[@"等级",@"实名制"],@[@"设置"]];
        _titleArr = @[@[],@[@"映票贡献榜"],@[@"短视频",@"收益",@"账户"],@[@"等级",@"实名制"],@[@"注销登出"]];
    }
    return _titleArr;
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
#if 0
    if([self.personTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.personTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.personTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.personTableView setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

-(void)logonButtonClick
{
    //用户登录窗口
    LogonViewController* logonVC =[[LogonViewController alloc] init];
    BaseViewController* naviVC = [[BaseViewController alloc]initWithRootViewController:logonVC];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:nil];
}

-(void)userHeadButtonClick
{
    UIActionSheet* sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}

#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch(buttonIndex)
            {
            case 0:
                return;
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
        }
        else {
            if(buttonIndex == 0)
                return;
            else
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSLog(@"found an image");
    [self.personHeadView2.btnUserHead setBackgroundImage:image forState:UIControlStateNormal];
    [self.personHeadView2.btnUserHead setBackgroundImage:image forState:UIControlStateSelected];
    
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    NSString* strUserId = [NSString stringWithFormat:@"%d", userData.userID];
    [parameters setObject:strUserId forKey:@"userid"];
    [parameters setObject:strUserId forKey:@"sessionmask"];
    [parameters setObject:@"PNG" forKey:@"filetype"];
    [parameters setObject:@"" forKey:@"uploadtime"];
    
    //NSDictionary *parameters = @{@"foo": @"bar"};
    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_UploadUserHead];
    
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileURL:filePathURL name:@"image" error:nil];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath isDirectory:NO] name:@"file1" error:nil];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath2 isDirectory:NO] name:@"file2" error:nil];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSString* errorCode= appDic[@"errCode"];
        NSString* errorMsg = appDic[@"errMsg"];
        NSLog(@" return, errCode=%@, errMsg=%@", errorCode, errorMsg);
        
        NSLog(@"Success: %@", responseObject);
        [hud removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [hud removeFromSuperview];
    }];
    
    
}

-(void)myProgressTask {
    //do nothing
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
