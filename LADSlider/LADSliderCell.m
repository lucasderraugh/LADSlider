//
//  LADSliderCell.m
//  LADSliderExample
//
//  Created by Alexander Lapshin on 04.10.13.
//  Copyright (c) 2013 Alexander Lapshin. All rights reserved.
//

#import "LADSliderCell.h"

@interface LADSliderCell () {
    NSRect _currentKnobRect;
    NSRect _barRect;

    BOOL _flipped;
}

@end

@implementation LADSliderCell

- (id)initWithKnobImage:(NSImage *)knob {
    if( nil == knob ) {
        return nil;
    }

    self = [self init];

    if( self ) {
        _knobImage = knob;
    }

    return self;
}

- (id)initWithKnobImage:(NSImage *)knob minimumValueImage:(NSImage *)minImage maximumValueImage:(NSImage *)maxImage {
    if (!knob || !minImage || !maxImage ) {
        return nil;
    }

    self = [self init];

    if (self) {
        _knobImage = knob;
        _minimumValueImage = minImage;
		_maximumValueImage = maxImage;
    }

    return self;
}

- (void)drawKnob:(NSRect)knobRect {
//  If don't have the knobImage
//  just call the super method
    if( nil == _knobImage ) {
        [super drawKnob:knobRect];
        return;
    }

//  We need to save the knobRect to redraw the bar correctly
    _currentKnobRect = knobRect;

//---------------------Interesting-bug----------------------
//  Sometimes slider may have some bugs when you
//  just click on it and hold the mouse down.
//  To prevent this I call this method once again
//  right here.
//  !!!- If you know other way how to prevent it
//  please tell me about it -!!!
    [self drawBarInside:_barRect flipped:_flipped];
//---------------------Interesting-bug----------------------

    [self.controlView lockFocus];

//  We crete this to make a right proportion for the knob rect
//  For example you knobImage width is longer then allowable
//  this line will position you knob normally inside the slider
    CGFloat newOriginX = knobRect.origin.x *
            (_barRect.size.width - (_knobImage.size.width - knobRect.size.width)) / _barRect.size.width;

	NSRect fromRect = {
		.origin = {newOriginX, knobRect.origin.y},
		.size = _knobImage.size
	};
	[_knobImage drawInRect:fromRect];

    [self.controlView unlockFocus];
}

- (void)drawBarInside:(NSRect)cellFrame flipped:(BOOL)flipped {
//  If don't have any of the bar images
//  just call the super method
    if (!_knobImage || !_minimumValueImage || !_maximumValueImage) {
        [super drawBarInside:cellFrame flipped:flipped];
        return;
    }

//---------------------Interesting-bug----------------------
//   Again we save this to prevent the same bug
//   I've wrote inside the drawKnob: method
    _barRect = cellFrame;
    _flipped = flipped;
//---------------------Interesting-bug----------------------

    NSRect beforeKnobRect = [self createBeforeKnobRect];
    NSRect afterKnobRect = [self createAfterKnobRect];

//  Sometimes you can see the ages off you bar
//  even if your knob is at the end or
//  at the beginning of it. It's about one pixel
//  but this help to hide that edges
//    if (self.minValue != self.doubleValue) {
//        NSDrawThreePartImage(beforeKnobRect, _barLeftAgeImage, _barFillBeforeKnobImage, _barFillBeforeKnobImage,
//                NO, NSCompositeSourceOver, 1.0, flipped);
//    }
//
//    if( self.maxValue != self.doubleValue ) {
//        NSDrawThreePartImage(afterKnobRect, _barFillImage, _barFillImage, _barRightAgeImage,
//                NO, NSCompositeSourceOver, 1.0, flipped);
//    }
	
	[_minimumValueImage drawInRect:beforeKnobRect];
	[_maximumValueImage drawInRect:afterKnobRect];
}

- (NSRect)createBeforeKnobRect {
    NSRect beforeKnobRect = _barRect;

    beforeKnobRect.size.width = _currentKnobRect.origin.x + _knobImage.size.width / 2;
    beforeKnobRect.size.height = _minimumValueImage.size.height;
    beforeKnobRect.origin.y = beforeKnobRect.size.height / 2;

    return beforeKnobRect;
}

- (NSRect)createAfterKnobRect {
    NSRect afterKnobRect = _currentKnobRect;

    afterKnobRect.origin.x += _knobImage.size.width / 2;
    afterKnobRect.size.width = _barRect.size.width - afterKnobRect.origin.x;
    afterKnobRect.size.height = _maximumValueImage.size.height;
    afterKnobRect.origin.y = afterKnobRect.size.height / 2;

    return afterKnobRect;
}

@end
