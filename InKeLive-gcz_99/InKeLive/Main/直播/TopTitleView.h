//
//  TopTitleView.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTitleView : UIView

@property (nonatomic,assign) NSInteger lastTag;

@property (nonatomic,copy)void (^titleClick)(NSInteger tag, NSInteger lastTag);

@property (nonatomic,strong)UIScrollView *titleScrollView;

@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic,strong)UIImageView *lineImageView;

- (void)scrollMove:(NSInteger)tag;
- (void)CreatUI;
@end
