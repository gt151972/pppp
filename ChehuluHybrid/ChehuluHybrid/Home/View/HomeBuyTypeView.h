//
//  HomeBuyTypeView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/1.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"
@protocol  HomeBuyTypeViewDelegate<NSObject>

@required
- (void)homeBuyTypeArray:(NSArray *)array name:(NSString*)name;

@end

@interface HomeBuyTypeView : BaseView<UIScrollViewDelegate>{
    NSArray *arraySource;
    NSArray *arrayImage;
    NSArray *arrayTitle;
    NSArray *arrayURL;
    NSArray *arrayName;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
}

@property (nonatomic, assign) id<HomeBuyTypeViewDelegate>delegate;

- (void)showViewWithView:(UIView *)view array:(NSArray *)array;

@end
