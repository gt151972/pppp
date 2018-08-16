//
//  NoOBD.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/3/27.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseView.h"

@protocol  NoOBDDelegate<NSObject>

@required
- (void)didNoOBDName:(NSString*)name;
@end
@interface NoOBD : BaseView{
    UIView *viewBg;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) id<NoOBDDelegate>delegate;

/**
 没车,可立即体验

 @param view <#view description#>
 */
- (void)addViewNoCar: (UIView *)view;



/**
 有车,可切换

 @param view <#view description#>
 */
- (void)addViewNoOBD: (UIView *)view strCarNo: (NSString *)strCarNo;


/**
 <#Description#>
 */
- (void)removeView;

@end
