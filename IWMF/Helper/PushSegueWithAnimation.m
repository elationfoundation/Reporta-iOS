//
//  PushSegueWithAnimation.m
//  IWMF
//
//
//
//

#import "PushSegueWithAnimation.h"
#import "IWMF-Swift.h"

@implementation PushSegueWithAnimation

-(void)perform{
    [[[self sourceViewController] navigationController]pushViewController:[self destinationViewController] animated:YES];
}
@end
