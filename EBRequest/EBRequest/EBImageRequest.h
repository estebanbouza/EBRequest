//
//  EBImageRequest.h
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <EBRequest/EBRequest.h>
#import <UIKit/UIKit.h>

/** EBImageRequest fetches images from a URL.
 It returns UIImage objects in the completionBlock. As usual, the completion block is executed
 in the main thread so it's safe to draw once the image is donwloaded inside completionBlock.
 
 See requestWithURL:
 
 Sample usage:
 
        EBImageRequest *imageRequest = [EBImageRequest requestWithURL:_imageURL];


        imageRequest.completionBlock = ^(id img) {
            UIImage *image = (UIImage *)img;

            _imageView.image = image;
        }

        [imageRequest start];

 */
@interface EBImageRequest : EBRequest

@end
