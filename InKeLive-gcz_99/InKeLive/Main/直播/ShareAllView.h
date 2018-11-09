//
//  ShareAllView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/9.
//  Copyright © 2018 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareAllView : UIView
@property (nonatomic, copy) void(^btnShareClick)(int tag);
- (void)popShow;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
