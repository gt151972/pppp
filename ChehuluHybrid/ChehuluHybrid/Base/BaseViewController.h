//
//  BaseViewController.h
//  HehuorenHybrid
//
//  Created by GT mac on 16/5/31.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "CommendFile.h"
#import "IndexRequestDAL.h"
#import "WXApi.h"
#import "BaseButton.h"
#import <POP.h>
#import "BaseAlertSheet.h"
#import "LoadingHUD.h"
#import "BaseAlertSheet2.h"
#import <UIImageView+WebCache.h>
#import "ShareAlertSheet.h"
#import "STableViewController.h"
#import "BaseTableView.h"
#import "TakePhoto.h"

@interface BaseViewController : UIViewController<IndexRequestDelegate, WXApiDelegate,UIImagePickerControllerDelegate,BaseActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, BaseActionSheet2Delegate>{
    IndexRequestDAL *indexDAL;
    LoadingHUD *HUD;
}
@property(nonatomic, assign) id<UIPageViewControllerDelegate, NSObject> delegate;
//@property(nonatomic, strong) UIRefreshControl *refreshControl;
+(instancetype)sharedManager;
/**
 *  初始化数据
 */
- (void)initData;

/**
 *  初始化页面
 */
- (void)initView;

/**
 *  颜色
 *
 *  @param stringToConvert 十六进制色
 *
 *  @return RGB
 */
- (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  backItem 图片
 *
 *  @param imageNormal      <#imageNormal description#>
 *  @param imageHighlighted <#imageHighlighted description#>
 */
- (UIBarButtonItem *)addBackButton: (UIImage *)imageNormal :(UIImage *)imageHighlighted;

/**
 *  RightItem 文字
 *
 *  @param TitleText <#TitleText description#>
 */
-(void)addRightButton :(NSString *)TitleText;

/**
 *  rightItem图片
 *
 *  @param imageName <#imageName description#>
 */
-(void)addRightButtonForImage :(NSString *)imageName;

/**
 *  提交按钮
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
- (UIButton *)addButtomSubmit: (NSString *)str;

/**
 *  黑色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeBlack: (NSString *)strTitle;

/**
 *  白色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeWhite: (NSString *)strTitle;

/**
 *  绿色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeGreen:(NSString *)strTitle;

/**
 *  字典转换成非空
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmpty:(NSDictionary *)dic;

/**
 *  字典转换成非空字符串
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmptyString:(NSDictionary *)dic;


/**
 *  字典转换成0
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmptyZero:(NSDictionary *)dic;

/**
 *  图片存入沙盒
 *
 *  @param tempImage 存入图片
  *  @param imageName 图片名称
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  从沙盒获取图片
 *
 *  @param imageName 图片名称
 */
- (UIImage *)getImageWithName:(NSString *)imageName;

/**
 *  UIImage -> Base64
 *
 *  @param image 传入图片
 */
- (NSString *) image2DataURL: (UIImage *) image;

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (void)getImageForImageUrl: (NSString *)strUrl :(UIImageView *)imageView;

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (UIImage *)getImageForUrl: (NSString *)strUr;

/**
 *  获取当前 年 月 日
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)todayData;

/**
 *  接口获取失败吼弹出的alert
 *
 *  @param strTitle
 */
- (void)alert: (NSString *)strTitle;

/**
 *  回收textField键盘
 *
 */
- (void)packUpKeyboard;


/**
 *  下拉刷新
 *
 */
- (void)refresh;
#pragma mark --微信分享
#pragma mark
- (void)wxShareMessagetitle:(NSString *)title desc: (NSString *)desc url: (NSString *)url mode: (NSString *)mode target: (NSString *)target shareImgUrl: (NSString *)shareImgUrl;

#pragma mark -- 微信图片分享
#pragma mark
- (void)WXSendImageData:(UIImage *)image target: (NSString *)target;

#pragma mark ---微信支付
#pragma mark
- (void)WXPayRmbpartnerId :(NSString *)partnerId prepayId:(NSString *)prepayId packageValue:(NSString *)packageValue nonceStr: (NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign;

#pragma mark ---微信回调
-(void) onResp:(BaseResp*)resp;

#pragma mark -- Action
- (void)btnBackClicked;

- (void)isLogin: (NSString *)strInfo;


/**
 截图

 @param theView <#theView description#>
 @param frame <#frame description#>
 @return <#return value description#>
 */
- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame;
@end
