//
//  ViewController.m
//  15Puzzle
//
//  Created by Stephen Kyles on 2/5/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "ViewController.h"
#import "PuzzleBrain.h"

@interface ViewController ()
{
    NSTimeInterval startTime;
    BOOL running;
    int finishedTime;
    int bestTime;
    int counter;
    int sliderValue;
}

@property (nonatomic, strong) NSArray *defaultPositions;
@property (nonatomic, strong) NSMutableArray *puzzleButtonArray;
@property (nonatomic, strong) PuzzleBrain *puzzleBrain;
@property (nonatomic, strong) UIButton *tempButton;
@property (nonatomic, strong) NSMutableArray *shuffledPuzzleButtonArray;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bestTime = 100000;
    [self setButtonStyle];
    self.difficultyLabel.text = [NSString stringWithFormat:@"%d", (int)self.difficultySlider.value];
    self.puzzleBrain = [[PuzzleBrain alloc] init];
    self.puzzleBrain.shuffled = NO;
    self.puzzleBrain.isShuffling = NO;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeUp:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDown:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight:)];
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];

    [self.puzzleView addGestureRecognizer:swipeUp];
    [self.puzzleView addGestureRecognizer:swipeDown];
    [self.puzzleView addGestureRecognizer:swipeLeft];
    [self.puzzleView addGestureRecognizer:swipeRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Changes the default button style.
// The background of the buttons remain transparent,
// but a thin black border is set to every button.
// Combined with a white background for the puzzle view,
// this look is clean and simple.
- (void)setButtonStyle
{
    self.oneButton.layer.borderWidth = 1.0f;
    self.oneButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.twoButton.layer.borderWidth = 1.0f;
    self.twoButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.threeButton.layer.borderWidth = 1.0f;
    self.threeButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.fourButton.layer.borderWidth = 1.0f;
    self.fourButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.fiveButton.layer.borderWidth = 1.0f;
    self.fiveButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.sixButton.layer.borderWidth = 1.0f;
    self.sixButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.sevenButton.layer.borderWidth = 1.0f;
    self.sevenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.eightButton.layer.borderWidth = 1.0f;
    self.eightButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.nineButton.layer.borderWidth = 1.0f;
    self.nineButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.tenButton.layer.borderWidth = 1.0f;
    self.tenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.elevenButton.layer.borderWidth = 1.0f;
    self.elevenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.twelveButton.layer.borderWidth = 1.0f;
    self.twelveButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.thirteenButton.layer.borderWidth = 1.0f;
    self.thirteenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.fourteenButton.layer.borderWidth = 1.0f;
    self.fourteenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.fifteenButton.layer.borderWidth = 1.0f;
    self.fifteenButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.blankButton.layer.borderWidth = 1.0f;
    self.blankButton.layer.borderColor = [[UIColor blackColor] CGColor];
}

// Just for fun, added a timer to the game.
// Only starts when the puzzle is shuffled.
// The label gets reset back to 0:00.0 once the reset
// button is pressed.
- (void)updateTimer
{
    if (running == FALSE) {
        return;
    }
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - startTime;
    
    int mins = (int) (elapsedTime / 60.0);
    elapsedTime -= mins * 60;
    int secs = (int) (elapsedTime);
    elapsedTime -= secs;
    int fraction = elapsedTime * 10.0;
    
    finishedTime = (mins*10)+secs;
    self.timer.text = [NSString stringWithFormat:@"%u:%02u.%u", mins, secs, fraction];
    [self performSelector:@selector(updateTimer) withObject:self afterDelay:0.1];
}

// Only stops when the puzzle is completed or
// when the reset button is pressed;
- (void)stopTimer
{
    // For fun, reset game timer
    [self.gameTimer invalidate];
    self.gameTimer = nil;
    running = FALSE;
}

// Setup array for default positions.
// This array is used for generating a solvable
// puzzle when shuffled, and is used for resetting
// the puzzle back to it's default position.
- (NSArray *)defaultPositions
{
    if (!_defaultPositions) {
        _defaultPositions = [NSArray arrayWithObjects:self.oneButton,
                             self.twoButton,self.threeButton,self.fourButton,
                             self.fiveButton,self.sixButton,self.sevenButton,
                             self.eightButton,self.nineButton,self.tenButton,
                             self.elevenButton,self.twelveButton,self.thirteenButton,
                             self.fourteenButton,self.fifteenButton,self.blankButton, nil];
    }
    return _defaultPositions;
}

// Setup array for puzzle buttons.
// This array is mutable and is used to generate
// the shuffled button postions. As buttons are moved,
// their position within the array are updated accordingly.
// The array matches a grid, which is represented by elements
// 0-15, 0 being square position 1 and 15 being the blank square's position.
- (NSMutableArray *)puzzleButtonArray
{
    if (!_puzzleButtonArray) {
        _puzzleButtonArray = [NSMutableArray arrayWithArray:self.defaultPositions];
    }
    return _puzzleButtonArray;
}

// Handle change in slider value
// The value ranges from 0 to 50
// Each value represents the number of
// shuffle moves are completed. Specifically,
// the number of times the blank button moves.
- (IBAction)sliderValueChanged:(UISlider *)sender
{
    self.difficultyLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

// Currently not using the code (commented out below) that generates a random solvable puzzle.
// Rather, I'm taking advantage of the fact that if we always start with an already solved puzzle,
// move the blank button randomly,
// x number of times,
// making only legal moves,
// we will always end up with a solvable puzzle.
// This includes multiple shuffles without solving in between each one,
// as long as the first condition (starting with an already solved puzzle) is true.
- (IBAction)shuffle:(id)sender
{
    /*
    if (!self.shuffledPuzzleButtonArray) {
        self.shuffledPuzzleButtonArray = [[NSMutableArray alloc] init];
    }
    
    // Shuffle puzzle buttons
    self.shuffledPuzzleButtonArray = [self.puzzleBrain shufflePuzzleButtons:self.puzzleButtonArray];
    if ([self.puzzleBrain checkForASolutionWithSorted:self.defaultPositions andShuffled:self.shuffledPuzzleButtonArray]) {
        NSLog(@"YES");
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.blankButton.center = [self.puzzleBrain getNewCenterPoint:self.shuffledPuzzleButtonArray with:0];
        self.twoButton.center = [self.puzzleBrain getNewCenterPoint:self.shuffledPuzzleButtonArray with:1];
    }];
    */
    
    if ([self.puzzleBrain isShuffling]) {
        return;
    }
    
    sliderValue = (int)[self.difficultySlider value];
    self.puzzleBrain.shuffled = YES;
    self.puzzleBrain.isShuffling = YES;
    
    for (int i=0; i<sliderValue; i++) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:i/2.0
                                                               target:self
                                                             selector:@selector(getRandomMove:)
                                                             userInfo:nil
                                                              repeats:NO];
        counter++;
    }
    
    [self performSelector:@selector(finishedShuffling) withObject:self afterDelay:sliderValue/2.0];
}

// Passes the puzzle button array and the blank button to the model to get a random integer.
// That integer value is used to call handleSwipe up, down, left, or right.
// The number of times this function is called corresponds to the silder value when 'shuffle' was tapped.
- (IBAction)getRandomMove:(id)sender
{
    int temp = 0;
    temp = [self.puzzleBrain getRandomMove:self.puzzleButtonArray withButton:self.blankButton];
    if (temp == 0) {
        [self handleSwipeRight:sender];
    }
    else if (temp == 1){
        [self handleSwipeDown:sender];
    }
    else if (temp == 2){
        [self handleSwipeLeft:sender];
    }
    else if (temp == 3){
        [self handleSwipeUp:sender];
    }
}

// Gets called once the shuffling of puzzle buttons
// has completed. Starts the timer for tracking the best (fastest)
// puzzle solve and sets the current slider value back to the slider variable.
- (void)finishedShuffling
{
    if (counter == sliderValue) {
        self.puzzleBrain.isShuffling = NO;
        
        // For fun, timer for the puzzle once shuffled
        self.timer.text = @"0:00.0";
        running = TRUE;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [self updateTimer];
        counter = 0;
        sliderValue = (int)[self.difficultySlider value];
    }
}

// Resets the game board back to it's default positioning.
- (IBAction)reset:(id)sender
{
    if ([self.puzzleBrain isShuffling]) {
        return;
    }
    
    self.puzzleBrain.shuffled = NO;
    [self stopTimer];
    self.timer.text = @"0:00.0";

    for (int i=0; i<[self.defaultPositions count]; i++) {
        self.puzzleButtonArray[i] = self.defaultPositions[i];
    }
   
    [UIView animateWithDuration:0.4 animations:^{
        self.blankButton.center = CGPointMake(265, 266);
        self.oneButton.center = CGPointMake(55, 56);
        self.twoButton.center = CGPointMake(125, 56);
        self.threeButton.center = CGPointMake(195, 56);
        self.fourButton.center = CGPointMake(265, 56);
        self.fiveButton.center = CGPointMake(55, 126);
        self.sixButton.center = CGPointMake(125, 126);
        self.sevenButton.center = CGPointMake(195, 126);
        self.eightButton.center = CGPointMake(265, 126);
        self.nineButton.center = CGPointMake(55, 196);
        self.tenButton.center = CGPointMake(125, 196);
        self.elevenButton.center = CGPointMake(195, 196);
        self.twelveButton.center = CGPointMake(265, 196);
        self.thirteenButton.center = CGPointMake(55, 266);
        self.fourteenButton.center = CGPointMake(125, 266);
        self.fifteenButton.center = CGPointMake(195, 266);
    }];
}

// A swipe up in this context means there is a puzzle button
// below the blank button that we wish to swap places with.
// The blank button moves down.
// The puzzle button moves up. Also, checks to see if the puzzle
// has been solved. Only needed for up and left.
- (void)handleSwipeUp:(UIGestureRecognizer *)recognizer
{
    if (!self.tempButton) {
        self.tempButton = [[UIButton alloc] init];
    }
    
    NSLog(@"swipe up");
    CGRect rect = [self.puzzleView frame];
    CGPoint point = self.blankButton.center;
    
    int i = [self.puzzleBrain getMoveablePuzzleButtonUpFrom:self.puzzleButtonArray withBlankButton:self.blankButton];
    self.tempButton = [self.puzzleButtonArray objectAtIndex:i];
    
    if ([self.puzzleBrain checkLegalMoveUp:rect withCurrentPosition:point]) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.blankButton.center = [self.puzzleBrain getNewCenterPoint:self.puzzleButtonArray with:i];
            self.tempButton.center = point;
        }];
        
        [self.puzzleButtonArray exchangeObjectAtIndex:[self.puzzleBrain getBlankButtonIdx:self.puzzleButtonArray withButton:self.blankButton]
                                    withObjectAtIndex:i];
        
        if (![self.puzzleBrain shouldContinueGame:self.defaultPositions withCurrentButtonLocations:self.puzzleButtonArray] && [self.puzzleBrain shuffled] && ![self.puzzleBrain isShuffling]) {
            NSLog(@"solved!");
            [self stopTimer];
            self.puzzleBrain.shuffled = NO;
            
            if (bestTime <= finishedTime) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                                message:[NSString stringWithFormat:@"You solved the puzzle with a time of: %@", self.timer.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                bestTime = finishedTime;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Personal Best"
                                                                message:[NSString stringWithFormat:@"Conratulations\nYou solved the puzzle with a time of: %@", self.timer.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                self.personalBestLabel.text = self.timer.text;
            }
        }
    }
}

// A swipe down in this context means there is a puzzle button
// above the blank button that we wish to swap places with.
// The blank button moves up.
// The puzzle button moves down.
- (void)handleSwipeDown:(UIGestureRecognizer *)recognizer
{
    if (!self.tempButton) {
        self.tempButton = [[UIButton alloc] init];
    }
    
    NSLog(@"swipe down");
    CGRect rect = [self.puzzleView frame];
    CGPoint point = self.blankButton.center;
    
    int i = [self.puzzleBrain getMoveablePuzzleButtonDownFrom:self.puzzleButtonArray withBlankButton:self.blankButton];
    self.tempButton = [self.puzzleButtonArray objectAtIndex:i];
    
    if ([self.puzzleBrain checkLegalMoveDown:rect withCurrentPosition:point]) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.blankButton.center = [self.puzzleBrain getNewCenterPoint:self.puzzleButtonArray with:i];
            self.tempButton.center = point;
        }];
        
        [self.puzzleButtonArray exchangeObjectAtIndex:[self.puzzleBrain getBlankButtonIdx:self.puzzleButtonArray withButton:self.blankButton]
                                    withObjectAtIndex:i];
    }
}

// A swipe left in this context means there is a puzzle button
// to the right of the blank button that we wish to swap places with.
// The blank button moves right.
// The puzzle button moves left. Also, checks to see if the puzzle
// has been solved. Only needed for up and left.
- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (!self.tempButton) {
        self.tempButton = [[UIButton alloc] init];
    }
    
    NSLog(@"swipe left");
    CGRect rect = [self.puzzleView frame];
    CGPoint point = self.blankButton.center;
    
    int i = [self.puzzleBrain getMoveablePuzzleButtonLeftFrom:self.puzzleButtonArray withBlankButton:self.blankButton];
    self.tempButton = [self.puzzleButtonArray objectAtIndex:i];
    
    if ([self.puzzleBrain checkLegalMoveLeft:rect withCurrentPosition:point]) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.blankButton.center = [self.puzzleBrain getNewCenterPoint:self.puzzleButtonArray with:i];
            self.tempButton.center = point;
        }];
        
        [self.puzzleButtonArray exchangeObjectAtIndex:[self.puzzleBrain getBlankButtonIdx:self.puzzleButtonArray withButton:self.blankButton]
                                    withObjectAtIndex:i];
        
        if (![self.puzzleBrain shouldContinueGame:self.defaultPositions withCurrentButtonLocations:self.puzzleButtonArray] && [self.puzzleBrain shuffled] && ![self.puzzleBrain isShuffling]) {
            NSLog(@"solved!");
            [self stopTimer];
            self.puzzleBrain.shuffled = NO;
            
            if (bestTime <= finishedTime) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                                message:[NSString stringWithFormat:@"You solved the puzzle with a time of: %@", self.timer.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                bestTime = finishedTime;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Personal Best"
                                                                message:[NSString stringWithFormat:@"Congratulations\nYou solved the puzzle with a time of: %@", self.timer.text]
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                self.personalBestLabel.text = self.timer.text;
            }
        }
    }
}

// A swipe right in this context means there is a puzzle button
// to the left of the blank button that we wish to swap places with.
// The blank button moves left.
// The puzzle button moves right.
- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (!self.tempButton) {
        self.tempButton = [[UIButton alloc] init];
    }
    
    NSLog(@"swipe right");
    CGRect rect = [self.puzzleView frame];
    CGPoint point = self.blankButton.center;
    
    int i = [self.puzzleBrain getMoveablePuzzleButtonRightFrom:self.puzzleButtonArray withBlankButton:self.blankButton];
    self.tempButton = [self.puzzleButtonArray objectAtIndex:i];
    
    if ([self.puzzleBrain checkLegalMoveRight:rect withCurrentPosition:point]) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.blankButton.center = [self.puzzleBrain getNewCenterPoint:self.puzzleButtonArray with:i];
            self.tempButton.center = point;
        }];
        
        [self.puzzleButtonArray exchangeObjectAtIndex:[self.puzzleBrain getBlankButtonIdx:self.puzzleButtonArray withButton:self.blankButton]
                                    withObjectAtIndex:i];
    }
}

@end
