//
//  HomeEarnings.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

//@interface HomeEarnings : BaseView
//
//@end

@protocol  HomeEarningsDelegate<NSObject>

@required
- (void)didEarningsArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeEarnings : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayTitle;
    NSArray *arrayURL;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
    BOOL isLocation;
}

@property (nonatomic, assign) id<HomeEarningsDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;

@end
