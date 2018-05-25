//
//  HonourListViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HonorListModel.h"
@interface HonourListViewCell : UITableViewCell

-(void)reloadDataModel:(HonorListModel *)model;

@end
