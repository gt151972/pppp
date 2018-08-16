//
//  HomePartnerView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@protocol  HomePartnerDelegate<NSObject>

@required
- (void)didPartnerArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomePartnerView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayTitle;

    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
}

@property (nonatomic, assign) id<HomePartnerDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;
@end
