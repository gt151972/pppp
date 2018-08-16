//
//  BasePickerView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 2017/2/28.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView{
    NSArray *array;
    int components;//列数
}
//- (NSString *)pickViewWithArraySource:(NSArray *)arraySource selectIndex:(int)selectIndex{
//    UIPickerView *pickerView = [[UIPickerView alloc] init];
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
//    pickerView.showsSelectionIndicator=YES;
//    array = arraySource;
//}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return array.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 1) {
        return 40;
    }
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString  *strSelect = [array objectAtIndex:row];
    NSLog(@"_proTimeStr=%@",strSelect);
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return [array objectAtIndex:row];
}
@end
