//
//  VPTSimpleCell.h
//  omega
//
//  Created by leon on 8/28/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>

enum VPTSimpleCellType{
    VPTSimpleCellFolder,
    VPTSimpleCellBoard,
    VPTSimpleCellTopic,
    VPTSimpleCellTop,
    VPTSimpleCellFavourite
};

@interface VPTSimpleCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic) enum VPTSimpleCellType type;
@end
