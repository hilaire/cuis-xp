'From Cuis 6.0 [latest update: #5847] on 13 June 2023 at 10:45:46 pm'!
'Description '!
!provides: 'Dyna' 1 21!
!requires: 'UI-Panel' 1 74 nil!
!requires: 'UI-Mold' 1 10 nil!
SystemOrganization addCategory: 'Dyna'!
SystemOrganization addCategory: 'Dyna-Core'!


!classDefinition: #DyBAgenda category: 'Dyna-Core'!
Object subclass: #DyBAgenda
	instanceVariableNames: 'start end daysOff assignments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBAgenda class' category: 'Dyna-Core'!
DyBAgenda class
	instanceVariableNames: ''!

!classDefinition: #DyBAssignment category: 'Dyna-Core'!
Object subclass: #DyBAssignment
	instanceVariableNames: 'date timeSlot task'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBAssignment class' category: 'Dyna-Core'!
DyBAssignment class
	instanceVariableNames: ''!

!classDefinition: #DyBCourse category: 'Dyna-Core'!
Object subclass: #DyBCourse
	instanceVariableNames: 'subject color teacher courseHours binder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBCourse class' category: 'Dyna-Core'!
DyBCourse class
	instanceVariableNames: ''!

!classDefinition: #DyBCourseHour category: 'Dyna-Core'!
Object subclass: #DyBCourseHour
	instanceVariableNames: 'room dayOfWeek timeSlots'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBCourseHour class' category: 'Dyna-Core'!
DyBCourseHour class
	instanceVariableNames: ''!

!classDefinition: #DyBModel category: 'Dyna-Core'!
Object subclass: #DyBModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBModel class' category: 'Dyna-Core'!
DyBModel class
	instanceVariableNames: ''!

!classDefinition: #DyBApp category: 'Dyna-Core'!
DyBModel subclass: #DyBApp
	instanceVariableNames: 'user schools agenda'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBApp class' category: 'Dyna-Core'!
DyBApp class
	instanceVariableNames: ''!

!classDefinition: #DyBClassGroup category: 'Dyna-Core'!
DyBModel subclass: #DyBClassGroup
	instanceVariableNames: 'number headTeacher students courses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBClassGroup class' category: 'Dyna-Core'!
DyBClassGroup class
	instanceVariableNames: ''!

!classDefinition: #DyBPerson category: 'Dyna-Core'!
DyBModel subclass: #DyBPerson
	instanceVariableNames: 'lastName firstName email'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBPerson class' category: 'Dyna-Core'!
DyBPerson class
	instanceVariableNames: ''!

!classDefinition: #DyBStudent category: 'Dyna-Core'!
DyBPerson subclass: #DyBStudent
	instanceVariableNames: 'classGroup'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBStudent class' category: 'Dyna-Core'!
DyBStudent class
	instanceVariableNames: ''!

!classDefinition: #DyBTeacher category: 'Dyna-Core'!
DyBPerson subclass: #DyBTeacher
	instanceVariableNames: 'classGroups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBTeacher class' category: 'Dyna-Core'!
DyBTeacher class
	instanceVariableNames: ''!

!classDefinition: #DyBSchool category: 'Dyna-Core'!
DyBModel subclass: #DyBSchool
	instanceVariableNames: 'name phone email timeSlots subjects classGroups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBSchool class' category: 'Dyna-Core'!
DyBSchool class
	instanceVariableNames: ''!

!classDefinition: #DyBTimeSlot category: 'Dyna-Core'!
Object subclass: #DyBTimeSlot
	instanceVariableNames: 'name startTime endTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBTimeSlot class' category: 'Dyna-Core'!
DyBTimeSlot class
	instanceVariableNames: ''!

!classDefinition: #DyBinder category: 'Dyna-Core'!
Object subclass: #DyBinder
	instanceVariableNames: 'topics last resources'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBinder class' category: 'Dyna-Core'!
DyBinder class
	instanceVariableNames: ''!

!classDefinition: #DyTopic category: 'Dyna-Core'!
Object subclass: #DyTopic
	instanceVariableNames: 'title color documents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyTopic class' category: 'Dyna-Core'!
DyTopic class
	instanceVariableNames: ''!


!DyBAgenda commentStamp: '<historical>' prior: 0!
The place to record teacher/student assignments or other events. It follows the user times slots as described in its related school instances
!

!DyBCourse commentStamp: '<historical>' prior: 0!
I describe a course of a teacher or a course attended by a student:
- subject: the taught topic (Math, History,...)
- color: distinctive color of the course
- courseHours: a collection of course hour describing the teaching period
- binder: a holder of the pedagogical documents!

!DyBCourseHour commentStamp: '<historical>' prior: 0!
Describes one or more contiguous teaching periods.

timeSlots := ListMultiModel with: aSchool timeSlots :: selectedIndexes: #()!

!DyBApp commentStamp: '<historical>' prior: 0!
- user: a teacher or student 
- schools: collection of schools the student is enrolled in or the teacher teaches in
- agenda of the user!

!DyBClassGroup commentStamp: '<historical>' prior: 0!
It describes a class: its number, the list of its students, taught courses, etc.
!

!DyBStudent commentStamp: '<historical>' prior: 0!
- classGroup: the class the student belong to!

!DyBTeacher commentStamp: '<historical>' prior: 0!
- classGroups: the classes the teacher teaches!

!DyBSchool commentStamp: '<historical>' prior: 0!
Description of the user's educational institutions. Possibly several per user.
!

!DyBTimeSlot commentStamp: '<historical>' prior: 0!
Describe the organization of the teaching periods in a school. There are generally 10 time slots per school.
Example of a time slot: P2, 9:25am, 10:10am!

!DyBinder commentStamp: '<historical>' prior: 0!
A binder contains the pedagogical materials related to a given course. 
!

!DyTopic commentStamp: '<historical>' prior: 0!
Pedagogical document grouped in one topic.!

!DyBAgenda methodsFor: 'initialization' stamp: 'hlsf 5/23/2023 20:46:38'!
initialize
	super initialize.
	assignments := OrderedCollection new! !

!DyBCourse methodsFor: 'initialization' stamp: 'hlsf 5/23/2023 20:59:24'!
initialize
	super initialize.
	courseHours := OrderedCollection new! !

!DyBModel methodsFor: 'ui-collection' stamp: 'hlsf 6/4/2023 17:55:10'!
editorsFor: aCollection ofType: classModel labelled: pluralLabel named: individualLabel
" A decorated editor to edit a collection of models "
	| listMorph quickButtons decoratedModel |
	listMorph := PluggableListMorph 
		model: (ListModel with: aCollection )		
		listGetter: #list 		indexGetter: #listIndex indexSetter: #listIndex:.
	decoratedModel := DecoratedPane open: listMorph label: pluralLabel .
	quickButtons := Array new: 3.
	quickButtons at:1 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickAdd: 
		actionArgument: (Array with: classModel with: decoratedModel with: listMorph)
		label: nil ::
		icon: Theme current listAddIcon;
		setBalloonText: ('Add a new {1}' translated format: {individualLabel});
		yourself).
	quickButtons at:2 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickEdit: 
		actionArgument: (Array with: decoratedModel with: listMorph)
		label: nil ::
		icon: Theme current textEditorIcon;
		setBalloonText: ('Edit the selected {1}' translated format: {individualLabel});
		yourself).
	quickButtons at:3 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickDelete: 
		actionArgument: (Array with: decoratedModel with: listMorph)
		label: nil ::
		icon: Theme current deleteIcon ;
		setBalloonText: ('Delete the selected {1}' translated format: {individualLabel});
		yourself).	
	decoratedModel quickButtons: quickButtons.
	^ decoratedModel! !

!DyBModel methodsFor: 'ui-collection' stamp: 'hlsf 6/4/2023 14:13:27'!
quickAdd: args
" args is a collection of object to operate the behavior of the quick button, in the following order:
1. the class of the object to instantiate
3. the decorated pane
4. the listMorph
"
 | objectClass decorator listModel listMorph newObject objectMold objectPane quickButtons |
	objectClass := args first.
	decorator := args second.
	listMorph := args third .
	listModel := listMorph model.
	quickButtons := decorator quickButtons.
	newObject := objectClass new.
	objectMold := newObject mold.
	objectPane := objectMold newPane.
	objectPane layoutSpec: LayoutSpec useAll.
	objectPane 
		actionOnAccept: [
			objectMold validate.
			objectMold isValid ifTrue: [
				objectMold save.
				listModel list add: newObject .
				decorator replaceSubmorph: objectPane by: listMorph.
				quickButtons submorphsDo: #lockUnlockMorph.
				listModel changed: #list]					
			];
		actionOnCancel: [
			decorator replaceSubmorph: objectPane by: listMorph.
			quickButtons submorphsDo: #lockUnlockMorph]; 
		buildMorphicWindow.
	decorator replaceSubmorph: listMorph by: objectPane .
	quickButtons submorphsDo: #lockUnlockMorph! !

!DyBModel methodsFor: 'ui-collection' stamp: 'hlsf 6/4/2023 14:13:33'!
quickDelete: args
" args is a collection of object to operate the behavior of the quick button, in the following order:
1. the decorated pane
2. the listMorph
"
 | decorator listModel listMorph objectPane text quickButtons |
	decorator := args first .
	listMorph := args second .
	listModel := listMorph model.
	listModel listIndex isZero ifTrue: [^ self]. "no selected item"
	quickButtons := decorator quickButtons.
	text := TextParagraphMorph contents: ('Are you sure to delete 	"{1}" ?' format: {listModel selectedItem}) :: borderWidth: 0; color: Color transparent.
	objectPane := nil.
	objectPane := PluggablePane open: [text] view: #value accept:[
		listModel list remove: listModel selectedItem.
		decorator replaceSubmorph: objectPane by: listMorph.
		quickButtons submorphsDo: #lockUnlockMorph.
		listModel changed: #list]				.
	objectPane
		actionOnCancel: [
			decorator replaceSubmorph: objectPane by: listMorph.
			quickButtons submorphsDo: #lockUnlockMorph]; 
		buildMorphicWindow.
	objectPane layoutSpec: LayoutSpec useAll.
	decorator replaceSubmorph: listMorph by: objectPane .
	quickButtons submorphsDo: #lockUnlockMorph! !

!DyBModel methodsFor: 'ui-collection' stamp: 'hlsf 6/4/2023 14:13:36'!
quickEdit: args
" args is a collection of object to operate the behavior of the quick button, in the following order:
1. the decorated pane
2. the listMorph
"
 | decorator listModel listMorph objectMold objectPane quickButtons |
	decorator := args first .
	listMorph := args second .
	listModel := listMorph model.
	listModel listIndex isZero ifTrue: [^ self]. "no selected item"
	quickButtons := decorator quickButtons.
	objectMold := listModel selectedItem mold.
	objectPane := objectMold newPane.
	objectPane layoutSpec: LayoutSpec useAll.
	objectPane 
		actionOnAccept: [
			objectMold validate.
			objectMold isValid ifTrue: [
				objectMold save.
				decorator replaceSubmorph: objectPane by: listMorph.
				quickButtons submorphsDo: #lockUnlockMorph.
				listModel changed: #list]					
			];
		actionOnCancel: [
			decorator replaceSubmorph: objectPane by: listMorph.
			quickButtons submorphsDo: #lockUnlockMorph]; 
		buildMorphicWindow.
	decorator replaceSubmorph: listMorph by: objectPane .
	quickButtons submorphsDo: #lockUnlockMorph! !

!DyBModel methodsFor: 'ui-collection' stamp: 'hlsf 6/13/2023 21:07:58'!
viewsFor: aCollection browse: canBeBrowsed
" Present a column of text views for each item of the collection. 
Each view may triggers the event #browseTo when clicked"

	| column |
	column := LayoutMorph newColumn ::
		layoutSpec: LayoutSpec useAll;
		color: Color transparent;
		yourself.
	aCollection do: [:aModel | 		
		column 
			addMorph: 	(self viewFor: aModel browse: canBeBrowsed )		 
			layoutSpec: (LayoutSpec new offAxisEdgeWeight: #columnLeft) ].
	^ column! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/4/2023 14:33:11'!
editor
" 
The editor presents in fields the attributes this model can edit. Only attributes defined in
the model are edited. An editor comes with an Accept and Cancel buttons.
The Accept activation does validation prior saving the updated fields
"
	self subclassResponsibility ! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:23:19'!
paneFor: anObject label: aTitle 
	^self paneFor: anObject label: aTitle browse: true! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:15:49'!
paneFor: anObject label: aTitle browse: canBeBrowsed
" Present the view of an object in a decorated pane with a title "
	| viewBuilderMessage attributeView |
	viewBuilderMessage := anObject isCollection 
		ifTrue:  [#viewsFor:browse:]
		ifFalse: [#viewFor:browse:].
	attributeView := self perform: viewBuilderMessage with: anObject with: canBeBrowsed.
	^ DecoratedPane open: attributeView label: aTitle ! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/6/2023 22:07:20'!
plugView: aMorph
" Add an Edit button to this contents "
	| viewer |
	viewer := nil.
	viewer := PluggablePane 
		open: [aMorph] 
		view: #value 
		accept: 	["Edit me" viewer owner replaceSubmorph: viewer by: self editor			]  ::
		acceptLabel: 'Edit' translated;
		buildMorphicWindow ;
		layoutSpec: LayoutSpec useAll;
		yourself.
	^ viewer ! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:07:25'!
viewFor: anAttribute 
" Present a text view of an attribute. Trigger the event #browseTo when view clicked"
	^ self viewFor: anAttribute browse: true! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:06:40'!
viewFor: anAttribute browse: canBeBrowsed
" Present a text view of an attribute. May trigger the event #browseTo when clicked"
	| aTextView |
	aTextView := TextParagraphMorph contents: anAttribute printString :: 
		color: Color transparent;
		borderWidth: 0;
		yourself.
	canBeBrowsed ifTrue: [
		aTextView 
			setBalloonText: 
				('Click to browse "{1}".' translated format: {anAttribute printString});			
			setProperty: #'handlesMouseDown:' 					toValue: [ :ignored | true ];
			setProperty: #'mouseButton1Up:localPosition:'
			toValue: [ :event :position | 	self triggerEvent: #browseTo with: anAttribute]].
	^ aTextView ! !

!DyBModel methodsFor: 'ui' stamp: 'hlsf 6/4/2023 14:34:08'!
viewer
" 
The viewer presents the attributes of the model in text form. When an attribute is defined elsewhere,
its presentation in the viewer is activable by mouse click to browser to its viewer.
A viewer always comes with an Edit button to present the editor of the model.
"

	self subclassResponsibility ! !

!DyBApp methodsFor: 'initialization' stamp: 'hlsf 5/29/2023 14:37:11'!
initialize
	super initialize.
	schools := OrderedCollection new.
	user := DyBTeacher new.! !

!DyBApp methodsFor: 'ui' stamp: 'hlsf 6/4/2023 18:27:06'!
editor
	^ LayoutMorph newColumn
		addMorph: (DecoratedPane open: user mold newPane label: 'Owner' translated);
		addMorph: (self 
			editorsFor: schools 
			ofType: DyBSchool 
			labelled: 'Schools' translated 
			named: 'school' translated);
		yourself! !

!DyBApp methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:25:55'!
viewer
	| column |
	column := LayoutMorph newColumn.
	column 	addMorph: (self paneFor: user label: 'Owner' translated);
		addMorph: (self paneFor: schools label: 'Schools' translated).
	^ self plugView: column! !

!DyBClassGroup methodsFor: 'ui' stamp: 'hlsf 6/4/2023 18:29:54'!
editor
	^ LayoutMorph newColumn
		addMorph: (DecoratedPane open: self mold newPane label: '');
		addMorph: (DecoratedPane 
			open: headTeacher mold newPane label: 'Head teacher' translated);
		addMorph: (self 
			editorsFor: courses 
			ofType: DyBCourse 
			labelled: 'Lessons' translated 
			named: 'lesson' translated);
		addMorph: (self 
			editorsFor: students 
			ofType: DyBStudent 
			labelled: 'Students' translated 
			named: 'student' translated);
		yourself! !

!DyBClassGroup methodsFor: 'ui' stamp: 'hlsf 6/4/2023 18:12:37'!
mold
	| mold |
	mold := Mold new.
	mold stringField
		label: 'Number' translated;
		on: #number of: self;
		beRequired.
"Head teacher - aPerson
students - collection of DyBStudent
courses - collection of DyBCourse
"

	^ mold! !

!DyBClassGroup methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:20:47'!
viewer
	| column |
	column := LayoutMorph newColumn.
	column 	addMorph: (self paneFor: headTeacher label: 'Head teacher' translated);	
		addMorph: (self paneFor: courses label: 'Lessons' translated);
		addMorph: (self paneFor: students label: 'Students' translated).
	^ self plugView: column! !

!DyBClassGroup methodsFor: 'accessing' stamp: 'hlsf 6/4/2023 18:12:55'!
number
	^number! !

!DyBClassGroup methodsFor: 'accessing' stamp: 'hlsf 6/4/2023 18:13:29'!
number: aUnicodeString 
	number := aUnicodeString! !

!DyBClassGroup methodsFor: 'printing' stamp: 'hlsf 6/4/2023 18:15:58'!
printOn: str
	number ifNil: [str nextPutAll: 'Unknown class' translated]
		ifNotNil: [	str nextPutAll: number ]! !

!DyBClassGroup methodsFor: 'initialization' stamp: 'hlsf 6/4/2023 18:24:37'!
initialize
	super initialize.
	headTeacher := DyBTeacher new.
	courses := OrderedCollection new.
	students := OrderedCollection new! !

!DyBPerson methodsFor: 'testing' stamp: 'hlsf 5/23/2023 20:18:30'!
isStudent
	^ false! !

!DyBPerson methodsFor: 'testing' stamp: 'hlsf 5/23/2023 20:18:25'!
isTeacher
	^ false! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:36:00'!
email
	^ email! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:35:49'!
email: aString
	email := 	aString ! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:35:38'!
firstName
	^ firstName! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:35:31'!
firstName: aString
	firstName := 	aString ! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:35:12'!
lastName
	^ lastName ! !

!DyBPerson methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:35:24'!
lastName: aString
	lastName := 	aString ! !

!DyBPerson methodsFor: 'printing' stamp: 'hlsf 6/4/2023 15:58:45'!
printOn: str
	(firstName isNil or: [lastName isNil])
		ifTrue: [str nextPutAll: 'Unknown person' translated]
		ifFalse: [ 
			str nextPutAll: firstName;
			space;
			nextPutAll: lastName]! !

!DyBPerson methodsFor: 'ui' stamp: 'hlsf 5/29/2023 16:55:56'!
mold
	| mold |
	mold := Mold new.
	mold stringField
		label: 'Firstname' translated;
		on: #firstName of: self;
		beRequired.
	mold stringField
		label: 'Lastname' translated;
		on: #lastName of: self;
		beRequired.
	mold stringField
		label: 'Email' translated;
		on: #email of: self;
		beRequired.
	^ mold! !

!DyBStudent methodsFor: 'testing' stamp: 'hlsf 5/23/2023 20:18:38'!
isStudent
	^ true! !

!DyBTeacher methodsFor: 'ui' stamp: 'hlsf 6/4/2023 18:26:31'!
editor
	^ LayoutMorph newColumn
		addMorph: (DecoratedPane open: self mold newPane label: 'Teacher' translated);
		addMorph: (self 
			editorsFor: classGroups 
			ofType: DyBClassGroup 
			labelled: 'Class groups' translated 
			named: 'class' translated);
		yourself! !

!DyBTeacher methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:27:26'!
viewer
	| column |
	column := LayoutMorph newColumn.
	column 	addMorph: (self paneFor: classGroups label: 'Classes taught' translated).
	^ self plugView: column! !

!DyBTeacher methodsFor: 'testing' stamp: 'hlsf 5/23/2023 20:18:52'!
isTeacher
	^ true! !

!DyBTeacher methodsFor: 'as yet unclassified' stamp: 'hlsf 6/4/2023 18:08:32'!
initialize
	super initialize.
	classGroups := OrderedCollection new! !

!DyBSchool methodsFor: 'initialization' stamp: 'hlsf 5/23/2023 20:44:06'!
initialize
	super initialize .
	timeSlots := OrderedCollection new.
	subjects := OrderedCollection new.
	classGroups := OrderedCollection new! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:55:35'!
email
	^ email! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:55:30'!
email: aString
	email := aString ! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:55:08'!
phone
	^ phone! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:55:19'!
phone: aString
	phone := aString ! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:54:57'!
schoolName
	^ name! !

!DyBSchool methodsFor: 'accessing' stamp: 'hlsf 5/23/2023 20:54:48'!
schoolName: aString
	name := aString ! !

!DyBSchool methodsFor: 'ui' stamp: 'hlsf 6/13/2023 22:21:39'!
editor
	| mold |
	mold := self mold.
	mold when: #edited send: #triggerEvent: to: self with: #edited.
	^ LayoutMorph newColumn
		addMorph: (DecoratedPane open: mold newPane label: 'Information' translated);
		addMorph: (self 
			editorsFor: timeSlots 
			ofType: DyBTimeSlot 
			labelled: 'Time slots' translated 
			named: 'time slot' translated);
		addMorph: (self 
			editorsFor: classGroups 
			ofType: DyBClassGroup 
			labelled: 'Classes' translated 
			named: 'class' translated);
		addMorph: (self 
			editorsFor: subjects 
			ofType: String 
			labelled: 'Taught subjects' translated 
			named: 'subject' translated);
		yourself! !

!DyBSchool methodsFor: 'ui' stamp: 'hlsf 5/29/2023 16:55:51'!
mold
	| mold |
	mold := Mold new.
	mold stringField
		label: 'School name' translated;
		on: #schoolName of: self;
		beRequired.
	mold stringField
		label: 'Phone' translated;
		on: #phone of: self.
	mold stringField
		label: 'Email' translated;
		on: #email of: self.
	^ mold! !

!DyBSchool methodsFor: 'ui' stamp: 'hlsf 6/13/2023 21:23:41'!
viewer
	| column |
	column := LayoutMorph newColumn.
	column 	
		addMorph: (self paneFor: timeSlots label: 'Time slots' translated);
		addMorph: (self paneFor: subjects label: 'Taught subjects' translated);
		addMorph: (self paneFor: classGroups label: 'Classes' translated).
	^ self plugView: column! !

!DyBSchool methodsFor: 'printing' stamp: 'hlsf 6/1/2023 19:52:41'!
printOn: str
	name ifNil: [str nextPutAll: 'Unknown school' translated] 
		ifNotNil: [	str nextPutAll: name]! !

!DyBTimeSlot methodsFor: 'as yet unclassified' stamp: 'hlsf 5/22/2023 20:08:23'!
mold
	| mold start |
	mold := Mold new.
	mold stringField
		label: 'Name' translated;
		on: #slotName of: self;
		beRequired.
	(start := mold timeField)
		label: 'Start time' translated;
		example: '8:35';
		on: #start of: self;
		beRequired.
	mold timeField 
		label: 'End time' translated;
		on: #end of: self;
		addCondition: [:input :value | input isEmptyOrNil or: [value > start value ] ]
			labeled: 'End time can''t preced start time.' translated.
	^ mold
	! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:58:55'!
end
	^ endTime! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:01:48'!
end: aTime
	endTime := aTime! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:58:11'!
slotName
	^ name! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:02:10'!
slotName: aString
	name := 	aString ! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 19:56:55'!
start
	^ startTime ! !

!DyBTimeSlot methodsFor: 'accessing' stamp: 'hlsf 5/22/2023 20:01:59'!
start: aTime
	startTime := aTime ! !

!DyBTimeSlot methodsFor: 'printing' stamp: 'hlsf 5/22/2023 22:04:28'!
printOn: aStream
	name ifNil: [ super printOn: aStream ]
		ifNotNil: [	
			aStream nextPutAll: name;
				space;
				nextPutAll: startTime hhmm24 ;
				nextPut: $-;
				nextPutAll: endTime hhmm24 ]! !

!String methodsFor: '*Dyna' stamp: 'hlsf 6/12/2023 22:29:16'!
mold
	self shouldBeImplemented.! !
