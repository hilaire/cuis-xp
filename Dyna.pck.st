'From Cuis 6.0 [latest update: #5836] on 1 June 2023 at 10:44:42 pm'!
'Description '!
!provides: 'Dyna' 1 11!
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

!classDefinition: #DyBApp category: 'Dyna-Core'!
Object subclass: #DyBApp
	instanceVariableNames: 'user schools agenda'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBApp class' category: 'Dyna-Core'!
DyBApp class
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

!classDefinition: #DyBClassGroup category: 'Dyna-Core'!
Object subclass: #DyBClassGroup
	instanceVariableNames: 'number headTeacher students courses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Dyna-Core'!
!classDefinition: 'DyBClassGroup class' category: 'Dyna-Core'!
DyBClassGroup class
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

!classDefinition: #DyBPerson category: 'Dyna-Core'!
Object subclass: #DyBPerson
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
Object subclass: #DyBSchool
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

!DyBApp commentStamp: '<historical>' prior: 0!
- user: a teacher or student 
- schools: collection of schools the student is enrolled in or the teacher teaches in
- agenda of the user!

!DyBClassGroup commentStamp: '<historical>' prior: 0!
It describes a class: its number, the list of its students, taught courses, etc.
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

!DyBApp methodsFor: 'initialization' stamp: 'hlsf 5/29/2023 14:37:11'!
initialize
	super initialize.
	schools := OrderedCollection new.
	user := DyBTeacher new.! !

!DyBApp methodsFor: 'ui' stamp: 'hlsf 5/30/2023 21:29:37'!
editor
	| pane decoratedSchool listMorph quickButtons |
	listMorph := PluggableListMorph 
		model: (ListModel with: schools)		
		listGetter: #list 		indexGetter: #listIndex indexSetter: #listIndex:.
	decoratedSchool := DecoratedPane open: listMorph label: 'Schools' translated.
	pane := LayoutMorph newColumn.
	pane addMorph: (DecoratedPane open: user mold newPane label: 'User' translated).
	quickButtons := Array new: 3.
	quickButtons at:1 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickAdd: 
		actionArgument: (Array with: DyBSchool with: decoratedSchool with: listMorph)
		label: nil ::
		icon: Theme current listAddIcon;
		setBalloonText: 'Add a new school' translated;
		yourself).
	quickButtons at:2 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickEdit: 
		actionArgument: (Array with: decoratedSchool with: listMorph)
		label: nil ::
		icon: Theme current textEditorIcon;
		setBalloonText: 'Edit the selected school' translated;
		yourself).
	quickButtons at:3 put: (PluggableButtonMorph 
		model: self 		stateGetter: nil stateArgument: nil 	action: #quickDelete: 
		actionArgument: (Array with: decoratedSchool with: listMorph)
		label: nil ::
		icon: Theme current deleteIcon ;
		setBalloonText: 'Delete the selected school' translated;
		yourself).	
	decoratedSchool quickButtons: quickButtons.
	pane addMorph: decoratedSchool.
	^ pane! !

!DyBApp methodsFor: 'ui' stamp: 'hlsf 5/30/2023 21:27:25'!
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

!DyBApp methodsFor: 'ui' stamp: 'hlsf 5/30/2023 21:32:56'!
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

!DyBApp methodsFor: 'ui' stamp: 'hlsf 5/30/2023 21:13:05'!
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

!DyBApp methodsFor: 'ui' stamp: 'hlsf 6/1/2023 22:19:07'!
view: anAttribute in: viewer
	^ TextParagraphMorph contents: anAttribute printString :: 
		color: Color transparent;
		setBalloonText: ('Click to browse "{1}".' translated format: {anAttribute printString});
		borderWidth: 0;
		setProperty: #'handlesMouseDown:' 		toValue: [ :ignored | true ];
		setProperty: #'mouseButton1Up:localPosition:'
			toValue: [ :event :position | | attributeMold attribueEditor |
				attributeMold := anAttribute mold.
				attribueEditor := attributeMold newPane.
				attribueEditor 
					actionOnAccept: [
						attributeMold validate.
						attributeMold isValid ifTrue: ["attribute edited, present new viewer of self "
							attributeMold save.
							attribueEditor owner replaceSubmorph: attribueEditor by: self viewer]		 ]			;
					actionOnCancel: [" attribute edition cancelled, present the former viewer "
						attribueEditor owner replaceSubmorph: attribueEditor by: viewer]; 
					buildMorphicWindow.
				viewer owner replaceSubmorph: viewer by: attribueEditor ];
		yourself.
! !

!DyBApp methodsFor: 'ui' stamp: 'hlsf 6/1/2023 22:21:50'!
viewer
	| viewer column |
	viewer := LayoutMorph newColumn.
	" User text "
	viewer 	addMorph: (DecoratedPane open: (self view: user in: viewer) label: 'User' translated).
	" School texts "
	column := LayoutMorph newColumn ::
		color: Color transparent;
		yourself.
	schools do: [:aSchool | 		
		column 
			addMorph: 	(self view: aSchool in: viewer)		 
			layoutSpec: (LayoutSpec new offAxisEdgeWeight: #columnLeft) ].
	viewer addMorph: (DecoratedPane open: column label: 'Schools' translated).	
	^ viewer! !

!DyBCourse methodsFor: 'initialization' stamp: 'hlsf 5/23/2023 20:59:24'!
initialize
	super initialize.
	courseHours := OrderedCollection new! !

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

!DyBPerson methodsFor: 'printing' stamp: 'hlsf 6/1/2023 18:53:33'!
printOn: str
	(firstName isNil or: [lastName isNil])
		ifTrue: [str nextPutAll: 'Unknown user' translated]
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

!DyBTeacher methodsFor: 'as yet unclassified' stamp: 'hlsf 5/23/2023 20:18:52'!
isTeacher
	^ true! !

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
