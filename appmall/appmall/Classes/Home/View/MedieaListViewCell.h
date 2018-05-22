//
//  MedieaListViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaListModel.h"

@interface MedieaListViewCell : UITableViewCell

-(void)reloadDataModel:(MediaListModel *)model;

@end
