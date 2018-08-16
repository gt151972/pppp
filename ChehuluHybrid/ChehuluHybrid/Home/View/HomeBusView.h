//
//  HomeBusView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/20.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"
@protocol  HomeBusDelegate<NSObject>

@required
- (void)didBusArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeBusView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayTitle;
    NSArray *arrayURL;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
    BOOL isLocation;
}

@property (nonatomic, assign) id<HomeBusDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;
@end
