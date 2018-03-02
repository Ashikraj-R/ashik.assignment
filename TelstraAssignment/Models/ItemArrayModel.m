//
//  ItemArray.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemArrayModel.h"
#import "NetworkManager.h"
#import "Reachability.h"
#import "Constants.h"

@implementation ItemArrayModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{@"title":@"title",
              @"itemsList":@"rows"}];
    
}

+ (void) fetchItemswithCompletionHandler:(void (^)(ItemArrayModel *itemArrayModel, NSError * error))completionBlock {
    
    //Check for internet connection and show error if not available
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        
        //Creating custom error object
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        [info setValue:@"Internet Connection not available" forKey:@"Message"];
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-1009 userInfo:info];
        
        completionBlock(nil,error);
        
        return;
    }
    
    //Perform service call to fetch list from server
    [NetworkManager getListFromServer:URL_FOR_LIST withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        
        //Check if no error is present
        if(error == nil && dictionary != nil) {
            
            NSError *err;
            ItemArrayModel *itemArrayModel = [[ItemArrayModel alloc] initWithDictionary:dictionary error:&err];
            completionBlock(itemArrayModel, err);
            
        }
        else {
            
            if(error) {
                completionBlock(nil,error);
            }
            else {
                //Creating custom error object
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                [info setValue:@"Some error occured" forKey:@"Message"];
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-1009 userInfo:info];
                
                completionBlock(nil,error);
            }
            
        }
    }];
    
}

@end
