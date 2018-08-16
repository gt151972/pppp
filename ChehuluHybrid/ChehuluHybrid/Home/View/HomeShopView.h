//
//  HomeShopView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@protocol  HomeShopDelegate<NSObject>

@required
- (void)didShopArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeShopView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    
    NSArray *arrayImage;
    NSArray *arrayTitle;
    NSArray *arrayAddress;
    NSArray *arrayStar;
    NSArray *arrayProjects;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
}

@property (nonatomic, assign) id<HomeShopDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;
@end
