//
//  Zombie.m
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"
#import "Person.h"
#import "Soldier.h"

@interface Zombie()
@property(nonatomic, strong) Boid *target;
@property(nonatomic) float targetDistance;
@end

@implementation Zombie

- (void) run:(ccTime)dt
{
    [self findTarget];
    [self seek:self.target.position];
    [super run:dt];
}

#pragma mark - Private API

- (void) findTarget
{
    CGRect myframe = self.boundingBox;
    
    if (self.soldiers && [self.soldiers count] > 0)
    {    
        self.target = [self.soldiers objectAtIndex:0];
        self.targetDistance = ccpDistance(self.target.position, self.position);        
        
        for (Soldier *soldier in self.soldiers)
        {
            float distance = ccpDistance(soldier.position, self.position);
            if(distance < self.targetDistance)
            {
                self.targetDistance = distance;
                self.target = soldier;
            }
            
            CGRect personFrame = soldier.boundingBox;
            
            // Check for a collision
            if (CGRectIntersectsRect(myframe, personFrame)) {
                soldier.turned = YES;
                NSLog(@"TURNED SOLDIER");
            }
        }
        
    }
    
    if(!self.people || [self.people count] == 0) return;
    // Target person
    if(!self.target)
    {
        self.target = [self.people objectAtIndex:0];
        self.targetDistance = ccpDistance(self.target.position, self.position);
    }
    
    for (Person *person in self.people)
    {
        float distance = ccpDistance(person.position, self.position);
        if(distance < self.targetDistance)
        {
            self.targetDistance = distance;
            self.target = person;
        }
        
        CGRect personFrame = person.boundingBox;
        
        // Check for a collision
        if (CGRectIntersectsRect(myframe, personFrame)) {
            int random = arc4random() % 100;

            if(random > 88)
            {
                person.turned = YES;
            }
            return;
        }
    }
}

@end
