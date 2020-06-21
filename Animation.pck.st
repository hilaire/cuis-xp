'From Cuis 5.0 [latest update: #4228] on 21 June 2020 at 5:33:41 pm'!
'Description '!
!provides: 'Animation' 1 4!
SystemOrganization addCategory: #Animation!
SystemOrganization addCategory: #'Animation-Collections-Atomic'!


!classDefinition: #AnimatedProperty category: #Animation!
Object subclass: #AnimatedProperty
	instanceVariableNames: 'target selector values startTime duration delay pause easing interpolator then'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Animation'!
!classDefinition: 'AnimatedProperty class' category: #Animation!
AnimatedProperty class
	instanceVariableNames: ''!

!classDefinition: #AnimationSupervisor category: #Animation!
Object subclass: #AnimationSupervisor
	instanceVariableNames: ''
	classVariableNames: 'Animators'
	poolDictionaries: ''
	category: 'Animation'!
!classDefinition: 'AnimationSupervisor class' category: #Animation!
AnimationSupervisor class
	instanceVariableNames: ''!

!classDefinition: #DelayedBlock category: #Animation!
Object subclass: #DelayedBlock
	instanceVariableNames: 'block startTime duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Animation'!
!classDefinition: 'DelayedBlock class' category: #Animation!
DelayedBlock class
	instanceVariableNames: ''!

!classDefinition: #OutputEventFetcher category: #Animation!
Object subclass: #OutputEventFetcher
	instanceVariableNames: 'animationHandlers renderHandlers timestamp deferred'
	classVariableNames: 'Default'
	poolDictionaries: ''
	category: 'Animation'!
!classDefinition: 'OutputEventFetcher class' category: #Animation!
OutputEventFetcher class
	instanceVariableNames: ''!

!classDefinition: #AtomicCollection category: #'Animation-Collections-Atomic'!
Object subclass: #AtomicCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Animation-Collections-Atomic'!
!classDefinition: 'AtomicCollection class' category: #'Animation-Collections-Atomic'!
AtomicCollection class
	instanceVariableNames: ''!

!classDefinition: #WaitfreeQueue category: #'Animation-Collections-Atomic'!
AtomicCollection subclass: #WaitfreeQueue
	instanceVariableNames: 'tail dummy'
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Animation-Collections-Atomic'!
!classDefinition: 'WaitfreeQueue class' category: #'Animation-Collections-Atomic'!
WaitfreeQueue class
	instanceVariableNames: ''!

!classDefinition: #AtomicQueueItem category: #'Animation-Collections-Atomic'!
Object subclass: #AtomicQueueItem
	instanceVariableNames: 'next object'
	classVariableNames: ''
	poolDictionaries: 'nil'
	category: 'Animation-Collections-Atomic'!
!classDefinition: 'AtomicQueueItem class' category: #'Animation-Collections-Atomic'!
AtomicQueueItem class
	instanceVariableNames: ''!


!AnimatedProperty commentStamp: 'hlsf 6/21/2020 17:31:43' prior: 0!
I can animate any property from outside, repeatedly sending setter messages until target value is reached. The target type must support + and *Float operations. Depends on AnimationSupervisor to prevent concurrent updates on the same property.

- morph position: (100@100 during: 2 seconds)

I can animate any property from outside, repeatedly sending setter messages until target value is reached. The target type must support + and *Float operations. Depends on AnimationSupervisor to prevent concurrent updates on the same property.

| morph |
morph := SystemWindow new openInWorld.
morph color: (Color black during: 5 seconds);
	morphExtent: (300@200 during: 5 seconds as: AnimatedProperty circOut);
	morphPosition: (10@10 during: 5 seconds);
	label: ('Cuis Smalltalk' during: 2 seconds ).!

!AnimationSupervisor commentStamp: 'ThibaultRaffaillac 1/14/2017 17:15' prior: 0!
Just a class-side Set to ensure there is at most one animation running on any {object, selector} at any time.!

!DelayedBlock commentStamp: 'ThibaultRaffaillac 10/20/2016 10:08' prior: 0!
I execute a BlockClosure after a certain delay, using the same delay mechanism as animations for deterministic timely behaviour.

- [ Transcript show: 'foo' ] after: 2 seconds!

!OutputEventFetcher commentStamp: 'ThibaultRaffaillac 10/7/2016 14:55' prior: 0!
I am a simple implementation of Javascript's requestAnimationFrame, allowing event-driven output.

For compatibility with Morphic, the event dispatch is currently integrated as deferredUIMessage, but should eventually listen to VSync events from the VM.!

!AtomicCollection commentStamp: '' prior: 0!
I am just a base abstract class, containing common behavior for various queue types!

!WaitfreeQueue commentStamp: '' prior: 0!
This is a thread-safe implementation of a queue with wait-free operations. 
It is guaranteed that any message sent to my instance (like adding new item, or fetching item) will not block sender, nor enter a waiting loop.

The implementation is based on atomicity of simple assignment operations, which can't be interrupted in a middle,
i.e. two assignment statements in a row, like:

x _ y.
y _ z.

can't be interrupted by interpreter and can be seen as a single atomic operation.


This implementation fits best for case, when multiple threads populating queue, but only single thread fetching items from it.

In given implementation, inserting new items into queue can't block the sender and insertion operation always takes constant time (if we ignore the possible GC interference here).
For reading/polling operations queue using a lock mechanism, which indicating that queue currently in the middle of extraction, and therefore, if some thread obtained a lock upon the queue, other threads must wait till one that obtained the lock will finish its operation(s) and release the lock.
All operations which may block the sender will answer the default value(s) instead. 



Implementation Notes

As mentioned above WaitfreeQueue relies on the VM treating simple assignment operations as uninterruptable.  It also ensures that reader and writer processes can't modify the same variables at the same time.

The queue consists of a linked list of AtomicQueueItems.  Each item contains a pointer to the next item and the object which is the queue entry.

An item can be:

- "circular", meaning that the next item is itself.
- a "zombie", meaning that the object points back to the queue's dummy object (more below).

Writing processes create a new item and then use atomic access to get the old tail entry and update the queue's tail variable.  They then own the old tail entry and can update its next variable at any time.  Because the queue's tail variable is updated atomically, any number of writer processes can be adding items to the queue.

A reader process uses atomic access to the get first item and make the dummy item circular.  At this point the reader process owns the linked list and can modify any item except the last one (which will be circular).  Any other process attempting to read the queue will find the dummy object is circular and return nil - meaning the queue is either empty or locked.

If the reader process wants to return the object from the last item in the linked list (which may be owned by a writer process), it will retrieve the object and then mark the item as a zombie, i.e. set the item's object to the queue's dummy item.  The zombie item will then be removed by a later reader process when it is no longer last in the linked list.

Once the reader process has retrieved the object it sets the dummy item's next variable to the first item in the linked list, making the queue avilable again to other processes.!

!AtomicQueueItem commentStamp: '' prior: 0!
I am a queue item, used by atomic queues.
All my new instances are circular i.e. next = self!

!WaitfreeQueue methodsFor: 'printing'!
printOn: aStream

	aStream 
		nextPutAll: self class name;
		nextPutAll: ' with ';
		print: self size;
	 	nextPutAll: ' items' .! !

!AtomicQueueItem methodsFor: 'printing'!
printOn: aStream

	super printOn: aStream.
	aStream << '('.
	self isZombie ifTrue: 
		[ aStream << '<zombie>' ]
	ifFalse:
		[ object printOn: aStream ].
	self isCircular ifTrue: 
		[ aStream << ', Circular' ].
	aStream
		<< ')'! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 1/15/2017 11:40'!
delay: aDelay
	delay := aDelay! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 1/15/2017 11:27'!
easing: aBlock
	easing := aBlock isSymbol ifTrue: [ self perform: aBlock ] ifFalse: [ aBlock ]! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 1/15/2017 11:27'!
interpolator: aBlock
	interpolator := aBlock isSymbol ifTrue: [ self perform: aBlock ] ifFalse: [ aBlock ]! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 11/2/2016 09:53'!
selector
	^selector! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 10/22/2016 14:04'!
target
	^target! !

!AnimatedProperty methodsFor: 'accessing' stamp: 'ThibaultRaffaillac 1/15/2017 11:44'!
then: aBlock
	then := aBlock! !

!AnimatedProperty methodsFor: 'initialization' stamp: 'hlsf 6/21/2020 17:23:29'!
receiver: anObject selector: aSelector argument: to during: aDelay as: anEase
	| from |
	target := anObject.
	selector := aSelector.
	from := anObject perform: aSelector allButLast asSymbol.
	to isArray ifTrue: [ values := to copyWithFirst: from ]
		ifFalse: [ values := Array with: from with: to ].
	duration := aDelay.
	easing := anEase .
	interpolator := self proportional.
	self start.! !

!AnimatedProperty methodsFor: 'compatibility' stamp: 'ThibaultRaffaillac 2/6/2017 14:51'!
addedIn: aCanvas
	"do nothing"! !

!AnimatedProperty methodsFor: 'compatibility' stamp: 'ThibaultRaffaillac 2/6/2017 15:01'!
hasCompleted
	^AnimationSupervisor includes: self! !

!AnimatedProperty methodsFor: 'compatibility' stamp: 'ThibaultRaffaillac 2/6/2017 15:03'!
inView: aView
	aView addAnimation: self! !

!AnimatedProperty methodsFor: 'compatibility' stamp: 'ThibaultRaffaillac 2/6/2017 15:16'!
refresh
	"does nothing, actual refresh is system-wide"
	target signalUpdate! !

!AnimatedProperty methodsFor: 'comparing' stamp: 'ThibaultRaffaillac 11/2/2016 09:53'!
= anObject
	^target = anObject target and: selector = anObject selector! !

!AnimatedProperty methodsFor: 'comparing' stamp: 'ThibaultRaffaillac 11/2/2016 10:04'!
hash
	^target hash bitXor: selector hash! !

!AnimatedProperty methodsFor: 'interpolators' stamp: 'ThibaultRaffaillac 4/25/2017 20:00'!
proportional
	^[ :v :t |
		| i factor from to |
		i := v size - 1.
		factor := t * i.
		from := v last.
		[
			to := from.
			from := v at: i.
			(i := i - 1) > factor and: i > 0
		] whileTrue.
		factor := (factor - i) asFloat.
		(from * (1.0 - factor)) + (to * factor) as: from class
	]! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 11/2/2016 10:41'!
pause
	self pause: OutputEventFetcher default now! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 11/2/2016 11:59'!
pause: when
	pause := when - startTime.
	OutputEventFetcher default cancelAnimationFrame: self.! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 11/2/2016 09:45'!
start
	self start: OutputEventFetcher default now! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 1/14/2017 17:20'!
start: when
	pause ifNil: [
		startTime := when.
		AnimationSupervisor add: self.
	] ifNotNil: [
		startTime := when - pause.
		pause := nil.
	].
	OutputEventFetcher default requestAnimationFrame: self.! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 1/14/2017 17:22'!
stop
	AnimationSupervisor remove: self.
	pause := nil.
	OutputEventFetcher default cancelAnimationFrame: self.! !

!AnimatedProperty methodsFor: 'playing' stamp: 'ThibaultRaffaillac 4/25/2017 19:58'!
value: timestamp
	| diff t value |
	diff := timestamp - startTime.
	diff < duration ifTrue: [
		t := easing value: diff / duration.
		value := interpolator value: values value: t.
		target perform: selector with: value.
		OutputEventFetcher default requestAnimationFrame: self.
	] ifFalse: [
		AnimationSupervisor remove: self.
		target perform: selector with: values last.
		then value.
	].! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:20'!
backIn
	^[ :t | t * t * (2.70158 * t - 1.70158) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:25'!
backInOut
	^[ :t | | u |
		u := t - 1.0.
		t < 0.5 ifTrue: [ 2.0 * t * t * (7.189819 * t - 2.5949095) ]
			ifFalse: [ 2.0 * u * u * (7.189819 * u + 2.5949095) + 1.0 ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:28'!
backOut
	^[ :t | | u | u := t - 1.0. u * u * (2.70158 * u + 1.70158) + 1.0 ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:35'!
circIn
	^[ :t | 1.0 - (1.0 - (t * t)) sqrt ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:41'!
circInOut
	^[ :t | | u |
		u := 1.0 - t.
		t < 0.5 ifTrue: [ 0.5 * (1.0 - (1.0 - (4.0 * t * t)) sqrt) ]
			ifFalse: [ 0.5 * (1.0 + (1.0 - (4.0 * u * u)) sqrt) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:45'!
circOut
	^[ :t | | u | u := 1.0 - t. (1.0 - (u * u)) sqrt ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:52'!
cubicIn
	^[ :t | t * t * t ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:25:57'!
cubicInOut
	^[ :t | | u |
		u := 1.0 - t.
		t < 0.5 ifTrue: [ 4.0 * t * t * t ] ifFalse: [ 1.0 - (4.0 * u * u * u) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:02'!
cubicOut
	^[ :t | | u | u := 1.0 - t. 1.0 - (u * u * u) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:06'!
expIn
	^[ :t | 2.0 raisedTo: 10.0 * (t - 1.0) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:10'!
expInOut
	^[ :t |
		t < 0.5 ifTrue: [ 0.5 * (2 raisedTo: 20.0 * (t - 0.5)) ]
			ifFalse: [ 1.0 - (0.5 * (2 raisedTo: 20.0 * (0.5 - t))) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:14'!
expOut
	^[ :t | 1.0 - (2.0 raisedTo: t * -10.0) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:24'!
linear
	^[ :t | t ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:31'!
quadIn
	^[ :t | t * t ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:36'!
quadInOut
	^[ :t | | u |
		u := 1.0 - t.
		t < 0.5 ifTrue: [ 2.0 * t * t ] ifFalse: [ 1.0 - (2.0 * u * u) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:40'!
quadOut
	^[ :t | | u | u := 1.0 - t. 1.0 - (u * u) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:43'!
quartIn
	^[ :t | t * t * t * t ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:47'!
quartInOut
	^[ :t | | u |
		u := 1.0 - t.
		t < 0.5 ifTrue: [ 8.0 * t * t * t * t ] ifFalse: [ 1.0 - (8.0 * u * u * u * u) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:50'!
quartOut
	^[ :t | | u | u := 1.0 - t. 1.0 - (u * u * u * u) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:53'!
quintIn
	^[ :t | t * t * t * t * t ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:26:57'!
quintInOut
	^[ :t | | u |
		u := 1.0 - t.
		t < 0.5 ifTrue: [ 16.0 * t * t * t * t * t ] ifFalse: [ 1.0 - (16.0 * u * u * u * u * u) ]
	]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:27:00'!
quintOut
	^[ :t | | u | u := 1.0 - t. 1.0 - (u * u * u * u * u) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:27:03'!
sineIn
	^[ :t | 1.0 - (t * Float halfPi) cos ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:27:06'!
sineInOut
	^[ :t | 0.5 - ((t * Float pi) cos * 0.5) ]! !

!AnimatedProperty class methodsFor: 'easing' stamp: 'hlsf 6/21/2020 17:27:10'!
sineOut
	^[ :t | (t * Float halfPi) sin ]! !

!AnimationSupervisor class methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 1/14/2017 17:21'!
add: anim
	(Animators like: anim) ifNotNil: [ :prev | prev stop ].
	Animators add: anim.! !

!AnimationSupervisor class methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 2/6/2017 15:00'!
includes: anim
	^Animators includes: anim! !

!AnimationSupervisor class methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 1/14/2017 17:16'!
initialize
	Animators := Set new.! !

!AnimationSupervisor class methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 1/14/2017 17:22'!
remove: anim
	Animators remove: anim ifAbsent: []! !

!DelayedBlock methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 10:11'!
do: aBlock after: aDelay
	block := aBlock.
	duration := aDelay.
	self start.! !

!DelayedBlock methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 09:45'!
start
	self start: OutputEventFetcher default now! !

!DelayedBlock methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 10:11'!
start: when
	startTime := when.
	OutputEventFetcher default requestAnimationFrame: self.! !

!DelayedBlock methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 10:11'!
stop
	OutputEventFetcher default cancelAnimationFrame: self! !

!DelayedBlock methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 10:12'!
value: timestamp
	| diff |
	diff := timestamp - startTime.
	diff < duration ifTrue: [
		OutputEventFetcher default requestAnimationFrame: self.
	] ifFalse: [
		block value.
	]! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 09:43'!
cancelAnimationFrame: aHandler
	animationHandlers flushAllSuchThat: [ :h | h = aHandler ]! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 11/2/2016 09:43'!
cancelRenderFrame: aHandler
	renderHandlers flushAllSuchThat: [ :h | h = aHandler ]! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 10/12/2016 09:46'!
dispatch
	"Trigger all display handlers, synchronized with the same timestamp"
	deferred := false.
	timestamp := DateAndTime now.
	1 to: animationHandlers size do: [ :i | animationHandlers nextOrNil value: timestamp ].
	1 to: renderHandlers size do: [ :i | renderHandlers nextOrNil value: timestamp ].! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 10/12/2016 09:23'!
initialize
	timestamp := DateAndTime now.
	animationHandlers := WaitfreeQueue new.
	renderHandlers := WaitfreeQueue new.
	deferred := false.! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 10/12/2016 09:49'!
now
	"Should eventually be timestamp updated at each display event, for implicit sync"
	^DateAndTime now! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'hlsf 5/27/2020 12:14:24'!
requestAnimationFrame: aHandler
	animationHandlers nextPut: aHandler.
	deferred ifFalse: [ WorldState addDeferredUIMessage: [ self dispatch ]. deferred := true ].
! !

!OutputEventFetcher methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 10/12/2016 09:31'!
requestRenderFrame: aHandler
	renderHandlers nextPut: aHandler.
	deferred ifFalse: [ WorldState defer: [ self dispatch ]. deferred := true ].! !

!OutputEventFetcher class methodsFor: 'as yet unclassified' stamp: 'ThibaultRaffaillac 9/30/2016 20:43'!
default
	^Default ifNil: [ Default := self new ]! !

!AtomicCollection methodsFor: 'utilities'!
newItem
	"override in subclass, if you need to instantiate queue items of different class or initialize them in some specific way"
	^ AtomicQueueItem new! !

!AtomicCollection methodsFor: 'copying'!
copy
	^ self errorDontCopy! !

!AtomicCollection methodsFor: 'copying'!
deepCopy
	^ self errorDontCopy! !

!AtomicCollection methodsFor: 'copying'!
errorDontCopy
	"copying a structure, involved in concurrent operations is a bad idea"
	^ self error: 'Copying not available'! !

!AtomicCollection methodsFor: 'signaling'!
signalAddedNewItem
	"Optional, override in subclass(es) to signal that new item available in queue.
	Default implementation does nothing"! !

!AtomicCollection methodsFor: 'signaling'!
signalNoMoreItems
	"Optional, override in subclass(es) to signal that queue is currently empty.
	Default implementation does nothing"! !

!AtomicCollection methodsFor: 'signaling'!
waitForNewItems
	"Override in subclass. By default, yield current process.
	If you run more than one process, which popping items from queue,
	then there is no guarantee, that after wait, #next won't block the queue"
	^ self yield! !

!AtomicCollection methodsFor: 'yielding'!
yield
	"Yield the current process.
	Used internally by spin loops, once detected that 
	current process can't make any progress
	without some external event to happen"
	Processor yield! !

!AtomicCollection methodsFor: 'debug support'!
interrupt
	"simulate interrupt , for debugging purposes only"
	Processor yield! !

!WaitfreeQueue methodsFor: 'initialization'!
initialize
	dummy _ AtomicQueueItem new.
	dummy object: dummy.
	tail _ dummy.
! !

!WaitfreeQueue methodsFor: 'initialization'!
initializeWithAll: aCollection
	"Initialise the receiver with the supplied items (AtomicQueueItem).
	This method is not thread safe and should only be used for initialising the queue prior to normal operation (and is normally used only for testing)."

	dummy next: aCollection first.
	1 to: aCollection size - 1 do: [ :i |
		(aCollection at: i) next: (aCollection at: i+1) ].
	tail _ aCollection last.! !

!WaitfreeQueue methodsFor: 'private - accessing'!
dummy
	"Answer the dummy entry of the receiver.
	This is internal state and is only for automated unit testing"

	^dummy! !

!WaitfreeQueue methodsFor: 'private - accessing'!
tail
	"Answer the tail entry of the receiver.
	This is internal state and is only for automated unit testing"

	^tail! !

!WaitfreeQueue methodsFor: 'accessing'!
findFirst: aBlock
	"Note, this method only for backward compatibility. It duplicating the semantics of #nextOrNilSuchThat: completely.
	Use #nextOrNilSuchThat: instead "

	
	^ self nextOrNilSuchThat: aBlock
	! !

!WaitfreeQueue methodsFor: 'accessing'!
flush
	self flush: [:ea | ]! !

!WaitfreeQueue methodsFor: 'accessing'!
flush: aFlushBlock
	"Process all currently available items, passing each item to a flush block.
	If there is another process, which currently fetching items from queue, or queue is empty,
	return immediately"
	
	| item |

	item _ dummy makeCircular. 
	item == dummy ifTrue: [ ^ self  ].

	[ | object |
		object _ item object.
		object == dummy ifFalse: [
			[ aFlushBlock value: object ] ifCurtailed: [ 
				item object: dummy.
				dummy next: item next ].
		].
		item object: dummy.
		
		item isCircular ifTrue: [
			"this was the last one"
			dummy next: item.
			self signalNoMoreItems.
			^ self
			].
		item _ item next.
	] repeat.

	! !

!WaitfreeQueue methodsFor: 'accessing'!
flushAllSuchThat: aBlock
	"Remove from the queue all objects that satisfy aBlock.
	Note, the operation is no-op, if queue is currently in the middle of extraction by other process"
	
	| item first |

	(item _ dummy makeCircular) == dummy ifTrue: [ ^ self ]. 
	first _ item.
	
	[ | object |
		object _ item object.
		object == dummy ifFalse: [
			( [ aBlock value: object ] ifCurtailed: [ dummy next: first ] ) ifTrue: [
				item object: dummy.
			] ].
	
		item isCircular ifTrue: [
			"this was the last one"
			dummy next: first.
			^ self
			].
		item _ item next.
	] repeat.! !

!WaitfreeQueue methodsFor: 'accessing'!
isEmpty
	"Answer true if queue contains at least one element.
	Note, that answer is non-deterministic, because sender could be interrupted at any moment,
	means that even if message answers true, there is no any guarantees that consequent #nextXX messages could 
	retrieve item(s) from queue.
	
	Therefore use of this method is discouraged. 
	This test will work only if sender is the only process, which fetching items from queue. If there are two or more processes which 
	fetching items from queue, using this method makes no sense "
	
	| item |

	item _ dummy next.

	[  item object == dummy ] whileTrue: [
		item isCircular ifTrue: [ ^ true ].
		item _ item next.
	].
	
	^ false! !

!WaitfreeQueue methodsFor: 'accessing'!
itemCount
	"Answer the number of items in the queue including zombies. 
	If queue is currently in the middle of extraction by other process, give a (very) approximate answer.
	
	This method has a non-deterministic result due to the design of the concurrent shared queue. 
	"
	
	| item count |

	item _ dummy.

	count _ 0.
	[ item _ item next. item == dummy ifFalse: [ count := count + 1 ]. item isCircular ] whileFalse.

	count = 0 ifTrue: [
		"if queue is locked by other process, check the tail and give a (very) approximate answer."
		^ tail object == dummy ifTrue: [ 0 ] ifFalse: [ 1 ]
		].	

	^ count! !

!WaitfreeQueue methodsFor: 'accessing'!
nextIfNone: aBlock
	"Attempt to fetch the next item from queue. Evaluate a block if attempt is failed i.e. there is no items available or queue is locked by another process"
	
	| item result |

	(item _ dummy makeCircular) == dummy ifTrue: [
		"queue is either empty or currently locked by other feeder,
		just give a quick answer that item not found"
		 ^ aBlock value  ].

	[ (result _ item object) == dummy ] whileTrue: [
		item isCircular ifTrue: [ 
			self signalNoMoreItems. 
			dummy next: item. ^ aBlock value ].
		item _ item next.
	].
	
	item object: dummy.

	dummy next: item next.
	^ result
! !

!WaitfreeQueue methodsFor: 'accessing'!
nextOrNil
	"Fetch next item from queue, or nil if queue is either empty or in the middle of extraction by other process.
	If queue can contain a nil as element, use #nextIfNone: instead "
	^ self nextIfNone: nil! !

!WaitfreeQueue methodsFor: 'accessing'!
nextOrNilSuchThat: aBlock
	"Fetch an object from queue that satisfies aBlock, skipping (but not removing) any intermediate objects.
	If no object has been found, answer <nil> and leave me intact.
	
	NOTA BENE:  aBlock can contain a non-local return (^).
	Found item is removed from queue.

	If queue currently in the middle of extraction by other process, don't wait and return <nil> immediately"
	
	| item first previous object |

	(first _ dummy makeCircular) == dummy  ifTrue: [ ^ nil ]. 

	"Remove any zombie objects from the start of the list"
	[ (object _ first object) == dummy ] whileTrue: [
		first isCircular ifTrue: [ 
			self signalNoMoreItems. 
			dummy next: first. ^ nil ].
		first _ first next.
	].

	previous _ nil.
	item _ first.
	"Iterate over the list searching for the requested entry and removing zombies"
	[
		object _ item object.
		object == dummy ifTrue: [ 
			"Remove the object unless it is the last.
			This can't happen on the first iteration, so no need to check previous"
			item isCircular ifFalse: [ 
				previous next: item next ] ]
		ifFalse: [
			( [ aBlock value: object ] ifCurtailed: [ dummy next: first ] ) ifTrue: [
				item object: dummy.
				previous ifNotNil: [ 
					previous next: item next.
					dummy next: first ]
				ifNil: 
					[ dummy next: item next ].
				^ object ]
			ifFalse:
				[ previous _ item ] ].
	
		item isCircular ifTrue: [
			"this was the last one"
			dummy next: first.
			^ nil
			].

		item _ item next.
	] repeat.
! !

!WaitfreeQueue methodsFor: 'accessing'!
nextPut: value
	" Add new item to queue "
	| item oldTail |
	
	item _ self newItem.
	item object: value.

	" atomic swap here"
	oldTail _ tail.
	tail _ item.
	
	"self interrupt"
	
	oldTail next: item.

	self signalAddedNewItem.

	^ value! !

!WaitfreeQueue methodsFor: 'accessing'!
peek
	"Answer the object that was sent through the receiver first and has not 
	yet been received by anyone but do not remove it from the receiver. 
	If queue is empty or there are other process currently fetching object from queue, answer nil.
	
	Note: do not assume that if #peek answers non-nil object, the next message sent to queue,
	like #next or #nextOrNil will answer the same item.
	The use of this method is discouraged , it is provided only for backward compatibility.
	"

	| item result |

	item _ dummy next. 

	[ (result _ item object) == dummy ] whileTrue: [
		item isCircular ifTrue: [ 
			self signalNoMoreItems. 
			^ nil ].
		item _ item next.
	].
	
	^ result
! !

!WaitfreeQueue methodsFor: 'accessing'!
removeAll
	"
	This message makes no sense in concurrent environment. There is no way to guarantee that when this method returns to sender, the queue will remain empty,
	because at any moment other process may interrupt current process and put new item(s) to queue.

	Therefore we just flush the queue and hope for the best"
	
	self flush! !

!WaitfreeQueue methodsFor: 'accessing'!
size
	"Answer the size of queue. 
	If queue is currently in the middle of extraction by other process, give a (very) approximate answer.
	
	This method having a non-deterministic results, because of nature of concurrent shared queue. 
	"
	
	| item count |

	item _ dummy.

	count _ 0.
	[ item _ item next. item object == dummy ifFalse: [ count := count + 1]. item isCircular ] whileFalse.

	count = 0 ifTrue: [
		"if queue is locked by other process, check the tail and give a (very) approximate answer."
		^ tail object == dummy ifTrue: [ 0 ] ifFalse: [ 1]
		].	

	^ count! !

!WaitfreeQueue class methodsFor: 'instance creation'!
new: anInteger 
	"Just to match SharedQueue protocol"
	^self new! !

!WaitfreeQueue class methodsFor: 'instance creation'!
withAll: aCollection
	"Answer an instance of the receiver initialised with the supplied collection of items"

	^self new initializeWithAll: aCollection! !

!AtomicQueueItem methodsFor: 'initialization'!
initialize
	"make circular"
	super initialize.
	next _ self.! !

!AtomicQueueItem methodsFor: 'testing'!
isCircular
	^ next == self! !

!AtomicQueueItem methodsFor: 'testing'!
isZombie
	"Answer a boolean indicating that the receiver doesn't have a real object.
	This should really check that the object is the queue's dummy, but since the item doesn't know which queue it is part of, use the object class instead."

	^object class = self class! !

!AtomicQueueItem methodsFor: 'accessing'!
makeCircular
	"Make a receiver circular, i.e. point to itself,
	answer the old value of next variable. 
	Note, this operation should be atomic"
	
	| temp |

	" atomic swap here"
	temp _ next.
	next _ self.

	^ temp! !

!AtomicQueueItem methodsFor: 'accessing'!
next
	"Answer the value of next"

	^ next! !

!AtomicQueueItem methodsFor: 'accessing'!
next: anObject
	"Set the value of next"

	next _ anObject! !

!AtomicQueueItem methodsFor: 'accessing'!
object
	"Answer the value of object"

	^ object! !

!AtomicQueueItem methodsFor: 'accessing'!
object: anObject
	"Set the value of object"

	object _ anObject! !

!Object methodsFor: '*Animation' stamp: 'hlsf 6/21/2020 17:31:22'!
during: aDelay
"We can't factor the code..."
	| sender target selector |
	sender := thisContext sender.
	selector := sender selectorToSendOrSelf.
	(sender willSend and: selector numArgs = 1) ifFalse:
		[ self error: 'Use with single arg setter message only' ].
	target := sender pop.
	sender pc: sender followingPc.
	^AnimatedProperty new receiver: target selector: selector argument: self during: aDelay as: AnimatedProperty linear! !

!Object methodsFor: '*Animation' stamp: 'hlsf 6/21/2020 17:22:15'!
during: aDelay as: easing
	| sender target selector |
	sender := thisContext sender.
	selector := sender selectorToSendOrSelf.
	(sender willSend and: selector numArgs = 1) ifFalse:
		[ self error: 'Use with single arg setter message only' ].
	target := sender pop.
	sender pc: sender followingPc.
	^AnimatedProperty new receiver: target selector: selector argument: self during: aDelay as: easing! !

!Float class methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 10/1/2016 14:11'!
newFrom: aValue
	^aValue asFloat! !

!Fraction class methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 10/1/2016 14:16'!
newFrom: aValue
	^aValue asFraction! !

!Integer class methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 10/1/2016 14:09'!
newFrom: aValue
	^aValue asInteger! !

!BlockClosure methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 4/25/2017 19:51'!
after: aDelay
	^DelayedBlock new do: self after: aDelay! !

!Collection methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/3/2016 13:26'!
pause
	self pause: OutputEventFetcher default now! !

!Collection methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/3/2016 13:26'!
pause: when
	self do: [ :animator | animator pause: when ]! !

!Collection methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/3/2016 13:25'!
start
	self start: OutputEventFetcher default now! !

!Collection methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/3/2016 13:25'!
start: when
	self do: [ :animator | animator start: when ]! !

!Collection methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/3/2016 13:26'!
stop
	self do: [ :animator | animator stop ]! !

!String methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 11/23/2016 10:58'!
* aFloat
	^self first: (self size * aFloat) asInteger! !

!String methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 4/7/2017 17:03'!
+ aString
	"Collections default to a per-element add"
	^self, aString! !

!SystemWindow methodsFor: '*Animation' stamp: 'hlsf 6/21/2020 17:21:20'!
label: aString
	self setLabel: aString ! !

!WorldState methodsFor: '*Animation' stamp: 'ThibaultRaffaillac 10/5/2016 13:58'!
runStepMethodsIn: aWorld
	"Perform periodic activity inbetween event cycles"
	
	| queue |
	"If available dispatch some deferred UI Message"
	queue := self class deferredUIMessages.
	1 to: queue size do: [ :i | queue nextOrNil value ].
	self runLocalStepMethodsIn: aWorld.
	"The multi-threaded global Transcript needs to be updated periodically and synchronously with the UI."
	Transcript stepGlobal.! !
AnimationSupervisor initialize!
