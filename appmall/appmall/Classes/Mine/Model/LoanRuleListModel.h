//
//  LoanRuleListModel.h
//  appmall
//
//  Created by majun on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"

@interface LoanRuleListModel : BaseModel
/**  欠款时长*/
@property (nonatomic, copy) NSString *time;
/**  到期应付金额*/
@property (nonatomic, copy) NSString *paymoney;
/**  最晚还款日*/
@property (nonatomic, copy) NSString *paytime;
/**  欠款时长id*/
//@property (nonatomic, copy) NSString *applyid;
/**  费率*/
@property (nonatomic, copy) NSString *poundage;
/**  */
@property (nonatomic, copy) NSString *length_time;
/** 欠款时长配置id*/
@property (nonatomic, copy) NSString *loanid;

@end
