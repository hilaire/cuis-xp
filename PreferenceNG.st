'From Cuis 6.0 [latest update: #5113] on 3 May 2022 at 9:26:09 pm'!
!classDefinition: #PreferenceNG category: #'System-Support'!
Object subclass: #PreferenceNG
	instanceVariableNames: 'name description category value type'
	classVariableNames: 'ThePreferences'
	poolDictionaries: ''
	category: 'System-Support'!
!PreferenceNG commentStamp: 'hlsf 4/30/2022 12:47:46' prior: 0!
My instance is a Preference whose value is of a given class (type), or follow the description of the type instance

- name, category: symbol
- description: string
- type: a class (Boolean, String, Color, BlockClosure, etc.) or an instance (collection, intervale, etc.)
- value: an object whose class match type or the instance description of the type

Modus Operendi
- To create a Preference, invoke the instance creation class method (Preference name:description:category:type:value:). The new preference is automatically remembered. If a preference with same name already exist, its instance is returned.
- To access, invoke as dictionary (Preference at: #biggerCursors), a short cut exist (Preference biggerCursors)!


!PreferenceNG methodsFor: 'printing' stamp: 'hlsf 4/30/2022 14:42:44'!
printOn: aStream
	aStream nextPutAll: self class name ;
		nextPutAll: ' (';
		nextPutAll: name capitalized ;
		nextPutAll: ' = ';
		nextPutAll: type printString;
		nextPutAll: '::';
		nextPutAll: value printString;
		nextPut: $)! !


!PreferenceNG methodsFor: 'initialization' stamp: 'hlsf 5/3/2022 20:42:49'!
name: nameSymbol description: aString category: categorySymbol type: aType value: aValue
	name _ nameSymbol.
	description _ aString.
	category _ categorySymbol.
	type _ aType ifNotNil: [aType] ifNil: [ aValue class].
	value _ 	aValue! !


!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 14:25:45'!
category
	^ category ! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 5/2/2022 22:19:11'!
category: aSymbol
	aSymbol isNil ifFalse: [category _ aSymbol ]! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 14:25:57'!
description
	^ description! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 5/2/2022 22:18:30'!
description: aString
	aString isEmptyOrNil ifFalse: [description _ aString ]! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 14:26:02'!
name
	^ name! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 5/3/2022 21:16:04'!
value
" If my type is closure without argument, return my value "
	^ (type == BlockClosure and: [value argumentCount = 0])
		ifTrue: [value value]
		ifFalse: [value]
	! !

!PreferenceNG methodsFor: 'accessing' stamp: 'hlsf 5/3/2022 20:54:17'!
value: aValue	
	type class class == Metaclass "type is a Class"
		ifTrue: [
			(aValue isKindOf: type) ifFalse: [self error: aValue printString, ' is not a ', type printString].
			value _ aValue .				
			]
		ifFalse: [ "Should be handled somehow by the preference editor "
			value _ aValue].
	self triggerEvent: #preferenceChanged with: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PreferenceNG class' category: #'System-Support'!
PreferenceNG class
	instanceVariableNames: ''!

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 21:11:22'!
all
	^ ThePreferences 
	! !

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 22:21:36'!
at: symbolName
	^ (self instanceAt: symbolName) value! !

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 5/3/2022 20:47:15'!
at: symbolName put: aValue
	| myPref |
	myPref _ self instanceAt: symbolName. 
	myPref value: aValue! !

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 14:28:57'!
categories
	| categories |
	categories _ Set new.
	ThePreferences values do: [:aPreference | categories add: aPreference category].
	^ categories sorted! !

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 22:19:26'!
instanceAt: symbolName
	^ ThePreferences at: symbolName ifAbsent: [self error: 'Unknown preference ', symbolName ]! !

!PreferenceNG class methodsFor: 'accessing' stamp: 'hlsf 4/30/2022 14:29:56'!
select: aCategory
" I select the preferences of the given category "
	^ ThePreferences values select: [:aPreference | aPreference category == aCategory ]! !


!PreferenceNG class methodsFor: 'instance creation' stamp: 'hlsf 4/30/2022 14:39:32'!
import
"Import the preferences from the old system"
	Preferences preferencesDictionary valuesDo: [:oldPref |
		PreferenceNG 
			name: oldPref name 
			description: (oldPref instVarNamed: #helpString)
			category: (oldPref instVarNamed: #categoryList) first
			type: Object
			value: oldPref preferenceValue 
		]! !

!PreferenceNG class methodsFor: 'instance creation' stamp: 'hlsf 5/3/2022 19:16:59'!
name: nameSymbol category: categorySymbol value: aValue
	self name: nameSymbol description: nil category: categorySymbol type: nil value: aValue 
! !

!PreferenceNG class methodsFor: 'instance creation' stamp: 'hlsf 5/3/2022 19:59:49'!
name: nameSymbol description: aString category: categorySymbol type: aType value: aValue
"If I exist, I am updated with the newer sent data "
	(nameSymbol isSymbol or: [categorySymbol isSymbol]) ifFalse: 
		[self error: 'Preference Name & Category are not valid symbol.'].
	^ ThePreferences 
		at: nameSymbol
		ifPresent: [:thePref |
			thePref 
				description: aString;
				category: categorySymbol;
				value: aValue;
				yourself]
		ifAbsent: [ | newPref |
			newPref _ self new ::
				name: nameSymbol 
				description: aString 
				category: categorySymbol 
				type: aType 
				value: aValue.
			ThePreferences at: nameSymbol put: newPref ].
	! !


!PreferenceNG class methodsFor: 'error handling' stamp: 'hlsf 4/30/2022 22:20:35'!
doesNotUnderstand: aMessage
	aMessage hasArguments ifTrue: [^ super doesNotUnderstand: aMessage].
	^ self at: aMessage selector! !


!PreferenceNG class methodsFor: 'class initialization' stamp: 'hlsf 4/30/2022 21:07:47'!
initialize
	self reset! !


!PreferenceNG class methodsFor: 'fileIn/Out' stamp: 'hlsf 4/30/2022 22:10:43'!
loadFrom: aFileEntry
" Load all preferences from file, it replaces entirely the existing preferences "
	ThePreferences _ SmartRefStream restoreFromFile: aFileEntry! !

!PreferenceNG class methodsFor: 'fileIn/Out' stamp: 'hlsf 4/30/2022 22:10:56'!
mergeWith: aFileEntry
" Load the preferences from file and merge with the existing preferences. 
Duplicates from file replace the ones in system "
	| newPrefs |
	newPrefs _ 	SmartRefStream restoreFromFile: aFileEntry.
	newPrefs associationsDo: [:assoc | 		ThePreferences at: assoc key put: assoc value]! !

!PreferenceNG class methodsFor: 'fileIn/Out' stamp: 'hlsf 4/30/2022 22:20:56'!
save: nameSymbol to: aFileEntry
" Save one preference to a file, even for a sole preference we save in a Dictionary"
	| myPref |
	myPref _ self instanceAt: nameSymbol.
	SmartRefStream 
		dumpOnFile: aFileEntry 
		object: {myPref name -> myPref} asDictionary! !

!PreferenceNG class methodsFor: 'fileIn/Out' stamp: 'hlsf 4/30/2022 21:58:19'!
saveAllTo: aFileEntry
" Save all the preferences to a file "
	SmartRefStream dumpOnFile: aFileEntry object: ThePreferences! !

!PreferenceNG class methodsFor: 'fileIn/Out' stamp: 'hlsf 4/30/2022 21:57:59'!
saveCategory: categorySymbol to: aFileEntry
	| myPref |
	myPref _ self select: categorySymbol.
	SmartRefStream 
		dumpOnFile: aFileEntry 
		object: 	(myPref collect: [:aPref | aPref name -> aPref ]) asDictionary! !


!PreferenceNG class methodsFor: 'helpers' stamp: 'hlsf 5/1/2022 18:34:41'!
detectType: anObject
	^ anObject class 
		caseOf: {
			[True] -> [Boolean].
			[False] -> [Boolean].
		}
		otherwise: [anObject class]
! !


!PreferenceNG class methodsFor: 'fonts handling' stamp: 'hlsf 5/3/2022 20:54:30'!
defaultFontSize: guiElementSizePref
	| font titleFont pointSize |
	pointSize _ self fontSizes at: guiElementSizePref value.
	font _ FontFamily familyName: FontFamily defaultFamilyName pointSize: pointSize.
	PreferenceNG name: #standardListFont category: #font value: font.
	PreferenceNG name: #standardMenuFont category: #font value: font.
	PreferenceNG name: #standardCodeFont category: #font value: font.
	PreferenceNG name: #standardButtonFont category: #font value: font.
	FontFamily defaultFamilyName: font familyName defaultPointSize: pointSize.	
	titleFont _ FontFamily familyName: FontFamily defaultFamilyName pointSize: pointSize * 12//10.
	PreferenceNG name: #windowTitleFont category: #font value: titleFont.
	MorphicCanvas allSubclassesDo: [ :c| c guiSizePreferenceChanged ].
	UISupervisor ui ifNotNil: [ :w | w fontPreferenceChanged ].
	PreferenceNG at: #biggerCursors put: (pointSize > 14).
	Cursor defaultCursor activateCursor.
	^font! !

!PreferenceNG class methodsFor: 'fonts handling' stamp: 'hlsf 5/3/2022 18:58:38'!
fontSizes
	^ `{
		#tinyFonts -> 7 .
		#verySmallFonts -> 9 .
		#smallFonts ->11 .
		#standardFonts -> 14 .
		#largeFonts -> 18 .
		#veryLargeFonts -> 24 .
		#hugeFonts -> 32} asDictionary`
		! !

!PreferenceNG class methodsFor: 'fonts handling' stamp: 'hlsf 5/3/2022 19:38:13'!
setDefaultFont: aFontName
	"Change the font on the whole system without changing point sizes."
	FontFamily defaultFamilyName: aFontName.
	Preferences
			setDefaultFont: FontFamily defaultFamilyName
			spec: {
				{#standardListFont. (PreferenceNG at: #standardListFont) pointSize.}.
				{#standardMenuFont. (PreferenceNG at: #standardMenuFont) pointSize.}.
				{#windowTitleFont. (PreferenceNG at: #windowTitleFont) pointSize.}.
				{#standardCodeFont. (PreferenceNG at: #standardCodeFont) pointSize.}.
				{#standardButtonFont. (PreferenceNG at: #standardButtonFont) pointSize.}.
			}.
	MorphicCanvas allSubclassesDo: [ :c| c guiSizePreferenceChanged ].
	UISupervisor ui ifNotNil: [ :w | w fontPreferenceChanged ].! !

!PreferenceNG class methodsFor: 'fonts handling' stamp: 'hlsf 5/3/2022 19:39:30'!
setDefaultFont: fontFamilyName spec: defaultFontsSpec
	| font |
	defaultFontsSpec do: [ :triplet |
		font _ FontFamily familyName: fontFamilyName pointSize: triplet second.
		font ifNil: [ font _ FontFamily defaultFamilyAndPointSize ]. 
		triplet size > 2 ifTrue: [			font _ font emphasized: triplet third ].
		PreferenceNG at: triplet first put: font ].
	MorphicCanvas allSubclassesDo: [ :c| c guiSizePreferenceChanged ].
	UISupervisor ui ifNotNil: [ :w | w fontPreferenceChanged ].! !


!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/3/2022 19:50:36'!
cuisDefaults
	^ #( #(#cacheTrueTypeGlyphs #font true )
		#(#loadOnlyLatinGlyphData #font true )
		#(#properDisplayAlphaForFonts #font false )	
		#(#subPixelRenderColorFonts #font true )
		#(#drawKeyboardFocusIndicator #gui true )
		#(#balloonHelpEnabled #gui true )
		#(#biggerCursors #gui false )
		#(#browseWithPrettyPrint #programming false )
		#(#caseSensitiveFinds #system false )
		#(#checkForSlips #system true )
		#(#cmdDotEnabled #system true )
		#(#diffsInChangeList #programming true )
		#(#diffsWithPrettyPrint #programming false )
		#(#menuKeyboardControl #gui true )
		#(#optionalButtons #gui true )
		#(#extraDebuggerButtons #programming true )
		#(#subPixelRenderFonts #gui true )
		#(#thoroughSenders #programming true )
		#(#cheapWindowReframe #gui false )
		#(#syntaxHighlightingAsYouType #programming true )
		#(#tapAndHoldEmulatesButton2 #gui true )
		#(#clickGrabsMorphs #gui false )
		#(#syntaxHighlightingAsYouTypeAnsiAssignment #programming false )
		#(#syntaxHighlightingAsYouTypeLeftArrowAssignment #programming false )
		#(#wantsMenuIcons #gui true )
		#(#classAnnotations #programming #(instanceMethodsCount classMethodsCount linesOfCode))
		#(#methodAnnotations #programming #(timeStamp linesOfCode messageCategory implementorsCount sendersCount  packages changeSets))
		#(#systemCategoryAnnotations #programming #(classCount instanceMethodsCount classMethodsCount linesOfCode))
	)! !

!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/3/2022 19:54:51'!
defaultFontPreferences
	| myPref |
	myPref _ PreferenceNG 
		name: #guiElementsSize 
		description: 'Size of the graphic intereface element' 
		category: #gui 
		type: #(tinyFonts verySmallFonts smallFonts standardFonts largeFonts veryLargeFonts hugeFonts)
		value: #standardFonts.
	myPref when: #preferenceChanged send: #defaultFontSize: to: PreferenceNG.
	"Trigger manually, the preference was instantiated with value, so no setter message sent"
	myPref triggerEvent: #preferenceChanged with: myPref. ! !

!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/2/2022 22:11:47'!
defaultHaloPreferencesWith: anArray
	| aColor |
	^ PreferenceNG 
		name: #haloSpecifications 
		description: 'Halo specifications describing which halos are to be used, what they should look like, and where they should be situated'
		category: #gui
		type: Array
		value: (anArray collect: [ :each |
			aColor _ Color.
			each fourth do: [ :sel | aColor _ aColor perform: sel].
			HaloSpec new 
				horizontalPlacement: each second
				verticalPlacement: each third 
				color: aColor
				iconSymbol: each fifth
				addHandleSelector: each first
				hoverHelp: each sixth])! !

!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/3/2022 21:23:24'!
defaultMiscPreferences
	PreferenceNG 
		name: #haloHandleSize description: 'Size of the halo handle' category: #gui 
		type: nil value: [(PreferenceNG at: #standardListFont) pointSize * 5 // 3 max: 16].
	PreferenceNG
		name: #roundedButtonsRadius description: 'Radius of the button corner, when rounded' 	category: #gui
		type: nil value: [(PreferenceNG at: #standardListFont) pointSize * 8 // 14].
	PreferenceNG
		name: #roundedWindowRadius description: 'Radius of the window corner, when rounded' 	category: #gui
		type: nil value: [(PreferenceNG at: #standardListFont) pointSize].
	PreferenceNG
		name: #scrollbarThickness category: #gui 		value: [(PreferenceNG at: #windowTitleFont) pointSize + 2]! !

!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/1/2022 18:48:26'!
iconicHaloSpecifications
"Answer an array that characterizes the locations, colors, icons, and selectors of the halo handles 
that may be used in the iconic halo scheme"

^ #(	"selector						horiz			vert			color info						icon key"
	(addDismissHandle:						left			top			(red)						haloDismissIcon 						'Remove')
	(addMenuHandle:						leftCenter			top			(blue lighter)						haloMenuIcon 						'Menu')
	(addGrabHandle:						center			top			(black)						haloGrabIcon 						'Pick up')
	(addDragHandle:						rightCenter			top			(brown)						haloDragIcon 						'Move')
	(addDupHandle:						right			top			(green)						haloDuplicateIcon 						'Duplicate')	

	(addExploreHandle:						left			topCenter			(orange)						haloDebugIcon 						'Explore')
	(addDebugHandle:						right			topCenter			(orange)						haloDebugIcon 						'Debug')
	(addCollapseHandle:						left			center			(tan)						haloCollapseIcon 						'Collapse')
	(addScaleHandle:						right			center			(blue)						haloScaleIcon 						'Change scale')

	(addRotateHandle:						left			bottom			(blue)						haloRotateIcon 						'Rotate')
	(addHelpHandle:						center			bottom			(lightBlue)						haloHelpIcon 						'Help')
	(addResizeHandle:						right			bottom			(yellow)						haloResizeIcon 						'Change size')

	"FIXME - Currently non-functional...
	(addRecolorHandle:						right			bottomCenter			(magenta darker)						haloColorIcon 						'Change color')
	"
)! !

!PreferenceNG class methodsFor: 'default preferences' stamp: 'hlsf 5/3/2022 21:24:41'!
reset
	ThePreferences _ Dictionary new.
	self cuisDefaults do: [:anArray |
		self 
			name: anArray first 
			description: '' 
			category: anArray second 
			type: (self detectType: anArray third)
			value: anArray third].
	self defaultHaloPreferencesWith: self iconicHaloSpecifications.
	self defaultFontPreferences.
	self defaultMiscPreferences 
		! !


PreferenceNG initialize!
