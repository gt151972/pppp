//
//  OilView.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/4/3.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@protocol OilViewDelegate <NSObject>

@required
- (void)oilView:(int)index name:(NSString*)name;

@end

@interface OilView : BaseView
- (UIView *)initView:(UIView *)superView oil: (float)oil date: (NSString *)date max: (float)max;
@end
