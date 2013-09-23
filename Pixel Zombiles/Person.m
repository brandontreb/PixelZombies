//
//  Person.m
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "Zombie.h"

#define kMinZombieDistance 20

@interface Person()
@property(strong) Zombie *closeZombie;
@property(nonatomic) float closeZombieDistance;
@end

@implementation Person

- (void) run:(ccTime)dt
{
    //[self checkZombies];
    if(!self.closeZombie)
    {
        [self wander];
    }
    else
    {
        [self steer:self.closeZombie.position away:YES];
        self.acceleration = ccpMult(self.acceleration, 50);
    }
    [super run:dt];
}

- (void) checkZombies
{
    if(!self.zombies || [self.zombies count] == 0) return;
    BOOL nearbyZombie = NO;
    
    for(Zombie *zombie in self.zombies)
    {
        float distance = ccpDistance(zombie.position, self.position);
        if((distance < self.closeZombieDistance || self.closeZombieDistance == 0) && distance <= kMinZombieDistance)
        {
            self.closeZombieDistance = distance;
            self.closeZombie = zombie;
            nearbyZombie = YES;
        }
    }
    
    if(!nearbyZombie)
    {
        self.closeZombie = nil;
        self.closeZombieDistance = 0;
    }
}

@end
