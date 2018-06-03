//
//  MyInvoicesModel.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInvoicesModel : NSObject
@property(nonatomic,assign)BOOL isSelect;
/**  发票id*/
@property (nonatomic, copy) NSString *invoiceid;
/**  公司抬头*/
@property (nonatomic, copy) NSString *issuingoffice;
/**  抬头类型*/
@property (nonatomic, copy) NSString *invoiceheadtype;
/**  税号*/
@property (nonatomic, copy) NSString *taxpayer_identification_number;
/**  审核状态*/
@property (nonatomic, copy) NSString *disposestatus;
/**  拒绝理由*/
@property (nonatomic, copy) NSString *disposereason;
@end
