//
//  MicStatusView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/11/5.
//  Copyright © 2018 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MicStatusView : UIView
@property (nonatomic, assign)BOOL isVideoPause;//视频暂停
@property (nonatomic, assign)BOOL isAudioPause;//音频暂停
@property (nonatomic, copy) void(^btnButtonClick)(int status);
- (void)popShow;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
