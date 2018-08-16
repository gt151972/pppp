//
//  TimeView.h
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/15.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeView : UIView
- (UIView*)timeViewWithStarTime:(NSArray *)arrStartTime endTime: (NSArray *)endTime hour:(NSString *)strHour color: (UIColor *)color;
@end
