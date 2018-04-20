//
//  YSCollectionCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/5/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMyCollectionModel.h"
@interface YSCollectionCell : UITableViewCell

-(void)refreshCellWithCollectionModel:(SCMyCollectionModel*)collectionM;

@end
