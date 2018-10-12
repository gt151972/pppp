//
//  TopTitleView.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
// 首页titleView

#import "TopTitleView.h"
#import "MyControlTool.h"

#define bWidth self.width/3

@implementation TopTitleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)scrollMove:(NSInteger)tag{
    UIButton *buttons = (UIButton *)[self viewWithTag:tag];
    [UIView animateWithDuration:0.3 animations:^{
        self.lineImageView.size = CGSizeMake(buttons.titleLabel.width, 3);
        self.lineImageView.centerX = buttons.centerX;
//        if (_btnTitleClicked) {
//            self.btnTitleClicked(tag);
//        }
    }];
}

#pragma 加载
//- (NSArray *)titleArr{
//    if (!_titleArr) {
////        _titleArr = @[@"关注",@"热门",@"附近"];
//        
//        _titleArr = @[@"推荐", @"手机", @"房间", @"客服"];
//    }
//    return _titleArr;
//}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc]init];
        _lineImageView.backgroundColor = MAIN_COLOR;
    }
    return _lineImageView;
}

- (void)CreatUI{
    UIView *topClassifyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:topClassifyView];
    CGFloat btnWidth = self.frame.size.width/3;
    CGFloat scrollWidth = btnWidth * _titleArr.count;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(scrollWidth, 35);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [topClassifyView addSubview:scrollView];
    for (NSInteger i = 0; i < self.titleArr.count; i++) {
        WEAKSELF;
        UIButton *buttons = [MyControlTool buttonWithText:self.titleArr[i] textColor:TEXT_COLOR selectTextColor:MAIN_COLOR font:18 tag:50 + i frame:CGRectMake(i * bWidth, 0, bWidth, 44) clickBlock:^(id x) {
            UIButton *button = (UIButton *)x;
            buttons.selected = !buttons.selected;
            [weakSelf scrollMove:button.tag];
            if (weakSelf.titleClick) {
                weakSelf.titleClick(button.tag, _lastTag);
                _lastTag = button.tag;
            }
        }];
        [scrollView addSubview:buttons];
        
        if (i == 0) {
            [buttons.titleLabel sizeToFit];
            self.lineImageView.frame = CGRectMake(0, 40, buttons.titleLabel.width, 3);
            self.lineImageView.centerX = buttons.centerX;
            UIButton *button = (UIButton *)[self viewWithTag:50];
            button.selected = YES;
            _lastTag = button.tag;
            [scrollView addSubview:self.lineImageView];
        }
    }
}


@end
