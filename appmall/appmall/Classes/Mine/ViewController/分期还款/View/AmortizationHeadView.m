//
//  AmortizationHeadView.m
//  appmall
//
//  Created by majun on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AmortizationHeadView.h"

@implementation AmortizationHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"AmortizationHeadView" owner:self options:nil] firstObject];
    self.frame = frame;
    return self;
}

- (IBAction)rightBtnAction:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(showAndHiddrenCell:)]) {
        [self.delegate showAndHiddrenCell:sender];
        
    }
    
}


@end
