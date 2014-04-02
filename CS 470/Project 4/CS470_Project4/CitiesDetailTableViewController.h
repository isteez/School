//
//  CitiesDetailTableViewController.h
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theater.h"

@interface CitiesDetailTableViewController : UITableViewController

-(instancetype) initWithTheater: (Theater *) theater;

@end
