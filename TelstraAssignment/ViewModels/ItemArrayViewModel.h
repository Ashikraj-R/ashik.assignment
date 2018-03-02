//
//  ItemArrayViewModel.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemArrayModel.h"
#import "ItemViewModel.h"

@interface ItemArrayViewModel : NSObject

@property (nonatomic, readonly) NSString* listTitle;
@property (nonatomic, readonly) NSArray* itemsList;

- (NSUInteger) itemsCount;
- (ItemViewModel *) itemAtIndex:(NSUInteger)index;
- (void) fetchItemswithCompletionHandler:(void (^)(NSError * error))completionBlock;

@end
