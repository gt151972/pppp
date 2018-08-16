//
//  BaseButton.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton
//白底绿框的按钮
- (UIButton *)btnWhite: (NSString *)title{
    UIColor *color =[UIColor colorWithRed:14/255.0 green:192/255.0 blue:202/255.0 alpha:1/1.0];
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4];
    [btn.layer setBorderColor:color.CGColor];
    [btn.layer setBorderWidth:1.0];
    return btn;
}

//绿底的按钮
- (UIButton *)btnGreen:(NSString *)title{
    UIColor *color =[UIColor colorWithRed:56.0/255 green:170.0/255 blue:121.0/255 alpha:1.0];
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4];
    return btn;
}

@end
