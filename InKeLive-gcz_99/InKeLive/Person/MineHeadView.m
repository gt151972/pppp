//
//  MineHeadView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/15.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib lastObject];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

+ (instancetype)userView
{
    //使用的静态函数加载方式
    return [self createViewFromNib];
    //return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib {
    [super awakeFromNib];
}

@end
