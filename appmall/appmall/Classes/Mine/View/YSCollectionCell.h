//
//  YSCollectionCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/5/19.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMyCollectionModel.h"
@interface YSCollectionCell : UITableViewCell

-(void)refreshCellWithCollectionModel:(SCMyCollectionModel*)collectionM;

@end
