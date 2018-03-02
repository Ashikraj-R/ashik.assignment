//
//  ItemViewModel.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemViewModel.h"

@interface ItemViewModel ()

@property (strong, nonatomic) ItemModel *itemModel;

@end

@implementation ItemViewModel

- (NSString *) itemTitle {
    
    if(self.itemModel) {
        if(self.itemModel.itemTitle) {
            return [self.itemModel.itemTitle stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        }
    }
    
    return @"";
    
}

- (NSString *) itemDescription {
    
    if(self.itemModel) {
        if(self.itemModel.itemDescription) {
            return [self.itemModel.itemDescription stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        }
    }
    
    return @"";
    
}

- (NSString *) imageURL {
    
    if(self.itemModel) {
        if(self.itemModel.imageURL) {
            return [self.itemModel.imageURL stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        }
    }
    
    return @"";
    
}

- (instancetype)initWithModel:(ItemModel *) itemModel {
    
    self = [super init];
    
    if(self) {
        self.itemModel = itemModel;
    }
    
    return self;
    
}

@end
