//
//  PentagoBrain.m
//  Pentago
//
//  Created by Stephen Kyles on 2/23/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "PentagoBrain.h"
#import "GridHole.h"
#import "Player.h"
#import "WhichView.h"

const int possibleLocations = 36;
const int gridWidth = 3;
const int numberOfSubViews = 4;

@interface PentagoBrain()
@property (nonatomic) NSMutableArray *redBallLocation;
@property (nonatomic) NSMutableArray *blueBallLocation;
@property (nonatomic) NSMutableArray *unMovedBallLocations;
@property (nonatomic) NSArray *setOfPoints;
@end

@implementation PentagoBrain

// Initializes the shared instance of
// the Pentago Brain, used by the sub vc's
+(PentagoBrain *) sharedInstance
{
    static PentagoBrain *sharedObject = nil;
    
    if( sharedObject == nil )
        sharedObject = [[PentagoBrain alloc] init];
    
    return sharedObject;
}

// Initializes array for holding the location of every red ball
// Location is represented by index in the array corresponding
// to an index in the sub vc and it's grid
// Sets the default to empty
- (NSMutableArray *)redBallLocation
{
    if (!_redBallLocation) {
         _redBallLocation = [[NSMutableArray alloc] init];
        
        id object = [NSNumber numberWithInt:empty];
        for (int j=0; j<numberOfSubViews; j++) {
            NSMutableArray *grid = [[NSMutableArray alloc] init];
            for (int i=0; i<gridWidth; i++) {
                NSMutableArray *row = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
                [grid addObject:row];
            }
            [_redBallLocation addObject:grid];
        }
    }
    return _redBallLocation;
}

// Initializes array for holding the location of every green ball
// Location is represented by index in the array corresponding
// to an index in the sub vc and it's grid
// Sets the default to empty
- (NSMutableArray *)blueBallLocation
{
    if (!_blueBallLocation) {
        _blueBallLocation = [[NSMutableArray alloc] init];
        
        id object = [NSNumber numberWithInt:empty];
        for (int j=0; j<numberOfSubViews; j++) {
            NSMutableArray *grid = [[NSMutableArray alloc] init];
            for (int i=0; i<gridWidth; i++) {
                NSMutableArray *row = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
                [grid addObject:row];
            }
            [_blueBallLocation addObject:grid];
        }
    }
    return _blueBallLocation;
}

// Initializes array for holding the location of every ball
// Location is represented by index in the array corresponding
// to an index in the sub vc and it's grid
// Sets the default to empty
// The indexes in this array do not rotate
// Used for checking to see if the grid hole is empty
- (NSMutableArray *)unMovedBallLocations
{
    if (!_unMovedBallLocations) {
        _unMovedBallLocations = [[NSMutableArray alloc] init];
        
        id object = [NSNumber numberWithInt:empty];
        for (int j=0; j<numberOfSubViews; j++) {
            NSMutableArray *grid = [[NSMutableArray alloc] init];
            for (int i=0; i<gridWidth; i++) {
                NSMutableArray *row = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
                [grid addObject:row];
            }
            [_unMovedBallLocations addObject:grid];
        }
    }
    return _unMovedBallLocations;}

// Array of points that represent locations 0-8 of the grid
// Each sub vc will have a grid with the same 0-8 points
- (NSArray *)setOfPoints
{
    if (!_setOfPoints) {
        
        NSArray *ary1 = [[NSArray alloc] initWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(43, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(86, 0)], nil];
        NSArray *ary2 = [[NSArray alloc] initWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 43)],
                         [NSValue valueWithCGPoint:CGPointMake(43, 43)],
                         [NSValue valueWithCGPoint:CGPointMake(86, 43)], nil];
        NSArray *ary3 = [[NSArray alloc] initWithObjects:
                         [NSValue valueWithCGPoint:CGPointMake(0, 86)],
                         [NSValue valueWithCGPoint:CGPointMake(43, 86)],
                         [NSValue valueWithCGPoint:CGPointMake(86, 86)], nil];
        
        _setOfPoints = [[NSArray alloc] initWithObjects:ary1, ary2, ary3, nil];
    }
    return _setOfPoints;
}

// Returns an index into the grid where the user tapped
// point = user touch point
// index = which sub vc made the call
- (CGPoint)getLocationInSubView:(CGPoint)point andTellBrainWhoItsFrom:(int)index
{
    CGPoint temp;
    for (int i=0; i<gridWidth; i++) {
        for (int j=0; j<gridWidth; j++) {
            if (CGPointEqualToPoint(point, [self.setOfPoints[i][j]CGPointValue])) {
                temp = CGPointMake(i, j);
            }
        }
    }
    return temp;
}

// Checks if there is a ball in the hole where the user tapped
- (BOOL)isThereABallInThatHoleAlready:(CGPoint)index subView:(int)subViewIndex
{
    return [[[self.unMovedBallLocations objectAtIndex:subViewIndex] objectAtIndex:index.x] objectAtIndex:index.y] == [NSNumber numberWithInt:filled] ? YES : NO;
}

// Adds a ball to the game
// Player = the current player trying to add a ball
// Point = where the touch point is from, gridview or view
// Index = the location within the array, the object that gets replaced
- (void)addBallToTheGame:(CGPoint)index player:(int)player point:(int)point subView:(int)subViewIndex
{
    if (player == red) {
        if (point == theGridView) {
            [[[self.unMovedBallLocations objectAtIndex:subViewIndex] objectAtIndex:index.x] replaceObjectAtIndex:index.y withObject:[NSNumber numberWithInt:filled]];
        }
        else {
            [[[self.redBallLocation objectAtIndex:subViewIndex] objectAtIndex:index.x] replaceObjectAtIndex:index.y withObject:[NSNumber numberWithInt:filled]];
        }
    }
    else if(player == blue) {
        if (point == theGridView) {
            [[[self.unMovedBallLocations objectAtIndex:subViewIndex] objectAtIndex:index.x] replaceObjectAtIndex:index.y withObject:[NSNumber numberWithInt:filled]];
        }
        else {
            [[[self.blueBallLocation objectAtIndex:subViewIndex] objectAtIndex:index.x] replaceObjectAtIndex:index.y withObject:[NSNumber numberWithInt:filled]];
        }
    }
}

// Rotates the array it's passed
// returns the new 'rotated' array
- (NSMutableArray *)rotateArrayRight:(NSMutableArray *)arrayToRotate
{
    id object = [NSNumber numberWithInt:empty];
    NSMutableArray *tempRow1 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRow2 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRow3 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRoot = [[NSMutableArray alloc] initWithObjects:tempRow1, tempRow2, tempRow3, nil];
    
    // rotate array
    for (int i=0; i<gridWidth; i++) {
        int temp = gridWidth-1;
        for (int j=0; j<gridWidth; j++) {
            [[tempRoot objectAtIndex:i] replaceObjectAtIndex:temp withObject:[[arrayToRotate objectAtIndex:j] objectAtIndex:i]];
            temp--;
        }
    }
    return arrayToRotate;
}

// Handles right rotation
// Index = sub vc
- (void)handleRightRotatationOfBalls:(int)index
{
    self.redBallLocation[index] = [self rotateArrayRight:[self.redBallLocation objectAtIndex:index]];
    self.blueBallLocation[index] = [self rotateArrayRight:[self.blueBallLocation objectAtIndex:index]];
}

// Rotates the array it's passed
// returns the new 'rotated' array
- (NSMutableArray *)rotateArrayLeft:(NSMutableArray *)arrayToRotate
{
    id object = [NSNumber numberWithInt:empty];
    NSMutableArray *tempRow1 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRow2 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRow3 = [[NSMutableArray alloc] initWithObjects:object, object, object, nil];
    NSMutableArray *tempRoot = [[NSMutableArray alloc] initWithObjects:tempRow1, tempRow2, tempRow3, nil];
    
    // rotate array
    for (int i=0; i<gridWidth; i++) {
        int temp = gridWidth-1;
        for (int j=0; j<gridWidth; j++) {
            [[tempRoot objectAtIndex:j] replaceObjectAtIndex:i withObject:[[arrayToRotate objectAtIndex:i] objectAtIndex:j]];
            temp--;
        }
    }
    
    arrayToRotate = tempRoot;
    return arrayToRotate;
}

// Handles left rotation
// Index = sub vc
- (void)handleLeftRotatationOfBalls:(int)index
{
    self.redBallLocation[index] = [self rotateArrayLeft:[self.redBallLocation objectAtIndex:index]];
    self.blueBallLocation[index] = [self rotateArrayLeft:[self.blueBallLocation objectAtIndex:index]];
}

// Returns either red or blue
- (int)whosTurnIsIt
{
    return self.redCanGo ? red : blue;
}

// Checking for winning configurations 
- (BOOL)checkForWin:(int)player
{
    if (player == red) {
        if (![self checkStraightFive:self.redBallLocation]) {
            if (![self checkMiddleFive:self.redBallLocation]) {
                if (![self checkMonicasFive:self.redBallLocation]) {
                    if (![self checkTriplePowerPlay:self.redBallLocation]) {
                        return NO;
                    }
                }
            }
        }
    }
    else {
        if (![self checkStraightFive:self.blueBallLocation]) {
            if (![self checkMiddleFive:self.blueBallLocation]) {
                if (![self checkMonicasFive:self.blueBallLocation]) {
                    if (![self checkTriplePowerPlay:self.blueBallLocation]) {
                        return NO;
                    }
                }
            }
        }
    }

    return YES;
}

// Checking known winning configurations:
// Straight five
// Middle Five
// Monicas Five
// Triple Power Play
- (BOOL)checkStraightFive:(NSArray *)coloredBallArray
{
    if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    return NO;
}

- (BOOL)checkMiddleFive:(NSArray *)coloredBallArray
{
    if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    return NO;
}

- (BOOL)checkMonicasFive:(NSArray *)coloredBallArray
{
    if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    return NO;
}

- (BOOL)checkTriplePowerPlay:(NSArray *)coloredBallArray
{
    if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
        [[[coloredBallArray objectAtIndex:3] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:0] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:0] objectAtIndex:2] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    else if ([[[coloredBallArray objectAtIndex:1] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:1] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:3] objectAtIndex:0] objectAtIndex:1] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:1] objectAtIndex:2] == [NSNumber numberWithInt:filled] &&
             [[[coloredBallArray objectAtIndex:2] objectAtIndex:2] objectAtIndex:1] == [NSNumber numberWithInt:filled]) {
        return YES;
    }
    return NO;
}

@end
