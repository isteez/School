//
//  ShowTimeDataSource.h
//  TableViewDemoPart1
//
//  Created by AAK on 3/8/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowtimesDataSource : NSObject

@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithJSONArray:(NSArray *)jsonArray;
-(NSArray *) showtimeForMovie: (NSString *) movieName atTheater: (NSString *) theaterName;
-(void) print;

@end
