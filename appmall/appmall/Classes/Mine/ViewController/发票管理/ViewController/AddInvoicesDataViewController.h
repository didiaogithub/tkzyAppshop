//
//  AddInvoicesDataViewController.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

@interface AddInvoicesDataViewController : BaseViewController
/**  tempid*/
@property (nonatomic, strong) NSString *tempid;
/**  是否是从点击修改发票详情过来的*/
@property (nonatomic, assign) BOOL isUpdateFaPDetail;
@end
