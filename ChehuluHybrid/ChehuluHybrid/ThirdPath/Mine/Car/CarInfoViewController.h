//
//  CarInfoViewController.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/22.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BaseViewController.h"
@protocol CarInfoDelegate
-(void)passViewController:(NSDictionary*)dic;//1a.定义协议与方法
@end

@interface CarInfoViewController : BaseViewController
@property(retain, nonatomic)id<CarInfoDelegate>carInfoDelegate;
@property (nonatomic,strong)NSDictionary *dic;
@end
