//
//  StateViewController.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "StateViewController.h"
#import "GTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>
#import <YYKit.h>
#import "YYFPSLabel.h"
#import "YYTableView.h"
#import "WBStatusCell.h"
#import "WBStatusTimelineViewController.h"
#import "WBStatusLayout.h"
#import "WBModel.h"
#import "YYPhotoGroupView.h"

#define URL_IMAGE @"http://up.aa1258.com/upload.php"
#define Dynamic_text_color RGB(97, 97, 97)
@interface StateViewController ()<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource,WBStatusCellDelegate>{
    double latitude;
    double longitude;
}
@property (nonatomic, strong)NSArray *arrData;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation StateViewController

- (instancetype)init {
    self = [super init];
    [self getLocation];//定位经纬度
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.title = @"动态";
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - kWBCellPadding;
    _fpsLabel.left = kWBCellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
//    self.navigationController.view.userInteractionEnabled = NO;
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    indicator.size = CGSizeMake(80, 80);
//    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
//    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
//    indicator.clipsToBounds = YES;
//    indicator.layer.cornerRadius = 6;
//    [indicator startAnimating];
//    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i <= 7; i++) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_%d.json",i]];
            WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
            for (WBStatus *status in item.statuses) {
                WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                //                [layout layout];
                [_layouts addObject:layout];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_layouts.count == %lu",(unsigned long)_layouts.count);
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((WBStatusLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIImageView *imgHead = [[UIImageView alloc] init];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:MY_HEAD_IMAGE_PATH] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [viewHead addSubview:imgHead];
    UIImageView *imgBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_bar_bg"]];
    [viewHead addSubview:imgBackground];
    UILabel *labText = [[UILabel alloc] init];
    labText.text = @"说说最近的新鲜事~";
    labText.textColor = Dynamic_text_color;
    labText.font = [UIFont systemFontOfSize:14];
    labText.textAlignment = NSTextAlignmentLeft;
    [imgBackground addSubview:labText];
    UIImageView *imgPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_attention_select"]];
    [viewHead addSubview:imgPhoto];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(@12);
        make.centerY.equalTo(viewHead);
    }];
    [imgBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgHead.mas_right).offset(8);
        make.right.equalTo(viewHead.mas_right).with.offset(-50);
        make.centerY.equalTo(viewHead);
        make.height.equalTo(@40);
        
    }];
    NSLog(@"width == %lf",imgBackground.frame.size.width);
    [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewHead).offset(-12);
        make.width.equalTo(@20);
        make.height.equalTo(@17);
        make.centerY.equalTo(viewHead);
    }];
    [labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgPhoto.mas_left);
        make.left.equalTo(imgBackground.mas_left).offset(16);
        make.height.equalTo(@14);
        make.centerY.equalTo(viewHead);
    }];
    return viewHead;
}


- (void)getLocation{
    //只获取一次
    __block  BOOL isOnece = YES;
    [GTLocationManager getMoLocationWithSuccess:^(double lat, double lng){
        isOnece = NO;
        //只打印一次经纬度
        NSLog(@"lat lng (%f, %f)", lat, lng);
        latitude = lat;
        longitude = lng;
        if (!isOnece) {
            [GTLocationManager stop];
        }
        [self loadGiftConf];
    } Failure:^(NSError *error){
        isOnece = NO;
        NSLog(@"error = %@", error);
        if (!isOnece) {
            [GTLocationManager stop];
        }
    }];
}


-(void) loadGiftConf
{
    NSLog(@"动态请求>>>>> ");
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"1259";
    parameters[@"userName"] = @"1259";
    parameters[@"longitude"] = [NSString stringWithFormat:@"%f",fabs(longitude)];
    parameters[@"latitude"] = [NSString stringWithFormat:@"%f",fabs(latitude)];
    parameters[@"nType"] = @"1";
    parameters[@"nNum"] = @"1";
    parameters[@"context"] = @"动态";
    parameters[@"cmd"] = @"1146";
    NSString* strAPIUrl = URL_IMAGE;
    NSLog(@"parameters:%@", parameters);
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer requestWithMethod:@"POST" URLString:strAPIUrl parameters:parameters error:nil];
    [session POST:strAPIUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSDictionary *appDic =(NSDictionary*)responseObject;
        NSString* errorCode= appDic[@"errorCode"];
        NSString* errorMsg = appDic[@"errorMsg"];
        NSLog(@"%@",appDic);
        if([errorCode isEqualToString:@"0"])
        {
//            [self.giftArray removeAllObjects];
//            NSString* url_giftpic_prefix = appDic[@"urlGiftPicPrefix"];
//            NSArray* giftconflist = (NSArray*)appDic[@"GiftList"];
//            for(NSDictionary* giftItem in giftconflist) {
//
//                [self.giftArray addObject:model];
//            }
        }

//        NSLog(@"load gift-config, gift count=%lu", (unsigned long)self.giftArray.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - WBStatusCellDelegate
// 此处应该用 Router 之类的东西。。。这里只是个Demo，直接全跳网页吧～

/// 点击了 Cell
- (void)cellDidClick:(WBStatusCell *)cell {
    
}

/// 点击了 Card
- (void)cellDidClickCard:(WBStatusCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... 会跳到 Weibo.app 的。。
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    vc.title = pageInfo.pageTitle;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了转发内容
- (void)cellDidClickRetweet:(WBStatusCell *)cell {
    
}

/// 点击了 Cell 菜单
- (void)cellDidClickMenu:(WBStatusCell *)cell {
    
}

/// 点击了下方 Tag
- (void)cellDidClickTag:(WBStatusCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... 会跳到 Weibo.app 的。。
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    vc.title = tag.tagName;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了关注
- (void)cellDidClickFollow:(WBStatusCell *)cell {
    
}

/// 点击了转发
- (void)cellDidClickRepost:(WBStatusCell *)cell {
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeRetweet;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    @weakify(nav);
//    vc.dismiss = ^{
//        @strongify(nav);
//        [nav dismissViewControllerAnimated:YES completion:NULL];
//    };
//    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了评论
- (void)cellDidClickComment:(WBStatusCell *)cell {
//    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
//    vc.type = WBStatusComposeViewTypeComment;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    @weakify(nav);
//    vc.dismiss = ^{
//        @strongify(nav);
//        [nav dismissViewControllerAnimated:YES completion:NULL];
//    };
//    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(WBStatusCell *)cell {
//    WBStatus *status = cell.statusView.layout.status;
//    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// 点击了用户
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user {
    if (user.userID == 0) return;
//    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld",user.userID];
//    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击了图片
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBStatus *status = cell.statusView.layout.status;
    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPicture *pic = pics[i];
        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;
        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    if (info[kWBLinkHrefName]) {
        NSString *url = info[kWBLinkHrefName];
//        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (info[kWBLinkURLName]) {
        WBURL *url = info[kWBLinkURLName];
        WBPicture *pic = url.pics.firstObject;
        if (pic) {
            // 点击了文本中的 "图片链接"
            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
            if ([attachment.content isKindOfClass:[UIView class]]) {
                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
                info.largeImageURL = pic.large.url;
                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
                
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
            }
            
        } else if (url.oriURL.length){
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    if (info[kWBLinkTagName]) {
        WBTag *tag = info[kWBLinkTagName];
        NSLog(@"tag:%@",tag.tagScheme);
        return;
    }
    
    if (info[kWBLinkTopicName]) {
        WBTopic *topic = info[kWBLinkTopicName];
        NSString *topicStr = topic.topicTitle;
        topicStr = [topicStr stringByURLEncode];
        if (topicStr.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    if (info[kWBLinkAtName]) {
        NSString *name = info[kWBLinkAtName];
        name = [name stringByURLEncode];
        if (name.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
