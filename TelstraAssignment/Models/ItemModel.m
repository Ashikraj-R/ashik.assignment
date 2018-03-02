//
//  ItemModel.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{@"itemTitle":@"title",
              @"itemDescription":@"description",
              @"imageURL":@"imageHref"}];
    
}

@end
