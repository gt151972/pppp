//
//  Commend.h
//  ChehuluHybrid
//
//  Created by GT mac on 16/5/30.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#ifndef Commend_h
#define Commend_h

//动画默认时间
#define gtActionTime 1.0

//宽高
#define gtHEIGHT    [UIScreen mainScreen].bounds.size.height
#define gtWIDTH     [UIScreen mainScreen].bounds.size.width

//color
//Navigation
#define gtNavigationBg ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1])
//按钮背景
#define gtButtonBg ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1])
//页面背景
#define gtViewBg ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1])
//字体颜色
#define gtTextColor ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1])


//NSUserDefaults
#define gtUser [[NSUserDefaults standardUserDefaults] objectForKey:@"crashCar"]
#define gtUserInfo [[NSUserDefaults standardUserDefaults] objectForKey:@"DicUserInfo"]
#define gtDicArea [[NSUserDefaults standardUserDefaults] objectForKey:@"DicArea"]

#endif /* Commend_h */
