//
//  SCConfirmOrderAddressCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/3.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface SCConfirmOrderAddressCell : UITableViewCell

-(void)refreshWithAddressModel:(AddressModel *)addressModel;

@end
