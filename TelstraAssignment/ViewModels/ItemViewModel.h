//
//  ItemViewModel.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface ItemViewModel : NSObject

@property (strong, readonly) NSString *itemTitle;
@property (strong, readonly) NSString *itemDescription;
@property (strong, readonly) NSString *imageURL;

- (instancetype)initWithModel:(ItemModel *) itemModel;

@end
