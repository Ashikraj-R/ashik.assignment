//
//  MainViewController.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkManager.h"
#import "ItemModel.h"
#import "CustomTableCell.h"
#import "UIImageView+ImageDownloader.h"
#import "Reachability.h"
#import "Constants.h"

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) NSCache *cache;

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialSetup];
    [self fetchAndRefresh];
    
}

- (void) initialSetup {
    
    //Initialize the required objects
    self.dataList = [[NSMutableArray alloc] init];
    self.cache = [[NSCache alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    //Set target to refresh control and add to the table view
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //Set the table cell height to dynamic so it increases or decreases depending on cell content
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
}

- (void) refreshTable {
    [self fetchAndRefresh];
}

- (void) fetchAndRefresh {
    
    @try {
        
        //Check for internet connection and show error if not available
        if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
            [self showError:ERROR_NO_INTERNET];
            return;
        }
        
        //Perform service call to fetch list from server
        [NetworkManager getListFromServer:URL_FOR_LIST withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
            
            //Check if no error is present
            if(error == nil && dictionary != nil) {
                
                if([dictionary objectForKey:@"title"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.navigationController.navigationBar.topItem.title = [dictionary objectForKey:@"title"];
                    });
                }
                
                if([dictionary objectForKey:@"rows"]) {
                    
                    //Checking if the row type is dictionary to avoid crashes
                    if([[dictionary objectForKey:@"rows"] isKindOfClass:[NSArray class]]) {
                        [self.dataList removeAllObjects];
                        NSArray *itemsList = [dictionary objectForKey:@"rows"];
                        
                        //Iterating and creating item models by passing the row data
                        for(NSDictionary *itemData in itemsList) {
                            ItemModel *item = [[ItemModel alloc] initWithDict:itemData];
                            if(item) {
                                [self.dataList addObject:item];
                            }
                        }
                        
                        //Pushing to main thread since UI related changes
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.refreshControl endRefreshing];
                            [self.tableView reloadData];
                        });
                    }
                }
            }
            else {
                [self showError:ERROR_FETCH_FAILED];
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Error occured : %@", exception);
    }
    
}

- (void)showError:(NSString *)errorMessage
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:errorMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    //Adding ok buttons to alert controller
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ItemCell";
    
    CustomTableCell *customCell = (CustomTableCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (customCell == nil) {
        customCell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    @try {
        ItemModel *item = [self.dataList objectAtIndex:indexPath.row];
        
        if(item) {
            
            customCell.titleLabel.text = item.itemTitle;
            customCell.descriptionLabel.text = item.itemDescription;
            customCell.itemImage.image = nil;
            
            //Load image data from cache if available
            if([_cache objectForKey:item.imageURL]) {
                customCell.itemImage.image = [UIImage imageWithData:[_cache objectForKey:item.imageURL]];
            }
            else {
                [customCell.itemImage downloadImageFromUrl:item.imageURL withCompletionHandler:^(NSData *imageData, NSString *imageURL) {
                    
                    //Dispatching in main thread to avoid redownload if user quickly scrolls up and down (Quick change of visible cells)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_cache setObject:imageData forKey:imageURL];
                    });
                    
                }];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error occured : %@", exception);
    }
    
    return customCell;
}

@end
