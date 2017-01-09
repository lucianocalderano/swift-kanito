//
//  ViewTour.m
//  Kanito
//
//  Created by Luciano Calderano on 18/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewTour.h"
#import "ClsSettings.h"

@interface ViewTour () {
    IBOutlet UIPageControl *pageCtrl;
    IBOutlet UIButton *btnSkip;
    IBOutlet UIButton *btnPrev;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnGotoApp;
    IBOutlet UIImageView *imvPic;
    IBOutlet UIView *viewZone;
    
    NSArray *arrImgPvt;
    NSArray *arrImgBiz;
    NSArray *arrImg;
    NSArray *arrPvt;
    NSArray *arrBiz;
    NSArray *arrTxt;
    
    UISwitch *swi;
    UILabel *lblSwi;
    NSInteger pagina;
}
@end

@implementation ViewTour

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImgPvt = @[
                  [UIImage imageNamed:@"tour-1"],  [UIImage imageNamed:@"tour-2"], [UIImage imageNamed:@"tour-3"],
                  ];
    arrImgBiz = @[
                  [UIImage imageNamed:@"tour-3"],  [UIImage imageNamed:@"tour-2"], [UIImage imageNamed:@"tour-4"],
                  ];
    btnGotoApp.contentHorizontalAlignment = NSTextAlignmentRight;
    pagina = 0;
    arrPvt = @[
               @[ keyLang(@"tour.pvt.01"), [keyLang(@"tour.pvt.02") stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"]
                  ],
               @[ keyLang(@"tour.pvt.11"), [keyLang(@"tour.pvt.12") stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"]
                  ],
               @[ keyLang(@"tour.pvt.21"), [keyLang(@"tour.pvt.22") stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"], keyLang(@"tour.pvt.23")
                  ],
               ];
    arrBiz = @[
               @[ keyLang(@"tour.biz.01"), keyLang(@"tour.biz.02")
                  ],
               @[ keyLang(@"tour.biz.11"), keyLang(@"tour.biz.12")
                  ],
               @[ keyLang(@"tour.biz.21"), keyLang(@"tour.biz.22"), keyLang(@"tour.biz.23")
                  ],
               ];
    arrTxt = arrPvt;
    arrImg = arrImgPvt;
    
    UISwipeGestureRecognizer *swipeSX = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(pageNext:)] ;
    swipeSX.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeSX];

    UISwipeGestureRecognizer *swipeDX = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(pagePrev:)] ;
    swipeDX.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeDX];

    [self showPageOK];
}

#pragma mark - IBActions

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    swi = [[UISwitch alloc] initWithFrame:CGRectMake(viewZone.frame.size.width - 70, 150, 60, 35)];
    swi.on = NO;
    swi.onTintColor = [MyColor myOrange];
    
    lblSwi = [self creaLabelAtY:153 Text:@"Don't show this tour again" Bold:NO];
    CGRect rect = lblSwi.frame;
    rect.size.width -= 35;
    lblSwi.frame = rect;
    lblSwi.textAlignment = NSTextAlignmentRight;
    lblSwi.textColor = [MyColor myGreyDark];
    lblSwi.font = [MyFont fontSize:12];
    [self showPageOK];
}

- (IBAction)btnSkip {
    if (swi.isOn) {
        [ClsSettings setVal:defTourDone ForKey:userTourDone];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tour"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)pagePrev:(id)sender {
    if (pagina > 0) {
        pagina--;
        [self showPageMovoToLeft:NO];
    }
}

- (IBAction)pageNext:(id)sender {
    if (pagina < pageCtrl.numberOfPages - 1) {
        pagina++;
        [self showPageMovoToLeft:YES];
    }
}

- (UIImage *) screenshot {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) showPageMovoToLeft:(BOOL)left {
    UIImage *img = [self screenshot];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:self.view.frame];
    imv.image = img;
    [self.view addSubview:imv];
    [self showPageOK];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = imv.frame;
                         rect.origin.x = left ? -imv.frame.size.width : imv.frame.size.width;
                         imv.frame = rect;
                     }
                     completion:^(BOOL fine) {
                     }];

    
}
- (void) showPageOK {
    pageCtrl.currentPage = pagina;
    if (pagina == 0) {
        btnPrev.hidden = YES;
        btnSkip.hidden = NO;
    }
    else {
        btnPrev.hidden = NO;
        btnSkip.hidden = YES;
    }
    if (pagina < 2) {
        btnNext.hidden = NO;
        btnGotoApp.hidden = YES;
    }
    else {
        btnNext.hidden = YES;
        btnGotoApp.hidden = NO;
    }
    for (UIView *v in viewZone.subviews)
        [v removeFromSuperview];
    switch (pagina) {
        case 0:
        case 1:
            [self openPage];
            break;
        case 2:
            [self lastPage];
            break;
        default:
            break;
    }
    imvPic.image = arrImg[pagina];
}

- (void) openPage {
    UILabel *lbl;
    NSArray *arr = arrTxt[pagina];
    lbl = [self creaLabelAtY:5 Text:arr[0]Bold:YES];
    [viewZone addSubview:lbl];
    
    lbl = [self creaLabelAtY:35 Text:arr[1]Bold:NO];
    [viewZone addSubview:lbl];
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
}

- (void) lastPage {
    UILabel *lbl;
    NSArray *arr = arrTxt[2];
    lbl = [self creaLabelAtY:5 Text:arr[0] Bold:YES];
    [viewZone addSubview:lbl];
    lbl = [self creaLabelAtY:35 Text:arr[1]Bold:NO];
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    [viewZone addSubview:lbl];

    if (arrTxt == arrPvt) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, viewZone.frame.size.width - 20, 32)];
        btn.backgroundColor = [MyColor myOrange];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[2] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tourBiz) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        [viewZone addSubview:btn];
    }
    else {
        lbl = [self creaLabelAtY:100 Text:arr[2]Bold:NO];
        [viewZone addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [MyFont fontSize:24];
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        lbl.attributedText = [[NSAttributedString alloc] initWithString:lbl.text
                                                             attributes:underlineAttribute];
        lbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openKanito)];
        [lbl addGestureRecognizer:tapGesture];
    }
    [viewZone addSubview:lblSwi];
    [viewZone addSubview:swi];
}

- (UILabel *) creaLabelAtY:(CGFloat) yPos Text:(NSString *)txt Bold:(BOOL)isBold {
    UILabel *lbl;
    lbl = [[UILabel alloc] init];
    CGRect rect = CGRectMake(40, yPos, viewZone.frame.size.width - 80, 24);
    lbl.frame = rect;
    if (isBold)
        lbl.textAlignment = NSTextAlignmentCenter;
    else
        lbl.textAlignment = NSTextAlignmentLeft;
    if (isBold)
        lbl.font = [MyFont fontSize:24];
    else
        lbl.font = [MyFont fontSize:13];
    lbl.text = [txt stringByReplacingOccurrencesOfString:@"-" withString:@"\u2022"];
    lbl.textColor = [MyColor myOrange];
    lbl.minimumScaleFactor = 0.5;
    return lbl;
}

- (void) tourBiz {
    arrImg = arrImgBiz;
    arrTxt = arrBiz;
    pagina = 0;
    [self showPageOK];
}

- (void) openKanito {
    NSURL *url = [NSURL URLWithString:[defKanito stringByAppendingPathComponent:@"dogbuddy"]];
    [[UIApplication sharedApplication] openURL:url];
}
@end
