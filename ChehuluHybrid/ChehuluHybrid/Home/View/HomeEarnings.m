//
//  HomeEarnings.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/4/21.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "HomeEarnings.h"

@implementation HomeEarnings
- (void)showViewWithView:(UIView *)view array:(NSArray *)array{
    arraySource = [NSArray arrayWithArray:array];
    //    NSLog(@"arraySource == %@",arraySource);
    NSMutableArray *arrImage = [[NSMutableArray alloc] init];
    NSMutableArray *arrTitle= [[NSMutableArray alloc] init];
    NSMutableArray *arrURL = [[NSMutableArray alloc] init];
    for (int index = 0; index < arraySource.count; index ++ ) {
        [arrImage addObject:[[arraySource objectAtIndex:index] objectForKey:@"img_url"]];
        [arrTitle addObject:[[arraySource objectAtIndex:index] objectForKey:@"name"]];
        [arrURL addObject:[[arraySource objectAtIndex:index] objectForKey:@"url"]];
    }
    arrayImage = [NSArray arrayWithArray:arrImage];
    arrayTitle = [NSArray arrayWithArray:arrTitle];
    arrayURL = [NSArray arrayWithArray:arrURL];
    int index = (int)arraySource.count/4;
    int number = arraySource.count%4;
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
    UIView *viewBg= [[UIView alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, 103)];
    [viewBg setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:viewBg];
    
    

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
        int number = 4;
        if (i == page) {
            number = arraySource.count%4;
            if (number == 0) {
                number = 4;
            }
        }
        
        for (int index = 0; index < number; index ++ ) {
            UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(index * gtWIDTH/4, 0, gtWIDTH/4, 103)];
            viewCell.backgroundColor = [UIColor clearColor];
            [viewBG addSubview:viewCell];
            UIImageView *imageViewIcon = [[UIImageView alloc] init];
            //            NSLog(@"number== %d",((i-1)*4 + index));
            if (isLocation == 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image;
                    image = [super getImageForUrl:[arrayImage objectAtIndex:((i-1)*4 + index)]];
                    //                    NSLog(@"imageUrl == %@",[arrayImage objectAtIndex:index]);
                    [super saveImage:image WithName:[NSString stringWithFormat:@"homeBusImage%d",index]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageViewIcon.image = image;
                    });
                });
            }else{
                UIImage *image = [super getImageWithName:[NSString stringWithFormat:@"homeBusImage%d",index]];
                imageViewIcon.image = image;
            }
            
            [viewCell addSubview:imageViewIcon];
            [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.top.mas_equalTo(24);
                make.centerX.equalTo(viewCell);
            }];
            UILabel *labName = [[UILabel alloc] init];
            labName.text = [arrayTitle objectAtIndex:((i-1) * 4 + index)];
            labName.textAlignment = NSTextAlignmentCenter;
            labName.textColor = COLOR_TEXT_GARY_DEEP;
            labName.font = [UIFont systemFontOfSize:12];
            [viewCell addSubview:labName];
            [labName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.centerX.equalTo(viewCell);
                make.top.mas_equalTo(68);
                make.height.mas_equalTo(12);
            }];
            UIButton *btnBus = [[UIButton alloc] initWithFrame:CGRectMake(0,0,gtWIDTH/4,103)];
            btnBus.tag = 201+i*4+index;
            [btnBus addTarget:self action:@selector(btnCellClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewCell addSubview:btnBus];
        }
        //        [self initCollectionView:viewBG];
        
        
    }
    
//    [self layoutScrollImages1]; //设置图片格式
    [view addSubview:scrollView]; //将scrollView封装到featureView
    
    //定义pageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 95, gtWIDTH, 8)];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = page;
    [view addSubview:pageControl]; //将pageControl封装到featureView
}


@end
