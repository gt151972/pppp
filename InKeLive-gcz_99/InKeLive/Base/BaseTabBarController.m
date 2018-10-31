//
//  BaseTabBarController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "CameraViewController.h"
#import "AttentionViewController.h"
#import "StateViewController.h"
//#import "PersonViewController.h"
#import "MineViewController.h"
#import "TabBar.h"
#import "BaseViewController.h"
#import "CameraView.h"
#import "CameraViewController.h"

#import "DPK_NW_Application.h"
#import "LogonViewController.h"
#import "AppDelegate.h"
#import "WebViewController.h"

@interface BaseTabBarController ()<UITabBarDelegate,TabBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end

@implementation BaseTabBarController
@synthesize imagePickerController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *backView=[[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor=[UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque=YES;
    
    self.tabBar.tintColor=[UIColor blackColor];
    [self initChildViewControllers];
    
    //隐藏tabBar上的线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initChildViewControllers{
    //首页
    HomeViewController *homePageVC = [[HomeViewController alloc]init];
    BaseViewController *homeNav = [[BaseViewController alloc]initWithRootViewController:homePageVC];
    [self addChildViewController:homeNav image:@"tab_home_normal" selectedImage:@"tab_home_select" title:@"大厅"];
    
    //关注
    AttentionViewController *attentionVC = [[AttentionViewController alloc] init];
    BaseViewController *attentionNav = [[BaseViewController alloc] initWithRootViewController:attentionVC];
    [self addChildViewController:attentionNav image:@"tab_attention_normal" selectedImage:@"tab_attention_select" title:@"关注"];
    
//    //动态
//    StateViewController *stateVC = [[StateViewController alloc] init];
//    BaseViewController *stateNav = [[BaseViewController alloc] initWithRootViewController:stateVC];
//    [self addChildViewController:stateNav image:@"tab_state_normal" selectedImage:@"tab_state_select" title:@"动态"];
    
    //活动
    WebViewController *activityVC = [[WebViewController alloc] init];
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"webAddress.plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *strUrl = [dict objectForKey:@"activity"];
    activityVC.strUrl = strUrl;
    activityVC.strTitle = @"活动";
    BaseViewController *activityNav = [[BaseViewController alloc] initWithRootViewController:activityVC];
    [self addChildViewController:activityNav image:@"tab_state_normal" selectedImage:@"tab_state_select" title:@"活动"];
    
    //个人
    MineViewController *personVC = [[MineViewController alloc]init];
    BaseViewController *personNav = [[BaseViewController alloc]initWithRootViewController:personVC];
    [self addChildViewController:personNav image:@"tab_mine_normal" selectedImage:@"tab_mine_select" title:@"我的"];
    
    //替换方式
    TabBar *tabBar = [[TabBar alloc]init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)addChildViewController:(UIViewController *)nav image:(NSString *)image selectedImage:(NSString *)selectedImage title: (NSString *)title{
    
    UIViewController *childViewController = nav.childViewControllers.firstObject;
    //tabBarItem图片,显示原图，否则变形
    UIImage *normal = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.tabBarItem.image = normal;
    childViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.title = title;
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [childViewController.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
     [childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animatedWithindex:index];
}

- (void)animatedWithindex:(NSInteger )index{
    NSMutableArray *tabArr = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabArr addObject:tabBarButton];
        }
    }
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    base.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    base.duration = 0.1;
    base.repeatCount = 1;
    base.autoreverses = YES;
    base.fromValue = [NSNumber numberWithFloat:0.8];
    base.toValue = [NSNumber numberWithFloat:1.2];
    [[tabArr[index] layer] addAnimation:base forKey:@"Base"];

}

- (void)cameraButtonClick:(TabBar *)tabBar{
    CameraViewController *cameraVc = [[CameraViewController alloc]init];
    //cameraVc.presentingVC = self;
    //[self presentViewController:cameraVc animated:YES completion:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.createCameraVC = cameraVc;
    [[UIApplication sharedApplication].keyWindow addSubview:cameraVc.view];
//    //全屏大小的pop 弹窗
//    //使用局部变量?,show里面因为增加到keyWindow中, 所以还是生存的..
//    CameraView *popCamera = [[CameraView alloc]initWithFrame:self.view.bounds];
//    [popCamera setButtonClick:^(NSInteger tag) {
//        //要求先登录
//        if([DPK_NW_Application sharedInstance].isLogon == NO) {
//            [self doLogon];
//            return;
//        }
//        //要求用户有归宿房间
//        LocalUserModel* userData = [DPK_NW_Application sharedInstance].localUserModel;
//        if(userData.guishuRoomId == 0) {
//            UIAlertView *baseAlert = [[UIAlertView alloc]
//                                      initWithTitle:@"提示" message:@"没有进行房间归属，不能开播!"
//                                      delegate:self cancelButtonTitle:@"Cancel"
//                                      otherButtonTitles:nil, nil];
//            [baseAlert show];
//            return;
//        }
//
//
//        //按钮事件
//        switch (tag) {
//            case 50: //直播
//            {
//                //直接切换显示方式 guchenghi
//                CameraViewController *cameraVc = [[CameraViewController alloc]init];
//                //cameraVc.presentingVC = self;
//                //[self presentViewController:cameraVc animated:YES completion:nil];
//                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                appDelegate.createCameraVC = cameraVc;
//                [[UIApplication sharedApplication].keyWindow addSubview:cameraVc.view];
//
//            }
//                break;
//            case 51: //短视频
//            {
//                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.allowsEditing = NO;
//                picker.delegate = self;
//                self.imagePickerController = picker;
//                [self setupImagePicker:sourceType];
//                picker = nil;
//                self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//                [self presentViewController:self.imagePickerController animated:YES completion:nil];
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//    [popCamera popShow];  //显示
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType{
    if (sourceType != UIImagePickerControllerSourceTypeCamera) {
        return;
    }
    self.imagePickerController.sourceType = sourceType;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)doLogon {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate doLogon];
    
}


@end
