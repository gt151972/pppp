//
//  HomeViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopTitleView.h"
#import "SearchView.h"

//就是首页(关注+热门+附近)的父VC
@interface HomeViewController : UIViewController

@property (nonatomic,strong)TopTitleView *titleView;
@property (nonatomic, strong)SearchView *searchView;

@property (nonatomic,strong)UIScrollView *homeScrollView;


@end
