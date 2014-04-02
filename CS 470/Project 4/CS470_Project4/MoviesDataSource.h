//
//  MoviesDataSource.h
//  TableViewBasics
//
//  Created by AAK on 2/24/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "DownloadAssistant.h"

@interface MoviesDataSource : NSObject

@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithJSONArray: (NSArray *) jsonArray;
-(Movie *) movieWithTitle: (NSString *) movieTitle;
-(NSMutableArray *) getAllMovies;
-(Movie *) movieAtIndex: (int) idx;
-(int) numberOfMovies;
-(NSString *) moviesTabBarTitle;
-(NSString *) moviesTabBarImage;
-(NSString *) moviesBarButtonItemBackButtonTitle;
-(BOOL) deleteMovieAtIndex: (NSInteger) idx;


@end
