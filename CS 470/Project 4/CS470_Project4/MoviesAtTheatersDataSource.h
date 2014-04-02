//
//  MovieAtTheaterDataSrouce.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/9/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoviesAtTheatersDataSrouce : NSObject

-(instancetype) initWithJSONArray:(NSArray *)jsonArray;
-(NSArray *) moviesForTheater: (NSString *) theaterName inCity: (NSString *) cityName;

@end
