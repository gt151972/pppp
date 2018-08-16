//
//  HomeGoodsView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@protocol  HomeGoodsDelegate<NSObject>

@required
- (void)didGoodsArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeGoodsView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayTitle;
    NSArray *arrayURL;
    NSArray *arrayPrice;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
    BOOL isLocation;
}

@property (nonatomic, assign) id<HomeGoodsDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;
@end
