#import "ViewController.h"
#import "BanubaSdkManager.h"

@interface ViewController ()
{
    BanubaSdkManager* sdkManager;
    __weak IBOutlet UIImageView* imageView;
}
@end

@implementation ViewController

- (NSData*)getRGBAFromImage:(UIImage*)image
{
    let imageRef = [image CGImage];
    let width = CGImageGetWidth(imageRef);
    let height = CGImageGetHeight(imageRef);
    let colorSpace = CGColorSpaceCreateDeviceRGB();
    let rawData = (unsigned char*) malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    let bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    let context = CGBitmapContextCreate(
        rawData,
        width,
        height,
        bitsPerComponent,
        bytesPerRow,
        colorSpace,
        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);


    return [NSData dataWithBytesNoCopy:rawData
                                length:height * width * 4
                          freeWhenDone:YES];
}

static void imageFromRGBAFree(void* info, const void* data, size_t size)
{
    free((void*) data);
}

- (UIImage*)imageFromRGBA:(NSData*)data width:(NSInteger)width height:(NSInteger)height
{
    let rawData = data.bytes;

    CGDataProviderRef provider = CGDataProviderCreateWithData(
        NULL,
        rawData,
        width * height * 4,
        imageFromRGBAFree);

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo =
        kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(
        width,
        height,
        8,
        32,
        4 * width,
        colorSpaceRef,
        bitmapInfo,
        provider,
        NULL,
        NO,
        renderingIntent);

    UIImage* newImage = [UIImage imageWithCGImage:imageRef];

    return newImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sdkManager = BanubaSdkManager_create();

    [EAGLContext setCurrentContext:
                     [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]];

    BanubaSdkManager_loadEffect(sdkManager, "effects/PineappleGlasses", true);

    let img = [UIImage imageWithContentsOfFile:
                           [NSBundle.mainBundle pathForResource:@"photo"
                                                         ofType:@"jpg"]];

    let width = img.size.width;
    let height = img.size.height;

    let processedRaw = BanubaSdkManager_processPhoto(
        sdkManager,
        [self getRGBAFromImage:img].bytes,
        width,
        height);
    let processed = [NSData
        dataWithBytesNoCopy:processedRaw
                     length:width * height * 4
               freeWhenDone:NO];
    let result = [self imageFromRGBA:processed width:width height:height];
    [imageView setImage:result];
}


- (void)dealloc
{
    BanubaSdkManager_destroy(sdkManager);
}

@end
