//
//  HomeGoodsView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "HomeGoodsView.h"

#define ROW_INDEX 2
#define HEIGHT 166

@implementation HomeGoodsView

- (void)showViewWithView:(UIView *)view array:(NSArray *)array{
    arraySource = [[NSArray alloc] initWithArray:array];
    isLocation = 0;
    
    NSLog(@"count == %lu",(unsigned long)arraySource.count);
    NSMutableArray *arrImage = [[NSMutableArray alloc] init];
    NSMutableArray *arrTitle= [[NSMutableArray alloc] init];
    NSMutableArray *arrURL = [[NSMutableArray alloc] init];
    NSMutableArray *arrPrice = [[NSMutableArray alloc] init];
    for (int index = 0; index < arraySource.count; index ++ ) {
        NSLog(@"array == %@",[arraySource objectAtIndex:index]);
        [arrImage addObject:[[arraySource objectAtIndex:index] objectForKey:@"image_url"]];
        [arrTitle addObject:[[arraySource objectAtIndex:index] objectForKey:@"name"]];
        [arrURL addObject:[[arraySource objectAtIndex:index] objectForKey:@"url"]];
        [arrPrice addObject:[[arraySource objectAtIndex:index] objectForKey:@"real_price"]];
    }
    arrayImage = [NSArray arrayWithArray:arrImage];
    arrayTitle = [NSArray arrayWithArray:arrTitle];
    arrayURL = [NSArray arrayWithArray:arrURL];
    arrayPrice = [NSArray arrayWithArray:arrPrice];
    int index = (int)arraySource.count/ROW_INDEX;
    int number = arraySource.count%ROW_INDEX;
    if (number != 0) {
        page = index+1;
    }else{
        page = index;
    }
    NSLog(@"page == %d",page);
    [self initView:view];
}

- (void)initView: (UIView *)view{
    //定义scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, HEIGHT)];
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
        rect.size.height = HEIGHT;
        rect.size.width = gtWIDTH;
        viewBG.frame = rect;
        //        viewBG.tag = i + 1000;
        [scrollView addSubview:viewBG];
        int number = ROW_INDEX;
        if (i == page) {
            number = arraySource.count%ROW_INDEX;
            if (number == 0) {
                number = ROW_INDEX;
            }
        }
//        NSLog(@"image = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"DicHomeGoodsImage"]);
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DicHomeGoodsImage"]) {
//            for (int index = 0; index < arrayImage.count; index ++ ) {
//                if ([[arrayImage objectAtIndex:index] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"DicHomeGoodsImage"] objectAtIndex:index]]) {
//                    isLocation = 1;
//                }else{
//                    [[NSUserDefaults standardUserDefaults] setObject:arrayImage forKey:@"DicHomeGoodsImage"];
//                }
//            }
//        }else{
//            [[NSUserDefaults standardUserDefaults] setObject:arrayImage forKey:@"DicHomeGoodsImage"];
//        }
        for (int index = 0; index < number; index ++ ) {
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(index * gtWIDTH/ROW_INDEX, 0, gtWIDTH/ROW_INDEX, HEIGHT)];
            viewCell.backgroundColor = [UIColor clearColor];
            [viewBG addSubview:viewCell];
            UIImageView *imageViewIcon = [[UIImageView alloc] init];
            NSLog(@"number== %d",((i-1)*ROW_INDEX + index));
            [imageViewIcon sd_setImageWithURL:[arrayImage objectAtIndex:((i-1)*ROW_INDEX + index)]];
            
//            if (isLocation == 0) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    UIImage *image;
//                    image = [super getImageForUrl:[arrayImage objectAtIndex:((i-1)*ROW_INDEX + index)]];
//                    [super saveImage:image WithName:[NSString stringWithFormat:@"homeGoodsImage%d",index]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageViewIcon.image = image;
//                    });
//                });
//            }else{
//                UIImage *image = [super getImageWithName:[NSString stringWithFormat:@"homeGoodsImage%d",index]];
//                imageViewIcon.image = image;
//            }
//            
//            NSLog(@"index == %d",(i-1)*ROW_INDEX + index);
            [viewCell addSubview:imageViewIcon];
            [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(96, 67));
                make.top.mas_equalTo(16);
                make.centerX.equalTo(viewCell);
            }];
            UILabel *labName = [[UILabel alloc] init];
            labName.text = [arrayTitle objectAtIndex:((i-1) * ROW_INDEX + index)];
            labName.textAlignment = NSTextAlignmentCenter;
            labName.textColor = COLOR_TEXT_GARY_DEEP;
            labName.font = [UIFont systemFontOfSize:14];
            [viewCell addSubview:labName];
            [labName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.centerX.equalTo(viewCell);
                make.top.mas_equalTo(91);
                make.height.mas_equalTo(14);
            }];
            
            UILabel *labPrice = [[UILabel alloc] init];
            labPrice.text = [NSString stringWithFormat:@"¥ %@",[arrayPrice objectAtIndex:((i-1) * ROW_INDEX + index)]];
            labPrice.textAlignment = NSTextAlignmentCenter;
            labPrice.textColor = COLOR_MAIN_GREEN;
            labPrice.font = [UIFont systemFontOfSize:16];
            [viewCell addSubview:labPrice];
            [labPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.centerX.equalTo(viewCell);
                make.top.mas_equalTo(114);
                make.height.mas_equalTo(16);
            }];
            UIButton *btnBus = [[UIButton alloc] initWithFrame:CGRectMake(0,0,gtWIDTH/4,103)];
            btnBus.tag = 201+i*ROW_INDEX+index;
            [btnBus addTarget:self action:@selector(btnCellClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewCell addSubview:btnBus];
        }
        //        [self initCollectionView:viewBG];
        
        
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
    NSLog(@"tag == %ld",button.tag - 204);
    int index = (int)button.tag - 204;
    [_delegate didGoodsArray:[arraySource objectAtIndex:index] name:@"HomeBus"];
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
