//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 1/30/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"


@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//order of buttons cant be determined
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel; //linked to game.score
@property (weak, nonatomic) IBOutlet UILabel *resultLabel; //linked to game.resultDescription
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameMode;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *flipsHistory;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                                andGameMode:self.gameMode.selectedSegmentIndex + 2];// 0 segment is 2 | 1 segment is 3
    }
    return _game;
}

- (NSMutableArray *)flipsHistory
{
    if (!_flipsHistory) _flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

-(void) setHistorySlider:(UISlider *)historySlider
{
    _historySlider = historySlider;

    _historySlider.enabled = NO;
}


// Setter for the CardButtons property (it will be called by the system to setup the interface)
-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    
    for (UIButton *button in self.cardButtons) {
        button.imageEdgeInsets = UIEdgeInsetsMake(4.0,4.0,4.0,4.0);
    }
    
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"backOfCard.png"] forState:UIControlStateNormal];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable) ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %d", self.game.score];
    self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", ([self.flipsHistory lastObject]) ? [self.flipsHistory lastObject] : @""];
}


- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    
    [self.flipsHistory addObject:[self.game resultDescription]];
    
    //adjust slider parameters setting max value according to flips history array size and set pointer to the end
    self.historySlider.maximumValue = [self.flipsHistory count] - 1;
    self.historySlider.enabled = YES;
    [self.historySlider setValue:self.historySlider.maximumValue];
    
    self.resultLabel.alpha = 1.0;
    
    self.gameMode.enabled = NO; //disable gameMode change during the game
    [self updateUI];
}

- (IBAction)dealPressed {
    self.game = nil; //recreate game when the getter is called in updateUI (Lazy Instantiation)
    self.flipCount = 0;
    self.gameMode.enabled = YES;
    self.historySlider.enabled = NO;
    self.resultLabel.alpha = 1.0;
    [self.flipsHistory removeAllObjects];
    [self updateUI];
}
- (IBAction)historySliderChanged:(UISlider *)sender {
    // link slider movement with flips history array
    self.resultLabel.text = self.flipsHistory[[[NSNumber numberWithFloat:sender.value] intValue]];
        
    //fade result label when checking flips history
    if (sender.value != ([self.flipsHistory count] - 1)) {
        self.resultLabel.alpha = 0.4;
    } else {
        self.resultLabel.alpha = 1.0;
    }
}

- (IBAction)gameModeChanged {
    self.game = nil;
}


@end
