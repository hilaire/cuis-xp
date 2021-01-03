'From Cuis 5.0 [latest update: #4413] on 22 October 2020 at 12:11:21 pm'!
'Description '!
!provides: 'Morphic-Circular' 1 34!
!requires: 'Animation' 1 4 nil!
!requires: 'VectorGraphics' 1 148 nil!
!requires: 'Collections-CompactArrays' 1 12 nil!
SystemOrganization addCategory: 'Morphic-Circular'!


!classDefinition: #SketchMorph category: 'Morphic-Circular'!
ImageMorph subclass: #SketchMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'SketchMorph class' category: 'Morphic-Circular'!
SketchMorph class
	instanceVariableNames: ''!

!classDefinition: #ChevronMorph category: 'Morphic-Circular'!
PluggableButtonMorph subclass: #ChevronMorph
	instanceVariableNames: 'aperture shift innerRadius radius corners bounds buttonNormalForm buttonOverForm center'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'ChevronMorph class' category: 'Morphic-Circular'!
ChevronMorph class
	instanceVariableNames: ''!

!classDefinition: #DropDownChevronMorph category: 'Morphic-Circular'!
ChevronMorph subclass: #DropDownChevronMorph
	instanceVariableNames: 'activated chevron toolbar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'DropDownChevronMorph class' category: 'Morphic-Circular'!
DropDownChevronMorph class
	instanceVariableNames: ''!

!classDefinition: #CircularToolbarMorph category: 'Morphic-Circular'!
WidgetMorph subclass: #CircularToolbarMorph
	instanceVariableNames: 'buttonSize aperture innerRadius shift'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'CircularToolbarMorph class' category: 'Morphic-Circular'!
CircularToolbarMorph class
	instanceVariableNames: ''!

!classDefinition: #CircularSubToolbarMorph category: 'Morphic-Circular'!
CircularToolbarMorph subclass: #CircularSubToolbarMorph
	instanceVariableNames: 'dropDown'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'CircularSubToolbarMorph class' category: 'Morphic-Circular'!
CircularSubToolbarMorph class
	instanceVariableNames: ''!


!SketchMorph commentStamp: '<historical>' prior: 0!
I am an image morph with a modifiable extent.!

!ChevronMorph commentStamp: 'hlsf 6/6/2020 22:11:24' prior: 0!
I am a button for a circular morph. I look like a truncated section of a circle, I am nammed chevron as a shorter name.
I  am inserted in a cicular toolbar of the given radius.

- aperture is the angle (radian) between the two straight lines of the chevron
- shift is the rotation angle (radian) of the chevron starting from the vertical centered position. With shift == 0, the chevron is centered at the top of the circular toolbar. The angle is clock-wise oriented. A shift value of pi/2 put the chevron at the right of the circular toolbar.
- corners: points 1 to 4 are the four corners of the chevron. The points 5, 6 and 7 are computed to ensure a better bounding box. The point 8 contains the decoration center if any.
- center: center of the shape in local coordinates for positionning, ie icon, owner position!

!DropDownChevronMorph commentStamp: '<historical>' prior: 0!
I am a small drop down chevron. The user clicks me to open a sub toolbar.
- activated: true when I have been clicked, those a sub circular toolbar should show up
- chevron: the chevron I am positionned close to!

!CircularToolbarMorph commentStamp: '<historical>' prior: 0!
- buttonSize: computed extent from the icon size (square)
- aperture: the chevron angle as seen from the toolbar center
- innerRadisu: interior size of the toolbar
- subToolbar: is it a toolbar open from a drop down chevron
- shift: shifted angle for the first button in the toolbar (0 top center, pi/2, right center)

I am circular toolbar. I can be a subToolbar too, then I render and behave a bit differently.

| tools |
Feature require: 'VectorGraphics'.
tools _ CircularToolbarMorph new buttonSize: 20; morphExtent: 150@150.
tools color: (Color orange alpha: 0.8);
	addButton: Theme current newIcon;
	addButton: Theme current openIcon;
	addButton: Theme current saveIcon;
	addButton: Theme current copyIcon ;
	addButton: Theme current pasteIcon ;
	addButton: Theme current undoIcon;
	addButton: Theme current redoIcon ;
	addButton: Theme current closeIcon ;
	addButton: Theme current quitIcon.
tools openInWorld.

Feature require: 'Animation'.
tools openAnimated . 
!

!CircularSubToolbarMorph commentStamp: 'hlsf 7/11/2020 12:23:55' prior: 0!
I am circular sub-toolbar. I am trigerred from a drop down chevron attached to a parent circular toolbar (the main one)
- dropDown : the drop down chevron I was opened from

| tools icons someIcons |
tools _ CircularToolbarMorph new buttonSize: 30; morphExtent: 300@300.
tools color: (Color orange alpha: 0.8).
someIcons _ {Theme current newIcon. Theme current openIcon .Theme current saveIcon. Theme current copyIcon.}.
icons _ {Theme current newIcon. Theme current openIcon .Theme current saveIcon. Theme current copyIcon. Theme current pasteIcon. Theme current undoIcon. Theme current redoIcon. Theme current closeIcon. Theme current quitIcon}.
icons do: [:icon | | button drop |
	drop _ (button _ tools addButton: icon) addDropDown.
	button setBalloonText: 'test'.
	someIcons do: [: icn | (drop toolbar addButton: icn) setBalloonText: 'I''am a button in a circular sub toolbar']
	].
tools openAnimated!

!SketchMorph methodsFor: 'drawing' stamp: 'hlsf 5/29/2020 12:10:14'!
drawOn: aCanvas
	aCanvas image: (image magnifyTo: extent) at: self morphTopLeft! !

!SketchMorph methodsFor: 'drawing' stamp: 'hlsf 5/29/2020 12:08:37'!
minimumExtent
	^ `1@1`! !

!SketchMorph methodsFor: 'geometry' stamp: 'hlsf 5/29/2020 12:09:05'!
morphExtent: newExtent
	"assume it is always in our coordinates!!"
	| oldBoundsInWorld |
	self flag: #jmvVer2.
	extent = newExtent ifFalse: [
		"Ask for the old bounds before updating them, but ask for repair only if extent was really changed."
		oldBoundsInWorld _ self morphBoundsInWorld.
		(self privateExtent: newExtent) ifTrue: [
			"Ask for the old bounds before updating them, but ask for repair only if extent was really changed."
			oldBoundsInWorld ifNotNil: [
				self invalidateDisplayRect: oldBoundsInWorld from: nil ].
			self someSubmorphPositionOrExtentChanged.
			owner ifNotNil: [ owner someSubmorphPositionOrExtentChanged ].
			self redrawNeeded ]]! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/12/2020 14:39:29'!
buttonNormalForm
	^ buttonNormalForm ifNil: [
		buttonNormalForm _ self drawMyShapeWith: color.
		icon ifNotNil: [
			(icon copy convertAlphaToZeroValueTransparency asGrayScaleAndTransparent )
				displayOn: buttonNormalForm 
				at: center - (icon extent // 2) 
				rule: Form blend 
"			(icon asFormOfDepth: 1)
				displayOn: buttonNormalForm 
				at: center - (icon extent // 2) 
				rule: Form and "].
		buttonNormalForm]
! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/5/2020 10:40:50'!
buttonOverForm
	^ buttonOverForm ifNil: [
		buttonOverForm _ self drawMyShapeWith: (Color white alpha: color alpha).
		icon ifNotNil: [icon displayOn: buttonOverForm at: center - (icon extent // 2) rule: Form blend].
		buttonOverForm]
	! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/2/2020 16:45:05'!
drawMyShapeWith: background
	| vectorCanvas aLocation aForm |
	aForm _ Form extent: extent depth: Display depth.
	aForm fillColor: Color transparent.
	vectorCanvas _ VectorCanvas onForm: aForm.
	aLocation _ AffineTransformation withTranslation: bounds topLeft negated.
	vectorCanvas engine geometryTransformation: aLocation.
	vectorCanvas strokeWidth: 2 color: color muchDarker fillColor: background  do: [: engine |
		engine abs_MoveToX: (corners floatAt: 1) y: (corners floatAt: 2);
			abs_LineToX: (corners floatAt: 3) y: (corners floatAt: 4);
			abs_ArcToX: (corners floatAt: 5) y: (corners floatAt: 6) 
				radiusX: radius radiusY: radius angleOfXAxis: aperture largeFlag: false sweepFlag: false;
			abs_LineToX: (corners floatAt: 7) y: (corners floatAt: 8);
			abs_ArcToX: (corners floatAt: 1) y: (corners floatAt: 2) 
				radiusX: innerRadius radiusY: innerRadius angleOfXAxis: aperture largeFlag: false sweepFlag: true].
	^ aForm
	! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/6/2020 22:41:25'!
drawOn: aCanvas
	aCanvas 
		image: (self mouseIsOver ifTrue:[ self buttonOverForm] ifFalse: [self buttonNormalForm])
		at: `0@0`.! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 5/26/2020 10:27:40'!
resetFormCaches
	buttonNormalForm _ buttonOverForm _ nil! !

!ChevronMorph methodsFor: 'geometry' stamp: 'hlsf 6/6/2020 22:14:48'!
computeBounds
	| angle matrix |
	"Corners are computed relatatively to the center of the circular toolbar: transform relatively to the top
	left corner of the circular toolbar and oriented as in in the display screen"
	matrix _ AffineTransformation withPointScale: `1@-1` position: radius@radius.
	angle _ Float halfPi - shift.
	center _ (matrix transform: (Point rho: radius + innerRadius // 2 theta: angle)).
	"Additionnal points for a better bounding box calculus"
	corners at: 5 put: (matrix transform: (Point rho: radius theta: angle)).
	corners at: 6 put: (matrix transform: (Point rho: radius theta: angle - (aperture / 4))).
	corners at: 7 put: (matrix transform: (Point rho: radius theta: angle + (aperture / 4))).
	corners at: 8 put: (matrix transform: (Point rho: radius + 5 theta: angle)).
	angle _ angle - (aperture / 2).
	corners 
		at: 1 put: (matrix transform: (Point rho: innerRadius theta: angle));
		at: 2 put: (matrix transform: (Point rho: radius theta: angle)).
	angle _ angle + aperture.
	corners 
		at: 3 put: (matrix transform: (Point rho: radius theta: angle));
		at: 4 put: (matrix transform: (Point rho: innerRadius theta: angle)).
	bounds _ (Rectangle encompassing: corners) expandBy: 3.
	extent _ bounds extent.
	"center of the shape in local coordinates for positionning, ie icon, owner position"
	center _ center - bounds topLeft. 
	self resetFormCaches
	! !

!ChevronMorph methodsFor: 'geometry' stamp: 'hlsf 5/25/2020 21:58:19'!
morphExtent: aPoint
"Can't be"! !

!ChevronMorph methodsFor: 'initialization' stamp: 'hlsf 6/12/2020 11:45:37'!
addDropDown
"Decorate me with a drop down chevron"
| newDropDown |
	newDropDown _ DropDownChevronMorph
	 	 aperture: aperture shift: shift radius: radius + self dropDownHeight innerRadius: radius. 
	newDropDown color: color;
		chevron: self.
	self owner addMorphBack: newDropDown.
	^ newDropDown 
	! !

!ChevronMorph methodsFor: 'initialization' stamp: 'hlsf 10/22/2020 12:09:23'!
initialize
	super initialize.
	corners _ Float32PointArray new: 8! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/9/2020 18:11:01'!
aperture: float1 shift: float2 radius: integer1 innerRadius: integer2 
	aperture _ float1.
	shift _ float2.
	radius _ integer1.
	innerRadius _ integer2.
	self computeBounds.
	self resetFormCaches.
	self dropDown ifNotNil: [:dropDown | 
		dropDown aperture: float1 shift: shift radius: radius + self dropDownHeight innerRadius: radius]! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 15:28:41'!
bounds
	^ bounds! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/2/2020 15:54:54'!
color: aColor
	super color: aColor.
	self resetFormCaches ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 15:33:03'!
dropDown
"Do I have any associated drow down chevron?"
	^ owner ifNotNil: [
		owner submorphs 
			detect: [:morph | morph isDropDownChevron and: [morph chevron == self]]
			ifNone: [nil]]! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 15:27:41'!
dropDownCenterPosition
	^ corners eighth ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/10/2020 12:48:40'!
dropDownHeight
	^ 15! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 10:28:16'!
icon: aForm
	super icon: aForm.
	self resetFormCaches ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 15:57:40'!
morphCenter
	^ center! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 15:58:32'!
morphCenter: aPoint
	super morphPosition: aPoint - center! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 16:49:03'!
morphPosition: aPoint
"You can't, positionning will be innacurate, positionning is done only from its center"! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 19:26:32'!
shift
	^ shift! !

!ChevronMorph methodsFor: 'geometry testing' stamp: 'hlsf 5/25/2020 22:00:18'!
isOrthoRectangularMorph
	^ false! !

!ChevronMorph methodsFor: 'geometry testing' stamp: 'hlsf 6/5/2020 22:08:24'!
morphContainsPoint: aLocalPoint
	| polarPoint min max |
	(self morphLocalBounds containsPoint: aLocalPoint) ifFalse: [^ false]. 
	polarPoint _ (aLocalPoint + bounds topLeft - radius asPoint) * (1 @ -1).
	min _  Float halfPi - (aperture / 2) - shift.
	max _ Float halfPi + (aperture / 2) - shift.
	^ (polarPoint r 
		between: innerRadius 
		and: radius) 
			and: ["Deal when crossing zero"
				(polarPoint theta 
					between: min
					and:  max)
				or: [polarPoint theta 
						between: min + Float twoPi 
						and:  max + Float twoPi
					]
				]! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:32:45'!
isChevron
	^ true! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:32:57'!
isDropDownChevron
	^ false! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/15/2020 21:50:36'!
isOnSubToolbar
	^ owner isSubToolbar ! !

!ChevronMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 6/15/2020 22:20:14'!
performAction
	super performAction.
	"Am I chevron on sub toolbar? 
	If so I become the chevron the sub toolbar  was attached too"
	self isOnSubToolbar ifTrue: [ | target |
		"Not a complete replacement, so do it by hand"
		target _ owner dropDown chevron.
		target icon: icon;
			model: self model;
			action: actionSelector;
			secondaryActionSelector: secondaryActionSelector.
		self valueOfProperty: #balloonText ifPresentDo: [:txt | target setBalloonText: txt].
		owner owner redrawNeeded.
		"Simulate a clic on the drop down so I close the subtoolbar"
		owner dropDown closeSubToolbar ]! !

!ChevronMorph class methodsFor: 'instance creation' stamp: 'hlsf 5/24/2020 11:26:21'!
aperture: float1 shift: float2 radius: integer1 innerRadius: integer2 
	^ super new 
		aperture: float1 shift: float2 radius: integer1 innerRadius: integer2;
		yourself
! !

!ChevronMorph class methodsFor: 'instance creation' stamp: 'hlsf 5/23/2020 16:39:54'!
new
	self error: 'Use aperture:angle:radius:innerRadius: message'! !

!DropDownChevronMorph methodsFor: 'initialization' stamp: 'hlsf 6/12/2020 14:57:48'!
initialize
	super initialize.
	corners _ FloatPointArray new: 3.
	activated _ false.
	self model: self;
		action: #dropDownClicked.
	getStateSelector _ #isActivated! !

!DropDownChevronMorph methodsFor: 'geometry' stamp: 'hlsf 6/9/2020 18:11:40'!
adjustToolbarExtent
	self toolbar 
		shift: chevron shift;
		morphExtent: owner morphExtent + (chevron dropDownHeight + 8 + owner buttonSize * 2)! !

!DropDownChevronMorph methodsFor: 'geometry' stamp: 'hlsf 6/7/2020 20:01:06'!
computeBounds
	| angle matrix |
	"Corners are computed relatatively to the center of the circular toolbar: transform relatively to the top
	left corner of the circular toolbar and oriented as in in the display screen"
	matrix _ AffineTransformation withPointScale: `1@-1` position: radius @ radius.
	angle _ Float halfPi - shift.
	center _ (matrix transform: (Point rho: innerRadius theta: angle)).
	corners at: 3 put: (matrix transform: (Point rho: radius theta: angle)).
	angle _ angle - (aperture / 2).
	corners at: 2 put: (matrix transform: (Point rho: innerRadius theta: angle)).
	angle _ angle + aperture.
	corners at: 1 put: (matrix transform: (Point rho: innerRadius theta: angle)).
	bounds _ (Rectangle encompassing: corners) expandBy: 3.
	extent _ bounds extent.
	"center of the shape in local coordinates for positionning, owner position"
	center _ center - bounds topLeft. 
	self resetFormCaches! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/5/2020 11:18:45'!
buttonNormalForm
	^ buttonNormalForm ifNil: [
		buttonNormalForm _ self drawMyShapeWith: color]
! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/5/2020 11:19:03'!
buttonOverForm
	^ buttonOverForm ifNil: [
		buttonOverForm _ self drawMyShapeWith: (Color white alpha: color alpha)]
	! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/5/2020 22:25:48'!
drawMyShapeWith: background
	| vectorCanvas aLocation aForm |
	aForm _ Form extent: extent depth: Display depth.
	aForm fillColor: Color transparent.
	vectorCanvas _ VectorCanvas onForm: aForm.
	aLocation _ AffineTransformation withTranslation: bounds topLeft negated.
	vectorCanvas engine geometryTransformation: aLocation.
	vectorCanvas strokeWidth: 2 color: color muchDarker fillColor: background  do: [: engine |
		engine abs_MoveToX: (corners floatAt: 1) y: (corners floatAt: 2);
			abs_ArcToX: (corners floatAt: 3) y: (corners floatAt: 4) 
				radiusX: innerRadius radiusY: innerRadius angleOfXAxis: aperture largeFlag: false sweepFlag: true;
			abs_LineToX: (corners floatAt: 5) y: (corners floatAt: 6);
			abs_LineToX: (corners floatAt: 1) y: (corners floatAt: 2)].
	^ aForm
	! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 6/7/2020 18:36:21'!
drawOn: aCanvas
	activated 
		ifTrue: [aCanvas image: self buttonOverForm at: `0@0`]
		ifFalse: [super drawOn: aCanvas]! !

!DropDownChevronMorph methodsFor: 'geometry testing' stamp: 'hlsf 6/5/2020 22:13:31'!
containsDropDownChevron
	^ false! !

!DropDownChevronMorph methodsFor: 'geometry testing' stamp: 'hlsf 6/6/2020 22:44:14'!
morphContainsPoint: aLocalPoint
"To be written properly"
	^ (self morphLocalBounds containsPoint: aLocalPoint)
	"(self morphLocalBounds containsPoint: aLocalPoint) ifFalse: [^ false].
	^ (aLocalPoint + bounds topLeft - radius asPoint) * (1 @ -1) 
		insideTriangle: corners first 
		with: corners second 
		with: corners third."! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 14:58:03'!
isActivated
	^ activated ! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:33:06'!
isChevron
	^ false! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:33:14'!
isDropDownChevron
	^ true! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:55:38'!
chevron
	^ chevron! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:55:49'!
chevron: aChevron
	chevron _ aChevron ! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 12:08:52'!
toolbar
	^ toolbar ifNil: [
		toolbar _ CircularSubToolbarMorph new
			color: (Color random alpha: owner color alpha);
			dropDown: self;
			privateButtonSize: owner buttonSize.
		self adjustToolbarExtent.
		toolbar ]! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 6/15/2020 22:20:14'!
closeSubToolbar
	self toolbar deleteAnimated.
	activated _ false! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 6/15/2020 22:20:14'!
dropDownClicked
	activated
		ifTrue: [ self closeSubToolbar ]
		ifFalse: [ self openSubToolbar ].! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 6/15/2020 22:22:49'!
openSubToolbar
	owner closeAllSubToolbars.
	self toolbar
		openAnimatedAt: self morphPositionInWorld
		to: owner morphCenter
		then: [
			owner addMorphBack: self toolbar.
			self toolbar morphCenter: owner center ].
	activated _ true.! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 20:04:15'!
addButton: icon
	| button |
	button _ ChevronMorph 
		aperture: self aperture 
		shift: self chevronCount * (self aperture + self gap) + shift
		radius: extent x // 2 
		innerRadius: self innerRadius.
	button color: color;
		icon: icon.
	self addMorphBack: button.
	^ button! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 16:51:54'!
aperture
"a very clever computation..."
	^ aperture ifNil: [aperture _ ((buttonSize / 2.0) arcTan: self innerRadius) * 2]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 18:14:42'!
buttonSize
	^ buttonSize! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:50:18'!
buttonSize: anInteger
	buttonSize _ anInteger * 1.4. "We need some gap to fit in the chevron area"
	aperture _ nil.
	self layoutChevrons.! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:39:59'!
chevronCount
	^ self chevrons size! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:36:42'!
chevrons
	^ self submorphsSatisfying: [:each | each isChevron]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:33:38'!
chevronsDo: aBlock
	self submorphs 
		select: [:each | each isChevron] 
		thenDo: [:aChevron | aBlock value: aChevron]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/4/2020 12:34:55'!
color: aColor
	super color: aColor.
	self submorphsDo: [:each | each color: aColor]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/8/2020 19:27:09'!
dropDownChevronsDo: aBlock
	self submorphs 
		select: [:each | each isDropDownChevron ] 
		thenDo: [:aDropDownChevron | aBlock value: aDropDownChevron ]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 11:53:20'!
gap
"Angle gap between the chevron button"
	^ `5 degreesToRadians`! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 16:08:12'!
innerRadius
	^ innerRadius ifNil: [innerRadius _ extent x // 2 - buttonSize]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 16:52:56'!
numberOfVisibleButtons
"Number of visible buttons"
	^  `Float twoPi` // (self aperture + self gap).! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 18:15:42'!
privateButtonSize: anInteger
	buttonSize _ anInteger! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 20:05:18'!
shift: angle
	shift _ angle! !

!CircularToolbarMorph methodsFor: 'change reporting' stamp: 'hlsf 6/7/2020 15:53:19'!
addedMorph: aMorph
	self layoutChevrons ! !

!CircularToolbarMorph methodsFor: 'drawing' stamp: 'hlsf 6/12/2020 11:52:37'!
drawOn: aCanvas
"aCanvas fillRectangle: self morphLocalBounds color: (Color white alpha: 0.5)."
| center | 
	center _ extent x // 2.
	aCanvas ellipseCenterX: center y: center rx: self innerRadius ry: self innerRadius 
		borderWidth: 0 borderColor: color darker fillColor: (color muchLighter alpha: 0.5)
! !

!CircularToolbarMorph methodsFor: 'initialization' stamp: 'hlsf 6/12/2020 11:51:11'!
initialize
	super initialize.
	extent _ 300 @ 300.
	shift _ 0! !

!CircularToolbarMorph methodsFor: 'geometry' stamp: 'hlsf 6/7/2020 19:40:03'!
layoutChevrons
	| buttonCenter center radius angle count |
	center _ extent x // 2.
	radius _ buttonSize / 2.0 + self innerRadius.
	angle _ `Float halfPi` - shift.
	count _ self numberOfVisibleButtons.
	self chevronsDo: [: chevron |
		count <= 0 
			ifTrue: [
				chevron setProperty: #visible toValue: false.
				chevron dropDown ifNotNil: [:drop  | drop setProperty: #visible toValue: false]
				]
			ifFalse: [
				buttonCenter _ Point rho: radius theta: angle.
				buttonCenter _ (buttonCenter x + center) @ (center - buttonCenter y).
				chevron morphCenter: buttonCenter.
				chevron setProperty: #visible toValue: true.
				chevron dropDown ifNotNil: [:drop  | 
					drop morphCenter: chevron dropDownCenterPosition.
					drop setProperty: #visible toValue: true]].
		angle _ angle - self aperture - self gap.
		count _ count - 1].
	self redrawNeeded ! !

!CircularToolbarMorph methodsFor: 'geometry' stamp: 'hlsf 6/8/2020 19:27:36'!
morphExtent: newExtent
	super morphExtent: (newExtent x max: buttonSize * 2) asPoint.
	innerRadius _ aperture _ nil.
	self chevrons withIndexDo: [:chevron :count |
		chevron 
			aperture: self aperture 
			shift: (count - 1) * (self aperture + self gap) + shift
			radius: extent x // 2
			innerRadius: self innerRadius].
	self layoutChevrons.
	self dropDownChevronsDo: [:each | each adjustToolbarExtent ]! !

!CircularToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:53'!
isSubToolbar
	^ false! !

!CircularToolbarMorph methodsFor: 'animate' stamp: 'hlsf 6/15/2020 22:03:51'!
deleteAnimated
	self deleteAnimatedAt: self morphCenter! !

!CircularToolbarMorph methodsFor: 'animate' stamp: 'hlsf 6/15/2020 22:03:33'!
deleteAnimatedAt: center
	| imageMorph  world |
	imageMorph _ SketchMorph new image: (self imageForm: 32).
	"center _ self morphCenter."
	self morphCenter: center.
	imageMorph 
		morphCenter: center;
		openInWorld.
	self delete.
	imageMorph
		morphExtent: (0 during: 0.2 seconds);
		morphCenter:  (center during: 0.2 seconds).
	world _ self runningWorld.
	[world doOneCycleNow.
	imageMorph dismissMorph.] forkAt: Processor userBackgroundPriority 
	! !

!CircularToolbarMorph methodsFor: 'animate' stamp: 'hlsf 6/15/2020 21:57:15'!
openAnimated
	self 
		openAnimatedAt: self activeHand morphPosition 
		then: [self openInWorld]! !

!CircularToolbarMorph methodsFor: 'animate' stamp: 'hlsf 6/15/2020 21:56:53'!
openAnimatedAt: center then: afterBlock
	self openAnimatedAt: center to: center then: afterBlock! !

!CircularToolbarMorph methodsFor: 'animate' stamp: 'hlsf 6/9/2020 18:16:34'!
openAnimatedAt: center to: destCenter then: afterBlock
	| imageMorph |
	imageMorph _ SketchMorph new image: (self imageForm: 32).
	self morphCenter: center.
	imageMorph 
		morphExtent: 0@0;
		morphCenter: center;
		openInWorld.
	imageMorph
		morphExtent: (self morphExtent during: 0.3 seconds);
		morphCenter:  (destCenter during: 0.3 seconds).
	[	afterBlock value.
		(Delay forMilliseconds: 50) wait.
		imageMorph delete.
	] forkAt: Processor userBackgroundPriority 
	! !

!CircularToolbarMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 6/15/2020 22:24:14'!
closeAllSubToolbars
	self dropDownChevronsDo: [:dropDown | 
		dropDown isActivated ifTrue: [dropDown closeSubToolbar ]]! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 12:10:11'!
dropDown
	^ dropDown! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 12:08:10'!
dropDown: aDropDownChevron
	dropDown _ aDropDownChevron ! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 11:53:08'!
gap
	^ `1 degreesToRadians`! !

!CircularSubToolbarMorph methodsFor: 'geometry testing' stamp: 'hlsf 6/12/2020 11:51:04'!
morphContainsPoint: aLocalPoint
"We don't want contains point for subtoolbar, so multiple subtoolbar can overlap"
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:31'!
isChevron
"sub toolbar are added too to toolbar so we need to sort out"
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:38'!
isDropDownChevron
"sub toolbar are added too to toolbar so we need to sort out"
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:03:13'!
isSubToolbar
	^ true! !

!CircularSubToolbarMorph methodsFor: 'drawing' stamp: 'hlsf 6/12/2020 11:52:13'!
drawOn: aCanvas
"We don't draw anything, not inner central disc for circular sub toolbar"! !

!CircularSubToolbarMorph methodsFor: 'as yet unclassified' stamp: 'hlsf 6/15/2020 22:08:12'!
deleteAnimated
"To close animated we must remove it first from its owner, then open in world"
	self morphCenter: owner morphCenter;
		delete;
		openInWorld.
	super deleteAnimated! !

!RectangleLikeMorph methodsFor: '*Morphic-Circular' stamp: 'hlsf 6/14/2020 20:31:46'!
center
"center positionning in morph coordinate"
	^ extent // 2! !

!RectangleLikeMorph methodsFor: '*Morphic-Circular' stamp: 'hlsf 6/7/2020 16:15:22'!
morphCenter
"We want float computation
Center positionning in its parents morph"
	^ self morphPosition + (extent // 2)! !

!RectangleLikeMorph methodsFor: '*Morphic-Circular' stamp: 'hlsf 6/7/2020 16:14:07'!
morphCenter: aPoint 
	self morphPosition: aPoint - (extent // 2)! !
