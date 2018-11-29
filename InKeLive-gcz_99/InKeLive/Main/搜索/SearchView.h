//
//  SearchView.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InKeModel.h"
@interface SearchView : UIView

@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)UIButton *cancleButton;

@property (nonatomic,strong)UIButton *searchButton;

@property (nonatomic,copy)void (^cancleBlock)();
@property (nonatomic,copy)void (^hideBlock)();
- (void) popToView;
- (void) hide;

@end
