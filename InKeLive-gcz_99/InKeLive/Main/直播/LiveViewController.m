//
//  LiveViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//直播详情页（游客端）拉流

#import "LiveViewController.h"
#import "LiveViewController+GiftAnnimation.h"
#import "ASHUD.h"
//#import <UMSocialWechatHandler.h>
//#import "WXApi.h"
#import "DPK_NW_Application.h"
#import "PresentModelAble.h"

//#import <UMengUShare/UMSocialCore/UMSocialManager.h>////
//#import <UMengUShare/UShareUI/UMSocialShareUIConfig.h>////
#import "DMHeartFlyView.h"
#import "DKScrollTextLable.h"
#import "AppDelegate.h"
#import "UserSmallHeadImageCell.h"
#import "UserBigHeadImageCell.h"

#import "ClientRoomModel.h"
#import "ClientUserModel.h"
#import "DPK_NW_Application.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Common.h"

#import "GTGiftListModel.h"
#import "GTGiftGroupModel.h"
#import "ChatPrivateView.h"
#import "ChatPublicView.h"
#import "ChangeScore.h"
#import "BeautyView.h"
#import "WebViewController.h"
#import "WebView.h"
#import "GTAFNData.h"
#import "SpecialView.h"
//#import "ShareCopyView.h"
#import "ShareAllView.h"
#import "MicStatusView.h"
#define USER_NEXTACTION_IDEL          0
#define USER_NEXTACTION_LOGON         1
#define USER_NEXTACTION_CREATEMBROOM  2
#define USER_NEXTACTION_JOINROOM      3


@interface LiveViewController ()< UIGestureRecognizerDelegate,
KeyBoardInputViewDelegate,
PresentViewDelegate,
UITableViewDataSource, UITableViewDelegate,
DPKRoomMessageSink,
UIAlertViewDelegate,
privateChatViewDelegate, GTAFNDataDelegate>
{
    bool use_cap_;
    UITapGestureRecognizer *tapGesture;
    NSMutableArray *registeredNotificationsKSY;  //金山播放器用到的通知集合
    bool is_ksystream_pull_connecting_;     //拉流器的状态,是否连接中
    bool is_ksystream_pull_connected_;      //拉流器的状态,是否连接成功
    bool is_ksystream_pull_autoconnect_;    //拉流器的状态,是否自动连接
    
    
    int nowIndex;//当前选中的行;
    
}

@property(nonatomic, strong) MBProgressHUD* hud;


//金山播放器参数
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *reloadUrl;
@property (strong, nonatomic) NSURL *pushStreamUrl;

@property(strong, nonatomic) NSArray *fileList;

//房间内 socket对象
@property( nonatomic, strong) DPKTCPSocket* socketObj;
@property(nonatomic, assign) BOOL isConnected;
@property(nonatomic, assign) BOOL isConnecting;
@property(nonatomic, assign) long lastConnectTime;
@property(nonatomic, assign) long lastJoinRoomTime;   //最后加入房间时间,用来检查房间加入是否超时(服务器无响应)?
@property(nonatomic, assign) long lastCreateRoomTime;  //最后创建房间时间,用来检查房间创建是否超时(服务器无响应)?
//房间心跳线程
@property(nonatomic, strong) NSThread* keepliveThread;
//线程关闭标志
@property(nonatomic, assign) int closeThreadFlag;

//最上层的视图
@property (nonatomic,strong)UIView *topSideView;
//直播窗口
@property (nonatomic,strong)UIView *showView;
//占位图
@property (nonatomic,strong)UIImageView *backdropView;
//player使用的窗口
@property (nonatomic, strong)UIView *playerView;
//推流器使用的窗口
@property (nonatomic, strong)UIView *pushStreamerView;

//关闭直播
@property (nonatomic,strong)UIButton *closeButton;  //按钮
@property (nonatomic,strong)UIButton *btnReload;//刷新按钮
@property (nonatomic,strong)UIButton *btnReloadBg;//刷新提示背景

//连麦视屏窗口数
@property (nonatomic,strong)NSMutableArray *remoteArray;

//分享平台
@property (nonatomic, nonnull,strong)NSMutableArray *platformArr;

@property (nonatomic,strong)NSString *adressStr;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *userIcon;
//私聊
@property (nonatomic, strong) ChatPrivateView *chatPrivateView;
//公聊
@property (nonatomic, strong) ChatPublicView *chatPublicView;
//积分兑换
@property (nonatomic, strong) ChangeScore *changeScore;
//美颜滤镜
@property (nonatomic, strong) BeautyView *beautyView;
//分享面板
//@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong)ShareAllView *shareView;
@property (nonatomic, strong) SpecialView *speicalView;
@property (nonatomic, strong)MicStatusView *micStatusView;
//充值网页
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, readwrite) float grind;//磨皮
@property (nonatomic, readwrite) float whiten;//美白
@property (nonatomic, readwrite) float rubby;//红润
//开关特效
@property (nonatomic, assign)BOOL isAnimationHide;//礼物动画
@property (nonatomic, assign)BOOL isGiftHide;//礼物信息
@property (nonatomic, assign)BOOL isEnterHide;//进房信息
@property (nonatomic, assign)BOOL isQuitHide;//退房信息
@property (nonatomic, assign)BOOL isHarnHide;//喇叭信息

//在麦状态
@property (nonatomic, assign)BOOL isVideoPause;//视频暂停
@property (nonatomic, assign)BOOL isAudioPause;//音频暂停
//公聊数据
@property (nonatomic, strong) NSMutableArray *arrPubChat;

//关注列表
@property (nonatomic, strong)NSArray *arrayAttention;

@property (nonatomic, strong)UIImageView *imgHeadForSinger;

//市长
@property (nonatomic, strong)ClientUserModel *mayor;
//市长夫人
@property (nonatomic, strong)ClientUserModel *Lady;

@property (nonatomic, assign)int wrongCount;
@end

@implementation LiveViewController
- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points，（状态栏不隐藏）
    // 也可以不写，系统默认是UIEdgeInsetsMake(10, 0, 34, 0);
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

- (void)initURL:(NSURL *)url fileList:(NSArray *)fileList
{
    self.url = url;
    self.reloadUrl = url;
    self.fileList = fileList;
    //[_player reload:_reloadUrl flush:YES mode:MPMovieReloadMode_Accurate];
}

- (void)initPushURL:(NSString*)rtmpUrl
{
    self.pushStreamUrl = [NSURL URLWithString:rtmpUrl];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;//屏幕常亮
    self.grind = 0.5;
    self.whiten = 0.5;
    self.rubby = 0.5;
    nowIndex = -1;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"userId", @"大家", @"userName", nil];
    _arrPubChat = [[NSMutableArray alloc] initWithObjects:dic, nil];
    [self creatUI];
    _arrPrivate = [NSMutableArray array];
    _arrAmchorList = [NSMutableArray array];
    _arrayAttention = [NSArray array];
    _isAnimationHide = NO;
    _isGiftHide = NO;
    _isEnterHide = NO;
    _isQuitHide = NO;
    _isHarnHide = NO;
    _isAudioPause = NO;
    _isVideoPause = NO;
    _wrongCount = 0;
    //创建聊天室对象和Socket对象
    self.roomObj = [[ClientRoomModel alloc]init];
    self.socketObj = [[DPK_NW_Application sharedInstance] CreateSocket];
    [self.socketObj SetMessageEventSink:self];
    //创建keeplive心跳线程
    self.closeThreadFlag = 0;
    self.keepliveThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRoomKeeplive) object:nil];
    [self.keepliveThread start];
    
    if(self.createFlag) {
        NSLog(@"主播端进入房间,要上麦!");
        //主播端，推流器
        //推流端设置
        if(!_kit) {
            _kit = [[KSYGPUStreamerKit alloc] init];
        }
        _curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
        //摄像头位置
        _kit.cameraPosition = self.caremaIsFront ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;  //默认前面
        //视频输出格式
        _kit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
        //采集格式
        _kit.capturePixelFormat   = kCVPixelFormatType_32BGRA;
        //采集样式 _profileNames= 360p_auto, 540p_auto, 720p_auto
        _kit.streamerProfile = 100;
        
        
        self.pushStreamerView.hidden = NO;
        self.playerView.hidden = YES;
        self.showView.hidden = YES;
        [self addPushStreamerObserver];
        [self onCapture:YES];
        //连接房间服务器
        //[self connect_roomserver_createroom];
        [self connect_roomserver_joinroom];  //现在都一样,区别是加入成功后要上麦
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];//进入后台
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeRoom) name:UIApplicationWillTerminateNotification object:nil];//退出程序
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeRoom) name:UIApplicationDidEnterBackgroundNotification object:nil];//退出程序
    }
    else {
        //观众端，播放器
        self.pushStreamerView.hidden = YES;
        self.playerView.hidden = NO;
        self.showView.hidden = NO;
        [self addObserver:self forKeyPath:@"player" options:NSKeyValueObservingOptionNew context:nil];
        [self initPlayerWithURL:_url fileList:_fileList];
        NSLog(@"_url == %@",_url);

        //连接房间服务器
        [self connect_roomserver_joinroom];
    }
    
    //其他状态
    is_ksystream_pull_autoconnect_ = NO;
    is_ksystream_pull_connecting_ = NO;
    is_ksystream_pull_connected_ = NO;
    TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    UIView *viewOnMic = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4, 70, SCREEN_WIDTH/4, 33)];
    if (kIs_iPhoneX) {
        viewOnMic.frame = CGRectMake(SCREEN_WIDTH*3/4, 94, SCREEN_WIDTH/4, 33);
    }
    [self.view addSubview:viewOnMic];
    UIButton *btnRoomName = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, SCREEN_WIDTH/4-4, 18)];
    [btnRoomName setBackgroundColor:RGBA(0, 0, 0, 0.2)];
    btnRoomName.layer.masksToBounds = YES;
    btnRoomName.layer.cornerRadius = 8;
    [btnRoomName setImage:[UIImage imageNamed:@"living_arrows_up"] forState:UIControlStateNormal];
    [btnRoomName setImage:[UIImage imageNamed:@"living_arrows_down"] forState:UIControlStateSelected];
//    [btnRoomName setBackgroundColor:[UIColor clearColor]];
//    [btnRoomName setTitle:[_dicInfo objectForKey:@"room_name"] forState:UIControlStateNormal];
    [btnRoomName setTitle:[NSString stringWithFormat:@"%@ ",joinRoomInfo.roomName
                           ] forState:UIControlStateNormal];
    btnRoomName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    NSLog(@"width == %f",btnRoomName.titleLabel.bounds.size.width);
    [btnRoomName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRoomName.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnRoomName setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnRoomName.imageView.bounds.size.width, 0, btnRoomName.imageView.bounds.size.width)];
    [btnRoomName setImageEdgeInsets:UIEdgeInsetsMake(0, btnRoomName.titleLabel.bounds.size.width, 0, -btnRoomName.titleLabel.bounds.size.width)];
    [btnRoomName addTarget:self action:@selector(btnSpreadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [viewOnMic addSubview:btnRoomName];
    UILabel *labRoomId = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH/4, 12)];
//    labRoomId.text = [NSString stringWithFormat:@"ID: %@",[_dicInfo objectForKey:@"room_id"]];
    labRoomId.text = [NSString stringWithFormat:@"ID: %d",joinRoomInfo.roomId];
    labRoomId.textColor = [UIColor whiteColor];
    labRoomId.textAlignment = NSTextAlignmentCenter;
    labRoomId.font = [UIFont systemFontOfSize:12];
    [viewOnMic addSubview:labRoomId];
    
    CGFloat width = (SCREEN_WIDTH - 132)/5;
    _btnReload = [[UIButton alloc] initWithFrame:CGRectMake(132+2* width, SCREEN_HEIGHT - 54, 40, 40)];
    if (kIs_iPhoneX) {
        _btnReload.frame = CGRectMake(132+2* width, SCREEN_HEIGHT - 65, 40, 40);
    }
    UIImage *imgReload = [UIImage imageNamed:@"living_reload"];
    [_btnReload setImage:imgReload forState:UIControlStateNormal];
    [_btnReload addTarget:self action:@selector(btnReloadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnReload];
    
    _btnReloadBg = [[UIButton alloc] initWithFrame: CGRectMake(132+2* width-12, SCREEN_HEIGHT - 94, 72, 40)];
    if (kIs_iPhoneX) {
        _btnReloadBg.frame = CGRectMake(132+2* width-12, SCREEN_HEIGHT - 105, 72, 40);
    }
    [_btnReloadBg.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_btnReloadBg setBackgroundImage:[UIImage imageNamed:@"living_reload_bg"] forState:UIControlStateNormal];
    [_btnReloadBg setTitle:@"点击刷新" forState:UIControlStateNormal];
    [self.view addSubview:_btnReloadBg];
    
    [_btnReload setHidden:YES];
    [_btnReloadBg setHidden:YES];
    
}
-(void)hadEnterBackGround{
    NSLog(@"推出从程序hadEnterBackGround");
}

- (void)btnReloadClicked{
    self.pushStreamerView.hidden = YES;
    self.playerView.hidden = NO;
    [self addObserver:self forKeyPath:@"player" options:NSKeyValueObservingOptionNew context:nil];
//    [self initPlayerWithURL:_url fileList:_fileList];
//    NSLog(@"_url == %@",_url);
//    //连接房间服务器
//    [self connect_roomserver_joinroom];
    //获取用户的麦状态
    int rotateDegree = 0;
    int mic_state = _userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK;
    switch (mic_state) {
        case FT_USERROOMSTATE_MIC_GUAN:
        case FT_USERROOMSTATE_MIC_GONG:
        case FT_USERROOMSTATE_MIC_SI:
        case FT_USERROOMSTATE_MIC_MI:
        case FT_USERROOMSTATE_MIC_LIWU:
            rotateDegree = 180;
            break;
        default:
            break;
    }
    
//    NSLog(@"============================");
//    NSLog(@"RTMP:%@",userObj.pullStreamUrl);
//    NSLog(@"============================");
    [self onPlayStream:YES URL:self.userObj.pullStreamUrl RotateDegree:rotateDegree];
    [self onPlayStream:YES URL:self.userObj.pullStreamUrl RotateDegree:rotateDegree];
    int64_t delayInSeconds = 10.0;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_btnReload setHidden:YES];
        [_btnReloadBg setHidden:YES];
    });

}

- (void)btnSpreadClicked:(UIButton *)button{
    button.selected = !button.selected;
    self.onMicUsersHeadView.hidden = button.selected;
}

//- (void)getAdress{
//    WEAKSELF;
//    [[NetUtil shead]getRTMPAddress:@"test001" withAppName:@"huilive" withType:2 withStreamId:@"123456" withSecretKey:nil withReturn:^(NSDictionary *dict, int code) {
//        if (dict && code == 200) {
//            weakSelf.adressStr = [dict objectForKey:@"url"];
//            [weakSelf repareStartPlay];
//            [weakSelf prepareRtc];
//        }
//    }];
//}


#pragma mark - 定时器线程函数

-(void)threadRoomKeeplive
{
    DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
    while(!self.closeThreadFlag)
    {
        //房间超时连接的房间
        long time_now = time(0);
        if((self.lastJoinRoomTime !=0) && (time_now - self.lastJoinRoomTime > 10))
        {
            //连接超时，主动断开
            NSLog(@"主动断开!加入房间时间超过10秒");
            self.lastJoinRoomTime = 0;
            if(self.isConnected || self.isConnecting)
                [self.socketObj CloseSocket:0];
            //
            self.isConnected = NO;
            self.isConnecting = NO;
            self.roomObj.isConnected = 0;
            self.roomObj.isJoinRoomFinished = 0;
            //提示客户端信息
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showConnectFailedDialog ];
            });
        }
        
        //创建房间的超时连接
        if((self.lastCreateRoomTime !=0) && (time_now -self.lastCreateRoomTime > 10))
        {
            //连接超时，主动断开
            NSLog(@"主动断开!创建房间时间超过10秒");
            self.lastCreateRoomTime = 0;
            if(self.isConnected || self.isConnecting)
                [self.socketObj CloseSocket:0];
            //
            self.isConnected= NO;
            self.isConnecting =NO;
            //提示客户端
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showCreateFailedDialog ];
            });
        }
        
        //已经连接就定时发送心跳保持连接
        if(self.isConnected == YES )
        {
            NSLog(@"保持心跳...");
            if(self.roomObj.isJoinRoomFinished == 1)
                [self.socketObj SendRoomKeeplive:self.roomObj.roomId UserID:dpk_app.localUserModel.userID];
        }
        else if(self.isConnected == NO &&
                self.isConnecting == NO &&
                self.roomObj.connectedCount >0)
        {
            NSLog(@"连接服务器..., connect_roomserver_joinroom()");
            WEAKSELF;
            if(time_now > self.lastConnectTime + 10) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf connect_roomserver_joinroom ];
                });
            }
        }
        
        //监测当前线程是否被取消过，如果被取消了，则该线程退出。
        if ([[NSThread currentThread] isCancelled])
        {
            NSLog(@"thread is canceled!!!!");
            [NSThread exit];
        }
        
        [NSThread sleepForTimeInterval:5];
    }
}

-(void) connect_roomserver_createroom
{
    if(self.roomObj.isJoinRoomFinished == 1 && self.roomObj.isConnected == 1)
        return;
    if(self.isConnected || self.isConnecting)
        return;
    
    //显示loading窗口
    [self showLoadingHud];
    
    LocalUserModel* userData =[DPK_NW_Application sharedInstance].localUserModel;
    userData.nextAction = USER_NEXTACTION_CREATEMBROOM;
    TempCreateRoomInfo* createRoomInfo = [DPK_NW_Application sharedInstance].tempCreateRoomInfo;
    LWServerAddr* serverAddr = [createRoomInfo getGateAddr:0];
    if(serverAddr != nil)
    {
        NSLog(@"===================");
        NSLog(@"创建房间，连接服务器[%@:%d]", serverAddr.addr, serverAddr.port);
        [self.socketObj ConnectServer:serverAddr.addr ServerPort:serverAddr.port];
        self.isConnecting = YES;
        self.lastConnectTime = time(0);
    }
    
}

-(void) connect_roomserver_joinroom
{
    if(self.roomObj.isJoinRoomFinished == 1 && self.roomObj.isConnected == 1)
        return;
    if(self.isConnected || self.isConnecting)
        return;
    
    //显示loading窗口
    [self showLoadingHud];
    
    LocalUserModel* userData =[DPK_NW_Application sharedInstance].localUserModel;
    userData.nextAction = USER_NEXTACTION_JOINROOM;
    
    TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
    self.playerId = joinRoomInfo.lookUserId;
    //
    LWServerAddr* serverAddr = [joinRoomInfo getGateAddr:0];
    if(serverAddr != nil)
    {
        NSLog(@"===================");
        NSLog(@"加入房间，连接服务器[%@:%d]，房间ID=%d", serverAddr.addr, serverAddr.port, joinRoomInfo.roomId);
        [self.socketObj ConnectServer:serverAddr.addr ServerPort:serverAddr.port];
        self.isConnecting = YES;
        self.lastConnectTime = time(0);
    }
}

#pragma mark init player
- (void)initPlayerWithURL:(NSURL *)aURL fileList:(NSArray *)fileList {
    //初始化播放器并设置播放地址
    self.player = [[KSYMoviePlayerController alloc] initWithContentURL: aURL fileList:fileList sharegroup:nil];
    [self setupObservers:_player];
    _player.controlStyle = MPMovieControlStyleNone;
    [_player.view setFrame: self.playerView.bounds];  // player's frame must match parent's
    [self.playerView addSubview: _player.view];
    self.playerView.autoresizesSubviews = TRUE;
//    self.playerView.backgroundColor
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    NSLog(@"url == %@",aURL);
    //设置播放参数
    _player.videoDecoderMode = MPMovieVideoDecoderMode_AUTO;
    _player.scalingMode = MPMovieScalingModeAspectFill;
    _player.shouldAutoplay = NO;  //YES
    _player.deinterlaceMode = MPMovieVideoDeinterlaceMode_Auto;
    _player.shouldLoop = NO;
    _player.bInterruptOtherAudio = NO;
    _player.mirror = NO;
    _player.shouldMute = NO;
//    _player.bufferTimeMax = config.bufferTimeMax;
//    _player.bufferSizeMax = config.bufferSizeMax;
    [_player setTimeout:10 readTimeout:30];
    NSKeyValueObservingOptions opts = NSKeyValueObservingOptionNew;
    [_player addObserver:self forKeyPath:@"currentPlaybackTime" options:opts context:nil];
    [_player addObserver:self forKeyPath:@"clientIP" options:opts context:nil];
    [_player addObserver:self forKeyPath:@"localDNSIP" options:opts context:nil];
    NSLog(@"%d",[_player isPreparedToPlay]);
    
    [_player prepareToPlay];
}

-(void)uninitPlayer {
    if(!_createFlag && _player !=nil)
    {
        [_player stop];
        [_player removeObserver:self forKeyPath:@"currentPlaybackTime" context:nil];
        [_player removeObserver:self forKeyPath:@"clientIP" context:nil];
        [_player removeObserver:self forKeyPath:@"localDNSIP" context:nil];
        [self releaseObservers:_player];
        [_player.view removeFromSuperview];
        self.player = nil;
    }
}

-(void)playerReloadURL {
    if(_player != nil)
        [_player reload:_reloadUrl flush:YES mode:MPMovieReloadMode_Accurate];
}

- (void)registerObserver:(NSString *)notification player:(KSYMoviePlayerController*)player {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(notification)
                                              object:player];
    [registeredNotificationsKSY addObject:notification];
}

- (void)setupObservers:(KSYMoviePlayerController*)player
{
    [self registerObserver:MPMediaPlaybackIsPreparedToPlayDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStateDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackDidFinishNotification player:player];
    [self registerObserver:MPMoviePlayerLoadStateDidChangeNotification player:player];
    [self registerObserver:MPMovieNaturalSizeAvailableNotification player:player];
    [self registerObserver:MPMoviePlayerFirstVideoFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerFirstAudioFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerSuggestReloadNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStatusNotification player:player];
    [self registerObserver:MPMoviePlayerNetworkStatusChangeNotification player:player];
    [self registerObserver:MPMoviePlayerSeekCompleteNotification player:player];
}

- (void)releaseObservers:(KSYMoviePlayerController*)player
{
    for (NSString *name in registeredNotificationsKSY) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:player];
    }
}

-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        //testcode 有数据了
        if(_player.shouldAutoplay == NO)
            [_player play];
        //隐藏loading背景
        self.showView.hidden = YES;
        
        NSString* serverIp = [_player serverAddress];
        NSLog(@"KSYPlayerVC: %@ -- ip:%@", [[_player contentURL] absoluteString], serverIp);
        //reloading = NO;
        is_ksystream_pull_connected_ = YES;
        is_ksystream_pull_connecting_ = NO;
        self.KSYstreamerStatusLabel.text =@"[L:播放准备]";
        
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        NSLog(@"------------------------");
        NSLog(@"player playback state: %ld", (long)_player.playbackState);
        NSLog(@"------------------------");
        
        if(_player.playbackState == MPMoviePlaybackStatePlaying ) {
            self.KSYstreamerStatusLabel.text =@"[L:播放中]";
        }
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        NSLog(@"player load state: %ld", (long)_player.loadState);
        if (MPMovieLoadStateStalled & _player.loadState) {
            NSLog(@"player start caching");
        }
        if (_player.bufferEmptyCount &&
            (MPMovieLoadStatePlayable & _player.loadState ||
             MPMovieLoadStatePlaythroughOK & _player.loadState)){
                NSLog(@"player finish caching");
                NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
                                     (int)_player.bufferEmptyCount,
                                     _player.bufferEmptyDuration];
                //[self toast:message];
            }
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        //guchengzhi,连接失败也是这个吗？
        is_ksystream_pull_connecting_ = NO;
        is_ksystream_pull_connected_ = NO;
        
        if(_playerId != 0) {
            self.KSYstreamerStatusLabel.text = @"[L:连接断开,准备重试...]";
        }
        else {
            self.KSYstreamerStatusLabel.text = @"[L:流状态:无]";
        }
        
        NSLog(@"播放器停止成功!");
        NSLog(@"player finish state: %ld", (long)_player.playbackState);
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
    }
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
        NSLog(@"video size %.0f-%.0f, rotate:%ld\n", _player.naturalSize.width, _player.naturalSize.height, (long)_player.naturalRotate);
        if (_player.naturalSize.width > _player.naturalSize.height) {
            _player.scalingMode = MPMovieScalingModeAspectFit;
            _player.mirror = YES;
            if (kIs_iPhoneX) {
                _player.view.frame = CGRectMake(0, 112, SCREEN_WIDTH, SCREEN_WIDTH * _player.naturalSize.height/_player.naturalSize.width);
            }else{
                _player.view.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_WIDTH * _player.naturalSize.height/_player.naturalSize.width);
            }
        }else{
            _player.scalingMode = MPMovieScalingModeAspectFill;
            _player.mirror = NO;
            _player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        if(((_player.naturalRotate / 90) % 2  == 0 && _player.naturalSize.width > _player.naturalSize.height) ||
           ((_player.naturalRotate / 90) % 2 != 0 && _player.naturalSize.width < _player.naturalSize.height))
        {
            //如果想要在宽大于高的时候横屏播放，你可以在这里旋转
//            if (kIs_iPhoneX) {
//                _player.view.frame = CGRectMake(0, 112, SCREEN_WIDTH, SCREEN_WIDTH * _player.naturalSize.height/_player.naturalSize.width);
//            }else{
//                _player.view.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_WIDTH * _player.naturalSize.height/_player.naturalSize.width);
//            }
            
        }
    }
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
        //TODO:
        NSLog(@"第一帧 Video render 通知!");
    }
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
        //TODO:
         NSLog(@"第一帧 Audio render 通知!");
    }
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        NSLog(@"suggest using reload function!\n");
        //if(!reloading)
        //{
        //    reloading = YES;
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
        //        if (_player) {
        //            NSLog(@"reload stream");
        //            [_player reload:_reloadUrl flush:YES mode:MPMovieReloadMode_Accurate];
        //        }
        //    });
        //}
    }
    if(MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
        NSLog(@"播放器 播放状态变化....\n");
        
        int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
        if(MPMovieStatusVideoDecodeWrong == status)
            NSLog(@"Video Decode Wrong!\n");
        else if(MPMovieStatusAudioDecodeWrong == status)
            NSLog(@"Audio Decode Wrong!\n");
        else if (MPMovieStatusHWCodecUsed == status )
            NSLog(@"Hardware Codec used\n");
        else if (MPMovieStatusSWCodecUsed == status )
            NSLog(@"Software Codec used\n");
        else if(MPMovieStatusDLCodecUsed == status)
            NSLog(@"AVSampleBufferDisplayLayer  Codec used");
    }
    if(MPMoviePlayerNetworkStatusChangeNotification == notify.name)
    {
        NSLog(@"播放器 网络状态变化....\n");
        int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
        int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
        NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
    }
    if(MPMoviePlayerSeekCompleteNotification == notify.name)
    {
        NSLog(@"Seek complete");
    }
}

#pragma mark common
- (NSTimeInterval) getCurrentTime {
    return [[NSDate date] timeIntervalSince1970];
}

- (void) toast:(NSString*)message {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    double duration = 0.5; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (NSString *) netStatus2Str:(KSYNetworkStatus)networkStatus {
    NSString *netString = nil;
    if(networkStatus == KSYNotReachable)
        netString = @"NO INTERNET";
    else if(networkStatus == KSYReachableViaWiFi)
        netString = @"WIFI";
    else if(networkStatus == KSYReachableViaWWAN)
        netString = @"WWAN";
    else
        netString = @"Unknown";
    return netString;
}


- (NSString*)JSONTOString:(id)obj {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}



#pragma 创建UI
- (void)creatUI {
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.pushStreamerView];
    
 

    [self.view addSubview:self.showView];
    [self.showView addSubview:self.backdropView];
    [self.view insertSubview:self.topSideView aboveSubview:self.showView];
//    [self.view addSubview:self.closeButton];
    
    [self.view addSubview:self.anchorView];//主播信息
    
//    [self.view addSubview:self.anchorListView];//在麦主播列表
    [self.topSideView addSubview:self.bottomTool];//底部工具栏
    [self.topSideView addSubview:self.topToolView];//顶部工具栏
//    [self.topSideView addSubview:self.membersHeadView];//观众头像(弃用)
    [self.topSideView addSubview:self.onMicUsersHeadView];//右侧主播头像
    [self.topSideView addSubview:self.keyBoardView];
    [self.topSideView addSubview:self.messageTableView];
    [self.topSideView addSubview:self.presentView];
    
//    [self.topSideView addSubview:self.KSYstreamerStatusBK];
//    [self.topSideView addSubview:self.KSYstreamerStatusLabel];
    
//    [self.view addSubview:self.danmuView]
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:_playerView.frame];
    imageBg.image = [UIImage imageNamed:@"wellcome_default_blur"];
    [_playerView addSubview:imageBg];
    //设置关闭按钮的约束
//    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-14);
//        make.right.equalTo(self.view).offset(-10);
//        make.width.height.equalTo(@40);
//    }];
//    [self registerForKeyboardNotifications];
    
    //送礼物，设置回调
    WEAKSELF;

    [self.giftView setGiftClick:^(NSDictionary *dic, int number) {
        //发送礼物
        if (dic.allKeys.count>1) {
            NSLog(@"dic == %@",dic);
            int giftID = [[dic objectForKey:@"giftId"] intValue];
            NSLog(@"点击了礼物, tag=%d, playerId=%d", giftID, weakSelf.playerId);
            LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            const char* szSrcAlias = (const char*)[userData.userName cStringUsingEncoding:enc];
            //        DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
            //        GTGiftListModel* model = [dpk_app.giftList objectAtIndex:tag];
            
            int toId = weakSelf.giftView.userId;
            int giftNum =number;
            if(toId == 0) {
//                MessageModel *model = [[MessageModel alloc] init];
                [MBProgressHUD showAlertMessage:@"请选择赠送对象"];
//                [model setModel:@"请选择赠送对象"];
//                [weakSelf.messageTableView sendMessage:model];
            }
            else if(giftNum == 0) {
                MessageModel *model = [[MessageModel alloc] init];
                [model setModel:@"请选择赠送数量"];
                [weakSelf.messageTableView sendMessage:model];
            }
            else {
                ClientUserModel* toUserObj = [weakSelf.roomObj findMember:toId];
                char szToAlias[32]= {0};
                if(toUserObj !=nil) {
                    const char * sztmp = (const char*)[toUserObj.userAlias cStringUsingEncoding:enc];
                    strcpy(szToAlias, sztmp);
                }
                else {
                    sprintf(szToAlias, "%d", toId);
                }
                
                //            DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
                //            GTGiftListModel* model = [dpk_app.giftList objectAtIndex:tag];
                //            if(model !=nil) {
                [weakSelf.socketObj SendRoomGiftReq:weakSelf.roomObj.roomId
                                              SrcID:userData.userID
                                               ToID:toId
                                             GiftID:giftID
                                            GiftNum:giftNum
                                            TextLen:0
                                       SrcUserAlias:szSrcAlias
                                        ToUserAlias:szToAlias
                                           GiftText:0
                                           hideMode:_isHide];
                //            }
            }
        }else{
            [[GTAlertTool shareInstance] showAlert:@"未选择赠送的礼物" message:@"请先选择礼物" cancelTitle:nil titleArray:nil viewController:weakSelf confirm:nil];
        }
//        [weakSelf bottomToolShow];
    }];
        
    //显示底部工具栏
    [self.giftView setGrayClick:^{
        [weakSelf bottomToolShow];
//        weakSelf.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-280, CGRectGetWidth(self.view.frame)*3/4, 220);
    }];
    //testcode 创建开始预览和开始推流按钮
    //选择赠送用户
    [self.giftView setSelectGiftUser:^{
        [weakSelf showSelectGiftUserView];
    }];
    //兑换
    [self.giftView setChangeScore:^{
        [weakSelf showChangeScoreView];
    }];
    //充值
    [self.giftView setRechargeClick:^{
        [weakSelf showWebView];
    }];
    [self.messageTableView setShowUserInfo:^(int userId) {
        NSArray *arrName = self.roomObj.memberList;
        for (int i = 0; i<arrName.count; i++) {
            ClientUserModel *model = [arrName objectAtIndex:i];
            if (userId == model.userId) {
                NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
                NSString*cachePath = array[0];
                NSString*filePathName = [cachePath stringByAppendingPathComponent:@"livingUserInfo.plist"];
                NSLog(@"%@",model.szcidiograph);
                NSDictionary*dict =@{@"userId":[NSString stringWithFormat:@"%d",model.userId],
                                     @"userAlias":model.userAlias,
                                     @"userSmallHeadPic":model.userSmallHeadPic,
                                     @"vipLevel":[NSString stringWithFormat:@"%d",model.vipLevel],
                                     @"userBigHeadPic":model.userBigHeadPic,
                                     @"pushStreamUrl":model.pushStreamUrl,
                                     @"pullStreamUrl":model.pullStreamUrl,
                                     @"szcidiograph":model.szcidiograph
                                     };
                [dict writeToFile:filePathName atomically:YES];
                break;
            }
        }
        [UIView animateWithDuration:0 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGesture];
}



// 键盘弹起
- (void)keyboardWasShown:(NSNotification*)notification{
    NSLog(@"notification == %@",notification.userInfo);
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(self.keyBoardView.frame.origin.x, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height, CGRectGetWidth(self.keyBoardView.frame), CGRectGetHeight(self.keyBoardView.frame));
    }
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height - CGRectGetHeight(self.messageTableView.frame) -10, CGRectGetWidth(self.messageTableView.frame), 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
// 键盘隐藏
- (void)keyboardWasHidden:(NSNotification*)notification {
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
    }
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-180, CGRectGetWidth(self.view.frame)/3*2, 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
- (void)tapEvent:(UITapGestureRecognizer*)recognizer {
    //if (recognizer.view == self.headImageView) {
    //}else {
    //}
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH - 40, self.view.bounds.size.height - 90);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    
    CGPoint point = [recognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.keyBoardView.frame toView:self.view];
    if (CGRectContainsPoint(rect, point)) {
        
    }else{
        if (self.keyBoardView.isEdit) {
            [self.keyBoardView editEndTextField];
        }
    }
    
}

- (BottomView *)bottomTool {
    //下部 工具条按钮区
    if (_bottomTool == nil) {
        _bottomTool = [[BottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64)];
        if (kIs_iPhoneX) {
            _bottomTool.frame = CGRectMake(0, SCREEN_HEIGHT - 75, SCREEN_WIDTH, 75);
        }
        
        WEAKSELF;
        [_bottomTool setButtonClick:^(NSInteger tag) {
            switch (tag) {
                case 150: //私聊
                {
//                    if (weakSelf.keyBoardView) {
//                        [weakSelf.keyBoardView editBeginTextField];
//                    }
                    [weakSelf showPrivateChatView:0];
                }
                break;
                case 151: //礼物
                {
                    
                    [weakSelf bottomToolPosition];
                    
                }
                break;
                case 152: //切换镜头
                {
                    [weakSelf.kit switchCamera];
                }
                    break;
                case 153: //美颜
                {
                    [weakSelf showBeautyViewLWithGrind:weakSelf.grind whiten:weakSelf.whiten ruddy:weakSelf.rubby];
                }
                    break;
                case 154: //静音
                {
                    
                    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    _micStatusView = [[MicStatusView alloc] initWithFrame:frame];
                    _micStatusView.isVideoPause = _isVideoPause;
                    _micStatusView.isAudioPause = _isAudioPause;
                    [_micStatusView popShow];
                    WEAKSELF;
                    [_micStatusView setBtnButtonClick:^(int status) {
                        int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
                        [weakSelf.socketObj sendMicStatusModifyReq:weakSelf.roomObj.roomId userId:srcuserid status:status];
                        NSLog(@"%d%d",status,status);
                        if (status == VIDEO_PLAY) {
                            weakSelf.isVideoPause = NO;
                            self.showView.hidden = YES;
                            [_kit.streamerBase startStream:_pushStreamUrl];
                        }else if (status == VIDEO_PAUSE){
                            weakSelf.isVideoPause = YES;
                            [_kit.streamerBase stopStream];
                        }else if (status == AUDIO_PLAY){
                            weakSelf.isAudioPause = NO;
                            [_kit.streamerBase muteStream:NO];
                        }else if (status == AUDIO_PAUSE){
                            weakSelf.isAudioPause = YES;
                            [_kit.streamerBase muteStream:YES];
                        }
                    }];
                    
//                    UIButton *btn = (UIButton *)[weakSelf.bottomTool viewWithTag:tag];
//
//                    btn.selected = !btn.selected;
//                    int status = 0;
//                    if (btn.selected != 0) {
//                        status = AUDIO_PLAY;
//                    }else{
//                        status = AUDIO_PAUSE;
//                    }
//                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
//                    int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
//                    [self.socketObj sendMicStatusModifyReq:self.roomObj.roomId userId:srcuserid status:status];
                    //testcode
//                    [weakSelf showSelectGiftUserView];
//                    break;
//                    [UMSocialManager setPreDefinePlatforms:weakSelf.platformArr];
//                    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
//                    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
//                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//                        // 根据platformType调用相关平台进行分享
//                        [weakSelf shareTextToPlatformType:platformType];
//                    }];
                }
                break;
//                case 100:{
//                    if (weakSelf.keyBoardView) {
//                       [weakSelf.keyBoardView editBeginTextField];
//                   }
//                }
                default:
                break;
            }
        }];
        
        [_bottomTool setTextFieldChangeClick:^{
            //动画隐藏
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            anim.duration = 0.3f;
            anim.removedOnCompletion = NO;
            anim.fillMode = kCAFillModeForwards;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 32)];
            [weakSelf.bottomTool.layer addAnimation:anim forKey:@"positionHide"];
            [weakSelf showPublicChatView:0 userName:@""];
        }];
    }
    return _bottomTool;
}

//- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //设置文本
//    messageObject.text = @"https://www.anyrtc.io/";
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
//}
#pragma mark privateChatViewDelegate
- (void)SendPrivateMessage:(NSString *)message receiverId:(int)receiverId{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
    int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
    ClientUserModel* srcUserObj = [self.roomObj findMember:srcuserid];
    int touserid = receiverId;
    const char* sz_srcalias = [srcUserObj.userAlias cStringUsingEncoding:enc];
    int msgType = 2;
    const char* sz_message = [message cStringUsingEncoding:enc];
    int len_message = (int)strlen(sz_message);
    //
    [self.socketObj SendRoomChatMsgReq:self.roomObj.roomId
                                 SrcID:srcuserid
                                  ToID:touserid
                               MsgType:msgType
                               TextLen:len_message
                          SrcUserAlias:sz_srcalias
                           ToUserAlias:nil
                            MsgContent:sz_message];
}

#pragma mark PublicChatViewDelegate
- (void)sendMessage:(NSString *)strInfo receiverID:(int)receiverId ToUserAlias:(NSString *)ToUserAlias{
    
    NSLog(@"ToUserAlias == %@",ToUserAlias);
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
    int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
    ClientUserModel* srcUserObj = [self.roomObj findMember:srcuserid];
    int touserid = receiverId;
    const char* sz_srcalias = [srcUserObj.userAlias cStringUsingEncoding:enc];
    int msgType = 1;//公聊
    const char* sz_message = [strInfo cStringUsingEncoding:enc];
    const char* tousername = [ToUserAlias cStringUsingEncoding:enc];
    int len_message = (int)strlen(sz_message);
    //
    [self.socketObj SendRoomChatMsgReq:self.roomObj.roomId
                                 SrcID:srcuserid
                                  ToID:touserid
                               MsgType:msgType
                               TextLen:len_message
                          SrcUserAlias:sz_srcalias
                           ToUserAlias:tousername
                            MsgContent:sz_message];
    
}

-(void)sendAttention:(int)flag roomId:(int)roomId singerId:(int)singerId{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
    [self.socketObj SendUserAttentionReq:flag
                                 uUserID:srcuserid
                                 nRoomID:roomId
                                 nSinger:singerId];
    
    
}

#pragma KeyBoardInputViewDelegate
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu {
    if (message.length == 0) {
        return;
    }
    //聊天消息发送
    if (danmu) {
        // 发送弹幕消息
        if (self.danmuView) {
            DanmuItem *item = [[DanmuItem alloc] init];
            item.u_userID = @"three id";
            item.u_nickName = self.nickName;
            item.thumUrl = self.userIcon;
            item.content = message;
            [self.danmuView setModel:item];
//            TODO:发送网络消息
        }
    }else{
        // 发送普通消息
        //MessageModel *model = [[MessageModel alloc] init];
        //[model setModel:@"guestID" withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
        //[self.messageTableView sendMessage:model];
        //发送网络消息
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
        int srcuserid =[DPK_NW_Application sharedInstance].localUserModel.userID;
        ClientUserModel* srcUserObj = [self.roomObj findMember:srcuserid];
        int touserid = _playerId;
        const char* sz_srcalias = [srcUserObj.userAlias cStringUsingEncoding:enc];
        int msgType = 1;
        const char* sz_message = [message cStringUsingEncoding:enc];
        int len_message = strlen(sz_message);
        //
        [self.socketObj SendRoomChatMsgReq:self.roomObj.roomId
                                     SrcID:srcuserid
                                      ToID:touserid
                                   MsgType:msgType
                                   TextLen:len_message
                              SrcUserAlias:sz_srcalias
                               ToUserAlias:nil
                                MsgContent:sz_message];
        
    }
}
/**
 *  返回自定义cell样式
 */
- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row {
    return [[GIftCell alloc] initWithRow:row];
}
/**
 *  礼物动画即将展示的时调用，根据礼物消息类型为自定义的cell设置对应的模型数据用于展示
 *
 *  @param cell        用来展示动画的cell
 *  @param model       礼物模型
 */
- (void)presentView:(PresentView *)presentView
         configCell:(PresentViewCell *)cell
              model:(id<PresentModelAble>)model {
    GIftCell *giftcell = (GIftCell *)cell;
    giftcell.presentmodel = model;
}

/**
 *  cell点击事件
 */
- (void)presentView:(PresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index {
    GIftCell *cell = [presentView cellForRowAtIndex:index];
}

/**
 一组连乘动画执行完成回调
 */
- (void)presentView:(PresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PresentModelAble>)model {
    NSLog(@"shakeNumber == %ld",(long)shakeNumber);
}

#pragma 点击事件
//隐藏工具栏,显示礼物界面
- (void)bottomToolPosition {
    //动画隐藏
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.3f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 32)];
    [self.bottomTool.layer addAnimation:anim forKey:@"positionHide"];
    //0.5秒后执行
    [self performSelector:@selector(popShowGiftView) withObject:nil afterDelay:0.5];
}
- (void)bottomToolHidden{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.3f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 32)];
    [self.bottomTool.layer addAnimation:anim forKey:@"positionHide"];
}

//显示工具栏
- (void)bottomToolShow {
    //动画显示
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.5f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 32)];
    [self.bottomTool.layer addAnimation:anim forKey:@"positionShow"];
}

//显示送礼物界面
- (void)popShowGiftView {
    self.giftView.roomObj = self.roomObj;
    [self.giftView popShow];
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    [self.giftView updateUserMoney:userData.nk NB:userData.nb];

//    if (kIs_iPhoneX) {
//        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-280 - 285 + 75, CGRectGetWidth(self.view.frame)*3/4, 220);
//    }else{
//        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-280 - 285 + 64, CGRectGetWidth(self.view.frame)*3/4, 220);
//    }
}

//显示送礼物界面
- (void)showGiftView: (int)userId :(NSString *)userName {
    self.giftView.roomObj = self.roomObj;
    self.giftView.userId = userId;
    self.giftView.userName = userName;
    [self.giftView popShow];
    NSString *strInfo = [NSString stringWithFormat:@"送给:%@",userName];
    [self.giftView.selectUserButton setTitle:strInfo forState:UIControlStateNormal];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strInfo];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(3, userName.length)];
    [self.giftView.selectUserButton setAttributedTitle:attrStr forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"living_gift_up"];
    [self.giftView.selectUserButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.giftView.selectUserButton.imageView.bounds.size.width, 0, self.giftView.selectUserButton.imageView.bounds.size.width)];
    [self.giftView.selectUserButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.giftView.selectUserButton.titleLabel.bounds.size.width, 0, -self.giftView.selectUserButton.titleLabel.bounds.size.width)];
    NSLog(@"width == %f",self.giftView.selectUserButton.titleLabel.bounds.size.width);
    [self.giftView.selectUserButton setImage:image forState:UIControlStateNormal];
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    [self.giftView updateUserMoney:userData.nk NB:userData.nb];
}

//关闭直播
- (void)closeRoom {
    if (_createFlag) {
        LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
        [self.socketObj SendDownMBMicReq:model.userID RoomID:self.roomObj.roomId];
    }
    [self closeRoom2:NO AlertString:nil];
}

-(void)closeRoom2:(BOOL)showAlert AlertString:(NSString*)text {
    //关闭心跳线程
    self.closeThreadFlag = 1;
    if(self.keepliveThread != nil) {
        [self.keepliveThread cancel];
        self.keepliveThread = nil;
    }
    
    //发送退出房间请求消息
    DPK_NW_Application* dpk_app = [DPK_NW_Application sharedInstance];
    if(self.roomObj.isConnected == 1 && self.roomObj.isJoinRoomFinished ==1) {
        NSLog(@"发送退出房间请求");
        self.roomObj.isConnected = 0;
        self.roomObj.isJoinRoomFinished = 0;
        [self.socketObj SendExitRoomReq:self.roomObj.roomId UserID:dpk_app.localUserModel.userID];
        
        //[self performSelector:@selector(dissMissViewController2) withObject:nil afterDelay:(0.03)];
    }
    [dpk_app CloseRoomSocket:self.socketObj];
    self.socketObj = nil;
    
    [self uninitPlayer];
    [self uninitPushStreamer];
    
    if(!showAlert)
        [self dismissViewControllerAnimated:YES completion:nil];
    else {
        //显示提示框，等待用户点击确定再关闭
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert setTag:15];
        [alert show];
    }
}

//切换摄像头
-(void)onCamera {
    self.caremaIsFront = !self.caremaIsFront;
    if(_kit !=nil) {
        [_kit switchCamera];
    }
}

//启动/关闭预览
-(void)onCapture:(BOOL)start {
    if(start) {
        if (!_kit.vCapDev.isRunning){
            _kit.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            [_kit setupFilter:_curFilter];
            //启动预览
            [_kit startPreview:_pushStreamerView];
        }
    }
    else {
        [_kit stopPreview];
    }
}


//启动/关闭推流
-(void)onPushStream:(BOOL)start {
    if(start) {
        if (_kit.streamerBase.streamState == KSYStreamStateIdle ||
            _kit.streamerBase.streamState == KSYStreamStateError) {
            //启动推流
            [_kit.streamerBase startStream:_pushStreamUrl];
        }
    }
    else {
        //停止推流
        [_kit.streamerBase stopStream];
    }
    
}

//启动播放器
-(void)onPlayStream:(BOOL)start URL:(NSString*)strlUrl RotateDegree:(int)rotateDegree {
    if(start) {
//        if(is_ksystream_pull_connecting_ ) return;
//        if(is_ksystream_pull_connected_ ) return;
        is_ksystream_pull_autoconnect_ = YES;
        
        is_ksystream_pull_connecting_ = YES;
        //if(self.player.isPlaying)
        //   [self.player stop];
        [self.player reset:NO];
        self.player.rotateDegress = rotateDegree;
        [self.player setUrl:[NSURL URLWithString:strlUrl]];
        [self.player setShouldMute:NO];
        [self.player prepareToPlay];
        [self.player play];
        self.KSYstreamerStatusLabel.text =@"[L:正在连接...]";
    }
    else {
        [self.player reset:NO];
        self.player.rotateDegress = 0;
        //if(self.player.isPlaying || self.player.isPreparedToPlay)
        //    [self.player stop];
        
        is_ksystream_pull_autoconnect_ = NO;
        is_ksystream_pull_connecting_ = NO;
        is_ksystream_pull_connected_ = NO;
        self.KSYstreamerStatusLabel.text =@"[L:流状态:无]";
        self.showView.hidden = YES;
    }
}

//销毁推流器
-(void)uninitPushStreamer {
    if(_createFlag && _kit !=nil) {
        [self removePushStreamerObserver];
        [_kit stopPreview];
        _kit = nil;
    }
}


- (void)layout:(int)index {
    switch (index) {
        case 0:
            for (int i=0; i<self.remoteArray.count; i++) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:i];
                UIView *videoView = [dict.allValues firstObject];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict.allValues firstObject];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(2)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqual:@"currentPlaybackTime"])
    {
        //progressView.playProgress = _player.currentPlaybackTime / _player.duration;
    }
    else if([keyPath isEqual:@"clientIP"])
    {
        NSLog(@"client IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if([keyPath isEqual:@"localDNSIP"])
    {
        NSLog(@"local DNS IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if ([keyPath isEqualToString:@"player"]) {
        if (_player) {
#if 0
            //progressView.hidden = NO;
            __weak typeof(_player) weakPlayer = _player;
            progressView.dragingSliderCallback = ^(float progress){
                typeof(weakPlayer) strongPlayer = weakPlayer;
                double seekPos = progress * strongPlayer.duration;
                //strongPlayer.currentPlaybackTime = progress * strongPlayer.duration;
                //使用currentPlaybackTime设置为依靠关键帧定位
                //使用seekTo:accurate并且将accurate设置为YES时为精确定位
                [strongPlayer seekTo:seekPos accurate:YES];
            };
#endif
        } else {
            //progressView.hidden = YES;
        }
    }
}

#pragma 加载
- (PresentView *)presentView {
    if (!_presentView) {
        _presentView  = [[PresentView alloc]init];
        _presentView.frame = CGRectMake(0,70, SCREEN_WIDTH*3/5, 214);
        if (kIs_iPhoneX) {
            _presentView.frame = CGRectMake(0,94, SCREEN_WIDTH*3/5, 214);
        }
        _presentView.showTime = 2;
        _presentView.delegate = self;
        _presentView.backgroundColor = [UIColor clearColor];
    }
    return _presentView;
}

- (NSMutableArray *)giftArr {
    if (!_giftArr) {
//        _giftArr = [NSMutableArray array];
//        PresentModel *model0 = [PresentModel modelWithSender:@"游客A" giftName:@"鲜花" icon:@"" giftImageName:@"live_emoji_meigui"];
//        [_giftArr addObject:model0];
//
//        PresentModel *model1 = [PresentModel modelWithSender:@"游客B" giftName:@"泰迪熊" icon:@"" giftImageName:@"bear0@2x"];
//        [_giftArr addObject:model1];
//
//        PresentModel *model2 = [PresentModel modelWithSender:@"游客C" giftName:@"游轮" icon:@"" giftImageName:@"ship_body"];
//        [_giftArr addObject:model2];
        _giftArr = [[NSMutableArray alloc] init];
    }
    return _giftArr;
}

- (UIView *)showView {
    if (_showView == nil) {
        _showView = [[UIView alloc]init];
        _showView.frame = self.view.bounds;
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

//房间对象
-(ClientRoomModel*)roomObj {
    if(_roomObj == nil) {
        _roomObj = [[ClientRoomModel alloc]init];
    }
    return _roomObj;
}

//播放器使用的窗口
-(UIView *)playerView {
    if(_playerView == nil) {
        _playerView = [[UIView alloc]init];
        _playerView.frame = self.view.bounds;
        _playerView.backgroundColor = [UIColor blackColor];
        
    }
    return _playerView;
}

//推流器使用的窗口
-(UIView *)pushStreamerView {
    if(_pushStreamerView == nil) {
        _pushStreamerView = [[UIView alloc]init];
        _pushStreamerView.frame = self.view.bounds;
        _pushStreamerView.backgroundColor = [UIColor whiteColor];
    }
    return _pushStreamerView;
}

//背景图
- (UIImageView *)backdropView {
    if (_backdropView == nil) {
        _backdropView = [[UIImageView alloc]init];
        _backdropView.frame = self.view.bounds;
        NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString*cachePath = array[0];
        NSString*filePathName = [cachePath stringByAppendingPathComponent:@"giftInfo.plist"];
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
        NSString *strRes = [dict objectForKey:@"res"];
        NSString *urlStr = [NSString stringWithFormat:@"%@room/%@",strRes,[_dicInfo objectForKey:@"img"]];
        [_backdropView setImage:[UIImage imageNamed:@"wellcome_default_blur"]];
//        [_backdropView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"wellcome_default_blur"]];
        UIVisualEffect *effcet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effcet];
        visualEffectView.frame = _backdropView.bounds;
        [_backdropView addSubview:visualEffectView];
    }
    return _backdropView;
}

//最上层视图(透明)
- (UIView *)topSideView {
    if (_topSideView == nil) {
        _topSideView = [[UIView alloc]initWithFrame:self.view.bounds];
        _topSideView.backgroundColor = [UIColor clearColor];
    }
    return _topSideView;
}

//关闭按钮
- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

//弹出来礼物视图
- (SendGiftView *)giftView {
    if (!_giftView) {
        _giftView = [[SendGiftView alloc]initWithFrame:self.view.bounds];
    }
    return _giftView;
}

//连麦窗口数
- (NSMutableArray *)remoteArray {
    if (!_remoteArray) {
        _remoteArray = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _remoteArray;
}

////分享平台
//- (NSMutableArray *)platformArr {
//    if(!_platformArr){
//        _platformArr = [[NSMutableArray alloc]init];
//        if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
//            [_platformArr addObject:@(UMSocialPlatformType_WechatSession)];
//            [_platformArr addObject:@(UMSocialPlatformType_WechatTimeLine)];
//            [_platformArr addObject:@(UMSocialPlatformType_WechatFavorite)];
//        }
//    }
//    return _platformArr;
//}

- (KeyBoardInputView*)keyBoardView {
    if (!_keyBoardView) {
        _keyBoardView = [[KeyBoardInputView alloc] initWityStyle:KeyBoardInputViewTypeNomal];
        _keyBoardView.backgroundColor = [UIColor clearColor];
        _keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
//        _keyBoardView.delegate = self;
    }
    return _keyBoardView;
}

//- (PrivateChatView *)privateChatView{
//    if (!_privateChatView) {
//        _privateChatView = [[PrivateChatView alloc] init];
//        _privateChatView.backgroundColor = [UIColor clearColor];
////        _privateChatView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, SCREEN_HEIGHT);
//        _privateChatView.delegate = self;
//    }
//    return _privateChatView;
//}

- (ChatPrivateView *)chatPrivateView{
    if (!_chatPrivateView) {
        _chatPrivateView = [[ChatPrivateView alloc] init];
    }
    
    return _chatPrivateView;
}

- (MessageTableView*)messageTableView {
    if (!_messageTableView) {
        _messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.view.frame)-280, CGRectGetWidth(self.view.frame)*4/5, 220)];
        if (kIs_iPhone5S) {
            _messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-210, CGRectGetWidth(self.view.frame)*4/5, 150);
        }
    }
    return _messageTableView;
}

- (DanmuLaunchView*)danmuView {
    if (!_danmuView) {
        _danmuView = [[DanmuLaunchView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.messageTableView.frame)-(ItemHeight*3+ItemSpace*2), self.view.frame.size.width, ItemHeight*3+ItemSpace*2)];
    }
    return _danmuView;
}

- (AnchorView *)anchorView {
    if (!_anchorView) {
        _anchorView = [[AnchorView alloc]initWithFrame:CGRectMake(4, 30, 160, 36)];
        if (kIs_iPhoneX) {
            _anchorView.frame = CGRectMake(4, 54, 150, 36);
        }
        WEAKSELF;
//        NSLog(@"userId == %d",_userObj.userId);
        [_anchorView setAnchorClick:^(int flag) {
            //Singer是等级在21<=level<=25
            LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
            NSLog(@"_userObj.vipLevel == %d",weakSelf.userObj.userId);
            if (_userObj.vipLevel <= 25 && _userObj.vipLevel >= 21) {
                [weakSelf sendAttention:flag roomId:_roomObj.roomId singerId:_userObj.userId];
            }else{
                [MBProgressHUD showAlertMessage:@"只能关注主播"];
            }
        }];
    }
    return _anchorView;
}

//- (FlyView *)flyView{
//    if (!_flyView) {
//        _flyView = [[FlyView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH*3/4, 18)];
//        if (kIs_iPhoneX) {
//            _flyView.frame = CGRectMake(0, 94, SCREEN_WIDTH*3/4, 18);
//        }
//
//    }
//    return _flyView;
//}

- (AnchorListView *)anchorListView{
    if (!_anchorListView) {
        _anchorListView = [[AnchorListView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH/4, SCREEN_WIDTH + 20)];
        NSLog(@"_roomObj.roomName == %@",_dicInfo);
        [_anchorListView.btnRoomName setTitle:[_dicInfo objectForKey:@"room_name"] forState:UIControlStateNormal];
        _anchorListView.dicAnchor = self.dicInfo;
//        [_anchorListView.labRoomId setText:[NSString stringWithFormat:@"ID: %@",[_dicInfo objectForKey:@"room_id"]]];
    }
    return _anchorListView;
}

- (ChangeScore *)changeScore{
    if (!_changeScore) {
        _changeScore = [[ChangeScore alloc] init];
    }
    return _changeScore;
}

-(UIView*) KSYstreamerStatusBK {
    if(!_KSYstreamerStatusBK) {
        CGRect rcFrame = CGRectMake(0, 70, SCREEN_WIDTH, 24);
        _KSYstreamerStatusBK = [[UIView alloc] initWithFrame:rcFrame];
        _KSYstreamerStatusBK.backgroundColor= RGBA(0, 0, 0, 0.2);
    }
    return _KSYstreamerStatusBK;
}

-(UILabel*) KSYstreamerStatusLabel {
    if(!_KSYstreamerStatusLabel) {
        CGRect rcFrame = CGRectMake(SCREEN_WIDTH/2, 70, SCREEN_WIDTH/2-20, 24);
        _KSYstreamerStatusLabel = [[UILabel alloc] initWithFrame:rcFrame];
        _KSYstreamerStatusLabel.backgroundColor = [UIColor clearColor];
        _KSYstreamerStatusLabel.textColor = [UIColor lightTextColor];
        _KSYstreamerStatusLabel.text = @"[流状态:无]";
        _KSYstreamerStatusLabel.font = [UIFont systemFontOfSize:12];
        _KSYstreamerStatusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _KSYstreamerStatusLabel;
}


/**
 顶部用户头像列表(弃用)

 @return <#return value description#>
 */
//-(RoomMembersView*)membersHeadView {
//    if(!_membersHeadView) {
//        CGRect frame =CGRectMake(170, 30, SCREEN_WIDTH - 170 - 5, 36);
//        _membersHeadView =[[RoomMembersView alloc]initWithFrame:frame style:UITableViewStylePlain];
//        _membersHeadView.backgroundColor = [UIColor redColor];
//        _membersHeadView.dataSource =self;
//        _membersHeadView.delegate=self;
//    }
//    return _membersHeadView;
//}
- (TopToolView *)topToolView{
    if (!_topToolView) {
        CGRect frame = CGRectMake(170, 30, SCREEN_WIDTH - 174, 33);
        _topToolView = [[TopToolView alloc] initWithFrame:frame];
        if (kIs_iPhoneX) {
            _topToolView.frame = CGRectMake(170, 54, SCREEN_WIDTH - 174, 33);
        }
        WEAKSELF;
        [_topToolView setToolClicked: ^(UIButton *btn) {
            if (btn.tag == 511) {
                //特效
//                isAnimation = btn.selected;
//                btn.selected = !btn.selected;
                [weakSelf showSpecialView];
            }else if (btn.tag == 512){
                //分享
                [weakSelf showShareView];
            }else if (btn.tag == 513){
                //用户列表
                [weakSelf showSelectGiftUserView];
            }else if (btn.tag == 514){
                //关闭
                [weakSelf closeRoom];
            }
        }];
    }
    return _topToolView;
}

-(RoomOnMicUsersView*)onMicUsersHeadView {
    if(!_onMicUsersHeadView) {
        CGRect frame = CGRectMake(SCREEN_WIDTH*3/4, 103, SCREEN_WIDTH/4, SCREEN_WIDTH);
        if (kIs_iPhoneX) {
            frame = CGRectMake(SCREEN_WIDTH*3/4, 127, SCREEN_WIDTH/4, SCREEN_WIDTH);
        }
        _onMicUsersHeadView = [[RoomOnMicUsersView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _onMicUsersHeadView.backgroundColor = [UIColor clearColor];
        _onMicUsersHeadView.dataSource =self;
        _onMicUsersHeadView.delegate=self;
    }
    return _onMicUsersHeadView;
}

-(LiveUserInfoView*)userView {
    if(!_userView) {
        LiveUserInfoView* userView = [LiveUserInfoView userView];
        //LiveUserInfoView* userView = [[LiveUserInfoView alloc] init];
        //userView.backgroundColor = [UIColor redColor];
        //userView.frame = self.view.bounds;
        
        [self.view addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //设置回调函数
        [userView setCloseBlock:^{
            //关闭回调函数
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
        }];
        [userView setGuanzhuBlock:^{
            //关闭回调函数
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
            
        }];

        [userView setSandGiftBlock:^(int userId, NSString *userName) {
            //关闭回调函数
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
            NSLog(@"userName == %@",userName);
            self.giftView.userName = userName;
            self.giftView.userId = userId;
            NSLog(@"userid == %d",userId);
//            [self bottomToolPosition];
            [self showGiftView:userId :userName];
        }];
        
        [userView setPrivateChatBlock:^(int userId, NSString *userName) {
            ClientUserModel* userObj = [self.roomObj findMember:[[NSString stringWithFormat:@"%ld",(long)userId]intValue]];
            //关闭回调函数
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
            if(userObj != nil) {
                [self showPrivateChatView:userId];
            }else{
                [[GTAlertTool shareInstance]showAlert:@"对方已离开房间" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:nil];
            }
            
        }];
        
        WEAKSELF;
        [userView setPublicChatBlock:^(int userId, NSString *userName) {
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            anim.duration = 0.3f;
            anim.removedOnCompletion = NO;
            anim.fillMode = kCAFillModeForwards;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 32)];
            [weakSelf.bottomTool.layer addAnimation:anim forKey:@"positionHide"];
            ClientUserModel* userObj = [self.roomObj findMember:[[NSString stringWithFormat:@"%ld",(long)userId]intValue]];
            if(userObj != nil) {
                [weakSelf showPublicChatView:userId userName:userName];
            }else{
                [[GTAlertTool shareInstance]showAlert:@"@的用户已离开房间" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                    
                }];
            }
            
        }];
       
    }
    return _userView;
}

- (NSString *)nickName {
    if (!_nickName) {
        _nickName = @"游客A";
    }
    return _nickName;
}

- (NSString *)userIcon {
    if (!_userIcon) {
        _userIcon = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTg4ODIzMjcxMCM4MDIjanBn.jpg"];
    }
    return _userIcon;
}


//- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBarHidden = YES;
//}

//- (void)dealloc {
//    if(self.createFlag) {
//        
//    }
//    else {
//        @try{
//            [self removeObserver:self forKeyPath:@"player"];
//        }@catch(NSException *exception){
//            NSLog(@"多次移除kvo");
//        }
//        
//    }
//    self.keyBoardView.delegate = nil;
//    self.presentView.delegate = nil;
//    self.privateChatView.delegate = nil;
//}

#pragma mark - 推流端
- (void)addPushStreamerObserver{
    //监听推流状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushStreamerStateChanged) name:KSYStreamStateDidChangeNotification object:nil];
}
- (void)removePushStreamerObserver{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pushStreamerStateChanged{
    NSString* strStatus=@"";
    switch (_kit.streamerBase.streamState) {
        case KSYStreamStateIdle:
            //_streamState.text = @"空闲状态";
            strStatus = @"空闲状态";
            break;
        case KSYStreamStateConnecting:
            //_streamState.text = @"连接中";
            strStatus = @"连接中";
            break;
        case KSYStreamStateConnected:
        {
            //_streamState.text = @"已连接";
            strStatus = @"已连接";
            if(self.isConnected == YES) {
                LocalUserModel* userData =[DPK_NW_Application sharedInstance].localUserModel;
                ClientUserModel* userObj = [self.roomObj findMember:userData.userID];
                if((userObj.inRoomState & FT_USERROOMSTATE_MIC_MBSI) !=0 ||
                   (userObj.inRoomState & FT_USERROOMSTATE_MIC_MBFEE) !=0 )
                {
                    [self.socketObj SendMBTLStatusReq:userData.userID RoomID:self.roomObj.roomId TLStatus:3];
                }
            }
        }
            break;
        case KSYStreamStateDisconnecting:
            //_streamState.text = @"失去连接";
            strStatus = @"失去连接";
            break;
        case KSYStreamStateError:
            //_streamState.text = @"连接错误";
            strStatus = @"连接错误";
            break;
        default:
            break;
    }
    NSLog(@" =========>推流器状态变化: %@", strStatus);
}

#pragma mark UITabelView Delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(tableView == _membersHeadView)
//    {
//        UserSmallHeadImageCell* cell = [UserSmallHeadImageCell cellWithTableView:tableView];
//        cell.tag = 10001;
//        //设置用户头像
//        ClientUserModel* userObj = [self.roomObj.memberList objectAtIndex:indexPath.row];
//        NSAssert(userObj!=nil,@"userObj must not be zero");
//
//        NSURL *url =[NSURL URLWithString:userObj.userSmallHeadPic];
//        //[cell.userHeadImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
//        //NSURL *url = [NSURL URLWithString:userModel.userHeadPic];
//        [cell.userHeadImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
//        if(userObj.roomLevel >0)
//            cell.userLevelImageView.image = [UIImage imageNamed:@"icon_guan"];
//        else
//            cell.userLevelImageView.hidden = YES;
//
//        return cell;
//    }
//    else
    if(tableView == _onMicUsersHeadView)
    {
        UserBigHeadImageCell* cell = [UserBigHeadImageCell cellWithTableView:tableView];
        cell.tag = 10001;
        //设置用户头像
        ClientUserModel* userObj = [self.roomObj.onMicUserList objectAtIndex:indexPath.row];
        NSAssert(userObj!=nil,@"userObj must not be zero");
        NSLog(@"userObj2 == %@",userObj);
        
        NSURL *url =[NSURL URLWithString:userObj.userSmallHeadPic];
        UIImage *imageDefault = [UIImage imageNamed:@"default_head"];
        UIImageView *image = [[UIImageView alloc] init];
        [image sd_setImageWithURL:url placeholderImage:imageDefault];
        [cell.contentView addSubview:image];
        image.layer.borderWidth = 2;
        image.layer.cornerRadius = (SCREEN_WIDTH/4-35)/2;
        image.layer.borderColor = [UIColor clearColor].CGColor;
        image.tag = 900+indexPath.row;
        if (indexPath.row == nowIndex) {
            image.layer.borderColor = MAIN_COLOR.CGColor;
        }
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4-35, SCREEN_WIDTH/4-35));
        }];
        
        UIImageView *imageMicrophone = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"living_microphone"];
        imageMicrophone.image = img;
        [cell.contentView addSubview:imageMicrophone];
        [imageMicrophone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(image.mas_right).offset(-5);
            make.size.mas_equalTo(img.size);
            make.bottom.equalTo(image.mas_bottom);
        }];
        if (userObj.isAudioStatus) {
            imageMicrophone.hidden = YES;
        }else{
            imageMicrophone.hidden = NO;
        }
        
        UIButton *btnName = [[UIButton alloc] init];
        if (userObj.micState == 1 || userObj.micState == 3 || userObj.micState == 4 || userObj.micState == 6 ) {
            [btnName setImage:[UIImage imageNamed:@"living_device_pc"] forState:UIControlStateNormal];
        }else if (userObj.micState == 7){
            [btnName setImage:[UIImage imageNamed:@"living_device_mobile"] forState:UIControlStateNormal];
        }
        [btnName setTitle:userObj.userAlias forState:UIControlStateNormal];
        [btnName setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [btnName.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:btnName];
        [btnName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 15));
            make.centerX.equalTo(cell.contentView);
        }];
        
//        UILabel *labName = [[UILabel alloc] init];
//        labName.text = userObj.userAlias;
//        labName.textColor = [UIColor whiteColor];
//        labName.font = [UIFont systemFontOfSize:13];
//        labName.textAlignment = NSTextAlignmentCenter;
//        [cell.contentView addSubview:labName];
//
////        [labName sizeToFit];
//
//        UIImageView *imageDevice = [[UIImageView alloc] init];
//        UIImage *imgDevice = [[UIImage alloc] init];
//        if (userObj.micState == 1 && userObj.micState == 2) {
//            imgDevice = [UIImage imageNamed:@"living_device_pc"];
//        }else if (userObj.micState == 7){
//            imgDevice = [UIImage imageNamed:@"living_device_mobile"];
//        }
//        [cell.contentView addSubview:imageDevice];
//        [imageDevice mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(imgDevice.size);
//            make.top.equalTo(labName.mas_top);
//            make.left.equalTo(cell.contentView.mas_left);
//        }];
//        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(image.mas_bottom);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 15));
//            make.left.equalTo(imageDevice.mas_right);
//        }];
//
        
        
        
        
        
//        [cell.userHeadImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_head"]];
//        //用户麦状态图片
//        uint32_t mic_state = userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK;
//        if(mic_state == FT_USERROOMSTATE_MIC_GUAN)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_guan"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_GONG)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_pubmic"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_SI)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_simic"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_MI)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_mimic"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_LIWU)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_mimic"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_MBSI)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_msimic"];
//        else if(mic_state == FT_USERROOMSTATE_MIC_MBFEE)
//            cell.userMicStatusImageView.image =[UIImage imageNamed:@"icon_timefeemic"];
//
        //cell.userMicStatusImageView.image =;
        return cell;
    }
    
    NSLog(@"[ERROR] unkown tableView!!!!!!!");
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(tableView == _membersHeadView) {
//        return self.roomObj.memberList.count;
//    }
//    else
    if(tableView == _onMicUsersHeadView) {
        return self.roomObj.onMicUserList.count;
    }
    
    NSLog(@"[ERROR] unkown tableView!!!!!!");
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(tableView == _membersHeadView)
//    {
//        //用户列表
//        ClientUserModel* userObj = [self.roomObj.memberList objectAtIndex:indexPath.row];
//        self.userView.userModel = userObj;
//        [self.userView updateInfo];
//        //UIView动画
//        [UIView animateWithDuration:0.5 animations:^{
//            self.userView.transform = CGAffineTransformIdentity;
//        }];
//
//    }
//    else
    if(tableView == _onMicUsersHeadView)
    {
//        for (int index = 0; index < self.roomObj.onMicUserList.count; index ++ ) {
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//            UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:900 + indexPath.row];
//            if (index == indexPath.row) {
//                image.layer.borderColor = MAIN_COLOR.CGColor;
//            }else{
//                image.layer.borderColor = [UIColor clearColor].CGColor;
//            }
//
//        }
        
        //在线用户列表
        if(!self.createFlag) {
            //观众端:点击头像观看该用户
            nowIndex = [[NSString stringWithFormat:@"%ld",(long)indexPath.row] intValue];
            ClientUserModel* userObj = [self.roomObj.onMicUserList objectAtIndex:indexPath.row];
            NSLog(@"userObj.micState == %d",userObj.micState);
            if (userObj.micState == 4) {
                [[GTAlertTool shareInstance]showAlert:@"手机端无法观看密麦主播" message:@"请选择其他主播" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                    
                }];
                return;
            }else if (userObj.micState == 6){
                [[GTAlertTool shareInstance]showAlert:@"手机端无法观看礼物麦主播" message:@"请选择其他主播" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                   
                }];
                 return;
            }
            self.userObj = [self.roomObj.onMicUserList objectAtIndex:indexPath.row];
            [self.anchorView setAnchorInfo:_userObj.userId UserName:_userObj.userAlias UserHeadPic:_userObj.userSmallHeadPic];
            self.playerId = _userObj.userId;
            NSLog(@"userObj == %@",_userObj);
            for (ClientUserModel *model in _arrayAttention) {
                if (model.userId == _userObj.userId) {
                    [self.anchorView setAttention:NO];
                }
            }
            //testcode 不在判断,直接连接
            //if(userObj.mbTLstatus == 3) {
            //    [self onPlayStream:YES URL:userObj.pullStreamUrl];
            //}
            
            //选中为赠送对象
            [self.giftView addUser:userObj.userId UserName:userObj.userAlias];
            
            //本机用户不处理
            LocalUserModel *userData = [DPK_NW_Application sharedInstance].localUserModel;
            if(userData.userID == userObj.userId)
                return;
            
            //主播端不处理
            if(self.createFlag){
                
            }
            
            
            
            //获取用户的麦状态
            int rotateDegree = 0;
            int mic_state = userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK;
            switch (mic_state) {
                case FT_USERROOMSTATE_MIC_GUAN:
                case FT_USERROOMSTATE_MIC_GONG:
                case FT_USERROOMSTATE_MIC_SI:
                case FT_USERROOMSTATE_MIC_MI:
                case FT_USERROOMSTATE_MIC_LIWU:
                    rotateDegree = 180;
                    break;
                default:
                    break;
            }
            
            NSLog(@"============================");
            NSLog(@"RTMP:%@",userObj.pullStreamUrl);
            NSLog(@"============================");

            [self onPlayStream:YES URL:userObj.pullStreamUrl RotateDegree:rotateDegree];
        }else{
            [[GTAlertTool shareInstance]showAlert:@"你当前处于主播状态" message:@"不能观看其他麦" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
            return;
        }
    }
    NSLog(@"tableView didSelect:%ld", (long)indexPath.row);
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(tableView == _membersHeadView) {
//        return 42; //36+6
//    }
//    else
    if(tableView == _onMicUsersHeadView) {
        return SCREEN_WIDTH/4-20; //64+6
    }
    
    NSLog(@"[ERROR] unkown tableView !!!!!!");
    return 0;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //if([touch.view isKindOfClass:[UITableView class]]) {
    //    return NO;
    //}
    if([touch.view isKindOfClass:[UserSmallHeadImageCell class]]) {
        return NO;
    }
    if([touch.view isKindOfClass:[UserBigHeadImageCell class]]) {
        return NO;
    }
    if(touch.view.tag == 10001) {
        return NO;
    }
    
    return YES;
    
    //if([touch.view isKindOfClass:[UIButton class]]) {
    //    return NO;
    //}
    //return YES;
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
    self.hud.labelText = @"获取数据中...";
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

-(void)showConnectFailedDialog {
    [self hideLoadingHud];
    if(self.roomObj.connectedCount <=0) {
        //提示用户房间连接失败,点击确定后退出该房间
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器/房间连接失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        // optional - add more buttons:
        //[alert addButtonWithTitle:@"Yes"];
        [alert setTag:12];
        [alert show];
    }
}

-(void)showCreateFailedDialog {
    [self hideLoadingHud];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建直播间失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    // optional - add more buttons:
    //[alert addButtonWithTitle:@"Yes"];
    [alert setTag:13];
    [alert show];
}

-(void)showJoinFailedDialog:(NSString*)errorMsg {
    [self hideLoadingHud];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    // optional - add more buttons:
    //[alert addButtonWithTitle:@"确定"];
    [alert setTag:14];
    [alert show];
}

- (void)showAlertRoomPwd{
    [self hideLoadingHud];
    NSString *strWrong;
    NSString *info;
    if (_wrongCount == 0) {
        strWrong = @"当前房间需要密码";
        info = @"请输入密码";
    }else{
        strWrong = @"当前密码错误";
        info = @"请重新输入";
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:strWrong message:info preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"在此输入密码";
    }];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertC.textFields.firstObject;
        //输出 检查是否正确无误
        
        NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
        DPK_NW_Application* dpkapp =[DPK_NW_Application sharedInstance];
        LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        const char* sessionMask =(const char*)[model.sessionMask cStringUsingEncoding:enc];
        const char* userLogonPwd =(const char*)[model.userLogonPwd cStringUsingEncoding:enc];
        const char* text =(const char*)[envirnmentNameTextField.text cStringUsingEncoding:enc];
        NSLog(@"self.roomObj.roomId == %d",model.userID);
        model.nextAction = USER_NEXTACTION_JOINROOM;
        self.roomObj.isConnected = 0;
        self.roomObj.isJoinRoomFinished = 0;
        [self.socketObj SendJoinRoomReq:0 RoomID:dpkapp.tempJoinRoomInfo.roomId UserID:model.userID SessionMask:sessionMask UserPwd:userLogonPwd RoomPwd:text IsReconnect:0 IsHide:_isHide isMobile:2];
        
    }]];
    //添加一个取消按钮
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeRoom];
    }]];
    
    //present出AlertView
    [self presentViewController:alertC animated:true completion:nil];

}


- (void)showSelectSendGiftUserView{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    SelectGiftUserView* view = [[SelectGiftUserView alloc] initWithFrame:frame];
    
#if 0
    // 利用block进行排序
    //========================================
    NSArray *array2 = [self.roomObj.memberList sortedArrayUsingComparator:
                       ^NSComparisonResult(ClientUserModel *obj1, ClientUserModel *obj2) {
                           // 先按照麦序
                           NSComparisonResult result = [obj1.lastname compare:obj2.lastname];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedSame) {
                               result = [obj1.firstname compare:obj2.firstname];
                           }
                           
                           return result;
                       }];
    //=======================================
#endif
    view.userArray = self.roomObj.memberList;
    view.ishide = _isHide;
    [view setUserClick:^(NSInteger userId, NSString *userAlias) {
        ClientUserModel* userObj = [self.roomObj findMember:[[NSString stringWithFormat:@"%ld",(long)userId]intValue]];
        if(userObj != nil) {
            self.giftView.userName = userAlias;
            self.giftView.userId = (int)userId;
        }
    }];
    
    [view popShow];
}

- (void)showSpecialView{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _speicalView = [[SpecialView alloc] initWithFrame:frame];
    _speicalView.isAnimationHide = _isAnimationHide;
    _speicalView.isGiftHide = _isGiftHide;
    _speicalView.isEnterHide = _isEnterHide;
    _speicalView.isQuitHide = _isQuitHide;
    _speicalView.isHarnHide = _isHarnHide;
    [_speicalView popShow];
    WEAKSELF;
    [_speicalView setBtnButtonClick:^(int tag, BOOL isSelect) {
        if (tag == 200) {
            weakSelf.isAnimationHide = isSelect;
        }else if (tag == 201) {
            weakSelf.isGiftHide = isSelect;
        }else if (tag == 202) {
            weakSelf.isEnterHide = isSelect;
        }else if (tag == 203) {
            weakSelf.isQuitHide = isSelect;
        }else if (tag == 204) {
            weakSelf.isHarnHide = isSelect;
        }
    }];
}
- (void)showShareView{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _shareView = [[ShareAllView alloc] initWithFrame:frame];
    [_shareView popShow];
}


-(void)showSelectGiftUserView {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    SelectGiftUserView* view = [[SelectGiftUserView alloc] initWithFrame:frame];
    
#if 0
    // 利用block进行排序
    //========================================
    NSArray *array2 = [self.roomObj.memberList sortedArrayUsingComparator:
                       ^NSComparisonResult(ClientUserModel *obj1, ClientUserModel *obj2) {
                           // 先按照麦序
                           NSComparisonResult result = [obj1.lastname compare:obj2.lastname];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedSame) {
                               result = [obj1.firstname compare:obj2.firstname];
                           }
                           
                           return result;
                       }];
    //=======================================
#endif
    NSArray *array = [self sortData:self.roomObj.memberList];
    view.userArray = array;
    view.ishide = _isHide;
    [view setUserClick:^(NSInteger userId, NSString *userAlias) {
        ClientUserModel* userObj = [self.roomObj findMember:[[NSString stringWithFormat:@"%ld",(long)userId]intValue]];
        if(userObj != nil) {
            [UIView animateWithDuration:0 animations:^{
                self.userView.transform = CGAffineTransformIdentity;
            }];
        }else{
            [[GTAlertTool shareInstance]showAlert:@"该用户已离开房间" message:nil cancelTitle:nil titleArray:nil viewController:self confirm:nil];
        }
    }];
    
    [view popShow];
}


/**
 基于model的Array的排序

 @param array <#array description#>
 @return <#return value description#>
 */
- (NSArray *)sortData: (NSArray *)array{
//    NSLog(@"array == %@",array);
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    for (ClientUserModel *model in array) {
        switch (model.vipLevel) {
            case 0:
                model.userLevel = 0;
                break;
            case 1:
                model.userLevel = 1;
                break;
            case 2:
                model.userLevel = 5;
                break;
            case 3:
                model.userLevel = 6;
                break;
            case 4:
                model.userLevel = 7;
                break;
            case 5:
                model.userLevel = 96;
                break;
            case 6:
                model.userLevel = 97;
                break;
            case 7:
                model.userLevel = 98;
                break;
            case 8:
                model.userLevel = 99;
                break;
            case 9:
                model.userLevel = 100;
                break;
            case 21:
                model.userLevel = 35;
                break;
            case 22:
                model.userLevel = 36;
                break;
            case 23:
                model.userLevel = 37;
                break;
            case 24:
                model.userLevel = 38;
                break;
            case 25:
                model.userLevel = 39;
                break;
            case 30:
                model.userLevel = 40;
                break;
            case 31:
                model.userLevel = 35;
                break;
            case 32:
                model.userLevel = 36;
                break;
            case 33:
                model.userLevel = 37;
                break;
            case 34:
                model.userLevel = 38;
                break;
            case 35:
                model.userLevel = 39;
                break;
            case 40:
                model.userLevel = 40;
                break;
            case 201:
                model.userLevel = 26;
                break;
            case 202:
                model.userLevel = 94;
                break;
            case 205:
                model.userLevel = 27;
                break;
            case 207:
                model.userLevel = 28;
                break;
            case 210:
                model.userLevel = 29;
                break;
            case 211:
                model.userLevel = 30;
                break;
            case 500:
                model.userLevel = 200;
                break;
            case 501:
                model.userLevel = 201;
                break;
                
            default:
                break;
        }
        [arrData addObject:model];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userLevel" ascending:NO];
    [arrData sortUsingDescriptors:@[sort]];
     //输出排序结果
    for (ClientUserModel *model in arrData) {
        NSLog(@"vip: %d userLevel: %d,userId: %d userAlias: %@",model.vipLevel, model.userLevel,model.userId, model.userAlias);
    }
    LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
    for (int index = 0; index < arrData.count; index ++ ) {
        ClientUserModel *model = arrData[index];
        if (model.userId == myModel.userID) {
            [arrData insertObject:arrData[index] atIndex:0];
            [arrData removeObjectAtIndex:index + 1];
        }
    }
    ClientUserModel *model = arrData[0];
    if (model.userId != myModel.userID) {
        for (int index = 0; index < self.roomObj.allMemberList.count; index ++ ) {
            ClientUserModel *model = self.roomObj.allMemberList[index];
            if (model.userId == myModel.userID) {
                NSLog(@"userId == %d",model.userId);
                [arrData insertObject:self.roomObj.allMemberList[index] atIndex:0];
            }
        }
    }
    NSArray *arr = [[NSArray alloc] initWithArray:arrData];
    return arr;
}

- (void)setUserLevel:(int)vipLevel{
    
    LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
    
}

- (void)showBeautyViewLWithGrind:(float)grind whiten:(float)whiten ruddy:(float)ruddy{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _beautyView = [[BeautyView alloc] initWithFrame:frame];
    
    [_beautyView.slidergrind setValue:self.grind*100];
    [_beautyView.sliderwhiten setValue:self.whiten*100];
    [_beautyView.sliderruddy setValue:self.rubby*100];
    [_beautyView popShow];
    WEAKSELF;
    [_beautyView setSliderClick:^(float value, int slideNum) {
        if (slideNum == 0) {
            weakSelf.grind = value/100;
        }else if (slideNum == 1){
            weakSelf.whiten = value/100;
        }else if (slideNum == 2){
            weakSelf.rubby = value/100;
        }
        KSYBeautifyFaceFilter *bf = [[KSYBeautifyFaceFilter alloc] init];
        bf.grindRatio  = [[NSString stringWithFormat:@"%.2lf",weakSelf.grind] floatValue];
        bf.whitenRatio = [[NSString stringWithFormat:@"%.2lf",weakSelf.whiten] floatValue];
        bf.ruddyRatio  = [[NSString stringWithFormat:@"%.2lf",weakSelf.rubby] floatValue];;
        [weakSelf.kit setupFilter:bf];
    }];
}
- (void)showWebView{
     CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.webView = [[WebView alloc] initWithFrame:frame];
    [self.webView popShow];
    WEAKSELF;
    [_webView setBtnCloseClick:^{
        [weakSelf bottomToolShow];
        weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-280, CGRectGetWidth(self.view.frame)*4/5, 220);
        if (kIs_iPhone5S) {
            weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-210, CGRectGetWidth(self.view.frame)*4/5, 150);
        }
    }];
}

- (void)showChangeScoreView{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _changeScore = [[ChangeScore alloc] initWithFrame:frame];
    [_changeScore popShow];
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    [self.changeScore updateUserMoney:userData.nk NB:userData.nb];
    WEAKSELF;
    [self.changeScore setCommendChangeClick:^(int score) {
        [weakSelf.socketObj sendScoreChargeReq:weakSelf.roomObj.roomId userId:userData.userID money:score];
    }];
}

- (void)showPrivateChatView:(int)userId{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _chatPrivateView = [[ChatPrivateView alloc] initWithFrame:frame];
    LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
    if (userId == myModel.userID) {
        [[GTAlertTool shareInstance] showAlert:@"不能与自己私聊" message:@"请选择其他私聊对象" cancelTitle:nil titleArray:nil viewController:self confirm:nil];
    }else{
        NSLog(@"_arrPrivate == %@",_arrPrivate);
        if (_arrPrivate.count > 0) {
            if (userId == 0) {
                //直接点击私聊:1 _arrPrivate.count>0
                _chatPrivateView.nowRow = [[NSString stringWithFormat:@"%lu",(unsigned long)_arrPrivate.count] intValue]-1;
                NSString *strUserId = [[_arrPrivate lastObject] objectForKey:@"userId"];
                NSString *strUserName = [[_arrPrivate lastObject] objectForKey:@"userAlias"];
//                _chatPrivateView.labNameAndId.text = [NSString stringWithFormat:@"  悄悄说:%@(%@)",strUserId, strUserName];
            }else{
                //直接跳入userId的私聊页面(判断是否替换)
                ClientUserModel* userObj = [self.roomObj findMember:userId];
                BOOL isAdd = YES;
                for (int index = 0; index < _arrPrivate.count; index ++ ) {
                    int userID = [[_arrPrivate[index] objectForKey:@"userId"] intValue];
                    if (userObj.userId == userID) {
                        isAdd = NO;
                        _nowRow = index;
                        break;
                    }
                }
                if (isAdd) {
                    NSDictionary *dicAll = @{@"userId":[NSString stringWithFormat:@"%d",userObj.userId],
                                             @"userAlias":userObj.userAlias,
                                             @"image":userObj.userSmallHeadPic
                                             };
                    [_arrPrivate addObject:dicAll];
                    _nowRow = [[NSString stringWithFormat:@"%lu",(unsigned long)_arrPrivate.count] intValue] - 1;
                    _chatPrivateView.lastRow = _nowRow;
                }
                
//                _chatPrivateView.labNameAndId.text = [NSString stringWithFormat:@"  悄悄说:%d(%@)",userId,userObj.userAlias];
            }
            _chatPrivateView.arrChatMessage = [NSMutableArray arrayWithArray:_arrPrivate];
            [self.chatPrivateView reloadDateForTableView];
        }else{
           if (userId == 0) {
                _chatPrivateView.labNameAndId.text = @"  悄悄说";
                _chatPrivateView.nowRow = -1;
               _chatPrivateView.arrChatMessage = [NSMutableArray arrayWithArray:_arrPrivate];
            }else{
                ClientUserModel* userObj = [self.roomObj findMember:userId];
                NSDictionary *dicAll = @{@"userId":[NSString stringWithFormat:@"%d",userObj.userId],
                                         @"userAlias":userObj.userAlias,
                                         @"image":userObj.userSmallHeadPic
                                         };
                [_arrPrivate addObject:dicAll];
                _chatPrivateView.arrChatMessage = [NSMutableArray arrayWithArray:_arrPrivate];
                _nowRow = [[NSString stringWithFormat:@"%lu",(unsigned long)_arrPrivate.count] intValue] - 1;
//                _chatPrivateView.labNameAndId.text = [NSString stringWithFormat:@"  悄悄说:%d(%@)",userId,userObj.userAlias];
                _chatPrivateView.nowRow = 0;
                [self.chatPrivateView reloadDateForTableView];

            }
        }
//        if (_chatPrivateView.arrChatMessage.count == 1) {
//            _chatPrivateView.lastRow = 0;
//        }
        [_chatPrivateView popShow];
    }
     WEAKSELF;
    [_chatPrivateView setPrivateChatSend:^(NSString *messageInfo, int toId) {
        NSLog(@"toId == %d",toId);
        //判断是否在线
        if (toId == 0) {
            [[GTAlertTool shareInstance] showAlert:@"未选择私聊对象" message:@"请先选择对象" cancelTitle:nil titleArray:nil viewController:weakSelf confirm:^(NSInteger buttonTag) {
                
            }];
//        }else if ([weakSelf.roomObj findAllMember:userId]){
//            [[GTAlertTool shareInstance] showAlert:@"对方已下线" message:@"请选择其他私聊对象" cancelTitle:nil titleArray:nil viewController:weakSelf confirm:^(NSInteger buttonTag) {
//                
//            }];
        }else{
            [weakSelf SendPrivateMessage:messageInfo receiverId:toId];
        }
        
    }];
    [_chatPrivateView setDeteleChatUser:^(int row) {
        [weakSelf.arrPrivate removeObjectAtIndex:row];
        NSLog(@"array == %@",weakSelf.arrPrivate);
    }];
}

#pragma mark 公聊接口
- (void)showPublicChatView: (int)userId userName: (NSString *)userName{
     CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _chatPublicView = [[ChatPublicView alloc] initWithFrame:frame];
    if (userId != 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",userId], @"userId", userName, @"userName", nil];
        for (int index = 0; index < _arrPubChat.count; index ++ ) {
            if ([[_arrPubChat[index] objectForKey:@"userId"] isEqualToString: [dic objectForKey:@"userId"]]) {
                [_arrPubChat removeObjectAtIndex:index];
            }
        }
        _chatPublicView.arrayUser = [NSMutableArray arrayWithArray:_arrPubChat];
        [_chatPublicView.arrayUser addObject:dic];
        _chatPublicView.strNanme = userName;
        _chatPublicView.userId = userId;
        _arrPubChat = [NSMutableArray arrayWithArray:_chatPublicView.arrayUser];
        [_chatPublicView.btnUserChoose setTitle:[NSString stringWithFormat:@"@%@",[[_arrPubChat lastObject] objectForKey:@"userName"]] forState:UIControlStateNormal];
    }else{
        _chatPublicView.strNanme = userName;
        _chatPublicView.userId = userId;
        _chatPublicView.arrayUser = [NSMutableArray arrayWithArray:_arrPubChat];
        [_chatPublicView.btnUserChoose setTitle:[NSString stringWithFormat:@"@%@",[[_arrPubChat firstObject] objectForKey:@"userName"]] forState:UIControlStateNormal];
    }
//    [self bottomToolHidden];
    [_chatPublicView popShow];
    WEAKSELF;
    [_chatPublicView setPublicChatSend:^(NSString *messageInfo, int toId, NSString *toUserAlias) {
        if (!weakSelf.isHide) {
            [weakSelf sendMessage:messageInfo receiverID:toId ToUserAlias:toUserAlias];
        }else{
            [MBProgressHUD showAlertMessage:@"隐身用户无法发送公聊"];
        }
        
    }];
    [_chatPublicView setClosePublicChatClick:^{
        [weakSelf bottomToolShow];
    }];
    [_chatPublicView setChangeMessageTableView:^(NSValue *value) {
        if (value == 0) {
            weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-280, CGRectGetWidth(self.view.frame)*4/5, 220);
            if (kIs_iPhone5S) {
                weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-210, CGRectGetWidth(self.view.frame)*4/5, 150);
            }
        }else{
            weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-280-[value CGRectValue].size.height, CGRectGetWidth(self.view.frame)*4/5, 220);
            if (kIs_iPhone5S) {
                weakSelf.messageTableView.frame = CGRectMake(5, CGRectGetMaxY(self.view.frame)-210-[value CGRectValue].size.height, CGRectGetWidth(self.view.frame)*4/5, 150);
            }
        }
    }];
}

#pragma mark - UIAlertViewDelegate protocol

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 12) {    // it's the Error alert
        if (buttonIndex == 0) {
            [self closeRoom ];
        }
    }
    else if(alertView.tag == 13) {
        if(buttonIndex == 0) {
            [self closeRoom];
        }
    }
    else if(alertView.tag == 14) {
        if(buttonIndex == 0) {
            [self closeRoom];
        }
    }
    else if(alertView.tag == 15) {
        if(buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - DPK_Socket Delegate DPKRoomMessageSink

- (void) OnDPKEventTCPSocketLink:(int)error_code
{
    if(error_code !=0) {
        //连接失败
        NSLog(@"连接服务器失败! error_code=%d", error_code);
        _isConnected = NO;
        _isConnecting = NO;
        [self showConnectFailedDialog];
    }
    else {
        NSLog(@"服务器连接成功!");
        _isConnected = YES;
        _isConnecting = NO;
        //创建房间 或者加入房间
        DPK_NW_Application* dpkapp =[DPK_NW_Application sharedInstance];
        if(dpkapp.localUserModel.nextAction == USER_NEXTACTION_JOINROOM)
        {
            //重置nextAction状态
            dpkapp.localUserModel.nextAction =USER_NEXTACTION_IDEL;
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);   //重点
            const char* sz_sessionmask = (const char*)[dpkapp.localUserModel.sessionMask cStringUsingEncoding:enc];
            const char* sz_userpwd =(const char*)[dpkapp.localUserModel.userLogonPwd cStringUsingEncoding:NSASCIIStringEncoding];
            const char* sz_roompwd =(const char*)[@"" cStringUsingEncoding:NSASCIIStringEncoding];
            //发送加入房间请求
            [self.socketObj SendJoinRoomReq:0 RoomID:dpkapp.tempJoinRoomInfo.roomId UserID:dpkapp.localUserModel.userID SessionMask:sz_sessionmask UserPwd:sz_userpwd RoomPwd:sz_roompwd IsReconnect:0 IsHide:_isHide isMobile:2];

            //房间连接标志
            self.roomObj.isConnected = 0;
            self.lastJoinRoomTime =time(0);
        }
        else if(dpkapp.localUserModel.nextAction == USER_NEXTACTION_CREATEMBROOM)
        {
            //这里不重置nextAction状态,只有创建成功后再重置
            TempCreateRoomInfo* createRoomInfo = dpkapp.tempCreateRoomInfo;
            
            NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            //NSString *blankText = @"sevensoft is a mobile software outsourcing company";
            //char *ptr = [blankText cStringUsingEncoding:NSASCIIStringEncoding];
            const char* roomName =(const char*)[createRoomInfo.roomName cStringUsingEncoding:enc];
            //发送创建房间请求
            [self.socketObj SendCreateRoomReq:dpkapp.localUserModel.userID RoomServerId:createRoomInfo.serverId RoomName:roomName UserPwd:""];
            self.lastCreateRoomTime =time(0);
        }
    }
}

- (void) OnDPKEventTCPSocketShut:(int)reason_code
{
    _isConnected = NO;
    _isConnecting = NO;
    self.roomObj.isConnected = 0;
    if(self.roomObj.connectedCount >0) {
        //聊天区域 提示连接失败,等待定时器重连
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:@"房间断开连接,尝试重新连接"];
        [self.messageTableView sendMessage:model];
        
        //断开音视频发送和播放
        [self onPushStream:NO];
        [self onPlayStream:NO URL:nil RotateDegree:0];
    }
}


//各种业务回文回调函数
//创建房间响应(主播端)
- (void) OnNetMsg_CreateRoomResp:(int)error_code
                          UserID:(int)userId
                          RoomID:(int)roomId
                       CreatorID:(int)creatorId
                        RoomName:(NSString*)roomName
                      ServerAddr:(NSString*)serverAddr
                        GateAddr:(NSString*)gateAddr
                       MediaAddr:(NSString*)mediaAddr
                      ServerPort:(int)serverPort
{
    NSLog(@"OnNetMsg_CreateRoomResp");
    self.lastCreateRoomTime = 0;
    if(error_code !=0) {
        //创建房间失败,关闭loading,提示错误,退出房间
        [self showCreateFailedDialog];
    }
    else {
        //连接房间服务器
        LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
        TempJoinRoomInfo* joinRoomInfo = [DPK_NW_Application sharedInstance].tempJoinRoomInfo;
        [joinRoomInfo reset];
        joinRoomInfo.roomId = roomId;
        joinRoomInfo.roomName = roomName;
        [joinRoomInfo setGateAddr2:gateAddr];
        
        //NSString *blankText = @"sevensoft is a mobile software outsourcing company";
        //char *ptr = [blankText cStringUsingEncoding:NSASCIIStringEncoding];
        const char* logonPwd =[userData.userLogonPwd cStringUsingEncoding:NSASCIIStringEncoding];
        const char* session_mask =[userData.sessionMask cStringUsingEncoding:NSASCIIStringEncoding];
        const char* sz_roompwd =(const char*)[@"" cStringUsingEncoding:NSASCIIStringEncoding];
        //修改nextAction 以后变为加入房间请求(断线重连时使用)
        userData.nextAction = USER_NEXTACTION_JOINROOM;
        self.roomObj.isConnected = 0;
        self.roomObj.isJoinRoomFinished = 0;
        [self.socketObj SendJoinRoomReq:1 RoomID:roomId UserID:userData.userID SessionMask:session_mask UserPwd:logonPwd RoomPwd:sz_roompwd IsReconnect:0 IsHide:_isHide isMobile:2];
//        [self.socketObj SendJoinRoomReq:1 RoomID:roomId UserID:userData.userID SessionMask:session_mask UserPwd:logonPwd];
        self.lastJoinRoomTime =time(0);
    }
}

//上手机麦响应(手机版)
-(void)OnNetMsg_UpMBMicResp:(int)error_code
                     UserID:(int)userId
                     RoomID:(int)roomId
              UserRoomState:(int)userRoomState
                   TLStatus:(int)tlStatus
                TLMediaUrl1:(NSString*)tlMediaUrl1
                TLMediaUrl2:(NSString*)tlMediaUrl2
{
    _player.scalingMode = MPMovieScalingModeAspectFill;
    NSLog(@"OnNetMsg_UpMBMicResp");
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    if(error_code !=0) {
        //TODO:上麦失败，提示客户端
        NSLog(@"主播上麦失败!!!!!");
    }
    else if(userId == userData.userID)  {
        NSLog(@"主播上麦成功，开始上传数据!");
        NSLog(@"上传地址:%@",tlMediaUrl1);
        NSLog(@"下发地址:%@",tlMediaUrl2);
        //自己先改变下房间状态，因为后面要检查
        ClientUserModel* userObj = [self.roomObj findMember:userId];
        userObj.inRoomState = userRoomState;
        userObj.mbTLstatus = 0;
        userObj.pushStreamUrl = tlMediaUrl1;
        userObj.pullStreamUrl = tlMediaUrl2;
        _pushStreamUrl = [NSURL URLWithString:tlMediaUrl1];
        [self onPushStream:YES];
    }
}

//上手机麦通知(手机版)
-(void)OnNetMsg_UpMBMicNoty:(int)userId
                     RoomID:(int)roomId
              UserRoomState:(int)userRoomState
                   TLStatus:(int)tlStatus
                TLMediaUrl1:(NSString*)tlMediaUrl1
                TLMediaUrl2:(NSString*)tlMediaUrl2
{
    NSLog(@"OnNetMsg_UpMBMicNoty");
    ClientUserModel* userObj = [self.roomObj findMember:userId];
    LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
    if(userObj != nil) {
        userObj.inRoomState = userRoomState;
        userObj.mbTLstatus = tlStatus;
        userObj.pushStreamUrl = tlMediaUrl1;
        userObj.pullStreamUrl = tlMediaUrl2;
        if([self.roomObj findOnMicUser:userId] == nil) {
            [self.roomObj.onMicUserList addObject:userObj];
            [self.onMicUsersHeadView reloadData];
        }
        for (int index = 0; index < self.roomObj.onMicUserList.count; index ++) {
            ClientUserModel *user = [self.roomObj.onMicUserList objectAtIndex:index];
            if (user.userId == userId) {
                nowIndex = index;
                
                [_onMicUsersHeadView reloadData];
            }
        }
        if (userId == myModel.userID) {
            [self.socketObj sendMicStatusModifyReq:self.roomObj.roomId userId:userId status:1];
            [self.socketObj sendMicStatusModifyReq:self.roomObj.roomId userId:userId status:3];
        }
    }
}

//下手机麦响应(手机版)
-(void)OnNetMsg_DownMBMicResp:(int)error_code
                       UserID:(int)userId
                       RoomID:(int)roomId
                UserRoomState:(int)userState
{
    NSLog(@"OnNetMsg_DownMBMicResp");
}

//下手机麦通知(手机版)
-(void)OnNetMsg_DownMBMicNoty:(int)userId
                       RoomID:(int)roomId
                UserRoomState:(int)userRoomState
{
    NSLog(@"OnNetMsg_DownMBMicNoty");
    ClientUserModel* userObj = [self.roomObj findMember:userId];
    if(userObj != nil) {
        userObj.inRoomState = userRoomState;
    }
    [self.roomObj delOnMicUser:userId];
    
    if (userId == self.userObj.userId) {
        [[GTAlertTool shareInstance] showAlert:@"您观看的主播已下麦" message:@"请选择其他主播" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
            _playerId = 0;
            [self.anchorView reset];
            [self onPlayStream:NO URL:nil RotateDegree:0];
            
        }];
    }else{
        for (int index = 0; index < self.roomObj.onMicUserList.count; index ++ ) {
            ClientUserModel *model = [self.roomObj.onMicUserList objectAtIndex:index];
            if (userId == model.userId) {
                _nowRow = index;
            }
        }
    }
    LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
    if (_createFlag) {
        for (int index = 0; index < self.roomObj.onMicUserList.count; index ++ ) {
            if (userId == myModel.userID) {
                _nowRow = index;
            }
        }
    }
    [self.onMicUsersHeadView reloadData];
}

//设置推流状态响应(手机版)
-(void)OnNetMsg_SetMBTLStatusResp:(int)error_code
                           UserID:(int)userId
                           RoomID:(int)roomId
                         TLStatus:(int)tlStatus
{
    NSLog(@"OnNetMsg_SetMBTLStatusResp");
}

//设置推流状态通知(手机版)
-(void)OnNetMsg_SetMBTLStatusNoty:(int)userId
                           RoomID:(int)roomId
                         TLStatus:(int)tlStatus
{
    NSLog(@"OnNetMsg_SetMBTLStatusNoty");
    //收到推流状态变化，
    NSLog(@"收到用户[%d]的推流状态变化:%d", userId, tlStatus);
    ClientUserModel* userObj = [self.roomObj findMember:userId];
    if(userObj !=nil)
    {
        userObj.mbTLstatus = tlStatus;
        
        //获取用户的麦状态
        int rotateDegree = 0;
        int mic_state = userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK;
        switch (mic_state) {
            case FT_USERROOMSTATE_MIC_GUAN:
            case FT_USERROOMSTATE_MIC_GONG:
            case FT_USERROOMSTATE_MIC_SI:
            case FT_USERROOMSTATE_MIC_MI:
            case FT_USERROOMSTATE_MIC_LIWU:
                rotateDegree = 180;
                break;
            default:
                break;
        }

        //如果该用户等于当前观看主播，自动打开播放器播放
        if(self.playerId == userId && tlStatus == 3) {
            [self onPlayStream:YES URL:userObj.pullStreamUrl RotateDegree:rotateDegree];
        }
    }
}

//加入房间响应
-(void) OnNetMsg_JoinRoomResp:(int)error_code
                    VersionID:(int)VersionId
                       UserID:(int)userId
                        VcbID:(int)vcbId
                    CreatorID:(int)creatorId
                   OPUserID01:(int)opUserId01
                   OPUserID02:(int)opUserId02
                   OPUserID03:(int)opUserId03
                   OPUserID04:(int)opUserId04
                   OPUserID05:(int)opUserId05
                   OPUserID06:(int)opUserId06
                    RoomState:(int)roomState
                   LayoutType:(int)layoutType
                   RoomAttrId:(int)roomAttId
                  Reserved_01:(int)reserved_01
                  Reserved_02:(int)reserved_02
                     RoomName:(NSString *)roomName
                  MediaServer:(NSString *)mediaServer
                RoomIsUsedPwd:(int)roomIsUsedPwd
                     VipLevel:(int)vipLevel
                  PlayerLevel:(int)playerLevel
                    RoomLevel:(int)roomLevel
                UserRoomState:(int)userRoomState
                           NK:(int64_t)nk
                           NB:(int64_t)nb
                       Ngende:(int)ngende{
    NSLog(@"OnNetMsg_JoinRoomResp");
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    self.lastJoinRoomTime = 0;
    NSLog(@"usedPwd == %d",roomIsUsedPwd);
    NSString* strErrorMsg;
    if(error_code !=0) {
        NSLog(@"加入房间出现错误,就不用重试了,直接提示,退出!");
        
        if(error_code == 407) {
            self.roomObj.isConnected = 0;
            self.roomObj.isJoinRoomFinished = 0;
            self.roomObj.connectedCount = 0; //防止自动重连
            [self.socketObj CloseSocket:0];
            self.isConnecting = NO;
            self.isConnected = NO;
            strErrorMsg = @"内核版本错误,请安装最新客户端!";
            [self showJoinFailedDialog:strErrorMsg];
        }
        else if(error_code == 408) {
            strErrorMsg =@"请输入房间密码";
            [self showAlertRoomPwd];
            _wrongCount++;
        }
        else if(error_code == 402) {
            self.roomObj.isConnected = 0;
            self.roomObj.isJoinRoomFinished = 0;
            self.roomObj.connectedCount = 0; //防止自动重连
            [self.socketObj CloseSocket:0];
            self.isConnecting = NO;
            self.isConnected = NO;
            strErrorMsg = @"用户密码错误!";
            [self showJoinFailedDialog:strErrorMsg];
        }
        else if(error_code == 404) {
            self.roomObj.isConnected = 0;
            self.roomObj.isJoinRoomFinished = 0;
            self.roomObj.connectedCount = 0; //防止自动重连
            [self.socketObj CloseSocket:0];
            self.isConnecting = NO;
            self.isConnected = NO;
            strErrorMsg = @"用户不存在!";
            [self showJoinFailedDialog:strErrorMsg];
        }
        else {
            strErrorMsg = [NSString stringWithFormat:@"加入直播间失败(errcode=%d)!", error_code];
            [self showJoinFailedDialog:strErrorMsg];
        }
        
        
    }
    else {
        NSLog(@"加入房间成功!");
        self.roomObj.connectedCount++;
        self.roomObj.isConnected =1;
        //设置房间信息
        self.roomObj.roomId = vcbId;
        self.roomObj.roomName = roomName;
        self.roomObj.creatorId = creatorId;
        //设置本地用户信息
        userData.nk = nk;
        userData.nb = nb;
        //更新礼物面板用户余额
        [self.giftView updateUserMoney:userData.nk NB:userData.nb];
    }
}

//获取房间用户列表
-(void) OnNetMsg_RoomUserListBegin
{
    NSLog(@"OnNetMsg_RoomUserListBegin");
    [self.roomObj clearMember];
//    [self.membersHeadView reloadData];
}
//房间用户信息结构
-(void)OnNetMsg_RoomUserListItem:(int)roomId
                          UserID:(int)userId
                          Gender:(int)gender
                        VipLevel:(int)vipLevel
                     PlayerLevel:(int)playerLevel
                       RoomLevel:(int)roomLevel
                     InRoomState:(int)inroomstate
                        ComeTime:(int)comeTime
                          SealID:(int)sealId
                 SealExpiredTime:(int)sealExpiredTime
                           CarID:(int)carId
                        param_01:(int)param_01 
                       UserAlias:(NSString *)userAlias
                     UserHeadPic:(NSString *)userHeadPic
                    nVideoStatus:(int)nVideoStatus
                    nAudioStatus:(int)nAudioStatus
                    szcidiograph:(NSString*)szcidiograph
{
    NSLog(@"OnNetMsg_RoomUserListItem");
//    NSLog(@"inroomstate == %d",inroomstate);
    ClientConfigParam* clientConfig = [DPK_NW_Application sharedInstance].clientConfigParam;
    
    ClientUserModel* userObj = [[ClientUserModel alloc]init];
    userObj.userId = userId;
    userObj.inRoomState = inroomstate;
    userObj.vipLevel = vipLevel;
    userObj.roomLevel = roomLevel;
    userObj.playerLevel = playerLevel;
    userObj.mbTLstatus = 0;
    userObj.nk = 0;
    userObj.nb = 0;
    userObj.userAlias = userAlias;
    userObj.userSmallHeadPic = [NSString stringWithFormat:@"%@%@", clientConfig.userHeadPicPrefix,userHeadPic];
    userObj.userBigHeadPic =@"";
    userObj.pushStreamUrl = @"";
    userObj.pullStreamUrl =@"";
    userObj.isVideoStatus = nVideoStatus;
    userObj.isAudioStatus = nAudioStatus;
    userObj.param_01 = param_01;
    userObj.szcidiograph = szcidiograph;
    NSLog(@"szcidiograph == %@",szcidiograph);
    if([self.roomObj findMember:userId] == nil) {
        if (!((inroomstate & FT_USERROOMSTATE_HIDEIN) !=0)) {
            //隐身登录
            [self.roomObj addMember:userObj];
        }
        [self.roomObj addaAllMember:userObj];
        
        if ((inroomstate & FT_USERROOMSTATE_SIEGE1) != 0) {
            //市长
            userObj.vipLevel = 501;
            
        }else if ((inroomstate & FT_USERROOMSTATE_SIEGE2) != 0){
            //市长夫人
            userObj.vipLevel = 500;
        }
    }
    int ismic = inroomstate & FT_USERROOMSTATE_MIC_MASK;
    NSLog(@"ismic == %d",ismic);
    if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == 0) {
        //普通用户
        NSLog(@"普通用户");
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_GONG){
        //公麦
        NSLog(@"公麦");
        userObj.micState = 1;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_MBSI){
        //私麦
        NSLog(@"私麦");
        userObj.micState = 7;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_SI){
        userObj.micState = 3;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_MI){
        //密麦(手机不可看)
        userObj.micState = 4;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_LIWU){
        //礼物麦(手机不可看)
        userObj.micState = 6;
    }
    
}

-(void) OnNetMsg_RoomUserListEnd {
    NSLog(@"OnNetMsg_RoomUserListEnd");
//    [self.membersHeadView reloadData];
}

//获取房间在麦用户列表
-(void)OnNetMsg_RoomOnMicUserListBegin
{
    NSLog(@"OnNetMsg_RoomOnMicUserListBegin");
    [self.roomObj clearOnMicUser];
    [self.onMicUsersHeadView reloadData];
    
}

-(void)OnNetMsg_RoomOnMicUserListItem:(int)roomId
                               UserID:(int)userId
                        UserRoomState:(int)userRoomState
                             VipLevel:(int)vipLevel
                          PlayerLevel:(int)playerLevel
                            RoomLevel:(int)roomLevel
                             TLStatus:(int)tlStatus
                             UserName:(NSString*)userName
                          TLMediaUrl1:(NSString*)tlMediaUrl1
                          TLMediaUrl2:(NSString*)tlMediaUrl2
{
    NSLog(@"OnNetMsg_RoomOnMicUserListItem");
    ClientUserModel* userObj = [self.roomObj findMember:userId];
//    [_arrAmchorList addObject:userObj];
//    _anchorListView.arrayAnchor = _arrAmchorList;
//    NSLog(@"_arrAmchorList == %@",_arrAmchorList);
//    [_anchorListView.tableView reloadData];
    if(userObj != nil)
    {
        userObj.inRoomState = userRoomState;
        userObj.mbTLstatus = tlStatus;
        userObj.pushStreamUrl = tlMediaUrl1;
        userObj.pullStreamUrl = tlMediaUrl2;

        [self.roomObj addOnMicUser:userObj];
        
    }
    
    
}

-(void)OnNetMsg_RoomOnMicUserListEnd
{
    self.roomObj.onMicUserList = [self.roomObj sortMicUser:self.roomObj.onMicUserList];
    nowIndex = 0;
    [self.onMicUsersHeadView reloadData];
    GTAFNData *data = [[GTAFNData alloc] init];
    data.delegate = self;
    [data AttentionList];
}


//加入房间结束
-(void) OnNetMsg_JoinRoomFinished {
    self.roomObj.isJoinRoomFinished = 1;
    //关闭loading等待
    [self hideLoadingHud];
    //提示信息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:@"加入房间完成"];
    [self.messageTableView sendMessage:model];
    
    //如果是主播端,主播请求上麦
    if(self.createFlag) {
        LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
        int micType = 0x07;
        int phoneStyle = 2;
        char* phoneDesc = "ios 9.0";
        [self.socketObj SendUpMBMicReq:userData.userID RoomID:self.roomObj.roomId PhoneStyle:phoneStyle MBMicType:micType PhoneInfo:phoneDesc];
        NSLog(@"主播发出上麦请求!");
        //设置主播信息(我自己)
        ClientUserModel* userObj = [self.roomObj findMember:userData.userID];
        NSAssert(userObj!=nil,@"user object must not nil!");
        [self.anchorView setAnchorInfo:userObj.userId UserName:userObj.userAlias UserHeadPic:userObj.userSmallHeadPic];
        NSLog(@"userObj == %@",userObj);

    }
    else {
        
        //找到对应的主播，打开视频连接
        if(_roomObj.roomId !=0 && self.roomObj.onMicUserList.count > 0) {
            for (int index = 0; index < self.roomObj.onMicUserList.count; index++) {
                ClientUserModel *model= [self.roomObj.onMicUserList objectAtIndex:index];
                BOOL canSee = (model.micState != 4) && (model.micState !=6);
                if (canSee) {
                    nowIndex = index;
                    self.playerId = model.userId;
                    ClientUserModel* userObj = [self.roomObj findMember:_playerId];
                    NSLog(@"userObj == %@",userObj);
                    if(userObj != nil) {
                        //设置主播信息
                        [self.anchorView setAnchorInfo:userObj.userId UserName:userObj.userAlias UserHeadPic:userObj.userSmallHeadPic];
                        self.userObj = userObj;
                    }
                    else {
                        //主播不在线
                        MessageModel *model = [[MessageModel alloc] init];
                        [model setModel:@"观看主播不在线"];
                        [self.messageTableView sendMessage:model];
                    }
                    //开始拉流
                    if((userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK) != 0)
                    {
                        //获取用户的麦状态
                        int rotateDegree = 0;
                        int mic_state = userObj.inRoomState & FT_USERROOMSTATE_MIC_MASK;
                        switch (mic_state) {
                            case FT_USERROOMSTATE_MIC_GUAN:
                            case FT_USERROOMSTATE_MIC_GONG:
                            case FT_USERROOMSTATE_MIC_SI:
                            case FT_USERROOMSTATE_MIC_MI:
                            case FT_USERROOMSTATE_MIC_LIWU:
                                rotateDegree = 180;
                                break;
                            default:
                                break;
                        }
                        
                        if(userObj.mbTLstatus == 3) {
                            nowIndex = index;
                            [self onPlayStream:YES URL:userObj.pullStreamUrl RotateDegree:rotateDegree];
                        }
                    }
                    return;
                }else{
                    nowIndex = -1;
                    [_onMicUsersHeadView reloadData];
                }
            }
        }
    }
}

//房间信息(变化)通知
-(void) OnNetMsg_RoomInfoNoty:(int)errroCode
                     RunnerID:(int)runnerId
                       RoomID:(int)roomId
                    CreatorID:(int)creatorId
                     OpUser01:(int)opUser01
                     OpUser02:(int)opUser02
                     OpUser03:(int)opUser03
                     OpUser04:(int)opUser04
                     OpUser05:(int)opUser05
                     OpUser06:(int)opUser06
                      OpState:(int)opState
                     RoomName:(NSString*)roomName
                    IsUsedPwd:(int)isUsedPwd
{
    if(self.roomObj.roomId == roomId)
    {
        self.roomObj.creatorId = creatorId;
        self.roomObj.op1 = opUser01;
        self.roomObj.op2 = opUser02;
        self.roomObj.op3 = opUser03;
        self.roomObj.op4 = opUser04;
        self.roomObj.op5 = opUser05;
        self.roomObj.op6 = opUser06;
        self.roomObj.roomName = roomName;
    }
}

//房间公告(变化)通知
-(void) OnNetMsg_RoomNoticeNoty:(int)errorCode
                       RunnerID:(int)runnerId
                         RoomID:(int)roomId
                        TextLen:(int)textLen
                      TextIndex:(int)textIndex
                           Text:(NSString*)text
{
    if(errorCode ==0 && self.roomObj.roomId == roomId) {
        if(textIndex == 0)
            self.roomObj.notice1 = text;
        else if(textIndex == 1)
            self.roomObj.notice2 = text;
        else if(textIndex == 2)
            self.roomObj.notice3 = text;
        else if(textIndex == 3)
            self.roomObj.notice4 = text;
        //系统提示
        if(text.length >0) {
            NSLog(@"%@", text);
            MessageModel *model = [[MessageModel alloc] init];
            [model setModel:text];
            [self.messageTableView sendMessage:model];
        }
        
    }
    
}

//房间媒体服务器变化通知
-(void) OnNetMsg_RoomMediaServerNoty:(int)errorCode
                              RoomID:(int)roomId
                        MediaSvrAddr:(NSString*)mediaSvrAddr
{
    //do nothing
}

//新用户进入通知

-(void) OnNetMsg_RoomUserComeNoty:(int)roomId
                           UserID:(int)userId
                           Gender:(int)gender
                         VipLevel:(int)vipLevel
                      PlayerLevel:(int)playerLevel
                        RoomLevel:(int)roomLevel
                      InRoomState:(int)inroomstate
                         ComeTime:(int)comeTime
                           SealID:(int)sealId
                  SealExpiredTime:(int)sealExpiredTime
                           CardID:(int)cardId
                         param_01:(int)param_01
                        UserAlias:(NSString *)userAlias
                      UserHeadPic:(NSString *)userHeadPic
                      videoStatus:(int)videoStatus
                      audioStatus:(int)audioStatus
                     szcidiograph:(NSString *)szcidiograph
{
    ClientConfigParam* clientConfig = [DPK_NW_Application sharedInstance].clientConfigParam;
    
    ClientUserModel* userObj = [[ClientUserModel alloc]init];
    userObj.userId = userId;
    userObj.inRoomState = inroomstate;
    userObj.vipLevel = vipLevel;
    userObj.roomLevel = roomLevel;
    userObj.playerLevel = playerLevel;
    userObj.mbTLstatus = 0;
    userObj.nk = 0;
    userObj.nb = 0;
    userObj.userAlias = userAlias;
    userObj.userSmallHeadPic = [NSString stringWithFormat:@"%@%@", clientConfig.userHeadPicPrefix,userHeadPic];
    userObj.userBigHeadPic =@"";
    userObj.pushStreamUrl = @"";
    userObj.pullStreamUrl =@"";
    userObj.param_01 = param_01;
    userObj.szcidiograph = szcidiograph;
    NSLog(@"param_01 == %d",param_01);
    NSLog(@"inroomstate == %d",inroomstate);
    if([self.roomObj findAllMember:userId] == nil) {
        [self.roomObj addaAllMember:userObj];
        //        [self.membersHeadView reloadData];
    }
    //所有用户都提示
    int ishide = inroomstate & FT_USERROOMSTATE_HIDEIN;
    if (ishide != 0) {//隐身
        NSLog(@"%d隐身登陆了",userId);
    }else{
        if([self.roomObj findMember:userId] == nil) {
            [self.roomObj addMember:userObj];
            //        [self.membersHeadView reloadData];
        }
        NSString* sysTipText;
        if(userObj.userId == self.playerId) {
            sysTipText= [NSString stringWithFormat:@"%@ 主播上线了",userObj.userAlias];
        }
        else {
            sysTipText = [NSString stringWithFormat:@"%@ 来了,欢迎~",userObj.userAlias];
        }
        if (!_isEnterHide) {
            MessageModel *model = [[MessageModel alloc] init];
//            [model setModel:sysTipText];
            [model setModelWithId:[NSString stringWithFormat:@"%d",userObj.userId] name:userObj.userAlias type:CellEnterType level:vipLevel];
            [self.messageTableView sendMessage:model];
        
        }
    }
    
    int ismic = inroomstate & FT_USERROOMSTATE_MIC_MASK;
    NSLog(@"ismic == %d",ismic);
    if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == 0) {
        //普通用户
//        NSLog(@"普通用户");
        userObj.micState = 0;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_GONG){
        //公麦
//        NSLog(@"公麦");
        userObj.micState = 1;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_MBSI){
        //手机麦
//        NSLog(@"私麦");
        userObj.micState = 7;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_SI){
        //私麦
        userObj.micState = 3;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_MI){
        //密麦(手机不可看)
        userObj.micState = 4;
    }else if ((inroomstate & FT_USERROOMSTATE_MIC_MASK) == FT_USERROOMSTATE_MIC_LIWU){
        //礼物麦(手机不可看)
        userObj.micState = 6;
    }
}

//用户聊天通知
-(void)OnNetMsg_RoomChatMsgNoty:(int)roomId
                          SrcID:(int)srcId
                           ToID:(int)toId
                        MsgType:(int)msgType
                        TextLen:(int)textLen
                   SrcUserAlias:(NSString *)srcUserAlias
                    ToUserAlias:(NSString *)toUserAlias
                    ChatContent:(NSString *)chatContent
                          error:(int)error
{
    NSLog(@"error == %d",error);
    
    int level = 0;
    NSArray *arrName = self.roomObj.memberList;
    for (int i = 0; i<arrName.count; i++) {
        ClientUserModel *model = [arrName objectAtIndex:i];
        if (toId == model.userId) {
            toUserAlias = model.userAlias;
        }
        if (srcId == model.userId) {
            level = model.vipLevel;
            srcUserAlias = model.userAlias;
        }
    }
//    NSLog(@"srcId == %d",srcId);
//    NSLog(@"toId == %d",toId);
//    NSLog(@"msgType == %d",msgType);
//    NSLog(@"chatContent == %@",chatContent);
//    NSLog(@"toUserAlias == %@",toUserAlias);
//    NSLog(@"srcUserAlias == %@",srcUserAlias);
    //聊天区域显示
    if (msgType == 1) {//公聊
        NSString* chatContent2 = [NSString filterHTML:chatContent];
        MessageModel *model = [[MessageModel alloc] init];
        model.cellType = CellNewChatMessageType;
        [model setModel:[NSString stringWithFormat:@"%d",srcId] withName:srcUserAlias withIcon:nil withType:CellNewChatMessageType withMessage:chatContent2 toUserAlias:(NSString *)toUserAlias toId:toId level:level];
        [self.messageTableView sendMessage:model];
    }else if(msgType == 2){//私聊
        //userId:
        //userAlias:
        //message(arr):
                //msg:
                //isMe:
        LocalUserModel *model = [DPK_NW_Application sharedInstance].localUserModel;
        int myId = model.userID;
        int count = -1;
        if (myId == srcId) {//isMe == 1
            for (int index = 0; index < _arrPrivate.count; index ++ ) {
                int userId = [[_arrPrivate[index] objectForKey:@"userId"] intValue];
                if (toId == userId) {
                    count = index;
                    break;
                }
            }
            ClientUserModel* userObj = [self.roomObj findMember:toId];
            if (userObj.userId == 0) {
                [[GTAlertTool shareInstance]showAlert:@"消息发送失败" message:@"对方已退出房间" cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                    return ;
                }];
            }else{
                if (count == -1) {
                    NSString* chatContent2 = [NSString filterHTML:chatContent];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chatContent2, @"msg", @"1", @"isMe", nil];
                    NSArray *arrMsg = [NSArray arrayWithObjects:dic, nil];
                    NSDictionary *dicAll = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",toId], @"userId", toUserAlias, @"userAlias", arrMsg, @"message",userObj.userSmallHeadPic, @"image", nil];
                    [_arrPrivate addObject:dicAll];
                    _nowRow = [[NSString stringWithFormat:@"%lu",(unsigned long)_arrPrivate.count] intValue]-1;
                }else{
                    NSString* chatContent2 = [NSString filterHTML:chatContent];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chatContent2, @"msg", @"1", @"isMe", nil];
                    NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[_arrPrivate objectAtIndex:count] objectForKey:@"message"]];
                    [arrMsg addObject:dic];
                    NSDictionary *dicAll = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",toId], @"userId", toUserAlias, @"userAlias", arrMsg, @"message",userObj.userSmallHeadPic, @"image", nil];
                    [_arrPrivate replaceObjectAtIndex:count withObject:dicAll];
                    _nowRow = count;///2
                }
            }
        }else if (myId == toId){
            for (int index = 0; index < _arrPrivate.count; index ++ ) {
                int userId = [[_arrPrivate[index] objectForKey:@"userId"] intValue];
                if (srcId == userId) {
                    count = index;
                    break;
                }
            }
            ClientUserModel* userObj = [self.roomObj findMember:srcId];
            if (count == -1) {
                NSString* chatContent2 = [NSString filterHTML:chatContent];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chatContent2, @"msg", @"0", @"isMe", nil];
                NSArray *arrMsg = [[NSArray alloc] initWithObjects:dic, nil];
                NSString *strName = userObj.userAlias;
                if (userObj == nil) {
                    strName = @"天外贵宾";
                }
                NSDictionary *dicAll = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",srcId],@"userId",
                                        strName, @"userAlias",
                                        arrMsg, @"message",
                                        @"", @"image", nil];

                [_arrPrivate addObject:dicAll];
                _nowRow = [[NSString stringWithFormat:@"%lu",(unsigned long)_arrPrivate.count] intValue]-1;
            }else{
                NSString* chatContent2 = [NSString filterHTML:chatContent];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:chatContent2, @"msg", @"0", @"isMe", nil];
                NSMutableArray *arrMsg = [NSMutableArray arrayWithArray:[[_arrPrivate objectAtIndex:count] objectForKey:@"message"]];
                [arrMsg addObject:dic];NSString *strName = userObj.userAlias;
                if (userObj == nil) {
                    strName = @"天外贵宾";
                }
                NSDictionary *dicAll = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",srcId], @"userId", strName, @"userAlias", arrMsg, @"message",userObj.userSmallHeadPic, @"image", nil];
                [_arrPrivate replaceObjectAtIndex:count withObject:dicAll];
                _nowRow = count;
            }
        }
        NSLog(@"arr == %@",_arrPrivate);
        _chatPrivateView.nowRow = self.nowRow;
        _chatPrivateView.arrChatMessage = [NSMutableArray arrayWithArray:_arrPrivate];
        [_chatPrivateView reloadDateForTableView];
//        if (<#condition#>) {
//            <#statements#>
//        }
    }else if (msgType == 3){//公告
        NSString *strToId = [NSString stringWithFormat:@"%d",toId];
        NSString* chatContent2 = [NSString filterHTML:chatContent];
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:strToId withName:srcUserAlias withIcon:nil withType:CellNoticeType
            withMessage:chatContent2 toUserAlias:toUserAlias toId:toId level:0];
        [self.messageTableView sendMessage:model];
    }
    

}

//用户赠送礼物响应
-(void)OnNetMsg_RoomSendGiftResp:(int)error_code
{
    if(error_code != 0) {
    //NSString* strText =[NSString stringWithFormat:@"赠送礼物失败(errcode=%d)", error_code];
    NSString* strText =@"余额不足，赠送礼物失败!";
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:strText];
    [self.messageTableView sendMessage:model];
    }
    
}

//用户赠送礼物通知
-(void)OnNetMsg_RoomSendGiftNoty:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                          GiftID:(int)giftId
                         GiftNum:(int)giftNum
                           flyId:(int)flyId
                         TextLen:(int)textLen
                    SrcUserAlias:(NSString*)srcUserAlias
                     ToUserAlias:(NSString*)toUserAlias
                        GiftText:(NSString*)giftText
{
    int level = 0;
    NSArray *arrName = self.roomObj.allMemberList;
    for (int i = 0; i<arrName.count; i++) {
        ClientUserModel *model = [arrName objectAtIndex:i];
        if (srcId == model.userId) {
            level = model.vipLevel;
        }
    }
    if (flyId >= 0) {
        if (!_flyView.hidden) {
            [_flyView removeFromSuperview];
        }
        //跑道显示
        _flyView = [[FlyView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH*3/4, 18)];
        if (kIs_iPhoneX) {
            _flyView.frame = CGRectMake(0, 94, SCREEN_WIDTH*3/4, 18);
        }
        [self.view addSubview:self.flyView];//跑道
        _flyView.strToName = toUserAlias;
        _flyView.strSrcName = srcUserAlias;
        NSArray *array = [NSArray arrayWithArray:[DPK_NW_Application sharedInstance].giftList];
        for (int index = 0; index < array.count; index ++ ) {
            GTGiftListModel *model = array[index];
            if (model.giftId == giftId) {
                _flyView.strGiftName = model.name;
                break;
            }
        }
        _flyView.giftNum = giftNum;
        [_flyView paomadeng];
//        DKScrollTextLable *lab = [[DKScrollTextLable alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH*3/4, 18)];
//        lab.text = @"1234";
//        [self.view addSubview:lab];
    }
    //聊天框显示
    //聊天区域和礼物区域显示
    NSLog(@"giftID == %d",giftId);
    MessageModel *model = [[MessageModel alloc] init];
    NSString* strSrcId = [NSString stringWithFormat:@"%d", srcId];
    GTGiftListModel* giftInfo = [[DPK_NW_Application sharedInstance] findGiftConfig:giftId];
    NSLog(@"giftInfo == %@",giftInfo);
    NSString* strGiftId = [NSString stringWithFormat:@"%d", giftId];
    NSString* strGiftName = [NSString stringWithFormat:@"未知礼物(%d)", giftId];
    NSString* strGiftNum =[NSString stringWithFormat:@"%d", giftNum];
    if(giftInfo !=nil) {
        strGiftName = giftInfo.name;
    }
    
    NSString* strToId = [NSString stringWithFormat:@"%d", srcId];
    NSString* strToName = [NSString stringWithFormat:@"%d", toId];
    BOOL hidding = NO;
    if(toId == 0)
        strToName = @"大家";
    ClientUserModel* srcUserObj= [self.roomObj findMember:srcId];
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    if(srcUserObj !=nil) {
        srcUserAlias = srcUserObj.userAlias;
    }else{
        srcUserAlias = @"天外贵宾";
        hidding = YES;
        if (srcId == toId) {
            strToName = @"天外贵宾";
        }
        if (srcId == userData.userID || toId == userData.userID) {
            ClientUserModel *srcAllUserObj= [self.roomObj findAllMember:srcId];
            srcUserAlias = [NSString stringWithFormat:@"[隐]%@",srcAllUserObj.userAlias];
            if (srcId == toId) {
                strToName = [NSString stringWithFormat:@"[隐]%@",srcAllUserObj.userAlias];
            }
        }
    }
    ClientUserModel* toUserObj = [self.roomObj findMember:toId];
    if(toUserObj !=nil) {
        strToName = toUserObj.userAlias;
    }
    
    
    
//    if(userData.userID == toId && srcId == toId){
//        strToName = @"你";
//        ClientUserModel *srcAllUserObj= [self.roomObj findAllMember:srcId];
//        if(srcUserObj ==nil && srcAllUserObj !=nil) {
//            srcUserAlias = [NSString stringWithFormat:@"[隐]%@",srcAllUserObj.userAlias];
//            hidding = YES;
//        }
//    }
    
    
    if (!_isGiftHide) {
        [model setModel:strSrcId withName:srcUserAlias withIcon:nil withType:CellNewGiftType withGiftId:strGiftId withGiftName:strGiftName withGiftNum:strGiftNum withToId:[NSString stringWithFormat:@"%d",toId] withToName:strToName level:level hide:hidding];
        [self.messageTableView sendMessage:model];
    }
    if (!_isAnimationHide) {
        //    WEAKSELF;
        PresentModel *presentModel = [[PresentModel alloc] init];
        presentModel.sender = srcUserAlias;
        presentModel.toName = toUserAlias;
        presentModel.giftName = strGiftName;
        presentModel.icon = giftInfo.pic_thumb;
        presentModel.giftImageName = giftInfo.pic_original;
        //    presentModel.giftNumber = giftNum;
        presentModel.giftNumber = giftNum;
        [self.presentView insertPresentMessages:@[presentModel]showShakeAnimation:1];
    }
}

//获取用户帐户信息响应
-(void)OnNetMsg_GetUserAccoutResp:(int)error_code
{
    
}

//获取用户账户通知
-(void)OnNetMsg_UserAccountNoty:(int)userId
                             NK:(int64_t)nk
                             NB:(int64_t)nb
{
    LocalUserModel* userData =[DPK_NW_Application sharedInstance].localUserModel;
    if(userId == userData.userID) {
        userData.nk = nk;
        userData.nb = nb;
        //TODO:更新礼物面板用户余额
        [self.giftView updateUserMoney:userData.nk NB:userData.nb];
    }
    
}

//用户退出房间响应
-(void)OnNetMsg_ExitRoomResp:(int)error_code
{
    NSLog(@"OnNetMsg_ExitRoomResp");
    
}

//用户退出房间通知
-(void)OnNetMsg_ExitRoomNoty:(int)roomId
                      UserID:(int)userId
{
    NSLog(@"OnNetMsg_ExitRoomResp");
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    if(_playerId == userId) {
        self.showView.hidden = NO;
    }
    else {
        //用户离开提示
        ClientUserModel* userObj = [self.roomObj findMember:userId];
        if(userObj != nil &&  !_isQuitHide) {
//            NSString* sysTipText =[NSString stringWithFormat:@"%@ 离开了", userObj.userAlias];
            MessageModel *model = [[MessageModel alloc] init];
//            [model setModel:sysTipText];
            [model setModelWithId:[NSString stringWithFormat:@"%d",userObj.userId] name:userObj.userAlias type:CellLeaveType level:userObj.vipLevel];
            [self.messageTableView sendMessage:model];
        }
        if (self.giftView.userId == userId) {
            [self.giftView delUser:userId];
        }
        //
        [self.roomObj delOnMicUser:userId];
        [self.roomObj delMember:userId];
//        [self.membersHeadView reloadData];
        [self.onMicUsersHeadView reloadData];
    }
}

//用户上PC麦通知
-(void)OnNetMsg_UpMicNoty:(int)RoomId
                 RunnerID:(int)runnerId
                   UserID:(int)userId
                  MicType:(int)micType
                  Param01:(int)param_01
                  Param02:(int)param_02
            UserRoomState:(int)userRoomState
              TLMediaurl1:(NSString*)tlMediaUrl1
              TLMediaurl2:(NSString*)tlMediaUrl2
{
    _player.scalingMode = MPMovieScalingModeAspectFit;
    ClientUserModel* userObj = [self.roomObj findMember:userId];
    userObj.inRoomState = userRoomState;
    userObj.mbTLstatus = 0;
    userObj.pushStreamUrl = tlMediaUrl1;
    userObj.pullStreamUrl = tlMediaUrl2;
    userObj.isAudioStatus = 1;
//    userObj.isVideoStatus = 1;
    //增加到在麦用户列表中
    if(nil == [self.roomObj findOnMicUser:userId]) {
        [self.roomObj addOnMicUser:userObj];
    }
    self.roomObj.memberList = [self.roomObj sortMicUser:self.roomObj.memberList];
    [self.onMicUsersHeadView reloadData];
   
    NSString* sysTipText = [NSString stringWithFormat:@"%@ 上PC麦了(type=%d)",userObj.userAlias, micType];
    MessageModel *model = [[MessageModel alloc] init];
//    [model setModel:sysTipText];
    
    [self.messageTableView sendMessage:model];
}

//用户下PC麦通知
-(void)OnNetMsg_DownMicNoty:(int)RoomId
                   RunnerID:(int)runnerId
                     UserID:(int)userId
              UserRoomState:(int)userRoomState
{
    ClientUserModel* userObj = [self.roomObj findMember:userId];
    
    //从在麦列表中删除
    [self.roomObj delOnMicUser: userId];
    [self.onMicUsersHeadView reloadData];
    
    if (userId == _playerId) {
        _playerId = 0;
        [self.anchorView reset];
        [self onPlayStream:NO URL:nil RotateDegree:0];
    }
    //停止当前的播放器和观看主播设置
    
    
    NSString* sysTipText = [NSString stringWithFormat:@"%@ 下PC麦了",userObj.userAlias];
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:sysTipText];
    [self.messageTableView sendMessage:model];
}

//删除房间响应
-(void)OnNetMsg_DelRoomResp:(int)error_code
                     RoomID:(int)roomId
                   OPUserID:(int)opuserId
{
    //do nothing
}

//删除房间通知
-(void)OnNetMsg_delRoomNoty:(int)roomId
                   OPUserID:(int)opuserId
{
    //do nothing
}

//增加/删除管理响应
-(void)OnNetMsg_RoomAddMgrResp:(int)error_code
                        RoomID:(int)roomId
                         SrcID:(int)srcId
                          ToID:(int)toId
                      ActionID:(int)actionId
{
    //do nothing
}

//增加/删除管理通知
-(void)OnNetMsg_RoomAddMgrNoty:(int)roomId
                         SrcID:(int)srcId
                          ToID:(int)toId
                 UserRoomState:(int)userRoomState
                      ActionID:(int)actionId
{
    //do nothing
}

//禁言/取消禁言响应
-(void)OnNetMsg_RoomForbidUserResp:(int)error_code
                            RoomID:(int)roomId
                             SrcID:(int)srcId
                              ToID:(int)toId
                          ActionID:(int)actionId
{
    //do nothing
}

//禁言/取消禁言通知
-(void)OnNetMsg_RoomForbidUserNoty:(int)roomId
                             SrcID:(int)srcId
                              ToID:(int)toId
                     UserRoomState:(int)userRoomState
                          ActionID:(int)actionId
{
    //do nothing
}

//踢出用户响应
-(void)OnNetMsg_RoomKickUserResp:(int)error_code
                          RoomID:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                        ReasonID:(int)reasonId
{
    //do nothing
}

//踢出用户通知
-(void)OnNetMsg_RoomKickUserNoty:(int)roomId
                           SrcID:(int)srcId
                            ToID:(int)toId
                        ReasonID:(int)reasonId
{
    LocalUserModel* userData =[DPK_NW_Application sharedInstance].localUserModel;
    if(userData.userID == toId) {
        //自己被踢出
        self.roomObj.isConnected = 0; //目的是不发出退出房间请求
        NSString* strText = @"";
        if(reasonId == 701) {
            strText = @"用户超时,被房间请出!";
        }
        else if(reasonId == 702) {
            strText = @"用户异地登录，被房间请出!";
        }
        else {
            strText= @"你被房间请出!如有疑问请联系客服.";
        }
        [self closeRoom2:YES AlertString:strText];
    }
    else {
        //用户离开提示
        ClientUserModel* userObj=[self.roomObj findMember:toId];
        if(userObj != nil) {
            NSString* sysTipText =[NSString stringWithFormat:@"%@ 离开了~", userObj.userAlias];
            MessageModel *model = [[MessageModel alloc] init];
            [model setModel:sysTipText];
            [self.messageTableView sendMessage:model];
        }
        //
        [self.giftView delUser:toId];
        //
        [self.roomObj delOnMicUser:toId];
        [self.roomObj delMember:toId];
//        [self.membersHeadView reloadData];
        [self.onMicUsersHeadView reloadData];
        
    }
}

//全局聊天(小喇叭，各种系统)信息通知
- (void)OnNetMsg_GlobalChatMsgNoty:(int)roomId
                             SrcID:(int)srcId
                              ToID:(int)toId
                          ChatType:(int)chatType
                           TextLen:(int)textLen
                           SrcName:(NSString *)srcName
                            ToName:(NSString *)toName
                          RoomName:(NSString *)roomName
                              Text:(NSString *)text
                          errorMsg:(int)error
{
    NSString *strUserId = [NSString stringWithFormat:@"%d",srcId];
    NSLog(@"srcName == %@\n toName == %d\n roomName == %d\n text == %@\n",srcName,srcId,chatType,text);
    NSString* chatContent2 = [NSString filterHTML:text];
    if (!_isHarnHide) {
        if (chatType == 10) {//系统公告(喇叭)
            MessageModel *model = [[MessageModel alloc] init];
            [model setModel:strUserId withName:srcName withIcon:nil withType:CellSystemHomType withMessage:chatContent2 toUserAlias:toName toId:toId level:0];
            [self.messageTableView sendMessage:model];
        }else if (chatType ==11){//小喇叭
            MessageModel *model = [[MessageModel alloc] init];
            [model setModel:strUserId withName:srcName withIcon:nil withType:CellHomType withMessage:chatContent2 toUserAlias:toName toId:toId level:0];
            [self.messageTableView sendMessage:model];
        }
    }
}

//用户关注回包
-(void)OnNetMsg_UserAttentionResp:(int)nRet
                            nFlag:(int)nFlag
                          nUserID:(int)nUserID
                          nRoomID:(int)nRoomID
                          nSinger:(int)nSinger{
    if (nRet == 0) {
        //操作成功
        if (nFlag == 1) {
            [self.anchorView setAttention:NO];
            [MBProgressHUD showAlertMessage:@"关注成功"];
        }else{
            [self.anchorView setAttention:YES];
            [MBProgressHUD showAlertMessage:@"取关成功"];
        }
    }else{
        if (nFlag ==1) {
            [MBProgressHUD showAlertMessage:@"关注未成功"];
        }else{
            [MBProgressHUD showAlertMessage:@"关注未成功"];
        }
    }
}

/**
 积分兑换回调

 @param vcbId <#vcbId description#>
 @param userId <#userId description#>
 @param money <#money description#>
 */
-(void)OnNetMsg_ScoreChargeResp:(int)vcbId
                         userId:(int)userId
                          money:(int)money{
    LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
    [self.changeScore updateUserMoney:userData.nk NB:userData.nb];
    [self.giftView updateUserMoney:userData.nk NB:userData.nb];
    [MBProgressHUD showAlertMessage:[NSString stringWithFormat:@"您已成功兑换%d金币",money]];
    [UIView animateWithDuration:2.0 animations:^{
        [self.changeScore hide];
    }];
}

//进房间跑道消息通知
-(void)OnNetMsg_trackInfoNoty:(int)roomId
                        srcId:(int)scrId
                         toId:(int)toId
                       giftId:(int)giftId
                      giftNum:(int)giftNum
                        flyId:(int)flyId
                     castMode:(int)castMode
                   serverMode:(int)serverMode
                     hideMode:(int)hideMode
                     sendType:(int)sendType
                   nextAction:(int)nextAction
                      textLen:(int)textLen
                    reserve01:(int)reserve01
                      srcName:(NSString *)srcName
                       toName:(NSString *)toName
                      vcbName:(NSString *)vcbName
                         text:(NSString *)text{
    if (!_flyView.hidden) {
        [_flyView removeFromSuperview];
    }
    _flyView = [[FlyView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH*3/4, 18)];
    if (kIs_iPhoneX) {
        _flyView.frame = CGRectMake(0, 94, SCREEN_WIDTH*3/4, 18);
    }
    [self.view addSubview:self.flyView];//跑道
    _flyView.strToName = toName;
    _flyView.strSrcName = srcName;
    NSArray *array = [NSArray arrayWithArray:[DPK_NW_Application sharedInstance].giftList];
    for (int index = 0; index < array.count; index ++ ) {
        GTGiftListModel *model = array[index];
        if (model.giftId == giftId) {
            _flyView.strGiftName = model.name;
            break;
        }
    }
    _flyView.giftNum = giftNum;
    [_flyView paomadeng];
}

- (void)OnNetMsg_micStatusModifyResp:(int)roomId
                              userId:(int)userId
                              status:(int)status{
//    self.userObj
    for (int index = 0; index < self.roomObj.onMicUserList.count; index ++ ) {
        ClientUserModel *onMicUser = [self.roomObj.onMicUserList objectAtIndex:index];
        LocalUserModel *myModel = [DPK_NW_Application sharedInstance].localUserModel;
        if (onMicUser.userId == userId) {
            
            UILabel *lab = [[UILabel alloc] init];
            lab.text = @"当前观看主播的视频已关闭";
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:22];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.showView addSubview:lab];
            lab.hidden = YES;
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.height.mas_equalTo(30);
                make.center.equalTo(self.view);
            }];
//            lab.hidden = YES;
            if(status == VIDEO_PLAY){//视频播放
                if (userId == self.userObj.userId) {
                    
                    self.showView.hidden = YES;
                    lab.hidden = YES;
                }
            }else if (status == VIDEO_PAUSE){//视频暂停
                if (userId == self.userObj.userId || userId == myModel.userID) {
                    [MBProgressHUD showAlertMessage:@"主播已关闭视频"];
                    self.showView.hidden = NO;
                    lab.hidden = NO;
                }
            }else if (status == AUDIO_PLAY){//音频播放
                onMicUser.isAudioStatus = 0;
                [self.roomObj.onMicUserList replaceObjectAtIndex:index withObject:onMicUser];
                [_onMicUsersHeadView reloadData];
//                if (!_createFlag) {
//                    [_btnReload setHidden:NO];
//                    [_btnReloadBg setHidden:NO];
//                }
//                lab.hidden = YES;
            }else if (status == AUDIO_PAUSE){//音频暂停
                onMicUser.isAudioStatus = 1;
                [self.roomObj.onMicUserList replaceObjectAtIndex:index withObject:onMicUser];
                [_onMicUsersHeadView reloadData];
                lab.hidden = YES;
                if (!_createFlag) {
                    [_btnReload setHidden:NO];
                    [_btnReloadBg setHidden:NO];
                }
                lab.hidden = YES;
            }
            
            return;
        }
    }
 
    
}

#pragma mark onMicUserList
- (void)responseDataWithCmd:(NSString *)cmd data:(NSDictionary *)data{
    if ([cmd isEqualToString:CMD_ATTENTION_ROOM_LIST]) {
        if ([[data objectForKey:@"code"] intValue] == 0) {
            NSLog(@"data == %@",data);
            NSArray *arrList = self.roomObj.onMicUserList;
            NSArray *arrData = [data objectForKey:@"List"];
            NSMutableArray *array = [NSMutableArray array];
            for (ClientUserModel *userObj in arrList) {//遍历在麦用户
                for (NSDictionary *dic in arrData) {//遍历关注用户
                    int uid = [[dic objectForKey:@"uId"] intValue];//关注
                    int userId = userObj.userId;
                    if (uid == userId) {
                        [array addObject:userObj];
                    }
                }
            }
            self.arrayAttention = [[NSArray alloc] initWithArray:array];
        }else{
            NSLog(@"获取关注列表失败");
        }
    }
}
@end



