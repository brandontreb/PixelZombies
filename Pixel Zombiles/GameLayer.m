//
//  HelloWorldLayer.m
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Person.h"
#import "Zombie.h"
#import "Soldier.h"
#import "GameOverLayer.h"

#define kMaxZombieSpeed 1.25
#define kMaxPersonSpeed 1.25
#define kMaxSoldierSpeed .75
#define KPersonCount 300
#define kZombieCount 10
#define kSoldierCount 3
#define kScale .5

@interface GameLayer ()
@property(nonatomic, strong) NSMutableArray *people;
@property(nonatomic, strong) NSMutableArray *zombies;
@property(nonatomic, strong) NSMutableArray *soldiers;
@property(nonatomic, strong) Soldier *player;
@property(nonatomic, strong) CCLabelTTF *zombieLabel;
@property(nonatomic, strong) CCLabelTTF *personLabel;
@property(nonatomic, strong) CCLabelTTF *soldierLabel;

@end

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
	if( (self=[super init]) ) {
        
        self.people = [NSMutableArray array];
        self.zombies = [NSMutableArray array];
        self.soldiers = [NSMutableArray array];
        
        for (int x = 0; x < KPersonCount; x++) {
            Person *person = [[Person alloc] initWithFile:@"green.png"];
            [self.people addObject:person];
            [self addChild:person];
            person.scale = kScale;
            person.position = CGPointMake(arc4random() % (NSInteger)winSize.width, arc4random() % (NSInteger)winSize.height);
            person.maxSpeed = kMaxPersonSpeed;
        }
        
        // zombies
        for (int x = 0; x < kZombieCount; x++) {
            Zombie *zombie = [[Zombie alloc] initWithFile:@"red.png"];
            [self.zombies addObject:zombie];
            [self addChild:zombie];
            zombie.scale = kScale;
            zombie.people = self.people;
            zombie.position = CGPointMake(arc4random() % (NSInteger)winSize.width, arc4random() % (NSInteger)winSize.height);
            zombie.maxSpeed = kMaxZombieSpeed;
            zombie.soldiers = self.soldiers;
        }
        
        self.player = [[Soldier alloc] initWithFile:@"orange.png"];
        [self.soldiers addObject:self.player];
        [self addChild:self.player];
        self.player.scale = kScale;
        self.player.isPlayer = YES;
        self.player.position = CGPointMake(arc4random() % (NSInteger)winSize.width, arc4random() % (NSInteger)winSize.height);
        self.player.maxSpeed = kMaxSoldierSpeed;
        self.player.zombies = self.zombies;
        
        // Soldiers
        for (int x = 0; x < kSoldierCount; x++) {
            Soldier *soldier = [[Soldier alloc] initWithFile:@"blue.png"];
            [self.soldiers addObject:soldier];
            [self addChild:soldier];
            soldier.scale = kScale;
            soldier.position = CGPointMake(arc4random() % (NSInteger)winSize.width, arc4random() % (NSInteger)winSize.height);
            soldier.maxSpeed = kMaxSoldierSpeed;
            soldier.zombies = self.zombies;
        }
        
        for (Zombie *zombie in self.zombies)
        {
            zombie.otherBoids = self.zombies;
        }
        
        for (Person *person in self.people)
        {
            person.zombies = self.zombies;
            person.otherBoids = self.zombies;
            person.separationDistance = 25;
        }
        
        [self schedule:@selector(gameLoop:) interval:1/30];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        // Stats labels
        self.zombieLabel = [CCLabelTTF labelWithString:@"Zombies" fontName:@"Helvetica Neue" fontSize:18];
        self.zombieLabel.position = CGPointMake(10, 45);
        self.zombieLabel.anchorPoint = ccp(0,0);
        [self addChild:self.zombieLabel z:5];
        
        self.personLabel = [CCLabelTTF labelWithString:@"People" fontName:@"Helvetica Neue" fontSize:18];
        self.personLabel.position = CGPointMake(10, 25);
        self.personLabel.anchorPoint = ccp(0,0);
        [self addChild:self.personLabel z:5];
        
        self.soldierLabel = [CCLabelTTF labelWithString:@"Soldiers" fontName:@"Helvetica Neue" fontSize:18];
        self.soldierLabel.position = CGPointMake(10, 5);
        self.soldierLabel.anchorPoint = ccp(0,0);
        [self addChild:self.soldierLabel z:5];
        
	}
	return self;
}

- (void) gameLoop:(ccTime) dt
{
    NSMutableArray *deadZombies = [NSMutableArray array];
    for (Zombie *zombie in self.zombies)
    {
        [zombie run:dt];
        if(zombie.dead)
        {
            [deadZombies addObject:zombie];
            [self removeChild:zombie cleanup:NO];
        }
        zombie.people = self.people;
        zombie.soldiers = self.soldiers;
    }
    
    [self.zombies removeObjectsInArray:deadZombies];

    NSMutableArray *turned = [NSMutableArray array];
    for (Person *person in self.people)
    {
        [person run:dt];
        if(person.turned)
        {
            [turned addObject:person];
        }
        person.zombies = self.zombies;
    }
    
    NSMutableArray *turnedSoldiers = [NSMutableArray array];
    for (Soldier *soldier in self.soldiers)
    {
        [soldier run:dt];
        soldier.zombies = self.zombies;
        soldier.otherBoids = self.zombies;
        soldier.separationDistance = 15;
        
        if(soldier.turned)
        {
            [turnedSoldiers addObject:soldier];
            [self removeChild:soldier cleanup:NO];
        }
    }
    
    [self.soldiers removeObjectsInArray:turnedSoldiers];
    
    // Convert turned people
    for(int x = 0; x < [turned count]; x++)
    {
        Person *turnedPerson = [turned objectAtIndex:x];
        [self removeChild:turnedPerson cleanup:NO];
        Zombie *zombie = [[Zombie alloc] initWithFile:@"red.png"];
        zombie.position = turnedPerson.position;
        zombie.scale = kScale;
        zombie.people = self.people;
        zombie.maxSpeed = kMaxZombieSpeed;
        zombie.otherBoids = self.zombies;
        zombie.soldiers = self.soldiers;
        [self.zombies addObject:zombie];
        [self addChild:zombie];
    }
    if([turned count] > 0)
    {
        [self.people removeObjectsInArray:turned];
    }
    
    [self updateUI:nil];
    
    if([self.people count] == 0 || [self.soldiers count] == 0)
    {
        [self endWithWin:NO];
    }
    
    if([self.zombies count] == 0)
    {
        [self endWithWin:YES];
    }
}

#pragma mark - touch

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    self.player.destination = touchLocation;
}

- (void) updateUI:(NSNotification *) notif
{
    self.zombieLabel.string = [NSString stringWithFormat:@"Zombies: %d",[self.zombies count]];
    self.personLabel.string = [NSString stringWithFormat:@"People: %d",[self.people count]];
    self.soldierLabel.string = [NSString stringWithFormat:@"Soldiers: %d",[self.soldiers count]];
}

- (void) endWithWin:(BOOL) win
{
    [self unscheduleAllSelectors];
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self scheduleOnce:@selector(makeTransition:) delay:0];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setBool:win forKey:@"WIN"];
    [d synchronize];    
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene] withColor:ccWHITE]];
}

@end
