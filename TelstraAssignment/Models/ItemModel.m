//
//  ItemModel.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithDict:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if(self)
    {
        if([dictionary objectForKey:@"title"]) {
            
            //Check if null received in JSON
            if([dictionary objectForKey:@"title"] == [NSNull null]) {
                self.itemTitle = @"";
            }
            else {
                self.itemTitle = [dictionary objectForKey:@"title"];
            }
        }
        
        if([dictionary objectForKey:@"description"]) {
            
            //Check if null received in JSON
            if([dictionary objectForKey:@"description"] == [NSNull null]) {
                self.itemDescription = @"";
            }
            else {
                self.itemDescription = [dictionary objectForKey:@"description"];
            }
        }
        
        if([dictionary objectForKey:@"imageHref"]) {
            
            //Check if null received in JSON
            if([dictionary objectForKey:@"imageHref"] == [NSNull null]) {
                self.imageURL = @"";
            }
            else {
                self.imageURL = [dictionary objectForKey:@"imageHref"];
            }
        }
    }
    
    return self;
}

@end
