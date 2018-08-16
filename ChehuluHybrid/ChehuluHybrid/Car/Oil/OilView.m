//
//  OilView.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/4/3.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "OilView.h"

@implementation OilView
- (UIView *)initView:(UIView *)superView oil: (float)oil date: (NSString *)date max: (float)max{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 51, 205)];
    self.frame = CGRectMake(0, 0, 51, 205);
    int oilPesent;
    if (oil < 0) {
        oilPesent = 0;
    }else{
        oilPesent = 150*oil/max;
    }
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 31, 205)];
    viewBg.backgroundColor = [UIColor clearColor];
    [view addSubview:viewBg];
    
    UIView *viewBar = [[UIView alloc] initWithFrame:CGRectMake(0, 205-oilPesent, 31, oilPesent)];
    viewBar.backgroundColor = COLOR_MAIN_GREEN;
    [viewBg addSubview:viewBar];
    
    UIView *viewState =[[UIView alloc] initWithFrame:CGRectMake(0, 205-25-oilPesent, 31, 23)];
    viewState.backgroundColor = [UIColor whiteColor];
    [viewBg addSubview:viewState];
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 31, 23)];
    labDetail.text = [NSString stringWithFormat:@"%.2f",oil];
    labDetail.textColor = COLOR_TEXT_GARY_DEEP;
    labDetail.font = [UIFont systemFontOfSize:8];
    labDetail.textAlignment = NSTextAlignmentCenter;
    [viewState addSubview:labDetail];
    
    UILabel *labDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 205, 31, 18)];
    labDate.text = [NSString stringWithFormat:@"%@",date];
    labDate.textAlignment = NSTextAlignmentCenter;
    labDate.textColor = [UIColor whiteColor];
    labDate.font = [UIFont systemFontOfSize:10];
    [viewBg addSubview:labDate];
    
    [superView addSubview:self];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 205)];
//    [btn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
//    [self addSubview:btn];
    return view;
}

- (void)btnClicked: (UIButton *)button{
    if (button.tag == 201) {
        
    }else if (button.tag == 202){
        
    }
}
@end
