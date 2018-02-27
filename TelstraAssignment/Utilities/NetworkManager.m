//
//  NetworkManager.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

//Method to get the date from the dropbox url
//urlString : URL of the dropbox server in string format
+ (void) getListFromServer:(NSString *)urlString withCompletionHandler:(void (^)(NSDictionary *responseDictionary, NSError * err))completionBlock {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(response) {
             
             //Performing check if make sure received response is correct.
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             if(httpResponse.statusCode == 200 && data != nil) {
                 
                 //Due to difference in encoding received from server, first converting data to string using charset=ISO-8859-1 encoding and then converting the string back to utf-8 encoded data.
                 NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                 NSData *utfData = [decodedString dataUsingEncoding:NSUTF8StringEncoding];
                 NSError *parserError;
                 NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:utfData options:0 error:&parserError];
                 
                if(dictionary) {
                    completionBlock(dictionary,nil);
                }
                else {
                    completionBlock(nil,parserError);
                }
                 
             }
             else {
                 completionBlock(nil, error);
             }
         }
         else {
             completionBlock(nil, error);
         }
     }];
}

//Method to download the image
//urlString : URL of the image
+ (void) downloadImage:(NSString *)urlString withCompletionHandler:(void (^)(NSData *imageData, NSError * err))completionBlock {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(response) {
             
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if(httpResponse.statusCode == 200 && data != nil) {
                completionBlock(data,nil);
             }
             else {
                 completionBlock(nil, error);
             }
             
         }
         else {
             completionBlock(nil, error);
         }
     }];
}

@end
