//
//  CustomTableCell.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //Inital Setup for title label
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:self.titleLabel];
        
        //Inital Setup for description label
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textColor = [UIColor blackColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:self.descriptionLabel];
        
        //Inital Setup for image view
        self.itemImage = [[UIImageView alloc] init];
        self.itemImage.contentMode = UIViewContentModeScaleToFill;
        self.itemImage.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:self.itemImage];
        
        [self setConstraints];
    }
    return self;
}


//Method which sets the constraints required by the title view
- (void) setConstraints {
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel,_descriptionLabel,_itemImage);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    
    //Adding contraints to image view
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10.0-[_itemImage(50)]" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10.0@1000-[_itemImage(<=50)]-10.0@500-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
    
    //Adding contraints to title label
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_itemImage]-10.0-[_titleLabel]-10.0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10.0@1000-[_titleLabel]" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
    
    //Adding constraints to description label
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[_descriptionLabel]-10.0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-10.0@1000-[_descriptionLabel]->=10.0@750-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraintsArray];
    
}

@end
