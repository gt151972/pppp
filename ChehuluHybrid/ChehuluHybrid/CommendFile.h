//
//  CommendFile.h
//  HehuorenHybrid
//
//  Created by GT mac on 16/5/31.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#ifndef CommendFile_h
#define CommendFile_h
//动画默认时间
#define gtActionTime 1.0

#define SW self.view

//宽高
#define gtHEIGHT    [UIScreen mainScreen].bounds.size.height
#define gtWIDTH     [UIScreen mainScreen].bounds.size.width

//color
//主色
#define COLOR_MAIN_GREEN [super colorWithHexString:@"#0EC0CA"]
#define COLOR_MAIN_RED [super colorWithHexString:@"#FF4343"]
#define COLOR_MAIN_BLACK [super colorWithHexString:@"#2D2F3B"]
#define COLOR_MAIN_GRAY [super colorWithHexString:@"#D7D8DA"]
#define COLOR_MAIN_WHITE [super colorWithHexString:@"#FFFFFF"]

//渐变
#define COLOR_SHADE_GREEN_DEEP [super colorWithHexString:@"#2cb774"]
#define COLOR_SHADE_YELLOW_DEEP [super colorWithHexString:@"#fff06d"]
#define COLOR_SHADE_BLUE_DEEP [super colorWithHexString:@"#30b4cc"]
#define COLOR_SHADE_GREEN [super colorWithHexString:@"#26e5a4"]
#define COLOR_SHADE_YELLOW [super colorWithHexString:@"#fbf08d"]
#define COLOR_SHADE_BLUE [super colorWithHexString:@"#55d4eb"]

//碳排,油耗,分割线
#define COLOR_ASSIST_ORANGE [super colorWithHexString:@"#f9c17e"]
#define COLOR_ASSIST_BLUE [super colorWithHexString:@"#55d4eb"]
#define COLOR_ASSIST_BLUE_DEEP [super colorWithHexString:@"#66ead8"]

//背景色
#define COLOR_BG_GRAY [super colorWithHexString:@"#f6f6f6"]
#define COLOR_BG_GRAY2 [super colorWithHexString:@"#F1F5F8"]
#define COLOR_BG_BLACK_DEEP [super colorWithHexString:@"#2D2F3B"]
#define COLOR_BG_BLACK [super colorWithHexString:@"#323538"]

//字体色
#define COLOR_TEXT_GARY [super colorWithHexString:@"#a6a6a6"]
#define COLOR_TEXT_GARY_DEEP [super colorWithHexString:@"#2D2F3B"]
#define COLOR_TEXT_GARY_HOME [super colorWithHexString:@"#7C7D84"]


//NSUserDefaults
#define gtUser [[NSUserDefaults standardUserDefaults] objectForKey:@"crashCar"]
#define gtUserInfo [[NSUserDefaults standardUserDefaults] objectForKey:@"DicUserInfo"] //登录返回
#define gtDicArea [[NSUserDefaults standardUserDefaults] objectForKey:@"DicArea"] //地址信息
#define gtDicMoney [[NSUserDefaults standardUserDefaults] objectForKey:@"dictMoney"] //车币信息
#define gtDicMyInfo [[NSUserDefaults standardUserDefaults] objectForKey:@"dicMyInfo"] //个人资料
#define gtLocation [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"]//定位
#define gtCarInfo [[NSUserDefaults standardUserDefaults] objectForKey:@"dicCar"]//车辆信息
//#define gtCarDefault [[NSUserDefaults standardUserDefaults] objectForKey:@"dicMyCar"]//默认车辆信息
#define gtSecret [[NSUserDefaults standardUserDefaults] objectForKey:@"Secret"]//可见为1,不可见为0  隐私设置



#define current_SYSTEMIOS  ([[[UIDevice currentDevice]systemVersion]floatValue])
//正式
//#define ServerUrl @"http://jh.buyubi.com/ZhiBao/Mobile/"
#define AppKey @"QoWGcVZjC2qCXuTLqua/bg=="

//测试
#define ServerUrl @"http://jh2.buyubi.com/ZhiBao/Mobile/"
#define MAIN_URL @"http://jh2.buyubi.com/newweixin/index.html?action_name=ShopDetails&file_name=ShopIndex&pdtid=14"
#define GTisFake @"0" //是否假数据

#define from_source @"C"
#define login_source @"2"   //ios端

//tag
//UILable 10x
//UIBotton 20x
//UITextField 30x
//UICollectionView 40x
//UITableView 50x
//UIImageView 60x
//UIPageControl 70x
//UIScrollView 80x
//UITapGestureRecognizer 90x
//UIView 100x
#endif /* CommendFile_h */
