//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/16/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

#define CARD_UNPLAYABLE_TRANSPARENCY_VALUE 0.3
#define CARD_SEPARATOR_CHARACTER @"&"

@end

@implementation PlayingCardGameViewController


-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    //Playing Card Matching Game matches 2 cards
    return 2;
}

- (NSDictionary *)getGameOptions
{
    return @{@"matchBonus": @(4), @"mismatchPenalty": @(2), @"flipCost": @(1)};
}

-(void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    [cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"backOfCard.png"] forState:UIControlStateNormal];
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.alpha = (card.isUnplayable) ? CARD_UNPLAYABLE_TRANSPARENCY_VALUE : 1.0;
}

- (NSMutableAttributedString *) getCardsFlippedContents:(NSArray *)cardsFlipped
{
    NSMutableAttributedString *cardContents = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (cardsFlipped) {
        
        PlayingCard *card = nil;
        
        for (int i = 0;  i < [cardsFlipped count]; i++) {
            
            if ([cardsFlipped[i] isKindOfClass:[PlayingCard class]]) {
                card = (PlayingCard *)cardsFlipped[i];
                [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents]];
                
                if (i < [cardsFlipped count] - 1) {
                    [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:CARD_SEPARATOR_CHARACTER]];
                }
            }
        }
    }
    
    return cardContents;
}

-(void)setup
{
    //initialization that can't wait intil viewDidLoad
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
