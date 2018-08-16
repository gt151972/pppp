//
//  Time.h
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/3.
//  Copyright © 2018年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject


/**
 倒计时

 @param button <#button description#>
 @param timeLine <#timeLine description#>
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param mColor <#mColor description#>
 @param color <#color description#>
 */
+ (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
@end
