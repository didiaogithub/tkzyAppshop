//
//  RecommendViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKHomeDataModel.h"


@interface RecommendMediaViewCell : UITableViewCell

-(void)refreshData:(TKHomeDataModel *)model;
@end