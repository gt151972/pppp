//
//  HomeAdView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

//@interface HomeAdView : BaseView
//
//@end

@protocol  HomeAdDelegate<NSObject>

@required
- (void)didAdArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeAdView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayURL;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
    BOOL isLocation;
}

@property (nonatomic, assign) id<HomeAdDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;
@end
