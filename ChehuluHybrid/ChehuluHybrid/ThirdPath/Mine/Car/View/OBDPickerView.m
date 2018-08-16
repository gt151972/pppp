//
//  OBDPickerView.m
//  ChehuluHybrid
//
//  Created by 高天的Mac on 2017/3/11.
//  Copyright © 2017年 GT mac. All rights reserved.
//

#import "OBDPickerView.h"
#import "CommendFile.h"

@implementation OBDPickerView

- (UIView *)pickerViewWithArray:(NSArray *)array color:(UIColor *)color{
    _view = [[UIView alloc] init];
    UIButton *btnBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, gtWIDTH, gtHEIGHT)];
    [btnBg setBackgroundColor:[UIColor  colorWithWhite:0 alpha:0.5]];
    [btnBg addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:btnBg];
    // 选择框
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, gtWIDTH - 80, gtWIDTH, 180)];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.backgroundColor = [UIColor redColor];
    pickerView.tintColor = color;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [_view addSubview:pickerView];
    
    _array = array;

    return _view;
}

- (void)btnClicked: (UIButton *)button{
    [_view setHidden:YES];
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _array.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return gtWIDTH;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 发送通知
    [center postNotificationName:@"obdRow"  object:[NSString stringWithFormat:@"%ld",(long)row]];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_array objectAtIndex:row];
}

@end
