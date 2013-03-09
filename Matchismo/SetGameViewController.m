//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController


#define STROKE_WIDTH 5
#define FADE_ALPHA_VALUE 0.3
#define CARD_SEPARATOR_CHARACTER @"&"

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    //Set Game matches 3 cards
    return 3;
}

- (NSDictionary *)getGameOptions
{
    return @{@"matchBonus": @(5), @"mismatchPenalty": @(5), @"flipCost": @(0)};
}

-(void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    NSAttributedString *cardButtonTitle = [[NSAttributedString alloc] initWithString:[self getSymbolsFromCard:card] attributes:[self getAttributesFromCard:card]];
    [cardButton setAttributedTitle:cardButtonTitle forState:UIControlStateNormal];
    [cardButton setBackgroundColor:(cardButton.selected) ? [UIColor grayColor] : nil];

    cardButton.alpha = (card.isUnplayable) ? 0.0 : 1.0;
}

- (NSString *)getSymbolsFromCard:(Card *)card
{
    NSString *result = nil;
    
    if ([card isKindOfClass:[SetCard class]]) {
        
        SetCard *setCard = (SetCard *)card;
        NSString *symbol = nil;
        
        if ([setCard.symbol isEqualToString:@"diamond"]) {
            symbol = @"▲";
        } else if ([setCard.symbol isEqualToString:@"squiggle"]) {
            symbol = @"■";
        } else if ([setCard.symbol isEqualToString:@"oval"]){
            symbol = @"●";
        }
        
        result = [symbol stringByPaddingToLength:setCard.number withString:symbol startingAtIndex:0];
    }
    return result;
}

-(NSDictionary *)getAttributesFromCard:(Card *)card
{
    NSDictionary *attributes = nil;
    UIColor *color = nil;
    
    if ([card isKindOfClass:[SetCard class]]){
        
        SetCard *setCard = (SetCard *)card;
        
        //setting color
        if ([setCard.color isEqualToString:@"red"]) {
            color = [UIColor redColor];
        } else if ([setCard.color isEqualToString:@"green"]) {
            color = [UIColor greenColor];
        } else if ([setCard.color isEqualToString:@"purple"]) {
            color = [UIColor purpleColor];
        }
        
        //setting shading and creating output
        if ([setCard.shading isEqualToString:@"solid"]) {
            attributes = @{NSForegroundColorAttributeName: color};
        } else if ([setCard.shading isEqualToString:@"striped"]) {
            attributes = @{NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @(-STROKE_WIDTH), NSForegroundColorAttributeName:[color colorWithAlphaComponent:FADE_ALPHA_VALUE]};
        } else if ([setCard.shading isEqualToString:@"open"]) {
            attributes = @{NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @(STROKE_WIDTH)};
        }
    }
    
    return attributes;
    
}

- (NSMutableAttributedString *) getCardsFlippedContents:(NSArray *)cardsFlipped
{
    NSMutableAttributedString *cardContents = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (cardsFlipped) {
        
        SetCard *card = nil;
        
        for (int i = 0;  i < [cardsFlipped count]; i++) {
            
            if ([cardsFlipped[i] isKindOfClass:[SetCard class]]) {
                card = (SetCard *)cardsFlipped[i];
                [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:[self getSymbolsFromCard:card]
                                                                                     attributes:[self getAttributesFromCard:card]]];
                
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
