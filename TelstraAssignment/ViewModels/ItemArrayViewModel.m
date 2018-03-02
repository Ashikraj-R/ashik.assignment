//
//  ItemArrayViewModel.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemArrayViewModel.h"
#import "ItemModel.h"
#import "Constants.h"

@interface ItemArrayViewModel ()

@property (strong, nonatomic) ItemArrayModel *itemArrayModel;

@end

@implementation ItemArrayViewModel

- (NSString *) listTitle {
    
    if(self.itemArrayModel) {
        if(self.itemArrayModel.title) {
            return self.itemArrayModel.title;
        }
    }
    
    return @"";
    
}

- (NSArray *) itemsList {
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    if(self.itemArrayModel) {
        if(self.itemArrayModel.itemsList) {
            
            for(ItemModel *itemModel in self.itemArrayModel.itemsList) {
                [itemsArray addObject:[[ItemViewModel alloc] initWithModel:itemModel]];
            }
            
        }
    }
    
    return itemsArray;
    
}

- (NSUInteger) itemsCount {
    
    if(self.itemArrayModel) {
        return self.itemArrayModel.itemsList.count;
    }
    else {
        return 0;
    }
    
}

- (ItemViewModel *) itemAtIndex:(NSUInteger)index {
    
    ItemViewModel *itemViewModel = [[ItemViewModel alloc] init];
    if(self.itemArrayModel) {
        if(self.itemsList.count > index) {
            itemViewModel = [[ItemViewModel alloc] initWithModel:[self.itemsList objectAtIndex:index]];
            return itemViewModel;
        }
    }
    
    return itemViewModel;
    
}

- (void) fetchItemswithCompletionHandler:(void (^)(NSError * error))completionBlock {
    
    NSLog(MESSAGE_ENTERING,__FUNCTION__);
    
    [ItemArrayModel fetchItemswithCompletionHandler:^(ItemArrayModel *itemArrayModel, NSError *error) {
        if(itemArrayModel) {
            self.itemArrayModel = itemArrayModel;
            completionBlock(nil);
        }
        else {
            completionBlock(error);
        }
    }];
    
    NSLog(MESSAGE_EXITING,__FUNCTION__);
    
}

@end
