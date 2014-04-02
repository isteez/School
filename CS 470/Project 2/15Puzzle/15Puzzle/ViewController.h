//
//  ViewController.h
//  15Puzzle
//
//  Created by Stephen Kyles on 2/5/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

// View for detecting swipe gesture and for holding puzzle buttons
@property (weak, nonatomic) IBOutlet UIView *puzzleView;

// Puzzle buttons
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;
@property (weak, nonatomic) IBOutlet UIButton *tenButton;
@property (weak, nonatomic) IBOutlet UIButton *elevenButton;
@property (weak, nonatomic) IBOutlet UIButton *twelveButton;
@property (weak, nonatomic) IBOutlet UIButton *thirteenButton;
@property (weak, nonatomic) IBOutlet UIButton *fourteenButton;
@property (weak, nonatomic) IBOutlet UIButton *fifteenButton;
@property (weak, nonatomic) IBOutlet UIButton *blankButton;

// Game control buttons and actions
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)shuffle:(id)sender;
- (IBAction)reset:(id)sender;

// Difficulty slider
@property (weak, nonatomic) IBOutlet UISlider *difficultySlider;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
- (IBAction)sliderValueChanged:(UISlider *)sender;

// Label for timed game
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UILabel *personalBestLabel;

@end
