//
//  ShareView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/9/17.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView
@property (nonatomic, copy) void(^btnShareClick)(int tag);
- (void)popShow;
- (void)hide;
@end
