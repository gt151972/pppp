//
//  SearchInfoView.m
//  InKeLive
//
//  Created by 高婷婷 on 2018/8/23.
//  Copyright © 2018年 jh. All rights reserved.
//

#import "SearchInfoView.h"
@interface SearchInfoView()
@property (weak, nonatomic) IBOutlet UIView *searchBg;

@end
@implementation SearchInfoView
- (UIView *)searchBg{
    _searchBg.layer.masksToBounds = YES;
    _searchBg.layer.cornerRadius = 18.0;
    _searchBg.layer.borderWidth = 2;
    _searchBg.layer.borderColor = RGB(24, 24, 24).CGColor;
    return _searchBg;
}

- (IBAction)btnBackClicked:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)btnGoToNextViewClicked:(id)sender {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
