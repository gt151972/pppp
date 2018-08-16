//
//  CarbonView.h
//  ChehuluHybrid
//
//  Created by GT mac on 16/7/18.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommendFile.h"
#import <Masonry.h>

@interface CarbonView : UIView{
    int max;
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong)UIBezierPath *pathCircle;
@property (nonatomic, assign)float carbonFloat;


- (UIView *)carbonViewWithColor: (UIColor *)color carbon: (NSString *)carbon maxCarbon : (int)maxCarbon;
@end
