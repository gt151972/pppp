//
//  BasePickerView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/28.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>
- (int)pickViewWithArraySource:(NSArray *)arraySource selectIndex:(int)selectIndex;
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end
