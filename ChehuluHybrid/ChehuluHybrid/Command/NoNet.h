//
//  NoNet.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/31.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"
@protocol NoNetDelegate <NSObject>

@required
- (void)noNetClicked;

@end

@interface NoNet : BaseView
@property (nonatomic, assign) id<NoNetDelegate>delegate;
@property (nonatomic, strong) UIView *backGroundView;
@end
