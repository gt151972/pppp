//
//  gtPickerView.h
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/12/9.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gtPickerView : UIView

/**
 *  pickerView
 *
 *  @param arrayData 各个数组的集合
 *
 *  @param title 标题
 *
 *  @return
 */
- (UIView *)pickerViewWithArrayData : (NSArray *)arrayData title:(NSString *)title;
@end
