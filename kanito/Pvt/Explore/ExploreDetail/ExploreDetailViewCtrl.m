//
//  ViewPvtDogDett.m
//  Kanito
//
//  Created by Luciano Calderano on 15/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ExploreDetailViewCtrl.h"
#import "ExploreDetailSubView.h"


@interface ExploreDetailViewCtrl () {
    IBOutlet UIScrollView *scrollView;
    IBOutlet NSLayoutConstraint *subHeight;
    ExploreDetailSubView *detailSubView;
}

@end

@implementation ExploreDetailViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isMemberOfClass:[ExploreDetailSubView class]]) {
        detailSubView = segue.destinationViewController;
        detailSubView.dicData = self.dicData;
        detailSubView.image = self.imageDog;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *titolo = self.dicData[@"fileTitle"];
    if (titolo.length == 0)
        titolo = self.dicData[@"dogName"];
    self.myNavigationBar.titolo = titolo.uppercaseString;
    [self updateImage];
}

- (void)viewDidLayoutSubviews {
    [self updateSize];
}

- (void) updateImage {
    NSString *strUrl = self.dicData[@"image_url"];
    NSArray *arr = [strUrl componentsSeparatedByString:@"&w="];
    if (arr.count != 2)
        return;
    
    strUrl = [arr.firstObject stringByAppendingFormat:@"&w=%.0f&zc=2&cc=000000",
              [UIScreen mainScreen].bounds.size.width];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error == nil)
                                          detailSubView.image = [UIImage imageWithData:data];
                                  }];
    [task resume];
}

- (void) updateSize {
    CGFloat h = scrollView.frame.size.width / self.imageDog.size.width * self.imageDog.size.height;
    subHeight.constant = h + 120;
    [self.view needsUpdateConstraints];
    scrollView.contentSize = detailSubView.view.frame.size;
}

@end
