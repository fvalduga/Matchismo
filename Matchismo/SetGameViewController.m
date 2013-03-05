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


-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(NSUInteger) getNumberOfCardsToMatch
{
    //Set Game matches 3 cards
    return 3;
}

-(void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card
{
    NSAttributedString *cardButtonTitle = [[NSAttributedString alloc] initWithString:card.contents attributes:[self getAttributesFromCard:card]];
    [cardButton setAttributedTitle:cardButtonTitle forState:UIControlStateNormal];
    [cardButton setBackgroundColor:(cardButton.selected) ? [UIColor grayColor] : nil];

    cardButton.alpha = (card.isUnplayable) ? 0.0 : 1.0;
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
        } else if ([setCard.color isEqualToString:@"blue"]) {
            color = [UIColor blueColor];
        }
        
        //setting shading and creating output
        if ([setCard.shading isEqualToString:@"solid"]) {
            attributes = @{NSForegroundColorAttributeName: color};
        } else if ([setCard.shading isEqualToString:@"faded"]) {
            attributes = @{NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @(-5), NSForegroundColorAttributeName:[color colorWithAlphaComponent:0.3F]};
        } else if ([setCard.shading isEqualToString:@"open"]) {
            attributes = @{NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @(5)};
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
                [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:card.contents attributes:[self getAttributesFromCard:card]]];
                
                if (i < [cardsFlipped count] - 1) {
                    [cardContents appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];//separator
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
