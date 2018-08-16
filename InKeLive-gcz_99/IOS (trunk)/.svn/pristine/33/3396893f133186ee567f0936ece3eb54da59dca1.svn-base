//
//  SelectGiftCountView.m
//  InKeLive
//
//  Created by gu  on 17/9/17.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SelectGiftCountView.h"

@interface SelectGiftCountView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    int giftNum_;
}

@end

@implementation SelectGiftCountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
        giftNum_ = 0;
    }
    return self;
}

-(void) setSubViews {
    
    ////
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIButton *viewBKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    viewBKBtn.frame = frame;
    viewBKBtn.backgroundColor = RGBA(0, 0, 0, 0.3);
    viewBKBtn.tag = 2000;
    [viewBKBtn addTarget:self action:@selector(btnClickedBKBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBKBtn];
    /////
    frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    UIView* viewBK2 = [[UIView alloc] initWithFrame:frame];
    viewBK2.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewBK2];

    ////
    frame = CGRectMake(10, SCREEN_HEIGHT/2 + 5, SCREEN_WIDTH/2, 36);
    UILabel* numTipLabel = [[UILabel alloc] initWithFrame:frame];
    numTipLabel.backgroundColor = [UIColor clearColor];
    numTipLabel.textColor = [UIColor grayColor];
    numTipLabel.text = @"请选择赠送数量";
    numTipLabel.font =[UIFont systemFontOfSize:18];
    [self addSubview:numTipLabel];
    
    ////
    frame = CGRectMake(SCREEN_WIDTH -70, SCREEN_HEIGHT/2 + 5, 60, 40);
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = frame;
    doneBtn.backgroundColor =RGB(160, 0, 0);
    doneBtn.tag = 2000;
    doneBtn.layer.cornerRadius = 4;
    doneBtn.layer.masksToBounds = YES;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnClickedDone:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];

    ////
    frame = CGRectMake(0, SCREEN_HEIGHT/2 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_HEIGHT/2 + 40));
    pickerArray = [[NSArray alloc]initWithObjects:@"1",@"11",@"111",@"438",@"520",
                   @"888",@"999",@"1314",@"8888",@"9999",@"88888",@"99999",
                   @"888888",@"999999",@"1314520",@"8888888",@"9999999", nil];
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.frame =frame;
    myPickerView.backgroundColor =[UIColor whiteColor];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self addSubview:myPickerView];
}


-(void) btnClickedBKBtn:(id)sender {
    [self hide];
}

-(void) btnClickedDone:(id)sender {
    if (self.numClick) {
        self.numClick(giftNum_);
    }
    [self hide];
}


//弹出窗口
- (void)popShow {
    //这个Window是什么?
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
}

-(void)hide {
    [self removeFromSuperview];
}

-(void)dealloc {
    NSLog(@"SelectGiftCountView dealloc()...\n");
}



#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    //[myTextField setText:[pickerArray objectAtIndex:row]];
    NSString* text = [pickerArray objectAtIndex:row];
    giftNum_ = [text intValue];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}


@end




