//
//  Boid.m
//  Pixel Zombiles
//
//  Created by Brandon Trebitowski on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Boid.h"

#define kMaxWidth 480
#define kMaxHeight 320

@interface Boid ()
@property(nonatomic) NSInteger maxWidth;
@property(nonatomic) NSInteger maxHeight;
@end

@implementation Boid

- (id) initWithFile:(NSString *)filename {
    if(self = [super initWithFile:filename])
    {
        self.separationDistance = 10;
        self.acceleration = CGPointZero;
        self.velocity = CGPointMake(arc4random() % 8 - 4, arc4random() %  8 - 4);
        self.position = CGPointMake(240, 160);
        
        self.r = 3.0;
        self.wanderTheta = (float)(arc4random() % (int)floorf((2 * M_PI)));
        self.maxSpeed = 1;
        self.maxForce = .5;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.maxWidth = winSize.width;
        self.maxHeight = winSize.height;
    }
    return self;
}

- (void) run:(ccTime) dt
{
    [self update:dt];
    [self borders];
}

- (void) update:(ccTime) dt
{
    self.velocity = ccpAdd(self.velocity, self.acceleration);
    self.velocity = [self limit:self.velocity value:self.maxSpeed];
    self.position = ccpAdd(self.position, self.velocity);
    self.acceleration = ccpMult(self.acceleration, 0);
    
    CGPoint separation = [self separate];
    separation = ccpMult(separation, 1.5);
    self.acceleration = ccpAdd(self.acceleration, separation);
}

- (void) seek:(CGPoint) target
{
    self.acceleration = ccpAdd(self.acceleration, [self steer:target away:NO]);
}

- (void) arrive:(CGPoint) target
{
    self.acceleration = ccpAdd(self.acceleration, [self steer:target away:YES]);
}

- (CGPoint) steer:(CGPoint) target away:(BOOL) away
{
    CGPoint steer = CGPointZero;
    CGPoint desired = ccpSub(target, self.position);
    float distance = ccpLength(desired) * (away ? -1 : 1);
    if(distance > 0)
    {
        desired = [Boid normalize:desired];
        desired = ccpMult(desired, self.maxSpeed);
        
        steer = ccpSub(desired, self.velocity);
        steer = [self limit:steer value:self.maxForce];
    }
    else
    {
        steer = CGPointZero;
    }
    return steer;
}

- (void) wander
{
    float wanderR = 16;
    float wanderD = 60;
    float change = .25;
    self.wanderTheta += [self randFloatBetween:-change and:change];
    
    CGPoint circleLocation = self.velocity;
    circleLocation = [Boid normalize:circleLocation];
    circleLocation = ccpMult(circleLocation, wanderD);
    circleLocation = ccpAdd(circleLocation, self.position);
    
    CGPoint circleOffset = CGPointMake(wanderR * cos(self.wanderTheta), wanderR * sin(self.wanderTheta));
    
    CGPoint target = ccpAdd(circleLocation, circleOffset);
    self.acceleration = ccpAdd(self.acceleration, [self steer:target away:NO]);
}

- (void) borders
{
    CGPoint position = self.position;
    BOOL reverseTheta = NO;
    
    if(position.x < -self.r)
    {
        position.x += self.r * 2;
        reverseTheta =YES;
    }
    
    if(position.y < -self.r)
    {
        position.y += self.r * 2;
        reverseTheta = YES;
    }
    
    if(position.x > self.maxWidth + self.r)
    {
        position.x -= self.r * 2;
        reverseTheta = YES;
    }
    
    if(position.y > self.maxHeight + self.r)
    {
        position.y -= self.r * 2;
        reverseTheta = YES;
    }
    if (reverseTheta) {
        self.wanderTheta += M_PI;
        self.velocity = ccpMult(self.velocity, -1);
    }
    self.position = position;
}

- (CGPoint) separate
{
    float desiredSeparation = self.separationDistance;
    int count = 0;
    CGPoint steer = CGPointZero;
    
    for (int i = 0; i < [self.otherBoids count]; i++)
    {
        Boid *other = [self.otherBoids objectAtIndex:i];
        float distance = ccpDistance(self.position, other.position);
        
        if(distance > 0 && distance < desiredSeparation)
        {
            CGPoint diff = ccpSub(self.position, other.position);
            diff = [Boid normalize:diff];
            diff = ccpMult(diff, 1/distance);
            steer = ccpAdd(steer, diff);
            count++;
        }
    }
    
    if (count > 0)
    {
        steer = ccpMult(steer, 1/(float)count);
    }
    
    if( ccpLength(steer) > 0)
    {
        steer = [Boid normalize:steer];
        steer = ccpMult(steer, self.maxSpeed);
        steer = ccpSub(steer, self.velocity);
        steer = [self limit:steer value:self.maxForce];
    }
    return steer;
}

#pragma mark - api

- (CGPoint) limit:(CGPoint) point value:(float) v
{
    if(point.x > v) point.x = v;
    if(point.y > v) point.y = v;
    return point;
}

- (float) magnitude:(CGPoint) point
{
    float x = powf(point.x, 2);
    float y = powf(point.y, 2);
    return sqrtf(x + y);
}

+ (CGPoint) normalize:(CGPoint) point
{
    float mpoint = ccpLength(point);
    if(mpoint > 0)
    {
        point.x = point.x / mpoint;
        point.y = point.y / mpoint;
    }
    else
    {
        point.x = 0;
        point.y = 0;
    }
    return point;
}

- (float) randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

@end
