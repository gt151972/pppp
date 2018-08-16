//
//  BaseViewController.m
//  HehuorenHybrid
//
//  Created by GT mac on 16/5/31.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "BaseViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
#define MAX_IMAGE_SIZE  CGSizeMake(270, 270)
#define DEFAULT_HEIGHT_OFFSET 52.0f

@interface BaseViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BaseViewController
////@synthesize tableView;
//@synthesize headerView;
//@synthesize footerView;
//
//@synthesize isDragging;
//@synthesize isRefreshing;
//@synthesize isLoadingMore;
//
//@synthesize canLoadMore;
//
//@synthesize pullToRefreshEnabled;
//
//@synthesize clearsSelectionOnViewWillAppear;

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static BaseViewController *instance;
    dispatch_once(&onceToken,^{
        instance = [[BaseViewController alloc] init];
    });
    return instance;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[self colorWithHexString:@"#F3F5F4"]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    indexDAL=[[IndexRequestDAL alloc]init];
    indexDAL.delegate=self;
    
    HUD = [[LoadingHUD alloc] init];
}

/**
 *  初始化数据
 */
- (void)initData{
    
}

/**
 *  初始化页面
 */
- (void)initView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  颜色
 *
 *  @param UIColor <#UIColor description#>
 *
 *  @return <#return value description#>
 */
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/**
 *  backItem 图片
 *
 *  @param imageNormal      <#imageNormal description#>
 *  @param imageHighlighted <#imageHighlighted description#>
 */
- (UIBarButtonItem *)addBackButton: (UIImage *)imageNormal :(UIImage *)imageHighlighted{
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:imageNormal forState:UIControlStateNormal];
    [btnBack setImage:imageHighlighted forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    return backItem;
}

/**
 *  rightItem 文字
 *
 *  @param TitleText <#TitleText description#>
 */
-(void)addRightButton :(NSString *)TitleText{
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, [TitleText length]*15, 22);
    [rightButton setTitle:TitleText forState:UIControlStateNormal];
//    [rightButton setTitleColor:ButtonColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doClickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    rightButton.titleLabel.textAlignment=NSTextAlignmentRight;
    UIBarButtonItem* rightBut = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBut;
}

/**
 *  rightItem图片
 *
 *  @param imageName <#imageName description#>
 */
-(void)addRightButtonForImage :(NSString *)imageName{
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 22);
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doClickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBut = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBut;
}

- (UIButton *)addButtomSubmit: (NSString *)str{
    UIButton *btnSubmit = [[UIButton alloc] init];
    [btnSubmit setBackgroundColor:[self colorWithHexString:@"#0EC0CA"]];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit setTitle:str forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btnSubmit;
}

/**
 *  黑色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeBlack: (NSString *)strTitle{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.leftBarButtonItem = [self addBackButton:[UIImage imageNamed:@"btnBackNormal"] :[UIImage imageNamed:@"btnBackSelect"]];
    [self.navigationController.navigationBar setBarTintColor:[self colorWithHexString:@"#15181B"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = strTitle;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

/**
 *  白色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeWhite:(NSString *)strTitle{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.leftBarButtonItem = [self addBackButton:[UIImage imageNamed:@"btnBackSelect"] :[UIImage imageNamed:@"btnBackNormal"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.title = strTitle;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

/**
 *  绿色导航栏
 *
 *  @param strTitle 导航栏标题
 */
- (void)navigationTypeGreen:(NSString *)strTitle{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.leftBarButtonItem = [self addBackButton:[UIImage imageNamed:@"btnBackNormal"] :[UIImage imageNamed:@"btnBackSelect"]];
    [self.navigationController.navigationBar setBarTintColor:[self colorWithHexString:@"#3ba87a"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = strTitle;
}

/**
 *  字典转换成非空
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmpty:(NSDictionary *)dic{
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
    NSDictionary *dict3 = [[NSDictionary alloc] init];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic2 setObject:dict3 forKey:key];
        }else{
            [dic2 setObject:[dic objectForKey:key] forKey:key];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dic2];
    return dict;
}

/**
 *  字典转换成非空字符串
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmptyString:(NSDictionary *)dic{
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
//    NSDictionary *dict3 = [[NSDictionary alloc] init];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic2 setObject:@"" forKey:key];
        }else{
            [dic2 setObject:[dic objectForKey:key] forKey:key];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dic2];
    return dict;
}

/**
 *  字典转换成非空字符串
 *
 *  @param dic 传入字典
 */
- (NSDictionary *)nullToEmptyZero:(NSDictionary *)dic{
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
    //    NSDictionary *dict3 = [[NSDictionary alloc] init];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic2 setObject:@"0" forKey:key];
        }else if (![dic objectForKey:key]){
            [dic2 setObject:@"0" forKey:key];
        }
        else{
            [dic2 setObject:[dic objectForKey:key] forKey:key];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dic2];
    return dict;
}

/**
 *  图片存入沙盒
 *
 *  @param tempImage 存入图片
 *  @param imageName 图片名称
 */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];

}

/**
 *  从沙盒获取图片
 *
 *  @param imageName 图片名称
 */
- (UIImage *)getImageWithName:(NSString *)imageName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:imageName];
    UIImage *imgHead = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
    return imgHead;
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
/**
 *  UIImage -> Base64
 *
 *  @param image 传入图片
 */
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (void)getImageForUrl: (NSString *)strUrl :(UIImageView *)imageView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        UIImage *image = [UIImage imageWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }
    });
}

/**
 *  通过URL从网上获取图片
 *
 *  @param strUrl
 */
- (UIImage *)getImageForUrl: (NSString *)strUrl{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
#pragma mark image scale utility

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    targetSize = MAX_IMAGE_SIZE;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  获取当前 年 月 日
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)todayData{
    NSDate *now = [NSDate date];
    //    NSLog(@"now == %@",now);
    NSDictionary *dicToday;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"dd"];
    NSString *year = [dateFormatter stringFromDate:now];
    NSString *month = [dateFormatter2 stringFromDate:now];
    NSString *day = [dateFormatter3 stringFromDate:now];
    dicToday = [NSDictionary dictionaryWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", nil];
    return dicToday;
}

/**
 *  回收textField键盘
 *
 */
- (void)packUpKeyboard{
    // 轻扫空白处键盘回收
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    // 轻扫方向, 向下轻扫
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    // 点击空白处键盘回收
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}
// 方法的实现
- (void)tap:(UITapGestureRecognizer *)tap
{
    // 根据Tag值,获取textField
//    UITextField *textField = (UITextField *)[self.view viewWithTag:300];
    [_textField resignFirstResponder];
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    // 根据Tag值,获取textField
//    UITextField *textField = (UITextField *)[self.view viewWithTag:300];
    [_textField resignFirstResponder];
}

///**
// *  下拉刷新
// *
// */
//- (void)refresh{
//    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
//    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
//    [refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
//    self.refreshControl = refresh;
//    [self.refreshControl beginRefreshing];
//}
//
//- (void)reload{
//    if (self.refreshControl.isRefreshing){
//      //  [self.modelArray removeAllObjects];//清除旧数据，每次都加载最新的数据
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
//        [self addData];
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
////        [self.tableView reloadData];
//        [self.refreshControl endRefreshing];
//        
//    }
//}

- (void)addData{
    
}

#pragma mark --微信分享
#pragma mark
- (void)wxShareMessagetitle:(NSString *)title desc: (NSString *)desc url: (NSString *)url mode: (NSString *)mode target: (NSString *)target shareImgUrl: (NSString *)shareImgUrl{
    NSLog(@"title == %@",title);
    NSLog(@"desc == %@",desc);
    NSLog(@"url == %@",url);
    NSLog(@"mode == %@",mode);
    NSLog(@"target == %@",target);
    NSLog(@"shareImgUrl == %@",shareImgUrl);
    // NSString *strPhoto = [NSString stringWithFormat:@"http://wx.buyubi.com/ZJJH_SHARE_ICON/share_icon_%@.jpg",mode];
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,        /**< 收藏       */
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = desc;
    //  NSURL *shareUrl = [NSURL URLWithString:strPhoto];
    NSURL *urlPhoto = [NSURL URLWithString:[NSString stringWithFormat:@"%@",shareImgUrl]];
    UIImage *photo =   [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPhoto]];
    
    [message setThumbImage:photo];
    
    WXWebpageObject *webpageObject = [[WXWebpageObject alloc] init];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if ([target isEqualToString:@"session"]) {
        req.scene = WXSceneSession;
    }else{
        req.scene = WXSceneTimeline;
    }
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [WXApi sendReq:req];
    });
    
//    if (req.scene == 0) {
//        _scene = 0;//聊天界面
//        //        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.wxOnShareSuccess(0)"] completionHandler:nil];
//    }else if (req.scene == 1){
//        _scene = 1;//朋友圈
//        //        [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.wxOnShareSuccess(1)"] completionHandler:nil];
//    }
}

#pragma mark -- 微信图片分享
#pragma mark
- (void)WXSendImageData:(UIImage *)image target: (NSString *)target {
    
    WXMediaMessage *message = [WXMediaMessage message];
    //    UIImage *thumbImage = [self generatePhotoThumbnail:image];
    [message setThumbImage:[UIImage imageNamed:@"Thumbnail"]];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if ([target isEqualToString:@"timeline"]) {
        req.scene = WXSceneTimeline;
//        _scene = 1;
    }else{
        req.scene = WXSceneSession;
//        _scene = 0;
    }
    [WXApi sendReq:req];
}


#pragma mark ---微信支付
#pragma mark
//String partnerId,String prepayId,String packageValue,String nonceStr,String timeStamp,String sign
- (void)WXPayRmbpartnerId :(NSString *)partnerId prepayId:(NSString *)prepayId packageValue:(NSString *)packageValue nonceStr: (NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign{
    NSLog(@"partnerId == %@",partnerId);
    NSLog(@"prepayId == %@",prepayId);
    NSLog(@"package == %@",packageValue);
    NSLog(@"nonceStr == %@",nonceStr);
    NSLog(@"timeStamp == %@",timeStamp);
    NSLog(@"sign == %@",sign);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = partnerId;
    request.prepayId= prepayId;
    request.package = packageValue;
    request.nonceStr= nonceStr;
    request.timeStamp= [timeStamp intValue];
    request.sign= sign;
    [WXApi sendReq:request];
    
    //    [self.wkWebView evaluateJavaScript:[NSString stringWithFormat:@"ZJJH.wxOnPayRmbSuccess()"] completionHandler:nil];
}

#pragma mark ---微信回调
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"resp == %d\n str == %@",resp.errCode,resp.errStr);
    //    NSString *strTitle;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = [NSString stringWithFormat:@"%d", resp.errCode];
        //        self.context [@"JHJSB"] = self;
        if ([strMsg isEqualToString:@"0"]) {
//            _strTitle = [NSString stringWithFormat:@"分享成功"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"result"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"分享成功"  forKey:@"result"];
        }else{
//            _strTitle = [NSString stringWithFormat:@"分享失败"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"result"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"分享失败"  forKey:@"result"];
        }
//        [_strTitle addObserver:self
//                    forKeyPath:@"wxShare"
//                       options:NSKeyValueObservingOptionNew
//                       context:nil];
    }else if ([resp isKindOfClass:[PayResp class]]){
        
        NSString *strPay = [NSString stringWithFormat:@"%d",resp.errCode];
        //        self.context[@"JHJSB"] = self;
        if ([strPay isEqualToString:@"0"]) {
//            _strTitle = [NSString stringWithFormat:@"支付成功"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"result"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"支付成功"  forKey:@"result"];
        }else {
//            _strTitle = [NSString stringWithFormat:@"取消支付"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"result"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"取消支付"  forKey:@"result"];
        }
    }
}

/**
 *  接口获取失败吼弹出的alert
 *
 *  @param strTitle
 */
- (void)alert: (NSString *)strTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -- Action
- (void)doClickRightButton :(UIButton *)sender{
    
}

- (void)btnBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)isLogin:(NSString *)strInfo{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strInfo message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    if ([strInfo isEqualToString:@"用户未登录！"]) {
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:actionCancle];
        [alertController addAction:actionLogin];
    }else{
        
    }
}
//截图
- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        for(UIView *subview in theView.subviews)
        {
            [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [theView.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease
    (ref);
    return CGImg;
}
@end
