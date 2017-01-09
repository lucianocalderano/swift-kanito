
#import "ViewCamStart.h"
#import "ViewCamClick.h"
#import "ClsSettings.h"
#import "ClsGalleria.h"
#import <AVFoundation/AVFoundation.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface ViewCamStart () < ClsGalleriaDelegate > {
    IBOutlet UIView *viewPreview;
    IBOutlet UIButton *btnClck;
    IBOutlet UIButton *btnFlsh;
    IBOutlet UIButton *btnSwap;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnGall;
    
    ClsGalleria *clsGalleria;
    UIImage *imgCaptured;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureSession *captureSession;
    BOOL FrontCamera;
    BOOL haveImage;
}
@end

@implementation ViewCamStart

- (void)viewDidLoad {
    [super viewDidLoad];

    clsGalleria = [[ClsGalleria alloc] init];
    clsGalleria.delegate = self;
    [clsGalleria loadLastThumbnail];
    
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    FrontCamera = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [ClsSettings setObj:nil ForKey:userArrayDataForPicsToUpload];

#if TARGET_IPHONE_SIMULATOR
    [self btnGallery:nil];
#else
    if (captureSession == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self initializeCamera];
        [hud hideAnimated:YES];
    }
    else {
        [captureSession startRunning];
    }
#endif
}

- (void) exitClsGalleriaWithArr:(NSArray *)arr {
    PHAsset *asset = arr.lastObject;
    if (asset) {
        UIImageView *imvPhoto = [[UIImageView alloc] initWithFrame:btnGall.bounds];
        [clsGalleria thumbnailToImageview:imvPhoto asset:asset];
        if (imvPhoto.image)
            [btnGall setBackgroundImage:imvPhoto.image forState:UIControlStateNormal];
    }
    clsGalleria = nil;
}

//AVCaptureSession to show live video feed in view

- (void) initializeCamera {
    UIView *viewCam = viewPreview;
    captureSession = [[AVCaptureSession alloc] init];
	captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
	captureVideoPreviewLayer.frame = viewCam.bounds;
	[viewCam.layer addSublayer:captureVideoPreviewLayer];
	
    viewCam.layer.masksToBounds = YES;
    captureVideoPreviewLayer.frame = viewCam.bounds;
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frntCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionBack) {
                backCamera = device;
            }
            else {
                frntCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [captureSession addInput:input];
    }
    
    if (FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frntCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [captureSession addInput:input];
    }
	
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    stillImageOutput.outputSettings = outputSettings;
    [captureSession addOutput:stillImageOutput];
	[captureSession startRunning];
}

////
- (IBAction)snapImage:(id)sender {
    if (!haveImage) {
        [self flashScreen];
        [self capImage];
    }
    else {
        haveImage = NO;
    }
}

- (void) flashScreen {
    UIWindow* wnd = [UIApplication sharedApplication].keyWindow;
    UIView* v = [[UIView alloc] initWithFrame:wnd.frame];
    [wnd addSubview:v];
    v.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         v.alpha = 0.0f;
                     }
                     completion: ^(BOOL finished) {
                     }
     ];
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CGFloat rotate = 0;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
            rotate = -90;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotate = 90;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotate = 180;
            break;
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        default:
            break;
    }

    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([port.mediaType isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }

    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                      if (imageSampleBuffer != NULL) {
                                                          [captureSession stopRunning];
                                                          NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                          
                                                          imgCaptured = [ClsUtil imageResize:[UIImage imageWithData:imageData] MaxSize:1920];
                                                          if (rotate != 0)
                                                              imgCaptured = [ClsUtil imageRotate:imgCaptured ByDegrees:rotate];
                                                          [self gotoCamClick];
                                                      }
                                                      [hud hideAnimated:YES];
                                                  }];
}

#define nextCtrl @"ViewCamClick"

- (void) gotoCamClick {
    [self performSegueWithIdentifier:nextCtrl sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:nextCtrl]) {
        ViewCamClick *ctrl = segue.destinationViewController;
        ctrl.imgCaptured = imgCaptured;
    }
}

- (IBAction)switchCamera:(id)sender {
    FrontCamera = !FrontCamera;
    [self initializeCamera];
}

- (IBAction)btnFlsh {
    if (btnFlsh.tag == 0) {
        [self setTorchOn:YES];
        btnFlsh.tag = 1;
    }
    else {
        [self setTorchOn:NO];
        btnFlsh.tag = 0;
    }
}

- (void) setTorchOn:(BOOL)isOn {
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil]; //you must lock before setting torch mode
    device.torchMode = isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    [device unlockForConfiguration];
}

- (IBAction)btnGallery:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Galleria" bundle:nil];
    UIViewController *ctrl = [sb instantiateInitialViewController];
    [self.navigationController showViewController:ctrl sender:self];
}

@end
