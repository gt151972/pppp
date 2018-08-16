//
//  ShareAlertSheet.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/5/11.
//  Copyright © 2017年 GT mac. All rights reserved.
//

//#import "BaseView.h"
//
//@interface ShareAlertSheet : BaseView


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol ShareAlertSheetDelegate <NSObject>

@required
- (void)didChoseIndex:(int)index name:(NSString*)name;

@end

@interface ShareAlertSheet : BaseView<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    UICollectionView *collection;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) id<ShareAlertSheetDelegate>delegate;


- (void)initViewWithView: (UIView *)view;
- (void)showInView:(UIView *)view;

@end
