//
//  OBDPickerView.h
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/11.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIView *view;

- (UIView *)pickerViewWithArray: (NSArray *)array color: (UIColor *)color;

@end
