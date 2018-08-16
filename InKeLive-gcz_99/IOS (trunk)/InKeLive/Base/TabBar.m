//
//  TabBar.m
//  51AutoPersonNew
//
//  Created by auto on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "TabBar.h"


@interface TabBar ()
//独立的按钮:创建直播
@property (strong, nonatomic) UIButton *cameraButton;

@end

@implementation TabBar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置背景图片
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"tab_live"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //按钮大小=背景图片大小
        cameraButton.size = cameraButton.currentBackgroundImage.size;
        self.cameraButton = cameraButton;
        [self addSubview:cameraButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews{
    //重新子布局
    [super layoutSubviews];
    [self bringSubviewToFront:self.cameraButton];
    
    CGFloat tabBarItemWidth = self.width / 5;
    //NSLog(@"tabbar width:%f,tabbar item width:%f", self.width, tabBarItemWidth);
    self.cameraButton.centerY = self.height * 0.125;
    self.cameraButton.centerX= self.width * 0.5;
    //NSLog(@"camerNtm frame:%@", NSStringFromCGRect([self.cameraButton frame]));
    
    CGFloat tabBarItemIndex = 0;
    for (UIView *childItem in self.subviews) {
        if ([childItem isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            childItem.width = tabBarItemWidth;
            childItem.x = tabBarItemIndex*tabBarItemWidth;
            //NSLog(@"index:%f, tabbar-button frame:%@", tabBarItemIndex, NSStringFromCGRect([childItem frame]));
            tabBarItemIndex ++;
            if (tabBarItemIndex == 2) {
                //中间的按钮跳过
                tabBarItemIndex ++;
            }
        }
    }
}

- (void)cameraButtonClick{
    //调用Delegate函数
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraButtonClick:)]) {
        [self.delegate cameraButtonClick:self];
    }
}


@end
