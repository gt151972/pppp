//
//  ShareCopyView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/10/30.
//  Copyright © 2018 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCopyView : UIView
@property (nonatomic, copy) void(^btnShareClick)(int tag);
- (void)popShow;
- (void)hide;
@end
