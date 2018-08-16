//
//  StopView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/29.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@interface StopView : BaseView
- (void)initViewWithDay: (int)day superView: (UIView *)superView money: (NSString *)money;

/**
 <#Description#>
 */
- (void)removeView;
@end
