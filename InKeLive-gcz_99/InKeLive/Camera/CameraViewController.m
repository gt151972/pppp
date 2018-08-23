//
//  CameraViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//主播端

#import "CameraViewController.h"
#import "ASHUD.h"

#import "LZBRecordVideoTool.h"
#import "LiveViewController.h"

#import "MBProgressHUD+MJ.h"
#import "DPK_NW_Application.h"
#import "CommonAPIDefines.h"
#import <AFNetworking.h>

#import "WBRadioGroup.h"

@interface CameraViewController ()< UIAlertViewDelegate >
{
    UIAlertView *alertView;
    WBRadioGroup* _roomStyleRadioBtnGroup;   //房间类型单选按钮组
}

@property(nonatomic, assign) BOOL isLogining;
@property(nonatomic, strong) MBProgressHUD* hud;  //提示框

//@property (nonatomic,strong)RTMPCHosterKit *hosterKit;
//随机12字符
@property (nonatomic, strong) NSString *randomStr;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, assign) BOOL cameraIsFront;

//前置/后置 按钮
@property (nonatomic, strong) UIButton *cameraButton;
//美颜 按钮
@property (nonatomic, strong) UIButton *beautyButton;
//关闭 按钮
@property (nonatomic, strong) UIButton *closeButton;
//开始直播 按钮
@property (nonatomic, strong)UIButton *startButton;
//输入信息背景面板
@property (nonatomic, strong)UIView *inputBackView;
//房间标题
@property (nonatomic, strong)UITextField *roomNameEdit;
//房间标题提示
@property (nonatomic, strong)UILabel * roomNameTipLabel;
//单选按钮
@property (nonatomic, strong)WBCheckButton* roomStyle1Button;
//单选按钮
@property (nonatomic, strong)WBCheckButton* roomStyle2Button;
//单选按钮
@property (nonatomic, strong)WBCheckButton* roomStyle3Button;
//单选按钮
@property (nonatomic, strong)WBCheckButton* roomStyle4Button;
//收费价格输入框
@property (nonatomic, strong)UITextField* roomPrice1Edit;
//收费价格输入框2
@property (nonatomic, strong)UITextField* roomPrice2Edit;
//房间密码设置
@property (nonatomic, strong)UITextField* roomPwdEdit;

//相机拍摄预览图层
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) LZBRecordVideoTool *videoTool;

@end

@implementation CameraViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _roomStyleRadioBtnGroup = [[WBRadioGroup alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    [self setupCaptureSession];
}

- (void)creatUI{
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.inputBackView];
    [self.topView addSubview:self.startButton];
    [self.topView addSubview:self.cameraButton];
    [self.topView addSubview:self.beautyButton];
    [self.topView addSubview:self.closeButton];
    self.inputBackView.hidden = YES;
    
    //
    [self.inputBackView addSubview:self.roomNameTipLabel];
    [self.inputBackView addSubview:self.roomNameEdit];
    //
    [self.inputBackView addSubview:self.roomStyle1Button];
    [self.inputBackView addSubview:self.roomStyle2Button];
    [self.inputBackView addSubview:self.roomStyle3Button];
    [self.inputBackView addSubview:self.roomStyle4Button];
    [self.inputBackView addSubview:self.roomPrice1Edit];
    [self.inputBackView addSubview:self.roomPrice2Edit];
    [self.inputBackView addSubview:self.roomPwdEdit];
    //
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingText)];
    //tap.cancelsTouchesInView =NO;
    //[self.view addGestureRecognizer:tap];

}

-(void)endEditingText
{
    [self.roomNameEdit resignFirstResponder];
    [self.roomPrice1Edit resignFirstResponder];
    [self.roomPrice2Edit resignFirstResponder];
    [self.roomPwdEdit resignFirstResponder];
}

#pragma UIAlertViewDelegate 连麦请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
#if 0
    if (buttonIndex == 1) {
        if (self.hosterKit && self.requestId) {
            BOOL isScuess = [self.hosterKit AcceptRTCLine:self.requestId];
            if (!isScuess) {
                [ASHUD showHUDWithCompleteStyleInView:self.view content:@"连麦人数已满" icon:nil];
                [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
            }
        }
    }else{
        if (self.hosterKit && self.requestId) {
            [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
        }
    }
    self.requestId = nil;
#endif
}

-(void)setupCaptureSession {
    self.captureVideoPreviewLayer  =  [self.videoTool previewLayer];
    CALayer *layer=self.containerView.layer;
    layer.masksToBounds=YES;
    self.captureVideoPreviewLayer.frame = layer.bounds;
    [layer addSublayer:self.captureVideoPreviewLayer];
    //默认是前置摄像头
    self.cameraIsFront =YES;
    //开启录制功能
    [self.videoTool changeCameraInputDeviceisFront:YES];  //默认使用,使用前置摄像头
    [self.videoTool startRecordFunction];
    
}

-(void)endRecordingVideo {
    [self.videoTool stopCapture];
    [self.videoTool stopRecordFunction];
    [self.captureVideoPreviewLayer removeFromSuperlayer];
}


#pragma 按钮点击事件
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 200: //美颜
            sender.selected = !sender.selected;
            break;
        case 201: //相机切换
            sender.selected = !sender.selected;
            if(sender.selected) {
                self.cameraIsFront = YES;
                [self.videoTool changeCameraInputDeviceisFront:YES];
            }
            else {
                self.cameraIsFront = NO;
                [self.videoTool changeCameraInputDeviceisFront:NO];
            }
            break;
        case 202: //关闭
        {
            [self close:NO];
        }
            break;
        case 203: //开始按钮
        {
            //self.randomStr = [self randomString:12];
            //[self sendQueryVCBServerRequest];
            //直接使用用户的信息数据开始(进入归属房间上手机私麦)
            [self close:YES];
        }
            break;
        default:
            break;
    }
}


- (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}

-(UIView*)topView {
    if(_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:self.view.bounds];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _topView;
}


-(UIView*)containerView {
    if(_containerView == nil) {
        _containerView = [[UIView alloc]initWithFrame:self.view.bounds];
        _containerView.backgroundColor = [UIColor greenColor];
    }
    return _containerView;
    
}

- (UIButton*)closeButton {
    if(!_closeButton) {
        //关闭按钮
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-50, 30,40,40);
        _closeButton.tag = 202;
    }
    return _closeButton;
}

- (UIButton*)cameraButton {
    if (!_cameraButton) {
        //相机前后切换按钮
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame)-50, 30,40,40);
        _cameraButton.selected = YES;  //这里默认选中,使用前置摄像头
        _cameraButton.tag = 201;
    }
    return _cameraButton;
}

- (UIButton*)beautyButton {
    //美颜 选择按钮(状态切换)
    if (!_beautyButton) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateSelected];
        [_beautyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _beautyButton.tag = 200;
        [_beautyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _beautyButton.frame = CGRectMake(CGRectGetMinX(self.cameraButton.frame)-50, 30,40,40);
    }
    return _beautyButton;
}

- (UIButton *)startButton{
    //圆角的开始按钮
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = RGB(36, 216, 200);
        _startButton.layer.cornerRadius = 25;
        _startButton.clipsToBounds = YES;
        [_startButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startButton.tag = 203;
        [_startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //_startButton.frame = CGRectMake(20, self.view.centerY, SCREEN_WIDTH - 40, 50);
        _startButton.frame = CGRectMake(20, self.view.centerY-80, SCREEN_WIDTH - 40, 50);
    }
    return _startButton;
}

-(UIView *)inputBackView {
    //输入背景面板
    if(!_inputBackView) {
        _inputBackView= [[UIView alloc]init ];
        _inputBackView.backgroundColor = RGBA(0, 0, 0, 0.5f);
        _inputBackView.frame = CGRectMake(20, 80, SCREEN_WIDTH -40, self.view.centerY - 80 - 10);
    }
    return _inputBackView;
}


-(UILabel*)roomNameTipLabel {
    //房间标题提示
    if(!_roomNameTipLabel) {
        _roomNameTipLabel = [[UILabel alloc] init ];
        _roomNameTipLabel.frame = CGRectMake(10, 10, 80, 30);
        _roomNameTipLabel.font = [UIFont systemFontOfSize:14];
        _roomNameTipLabel.textColor = [UIColor whiteColor];
        _roomNameTipLabel.text= @"房间标题:";
    }
    return _roomNameTipLabel;
}

-(UITextField*)roomNameEdit {
    //房间标题编辑
    if(!_roomNameEdit) {
        _roomNameEdit = [[UITextField alloc] init];
        _roomNameEdit.frame = CGRectMake(80, 10, SCREEN_WIDTH -80 -40 -10, 30);
        _roomNameEdit.borderStyle =UITextBorderStyleNone;
        _roomNameEdit.textColor = [UIColor whiteColor];
        _roomNameEdit.font = [UIFont systemFontOfSize:14];
        _roomNameEdit.tintColor = [UIColor lightGrayColor];
        
        _roomNameEdit.layer.borderColor = [UIColor whiteColor].CGColor; // set color as you want.
        _roomNameEdit.layer.borderWidth = 1.0; // set borderWidth as you want.
        
        //左边空一点
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _roomNameEdit.leftView = paddingView;
        _roomNameEdit.leftViewMode = UITextFieldViewModeAlways;
        
        if([_roomNameEdit respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            UIColor* color =[UIColor lightGrayColor];
            _roomNameEdit.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"请输入房间标题" attributes:@{NSForegroundColorAttributeName: color}];
        }else{
            NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
            // TODO: Add fall-back code to set placeholder color.
        }
    }
    return _roomNameEdit;
}

-(WBCheckButton*)roomStyle1Button {
    //房间类型单选按钮
    if( !_roomStyle1Button) {
        _roomStyle1Button=[[ WBCheckButton alloc] initWithFrame:CGRectMake(20,45,SCREEN_WIDTH -20 -40 -10, 32)];
        //_roomStyle1Button.backgroundColor = RGB(255, 0, 0);
        _roomStyle1Button.label.textColor = [UIColor whiteColor];
        _roomStyle1Button.label.text =@"免费直播";
        _roomStyle1Button.style = WBCheckButtonStyleRadio;
        [_roomStyle1Button setChecked:YES];
        [_roomStyleRadioBtnGroup add:_roomStyle1Button];
    }
    return _roomStyle1Button;
}

-(WBCheckButton*)roomStyle2Button {
    //房间类型单选按钮
    if( !_roomStyle2Button) {
        _roomStyle2Button=[[ WBCheckButton alloc] initWithFrame:CGRectMake(20,80,SCREEN_WIDTH -20 -40 -10, 32)];
        //_roomStyle1Button.backgroundColor = RGB(255, 0, 0);
        _roomStyle2Button.label.textColor = [UIColor whiteColor];
        _roomStyle2Button.label.text =@"按次收费";
        _roomStyle2Button.style = WBCheckButtonStyleRadio;
        [_roomStyleRadioBtnGroup add:_roomStyle2Button];
    }
    return _roomStyle2Button;
}

-(WBCheckButton*)roomStyle3Button {
    //房间类型单选按钮
    if( !_roomStyle3Button) {
        _roomStyle3Button=[[ WBCheckButton alloc] initWithFrame:CGRectMake(20,115,SCREEN_WIDTH -20 -40 -10, 32)];
        //_roomStyle1Button.backgroundColor = RGB(255, 0, 0);
        _roomStyle3Button.label.textColor = [UIColor whiteColor];
        _roomStyle3Button.label.text =@"按分钟收费";
        _roomStyle3Button.style = WBCheckButtonStyleRadio;
        [_roomStyleRadioBtnGroup add:_roomStyle3Button];
    }
    return _roomStyle3Button;
}


-(WBCheckButton*)roomStyle4Button {
    //房间类型单选按钮
    if( !_roomStyle4Button) {
        _roomStyle4Button=[[ WBCheckButton alloc] initWithFrame:CGRectMake(20,150,SCREEN_WIDTH -20 -40 -10, 32)];
        //_roomStyle1Button.backgroundColor = RGB(255, 0, 0);
        _roomStyle4Button.label.textColor = [UIColor whiteColor];
        _roomStyle4Button.label.text =@"加密直播";
        _roomStyle4Button.style = WBCheckButtonStyleRadio;
        [_roomStyleRadioBtnGroup add:_roomStyle4Button];
    }
    return _roomStyle4Button;
}

-(UITextField*)roomPrice1Edit {
    //房间价格输入框1
    if(!_roomPrice1Edit) {
        _roomPrice1Edit = [[UITextField alloc] init];
        _roomPrice1Edit.frame = CGRectMake(140, 81, SCREEN_WIDTH -140 -40 -10, 30);
        _roomPrice1Edit.borderStyle =UITextBorderStyleNone;
        _roomPrice1Edit.textColor = [UIColor whiteColor];
        _roomPrice1Edit.font = [UIFont systemFontOfSize:14];
        _roomPrice1Edit.tintColor = [UIColor lightGrayColor];
        //边框
        _roomPrice1Edit.layer.borderColor = [UIColor whiteColor].CGColor; // set color as you want.
        _roomPrice1Edit.layer.borderWidth = 1.0; // set borderWidth as you want.
        //左边空一点
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _roomPrice1Edit.leftView = paddingView;
        _roomPrice1Edit.leftViewMode = UITextFieldViewModeAlways;
    }
    return _roomPrice1Edit;
}

-(UITextField*)roomPrice2Edit {
    //房间价格输入框2
    if(!_roomPrice2Edit) {
        _roomPrice2Edit = [[UITextField alloc] init];
        _roomPrice2Edit.frame = CGRectMake(140, 116, SCREEN_WIDTH -140 -40 -10, 30);
        _roomPrice2Edit.borderStyle =UITextBorderStyleNone;
        _roomPrice2Edit.textColor = [UIColor whiteColor];
        _roomPrice2Edit.font = [UIFont systemFontOfSize:14];
        _roomPrice2Edit.tintColor = [UIColor lightGrayColor];
        //边框
        _roomPrice2Edit.layer.borderColor = [UIColor whiteColor].CGColor; // set color as you want.
        _roomPrice2Edit.layer.borderWidth = 1.0; // set borderWidth as you want.
        //左边空一点
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _roomPrice2Edit.leftView = paddingView;
        _roomPrice2Edit.leftViewMode = UITextFieldViewModeAlways;
    }
    return _roomPrice2Edit;
}

-(UITextField*)roomPwdEdit {
    //房间密码
    if(!_roomPwdEdit) {
        _roomPwdEdit = [[UITextField alloc] init];
        _roomPwdEdit.frame = CGRectMake(140, 151, SCREEN_WIDTH -140 -40 -10, 30);
        _roomPwdEdit.borderStyle =UITextBorderStyleNone;
        _roomPwdEdit.textColor = [UIColor whiteColor];
        _roomPwdEdit.font = [UIFont systemFontOfSize:14];
        _roomPwdEdit.tintColor = [UIColor lightGrayColor];
        //边框
        _roomPwdEdit.layer.borderColor = [UIColor whiteColor].CGColor; // set color as you want.
        _roomPwdEdit.layer.borderWidth = 1.0; // set borderWidth as you want.
        //左边空一点
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _roomPwdEdit.leftView = paddingView;
        _roomPwdEdit.leftViewMode = UITextFieldViewModeAlways;
    }
    return _roomPwdEdit;
}


-(LZBRecordVideoTool*) videoTool {
    if(_videoTool == nil) {
        _videoTool = [[LZBRecordVideoTool alloc]init];
    }
    return _videoTool;
}


- (void)viewWillAppear:(BOOL)animated {
   // [super viewWillAppear:<#animated#>];
    
#if 0
    //由小变大的圆形动画
    CGFloat radius = [UIScreen mainScreen].bounds.size.height;
    UIBezierPath *startMask =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.centerX, self.view.centerY, 0, 0)];
    UIBezierPath *endMask = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(self.view.centerX, self.view.centerY, 0, 0), -radius, -radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endMask.CGPath;
    maskLayer.backgroundColor = (__bridge CGColorRef)([UIColor whiteColor]);
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startMask.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endMask.CGPath));
    maskLayerAnimation.duration = 0.8f;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    self.view.layer.mask = maskLayer;
#endif
}

-(void)showLoadingHud {
    //======================
    //圆形进度条
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.hud = [[MBProgressHUD alloc]initWithFrame:frame];
    //全屏禁止
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    //[self.view addSubview:hud];
    //当前view背景颜色暗下去
    self.hud.minShowTime= 10000;
    self.hud.dimBackground =YES;
    self.hud.labelText = @"正在连接...";
    [self.hud showAnimated:YES whileExecutingBlock:^{
        //sleep(2);
    } completionBlock:^{
        //[hud removeFromSuperview];
    }];
    //=====================
}

-(void)hideLoadingHud {
    [self.hud removeFromSuperview];
}

-(void)close:(BOOL)createFlag {
    //新的关闭方式
    [self endRecordingVideo];
    [self.view removeFromSuperview];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.createCameraVC = nil;
    if(createFlag) {
        [appDelegate showLiveRoom:YES CameraFront:self.cameraIsFront];
    }
    
#if 0 //异步的方式
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showLiveRoom:YES CameraFront:self.cameraIsFront];
    });
#endif
}

-(void)sendQueryVCBServerRequest {
    if(self.isLogining) return;
    
    self.isLogining  =YES;
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    NSString* strUserId = [NSString stringWithFormat:@"%d", userData.userID];
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:strUserId forKey:@"userid"];
    [self showLoadingHud];
    WEAKSELF;
    NSString* strAPIUrl = [NSString stringWithFormat:@"%@%@",[DPK_NW_Application sharedInstance].clientConfigParam.commonApiPrefix, URL_QueryVCBServer];
    [manager POST:strAPIUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"CameraViewController Success: %@", responseObject);
        if(weakSelf !=nil)
            [weakSelf onAPI_QueryVCBServerRequest_Success:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"CameraViewController Error: %@", error);
        if(weakSelf !=nil)
            [weakSelf onAPI_QueryVCBServerRequest_Failed];
    }];
}


-(void)onAPI_QueryVCBServerRequest_Success:(id)responseObject {
    NSDictionary *appDic =(NSDictionary*)responseObject;
    NSString* errorCode= appDic[@"errorCode"];
    NSString* errorMsg = appDic[@"errorMsg"];
    //先移除,后面可能还会弹出
    [self hideLoadingHud];
    self.isLogining = NO;
    
    NSLog(@" return, errCode=%@, errMsg=%@", errorCode, errorMsg);
    if(![errorCode isEqualToString:@"0"]) {
        [MBProgressHUD showError:errorMsg];
    }
    else {
        //请求成功,保存数据
        TempQueryVCBSvrInfo* tempData = [DPK_NW_Application sharedInstance].tmpQueryVCBSvrInfo;
        tempData.serverId =[appDic[@"serverid"] intValue];
        tempData.serverAddr=appDic[@"serverip"];
        tempData.serverPort = [appDic[@"serverport"] intValue];
        tempData.roomId = [appDic[@"roomid"] intValue];
        tempData.roomGateAddr = appDic[@"gateaddr"];
        tempData.userCount0 =[appDic[@"usercount0"] intValue];
        tempData.userCount1 =[appDic[@"usercount1"] intValue];
        tempData.roomCount0 = [appDic[@"roomcount0"] intValue];
        tempData.roomCount1 = [appDic[@"roomcount1"] intValue];
        //转换为创建房间数据保存
        TempCreateRoomInfo* createRoomInfo = [DPK_NW_Application sharedInstance].tempCreateRoomInfo;
        createRoomInfo.roomId = tempData.roomId;
        createRoomInfo.creatorId = 0;
        createRoomInfo.serverId = tempData.serverId;
        createRoomInfo.roomName = @"";
        [createRoomInfo setGateAddr:tempData.roomGateAddr];
        //关闭自己
        [self close:YES];
    }
}

-(void)onAPI_QueryVCBServerRequest_Failed {
    [self hideLoadingHud];
    self.isLogining = NO;
    [MBProgressHUD showError:@"请求服务器信息失败!"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
