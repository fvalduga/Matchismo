//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/16/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"

@interface PlayingCardGameViewController ()



@end

@implementation PlayingCardGameViewController


-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger) getNumberOfCardsToMatch
{
    //Playing Card Matching Game matches 2 cards
    return 2;
}

-(void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    [cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"backOfCard.png"] forState:UIControlStateNormal];
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.alpha = (card.isUnplayable) ? 0.3 : 1.0;
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
