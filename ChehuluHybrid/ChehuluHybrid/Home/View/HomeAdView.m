//
//  HomeAdView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "HomeAdView.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation HomeAdView
- (void)showViewWithView:(UIView *)view array:(NSArray *)array{
    arraySource = [NSArray arrayWithArray:array];
    NSLog(@"array== %@",array);
    NSMutableArray *arrImage = [[NSMutableArray alloc] init];
    NSMutableArray *arrURL = [[NSMutableArray alloc] init];
    for (int index = 0; index < arraySource.count; index ++ ) {
        [arrImage addObject:[[arraySource objectAtIndex:index] objectForKey:@"img_url"]];
        [arrURL addObject:[[arraySource objectAtIndex:index] objectForKey:@"url"]];
    }
    arrayImage = [NSArray arrayWithArray:arrImage];
    arrayURL = [NSArray arrayWithArray:arrURL];
    page = (int )arrImage.count;
    NSLog(@"page == %d",page);
    [self initView:view];
}

- (void)initView: (UIView *)view{
    //定义scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 103)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setCanCancelContentTouches:NO];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = YES;     // default is NO, we want to restrict drawing within our scrollview
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.tag = 1;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //为scrollView添加手势
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTap.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:singleTap];
    
    //向scrollView中添加imageView
    //    NSUInteger i;
    //    NSArray *array = [NSArray arrayWithObjects:@"Aaiyuezhicheng", @"danshennanzi", @"yueguangnanhai", nil];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DicHomeAdImage"]) {
//        for (int index = 0; index < arrayImage.count; index ++ ) {
//            if ([[arrayImage objectAtIndex:index] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"DicHomeAdImage"] objectAtIndex:index]]) {
//                isLocation = 1;
//            }else{
//                [[NSUserDefaults standardUserDefaults] setObject:arrayImage forKey:@"DicHomeAdImage"];
//            }
//        }
//    }else{
//        [[NSUserDefaults standardUserDefaults] setObject:arrayImage forKey:@"DicHomeAdImage"];
//    }

    for (int i = 1; i <= page; i++)
    {
        //        NSString *imageName = [array objectAtIndex:i];
        //        UIImage *image = [UIImage imageNamed:imageName];
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        UIView *viewBG = [[UIView alloc] init];
        viewBG.backgroundColor = [UIColor clearColor];
        viewBG.tag = 1000+i;
        //设置frame
        CGRect rect = viewBG.frame;
        rect.size.height = 103;
        rect.size.width = gtWIDTH;
        viewBG.frame = rect;
        //        viewBG.tag = i + 1000;
        [scrollView addSubview:viewBG];
        UIButton *btnAd = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, gtWIDTH - 16, 77)];
        [btnAd sd_setImageWithURL:[arrayImage objectAtIndex:(i-1)] forState:UIControlStateNormal];
        
//        if (isLocation == 0) {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                UIImage *image;
//                image = [super getImageForUrl:[arrayImage objectAtIndex:(i-1)]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [super saveImage:image WithName:[NSString stringWithFormat:@"homeAdImage%d",i]];
//                    [btnAd setImage:image forState:UIControlStateNormal];
//                });
//            });
//        }else{
//            UIImage *image = [super getImageWithName:[NSString stringWithFormat:@"homeAdImage%d",i]];
//            [btnAd setImage:image forState:UIControlStateNormal];
//        }

        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *image = [super getImageForUrl:[arrayImage objectAtIndex:(i-1)]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [btnAd setImage:image forState:UIControlStateNormal];
//            });
//        });
        
        [btnAd addTarget:self action:@selector(btnCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnAd setTag:200+i];
        [viewBG addSubview:btnAd];
//        [btnAd mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(viewBG);
//            make.size.equalTo(viewBG);
//        }];
    }
    
    [self layoutScrollImages1]; //设置图片格式
    [view addSubview:scrollView]; //将scrollView封装到featureView
    
    //定义pageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 95, gtWIDTH, 8)];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = page;
    [view addSubview:pageControl]; //将pageControl封装到featureView
}
- (void)initCell{
    
}

- (void)btnCellClicked: (UIButton *)button{
    NSLog(@"tag == %ld",button.tag - 201);
    int index = (int)button.tag - 201;
    [_delegate didAdArray:[arraySource objectAtIndex:index] name:@"HomeAd"];
}


//设置图片的格式
//代码来源：Apple官方例子Scrolling
- (void)layoutScrollImages1
{
    UIView *view = nil;
    NSArray *subviews = [scrollView subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        if ([view isKindOfClass:[UIView class]] && view.tag > 1000)
        {
            CGRect frame = view.frame;
            frame.origin = CGPointMake(curXLoc, 0);
            view.frame = frame;
            
            curXLoc += (gtWIDTH);
        }
    }
    
    // set the content size so it can be scrollable
    [scrollView setContentSize:CGSizeMake((page * gtWIDTH), [scrollView bounds].size.height)];
}


//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    if (sView.tag == 1)
    {
        NSInteger index = fabs(sView.contentOffset.x) / sView.frame.size.width;
        //NSLog(@"%d",index);
        [pageControl setCurrentPage:index];
        //        featureLabel.text = [array objectAtIndex:index];
    }
}



//UIScrollView响应gesture的action
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    NSInteger index = touchPoint.x/320;
    //    shopDetailView = [[ShopDetailViewController alloc] init];
    //    [self.navigationController pushViewController:shopDetailView animated:YES];
    //    [shopDetailView release];
    
}


@end
