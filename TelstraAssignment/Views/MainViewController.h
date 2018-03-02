//
//  MainViewController.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemArrayViewModel.h"

@interface MainViewController : UITableViewController

@property (nonatomic, strong) ItemArrayViewModel *itemArrayViewModel;

- (instancetype)initWithViewModel:(ItemArrayViewModel *) itemArrayViewModel;

@end
