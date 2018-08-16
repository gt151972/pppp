//
//  StopView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/29.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "StopView.h"

@implementation StopView
- (void)initViewWithDay: (int)day superView: (UIView *)superView money: (NSString *)money{
    self.frame = CGRectMake(0, 99, gtWIDTH, gtHEIGHT - 64 - 35 - 49);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT - 64 - 35 - 49)];
    view.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:view];
    
    if (day > 0) {
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, gtWIDTH, 18)];
        labTitle.text = [NSString stringWithFormat:@"停车第%d天",day];
        labTitle.textAlignment = NSTextAlignmentCenter;
        labTitle.textColor = COLOR_TEXT_GARY_DEEP;
        labTitle.font = [UIFont systemFontOfSize:18];
        [view addSubview:labTitle];
        [LableColor setRichNumberWithLabel:labTitle Color:COLOR_MAIN_GREEN FontSize:24.0];
    }
    if (money) {
        UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, gtWIDTH, 12)];
        //    当日环保奖励%@车币已存入您的账户
        labDetail.text = [NSString stringWithFormat:@"%@",money];
        labDetail.textColor = COLOR_TEXT_GARY;
        labDetail.textAlignment = NSTextAlignmentCenter;
        labDetail.font = [UIFont systemFontOfSize:12];
        [view addSubview:labDetail];
    }
    
    UIImage *imgStop = [UIImage imageNamed:@"stopCar"];
    UIImageView *imageStop = [[UIImageView alloc] init];
    imageStop.image = imgStop;
    [view addSubview:imageStop];
    [imageStop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imgStop.size);
        make.center.equalTo(view);
    }];
    
    UILabel *labState = [[UILabel alloc] init];
    labState.text = @"当日车子处于停驶状态";
    labState.textColor = COLOR_TEXT_GARY;
    labState.textAlignment = NSTextAlignmentCenter;
    labState.font = [UIFont systemFontOfSize:16];
    [view addSubview:labState];
    [labState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageStop.mas_bottom).offset(16);
        make.width.and.centerX.equalTo(view);
        make.height.mas_equalTo(16);
    }];
    [superView addSubview:self];
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

/**
 <#Description#>
 */
- (void)removeView {
    [self removeFromSuperview];
}
@end
