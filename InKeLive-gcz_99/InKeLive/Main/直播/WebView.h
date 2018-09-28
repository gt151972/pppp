//
//  WebView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/27.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebView : UIView
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, copy) void(^btnCloseClick)();
- (void)popShow;
- (void)hide;
@end
