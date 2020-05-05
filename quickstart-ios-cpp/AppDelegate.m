#import "AppDelegate.h"
#import "BanubaSdkManager.h"
#import "BanubaClientToken.h"
#import <BanubaEffectPlayer/BanubaEffectPlayer.h>
#import <OpenGLES/EAGL.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    let bnbFramework = [NSBundle bundleForClass:BNBEffectPlayer.class];
    let bnbRes = [NSString stringWithFormat:@"%@/%@",
                                            bnbFramework.bundlePath,
                                            @"bnb-resources"];
    BanubaSdkManager_initialize(
        (const char*[]){
            bnbRes.UTF8String /* this is sdk resources */,
            NSBundle.mainBundle.bundlePath.UTF8String /*this is for effects*/,
            NULL},
        BNB_CLIENT_TOKEN);

    return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    BanubaSdkManager_deinitialize();
}

@end
