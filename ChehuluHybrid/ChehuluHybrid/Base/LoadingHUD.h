//
//  LoadingHUD.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/30.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@interface LoadingHUD : BaseView
@property (nonatomic, strong) UIView *backGroundView;



/**
 无背景的loading
 */
- (void)loadingHUD;
- (void)hidHUD;

/**
 有背景的loading
 */
- (void)loadingHUDbg;
- (void)hidHUDbg;
@end
