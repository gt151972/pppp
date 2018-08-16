//
//  Calender.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/17.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DateChange.h"
#import "BaseView.h"
#import "IndexRequestDAL.h"

@protocol CalenderDelegate <NSObject>

@required
- (void)calenderChooseDate:(NSString *)date name:(NSString *)name;

@end

@interface Calender : BaseView <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IndexRequestDelegate>{
    NSDictionary *dicToday;
    UITableViewCell *cell;
    DateChange *dateChange;
    IndexRequestDAL *indexDal;
    
    int theYear;//今年
    int theMoon;//本月
    NSString *strStartDay;
    int aYear;//指定年
    int aMonth;//指定月
    int aDay;//指定日
    int firstFrame;
    
    int page;//当前页为最新页的第几页
    
    UIView *viewPoint;
    UILabel *labDay;
    
    NSDictionary *dicCarStatus;//停驶情况
    
    int mon;
}

@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, assign) id<CalenderDelegate>delegate;

- (void)initWithToday: (NSDictionary *)today;
- (void)showInView:(UIView *)view;

@end
