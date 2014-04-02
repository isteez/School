//
//  DetailedMovieViewController.h
//  TableViewDemoPart1
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Theater.h"

@interface DetailedMovieViewController : UIViewController

-(instancetype) initWithMovie: (Movie *) movie andTheater: (Theater *) theater;

@end
