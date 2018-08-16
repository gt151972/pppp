//
//  gtPickerView.m
//  ChehuluHybrid
//
//  Created by 高婷婷 on 16/12/9.
//  Copyright © 2016年 GT mac. All rights reserved.
//

#import "gtPickerView.h"
#import "CommendFile.h"

@interface gtPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *array;
}

@end
@implementation gtPickerView

/**
 *  pickerView
 *
 *  @param arrayData 各个数组的集合
 *
 *  @param title 标题
 *
 *  @return
 */
- (UIAlertController *)pickerViewWithArrayData : (NSArray *)arrayData title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIButton *btnOk = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 50, 0, 40, 14)];
    [btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [btnOk setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnOk.titleLabel setFont: [UIFont systemFontOfSize:12]];
    [btnOk addTarget:self action:@selector(btnOkClicked) forControlEvents:UIControlEventTouchUpInside];
    [alertController.view addSubview:btnOk];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(gtWIDTH - 50, 0, 40, 14)];
    [btnCancel setTitle:@"确定" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont: [UIFont systemFontOfSize:12]];
    [btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [alertController.view addSubview:btnCancel];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 14, gtWIDTH, 300)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [alertController.view addSubview:pickerView];
    return alertController;
    
    //加载数据
    array = [[NSArray alloc] initWithArray:arrayData];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return array.count;
}



//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    for (int index = 0; index<array.count; index ++) {
//        component = index;
//        return [[array objectAtIndex:index] count];
//    }
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return [[provinces objectAtIndex:row] objectForKey:@"state"];
//            break;
//        case 1:
//            return [[cities objectAtIndex:row] objectForKey:@"city"];
//            break;
//        case 2:
//            if ([areas count] > 0) {
//                return [areas objectAtIndex:row];
//                break;
//            }
//        default:
//            return  @"";
//            break;
//    }
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    switch (component) {
//        case 0:
//            cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
//            [self.ppView selectRow:0 inComponent:1 animated:YES];
//            [self.ppView reloadComponent:1];
//            
//            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
//            [self.ppView selectRow:0 inComponent:2 animated:YES];
//            [self.ppView reloadComponent:2];
//            
//            self.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
//            self.city = [[cities objectAtIndex:0] objectForKey:@"city"];
//            if ([areas count] > 0) {
//                self.district = [areas objectAtIndex:0];
//            } else{
//                self.district = @"";
//            }
//            break;
//        case 1:
//            areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
//            [self.ppView selectRow:0 inComponent:2 animated:YES];
//            [self.ppView reloadComponent:2];
//            
//            self.city = [[cities objectAtIndex:row] objectForKey:@"city"];
//            if ([areas count] > 0) {
//                self.district = [areas objectAtIndex:0];
//            } else{
//                self.district = @"";
//            }
//            break;
//        case 2:
//            if ([areas count] > 0) {
//                self.district = [areas objectAtIndex:row];
//            } else{
//                self.district = @"";
//            }
//            break;
//        default:
//            break;
//    }
//}


//- (NSArray *)btnOkClicked{
//    
//}

- (void)btnCancelClicked{
    
}
@end
