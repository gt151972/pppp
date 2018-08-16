//
//  TabBar.h
//  51AutoPersonNew
//
//  Created by auto on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBar;

@protocol TabBarDelegate <UITabBarDelegate>

@optional
- (void)cameraButtonClick:(TabBar *)tabBar;

@end

//自定义的UITabBar,中间有个大按钮
@interface TabBar : UITabBar


@property (nonatomic, assign) id <TabBarDelegate> delegate;


@end
