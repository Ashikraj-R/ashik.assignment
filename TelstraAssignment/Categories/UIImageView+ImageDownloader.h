//
//  UIImageView+ImageDownloader.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 28/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageDownloader)

- (void)downloadImageFromUrl:(NSString *)urlString withCompletionHandler:(void (^)(NSData *imageData, NSString *imageURL))completionBlock;

@end
