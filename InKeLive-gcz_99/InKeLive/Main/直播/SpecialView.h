//
//  SpecialView.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/10/16.
//  Copyright © 2018 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecialView : UIView
@property (nonatomic, assign)BOOL isAnimationHide;//礼物动画
@property (nonatomic, assign)BOOL isGiftHide;//礼物信息
@property (nonatomic, assign)BOOL isEnterHide;//进房信息
@property (nonatomic, assign)BOOL isQuitHide;//退房信息
@property (nonatomic, assign)BOOL isHarnHide;//喇叭信息

@property (nonatomic, copy) void(^btnButtonClick)(int tag, BOOL isSelect);
- (void)popShow;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
