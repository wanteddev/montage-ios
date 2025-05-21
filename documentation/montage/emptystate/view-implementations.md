---
title: View Implementations
---

## Topics

### Instance Methods


~~``func accentColor(Color?) -> some View``~~

~~``func accessibility(activationPoint: CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(activationPoint: UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(addTraits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(hidden: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(identifier: String) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(inputLabels: [Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(label: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(removeTraits: AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(selectionIdentifier: AnyHashable) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(sortPriority: Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

~~``func accessibility(value: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

``func accessibilityAction(AccessibilityActionKind, () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityAction<Label>(action: () -> Void, label: () -> Label) -> some View``

``func accessibilityAction(named: LocalizedStringKey, () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityAction(named: Text, () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityAction<S>(named: S, () -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityActions<Content>(() -> Content) -> some View``

``func accessibilityActions<Content>(category: AccessibilityActionCategory, () -> Content) -> some View``

``func accessibilityActivationPoint(CGPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityActivationPoint(UnitPoint) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityActivationPoint(UnitPoint, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityActivationPoint(CGPoint, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityAddTraits(AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityAdjustableAction((AccessibilityAdjustmentDirection) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityChartDescriptor<R>(R) -> some View``

``func accessibilityChildren<V>(children: () -> V) -> some View``

``func accessibilityCustomContent(AccessibilityCustomContentKey, LocalizedStringKey, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityCustomContent<V>(AccessibilityCustomContentKey, V, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityCustomContent(Text, Text, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityCustomContent(AccessibilityCustomContentKey, Text?, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityCustomContent(LocalizedStringKey, Text, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

~~``func accessibilityCustomContent<L, V>(L, V, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``~~

``func accessibilityCustomContent<V>(LocalizedStringKey, V, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityCustomContent(LocalizedStringKey, LocalizedStringKey, importance: AXCustomContent.Importance) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDirectTouch(Bool, options: AccessibilityDirectTouchOptions) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint(UnitPoint, description: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint<S>(UnitPoint, description: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint(UnitPoint, description: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint(UnitPoint, description: Text, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint<S>(UnitPoint, description: S, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDragPoint(UnitPoint, description: LocalizedStringKey, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint(UnitPoint, description: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint(UnitPoint, description: LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint<S>(UnitPoint, description: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint<S>(UnitPoint, description: S, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint(UnitPoint, description: LocalizedStringKey, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityDropPoint(UnitPoint, description: Text, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityElement(children: AccessibilityChildBehavior) -> some View``

``func accessibilityFocused(AccessibilityFocusState<Bool>.Binding) -> some View``

``func accessibilityFocused<Value>(AccessibilityFocusState<Value>.Binding, equals: Value) -> some View``

``func accessibilityHeading(AccessibilityHeadingLevel) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHidden(Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHidden(Bool, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint<S>(S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint(Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint(LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint(Text, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint(LocalizedStringKey, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityHint<S>(S, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityIdentifier(String) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityIdentifier(String, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityIgnoresInvertColors(Bool) -> some View``

``func accessibilityInputLabels<S>([S]) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityInputLabels([Text]) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityInputLabels([LocalizedStringKey]) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityInputLabels([LocalizedStringKey], isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityInputLabels([Text], isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityInputLabels<S>([S], isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel(LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel(Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel<S>(S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel<S>(S, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel(Text, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel(LocalizedStringKey, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityLabel<V>(content: (PlaceholderContentView<Self>) -> V) -> some View``

``func accessibilityLabeledPair<ID>(role: AccessibilityLabeledPairRole, id: ID, in: Namespace.ID) -> some View``

``func accessibilityLinkedGroup<ID>(id: ID, in: Namespace.ID) -> some View``

``func accessibilityRemoveTraits(AccessibilityTraits) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityRepresentation<V>(representation: () -> V) -> some View``

``func accessibilityRespondsToUserInteraction(Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityRespondsToUserInteraction(Bool, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityRotor<Content>(AccessibilitySystemRotor, entries: () -> Content) -> some View``

``func accessibilityRotor<Content>(Text, entries: () -> Content) -> some View``

``func accessibilityRotor<Content>(LocalizedStringKey, entries: () -> Content) -> some View``

``func accessibilityRotor<L, Content>(L, entries: () -> Content) -> some View``

``func accessibilityRotor<EntryModel, ID>(LocalizedStringKey, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<EntryModel, ID>(AccessibilitySystemRotor, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<EntryModel, ID>(Text, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<L, EntryModel, ID>(L, entries: [EntryModel], entryID: KeyPath<EntryModel, ID>, entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<EntryModel>(Text, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<L, EntryModel>(L, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<EntryModel>(AccessibilitySystemRotor, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor<EntryModel>(LocalizedStringKey, entries: [EntryModel], entryLabel: KeyPath<EntryModel, String>) -> some View``

``func accessibilityRotor(LocalizedStringKey, textRanges: [Range<String.Index>]) -> some View``

``func accessibilityRotor<L>(L, textRanges: [Range<String.Index>]) -> some View``

``func accessibilityRotor(Text, textRanges: [Range<String.Index>]) -> some View``

``func accessibilityRotor(AccessibilitySystemRotor, textRanges: [Range<String.Index>]) -> some View``

``func accessibilityRotorEntry<ID>(id: ID, in: Namespace.ID) -> some View``

``func accessibilityScrollAction((Edge) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityShowsLargeContentViewer() -> some View``

``func accessibilityShowsLargeContentViewer<V>(() -> V) -> some View``

``func accessibilitySortPriority(Double) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityTextContentType(AccessibilityTextContentType) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue<S>(S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue(LocalizedStringKey) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue(Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue<S>(S, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue(LocalizedStringKey, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityValue(Text, isEnabled: Bool) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

``func accessibilityZoomAction((AccessibilityZoomGestureAction) -> Void) -> ModifiedContent<Self, AccessibilityAttachmentModifier>``

~~``func actionSheet(isPresented: Binding<Bool>, content: () -> ActionSheet) -> some View``~~

~~``func actionSheet<T>(item: Binding<T?>, content: (T) -> ActionSheet) -> some View``~~

``func alert<S, A>(S, isPresented: Binding<Bool>, actions: () -> A) -> some View``

``func alert<A>(Text, isPresented: Binding<Bool>, actions: () -> A) -> some View``

``func alert<A>(LocalizedStringKey, isPresented: Binding<Bool>, actions: () -> A) -> some View``

``func alert<A, M>(LocalizedStringKey, isPresented: Binding<Bool>, actions: () -> A, message: () -> M) -> some View``

``func alert<A, M>(Text, isPresented: Binding<Bool>, actions: () -> A, message: () -> M) -> some View``

``func alert<S, A, M>(S, isPresented: Binding<Bool>, actions: () -> A, message: () -> M) -> some View``

``func alert<S, A, T>(S, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A) -> some View``

``func alert<A, T>(LocalizedStringKey, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A) -> some View``

``func alert<A, T>(Text, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A) -> some View``

``func alert<A, M, T>(LocalizedStringKey, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

``func alert<S, A, M, T>(S, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

``func alert<A, M, T>(Text, isPresented: Binding<Bool>, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

~~``func alert(isPresented: Binding<Bool>, content: () -> Alert) -> some View``~~

``func alert<E, A>(isPresented: Binding<Bool>, error: E?, actions: () -> A) -> some View``

``func alert<E, A, M>(isPresented: Binding<Bool>, error: E?, actions: (E) -> A, message: (E) -> M) -> some View``

~~``func alert<Item>(item: Binding<Item?>, content: (Item) -> Alert) -> some View``~~

``func alignmentGuide(HorizontalAlignment, computeValue: (ViewDimensions) -> CGFloat) -> some View``

``func alignmentGuide(VerticalAlignment, computeValue: (ViewDimensions) -> CGFloat) -> some View``

``func allowedDynamicRange(Image.DynamicRange?) -> some View``

``func allowsHitTesting(Bool) -> some View``

``func allowsTightening(Bool) -> some View``

``func allowsWindowActivationEvents(Bool?) -> some View``

``func anchorPreference<A, K>(key: K.Type, value: Anchor<A>.Source, transform: (Anchor<A>) -> K.Value) -> some View``

~~``func animation(Animation?) -> some View``~~

``func animation<V>(Animation?, body: (PlaceholderContentView<Self>) -> V) -> some View``

``func animation<V>(Animation?, value: V) -> some View``

``func aspectRatio(CGFloat?, contentMode: ContentMode) -> some View``

``func aspectRatio(CGSize, contentMode: ContentMode) -> some View``

~~``func autocapitalization(UITextAutocapitalizationType) -> some View``~~

``func autocorrectionDisabled(Bool) -> some View``

~~``func background<Background>(Background, alignment: Alignment) -> some View``~~

``func background<S>(S, ignoresSafeAreaEdges: Edge.Set) -> some View``

``func background<S, T>(S, in: T, fillStyle: FillStyle) -> some View``

``func background<S, T>(S, in: T, fillStyle: FillStyle) -> some View``

``func background<V>(alignment: Alignment, content: () -> V) -> some View``

``func background(ignoresSafeAreaEdges: Edge.Set) -> some View``

``func background<S>(in: S, fillStyle: FillStyle) -> some View``

``func background<S>(in: S, fillStyle: FillStyle) -> some View``

``func backgroundPreferenceValue<Key, T>(Key.Type, (Key.Value) -> T) -> some View``

``func backgroundPreferenceValue<K, V>(K.Type, alignment: Alignment, (K.Value) -> V) -> some View``

``func backgroundStyle<S>(S) -> some View``

``func badge(LocalizedStringKey?) -> some View``

``func badge(Text?) -> some View``

``func badge(Int) -> some View``

``func badge<S>(S?) -> some View``

``func badgeProminence(BadgeProminence) -> some View``

``func baselineOffset(CGFloat) -> some View``

``func blendMode(BlendMode) -> some View``

``func blur(radius: CGFloat, opaque: Bool) -> some View``

``func bold(Bool) -> some View``

``func border<S>(S, width: CGFloat) -> some View``

``func brightness(Double) -> some View``

``func buttonBorderShape(ButtonBorderShape) -> some View``

``func buttonRepeatBehavior(ButtonRepeatBehavior) -> some View``

``func buttonStyle<S>(S) -> some View``

``func buttonStyle<S>(S) -> some View``

``func clipShape<S>(S, style: FillStyle) -> some View``

``func clipped(antialiased: Bool) -> some View``

``func colorEffect(Shader, isEnabled: Bool) -> some View``

``func colorInvert() -> some View``

``func colorMultiply(Color) -> some View``

~~``func colorScheme(ColorScheme) -> some View``~~

``func compositingGroup() -> some View``

``func confirmationDialog<A>(LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A) -> some View``

``func confirmationDialog<S, A>(S, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A) -> some View``

``func confirmationDialog<A>(Text, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A) -> some View``

``func confirmationDialog<A, M>(LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A, message: () -> M) -> some View``

``func confirmationDialog<S, A, M>(S, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A, message: () -> M) -> some View``

``func confirmationDialog<A, M>(Text, isPresented: Binding<Bool>, titleVisibility: Visibility, actions: () -> A, message: () -> M) -> some View``

``func confirmationDialog<A, T>(Text, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A) -> some View``

``func confirmationDialog<A, T>(LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A) -> some View``

``func confirmationDialog<S, A, T>(S, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A) -> some View``

``func confirmationDialog<A, M, T>(Text, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

``func confirmationDialog<S, A, M, T>(S, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

``func confirmationDialog<A, M, T>(LocalizedStringKey, isPresented: Binding<Bool>, titleVisibility: Visibility, presenting: T?, actions: (T) -> A, message: (T) -> M) -> some View``

``func containerBackground<S>(S, for: ContainerBackgroundPlacement) -> some View``

``func containerBackground<V>(for: ContainerBackgroundPlacement, alignment: Alignment, content: () -> V) -> some View``

``func containerRelativeFrame(Axis.Set, alignment: Alignment) -> some View``

``func containerRelativeFrame(Axis.Set, alignment: Alignment, (CGFloat, Axis) -> CGFloat) -> some View``

``func containerRelativeFrame(Axis.Set, count: Int, span: Int, spacing: CGFloat, alignment: Alignment) -> some View``

``func containerShape<T>(T) -> some View``

``func containerValue<V>(WritableKeyPath<ContainerValues, V>, V) -> some View``

``func contentMargins(Edge.Set, CGFloat?, for: ContentMarginPlacement) -> some View``

``func contentMargins(Edge.Set, EdgeInsets, for: ContentMarginPlacement) -> some View``

``func contentMargins(CGFloat, for: ContentMarginPlacement) -> some View``

``func contentShape<S>(ContentShapeKinds, S, eoFill: Bool) -> some View``

``func contentShape<S>(S, eoFill: Bool) -> some View``

``func contentToolbar<Content>(for: ContentToolbarPlacement, content: () -> Content) -> some View``

``func contentToolbar<Content>(for: ContentToolbarPlacement, content: () -> Content) -> some View``

``func contentTransition(ContentTransition) -> some View``

~~``func contextMenu<MenuItems>(ContextMenu<MenuItems>?) -> some View``~~

``func contextMenu<I, M>(forSelectionType: I.Type, menu: (Set<I>) -> M, primaryAction: ((Set<I>) -> Void)?) -> some View``

``func contextMenu<MenuItems>(menuItems: () -> MenuItems) -> some View``

``func contextMenu<M, P>(menuItems: () -> M, preview: () -> P) -> some View``

``func contrast(Double) -> some View``

``func controlGroupStyle<S>(S) -> some View``

``func controlSize(ControlSize) -> some View``

``func coordinateSpace(NamedCoordinateSpace) -> some View``

~~``func coordinateSpace<T>(name: T) -> some View``~~

~~``func cornerRadius(CGFloat, antialiased: Bool) -> some View``~~

``func datePickerStyle<S>(S) -> some View``

``func defaultAdaptableTabBarPlacement(AdaptableTabBarPlacement) -> some View``

``func defaultAppStorage(UserDefaults) -> some View``

``func defaultFocus<V>(FocusState<V>.Binding, V, priority: DefaultFocusEvaluationPriority) -> some View``

``func defaultHoverEffect(some CustomHoverEffect) -> some View``

``func defaultHoverEffect(HoverEffect?) -> some View``

``func defaultScrollAnchor(UnitPoint?) -> some View``

``func defaultScrollAnchor(UnitPoint?, for: ScrollAnchorRole) -> some View``

``func defersSystemGestures(on: Edge.Set) -> some View``

``func deleteDisabled(Bool) -> some View``

``func dialogIcon(Image?) -> some View``

``func dialogSuppressionToggle<S>(S, isSuppressed: Binding<Bool>) -> some View``

``func dialogSuppressionToggle(LocalizedStringKey, isSuppressed: Binding<Bool>) -> some View``

``func dialogSuppressionToggle(Text, isSuppressed: Binding<Bool>) -> some View``

``func dialogSuppressionToggle(isSuppressed: Binding<Bool>) -> some View``

~~``func disableAutocorrection(Bool?) -> some View``~~

``func disabled(Bool) -> some View``

``func disclosureGroupStyle<S>(S) -> some View``

``func distortionEffect(Shader, maxSampleOffset: CGSize, isEnabled: Bool) -> some View``

``func documentBrowserContextMenu(([URL]?) -> some View) -> some View``

``func draggable<T>(@autoclosure () -> T) -> some View``

``func draggable<V, T>(@autoclosure () -> T, preview: () -> V) -> some View``

``func drawingGroup(opaque: Bool, colorMode: ColorRenderingMode) -> some View``

``func dropDestination<T>(for: T.Type, action: ([T], CGPoint) -> Bool, isTargeted: (Bool) -> Void) -> some View``

``func dynamicTypeSize(DynamicTypeSize) -> some View``

~~``func edgesIgnoringSafeArea(Edge.Set) -> some View``~~

``func environment<T>(T?) -> some View``

``func environment<V>(WritableKeyPath<EnvironmentValues, V>, V) -> some View``

``func environmentObject<T>(T) -> some View``

``func fileDialogBrowserOptions(FileDialogBrowserOptions) -> some View``

``func fileDialogConfirmationLabel(Text?) -> some View``

``func fileDialogConfirmationLabel<S>(S) -> some View``

``func fileDialogConfirmationLabel(LocalizedStringKey) -> some View``

``func fileDialogCustomizationID(String) -> some View``

``func fileDialogDefaultDirectory(URL?) -> some View``

``func fileDialogImportsUnresolvedAliases(Bool) -> some View``

``func fileDialogMessage<S>(S) -> some View``

``func fileDialogMessage(Text?) -> some View``

``func fileDialogMessage(LocalizedStringKey) -> some View``

``func fileDialogURLEnabled(Predicate<URL>) -> some View``

``func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentType: UTType, defaultFilename: String?, onCompletion: (Result<URL, any Error>) -> Void) -> some View``

``func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentType: UTType, defaultFilename: String?, onCompletion: (Result<URL, any Error>) -> Void) -> some View``

``func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType], defaultFilename: String?, onCompletion: (Result<URL, any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporter<D>(isPresented: Binding<Bool>, document: D?, contentTypes: [UTType], defaultFilename: String?, onCompletion: (Result<URL, any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentType: UTType, onCompletion: (Result<[URL], any Error>) -> Void) -> some View``

``func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentType: UTType, onCompletion: (Result<[URL], any Error>) -> Void) -> some View``

``func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType], onCompletion: (Result<[URL], any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporter<C>(isPresented: Binding<Bool>, documents: C, contentTypes: [UTType], onCompletion: (Result<[URL], any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporter<T>(isPresented: Binding<Bool>, item: T?, contentTypes: [UTType], defaultFilename: String?, onCompletion: (Result<URL, any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporter<C, T>(isPresented: Binding<Bool>, items: C, contentTypes: [UTType], onCompletion: (Result<[URL], any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileExporterFilenameLabel(Text?) -> some View``

``func fileExporterFilenameLabel<S>(S) -> some View``

``func fileExporterFilenameLabel(LocalizedStringKey) -> some View``

``func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: (Result<[URL], any Error>) -> Void) -> some View``

``func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: (Result<[URL], any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], onCompletion: (Result<URL, any Error>) -> Void) -> some View``

``func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: (Result<URL, any Error>) -> Void) -> some View``

``func fileMover(isPresented: Binding<Bool>, file: URL?, onCompletion: (Result<URL, any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: (Result<[URL], any Error>) -> Void) -> some View``

``func fileMover<C>(isPresented: Binding<Bool>, files: C, onCompletion: (Result<[URL], any Error>) -> Void, onCancellation: () -> Void) -> some View``

``func findDisabled(Bool) -> some View``

``func findNavigator(isPresented: Binding<Bool>) -> some View``

``func fixedSize() -> some View``

``func fixedSize(horizontal: Bool, vertical: Bool) -> some View``

``func flipsForRightToLeftLayoutDirection(Bool) -> some View``

``func focusEffectDisabled(Bool) -> some View``

``func focusable(Bool) -> some View``

``func focusable(Bool, interactions: FocusInteractions) -> some View``

``func focused(FocusState<Bool>.Binding) -> some View``

``func focused<Value>(FocusState<Value>.Binding, equals: Value) -> some View``

``func focusedObject<T>(T) -> some View``

``func focusedObject<T>(T?) -> some View``

``func focusedSceneObject<T>(T?) -> some View``

``func focusedSceneObject<T>(T) -> some View``

``func focusedSceneValue<T>(T?) -> some View``

``func focusedSceneValue<T>(WritableKeyPath<FocusedValues, T?>, T) -> some View``

``func focusedSceneValue<T>(WritableKeyPath<FocusedValues, T?>, T?) -> some View``

``func focusedValue<T>(T?) -> some View``

``func focusedValue<Value>(WritableKeyPath<FocusedValues, Value?>, Value?) -> some View``

``func focusedValue<Value>(WritableKeyPath<FocusedValues, Value?>, Value) -> some View``

``func font(Font?) -> some View``

``func fontDesign(Font.Design?) -> some View``

``func fontWeight(Font.Weight?) -> some View``

``func fontWidth(Font.Width?) -> some View``

~~``func foregroundColor(Color?) -> some View``~~

``func foregroundStyle<S>(S) -> some View``

``func foregroundStyle<S1, S2>(S1, S2) -> some View``

``func foregroundStyle<S1, S2, S3>(S1, S2, S3) -> some View``

``func formStyle<S>(S) -> some View``

~~``func frame() -> some View``~~

``func frame(minWidth: CGFloat?, idealWidth: CGFloat?, maxWidth: CGFloat?, minHeight: CGFloat?, idealHeight: CGFloat?, maxHeight: CGFloat?, alignment: Alignment) -> some View``

``func frame(width: CGFloat?, height: CGFloat?, alignment: Alignment) -> some View``

``func fullScreenCover<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, content: () -> Content) -> some View``

``func fullScreenCover<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)?, content: (Item) -> Content) -> some View``

``func gaugeStyle<S>(S) -> some View``

``func geometryGroup() -> some View``

``func gesture(some UIGestureRecognizerRepresentable) -> some View``

``func gesture<T>(T, including: GestureMask) -> some View``

``func gesture<T>(T, isEnabled: Bool) -> some View``

``func gesture<T>(T, name: String, isEnabled: Bool) -> some View``

``func grayscale(Double) -> some View``

``func gridCellAnchor(UnitPoint) -> some View``

``func gridCellColumns(Int) -> some View``

``func gridCellUnsizedAxes(Axis.Set) -> some View``

``func gridColumnAlignment(HorizontalAlignment) -> some View``

``func groupBoxStyle<S>(S) -> some View``

``func handGestureShortcut(HandGestureShortcut, isEnabled: Bool) -> some View``

``func handlesExternalEvents(preferring: Set<String>, allowing: Set<String>) -> some View``

``func headerProminence(Prominence) -> some View``

``func help(LocalizedStringKey) -> some View``

``func help<S>(S) -> some View``

``func help(Text) -> some View``

``func hidden() -> some View``

``func highPriorityGesture<T>(T, including: GestureMask) -> some View``

``func highPriorityGesture<T>(T, isEnabled: Bool) -> some View``

``func highPriorityGesture<T>(T, name: String, isEnabled: Bool) -> some View``

``func hoverEffect(HoverEffect) -> some View``

``func hoverEffect(HoverEffect, isEnabled: Bool) -> some View``

``func hoverEffect(some CustomHoverEffect, isEnabled: Bool) -> some View``

``func hoverEffectDisabled(Bool) -> some View``

``func hueRotation(Angle) -> some View``

``func id<ID>(ID) -> some View``

``func ignoresSafeArea(SafeAreaRegions, edges: Edge.Set) -> some View``

``func imageScale(Image.Scale) -> some View``

``func indexViewStyle<S>(S) -> some View``

``func inspector<V>(isPresented: Binding<Bool>, content: () -> V) -> some View``

``func inspectorColumnWidth(CGFloat) -> some View``

``func inspectorColumnWidth(min: CGFloat?, ideal: CGFloat, max: CGFloat?) -> some View``

``func interactionActivityTrackingTag(String) -> some View``

``func interactiveDismissDisabled(Bool) -> some View``

``func invalidatableContent(Bool) -> some View``

``func italic(Bool) -> some View``

``func itemProvider(Optional<() -> NSItemProvider?>) -> some View``

``func kerning(CGFloat) -> some View``

``func keyboardShortcut(KeyboardShortcut) -> some View``

``func keyboardShortcut(KeyboardShortcut?) -> some View``

``func keyboardShortcut(KeyEquivalent, modifiers: EventModifiers) -> some View``

``func keyboardShortcut(KeyEquivalent, modifiers: EventModifiers, localization: KeyboardShortcut.Localization) -> some View``

``func keyboardType(UIKeyboardType) -> some View``

``func keyframeAnimator<Value>(initialValue: Value, repeating: Bool, content: (PlaceholderContentView<Self>, Value) -> some View, keyframes: (Value) -> some Keyframes) -> some View``

``func keyframeAnimator<Value>(initialValue: Value, trigger: some Equatable, content: (PlaceholderContentView<Self>, Value) -> some View, keyframes: (Value) -> some Keyframes) -> some View``

``func labelStyle<S>(S) -> some View``

``func labeledContentStyle<S>(S) -> some View``

``func labelsHidden() -> some View``

``func labelsVisibility(Visibility) -> some View``

``func layerEffect(Shader, maxSampleOffset: CGSize, isEnabled: Bool) -> some View``

``func layoutDirectionBehavior(LayoutDirectionBehavior) -> some View``

``func layoutPriority(Double) -> some View``

``func layoutValue<K>(key: K.Type, value: K.Value) -> some View``

``func lineLimit(PartialRangeFrom<Int>) -> some View``

``func lineLimit(PartialRangeThrough<Int>) -> some View``

``func lineLimit(Int?) -> some View``

``func lineLimit(ClosedRange<Int>) -> some View``

``func lineLimit(Int, reservesSpace: Bool) -> some View``

``func lineSpacing(CGFloat) -> some View``

``func listItemTint(ListItemTint?) -> some View``

``func listItemTint(Color?) -> some View``

``func listRowBackground<V>(V?) -> some View``

``func listRowInsets(EdgeInsets?) -> some View``

``func listRowSeparator(Visibility, edges: VerticalEdge.Set) -> some View``

``func listRowSeparatorTint(Color?, edges: VerticalEdge.Set) -> some View``

``func listRowSpacing(CGFloat?) -> some View``

``func listSectionSeparator(Visibility, edges: VerticalEdge.Set) -> some View``

``func listSectionSeparatorTint(Color?, edges: VerticalEdge.Set) -> some View``

``func listSectionSpacing(ListSectionSpacing) -> some View``

``func listSectionSpacing(CGFloat) -> some View``

``func listStyle<S>(S) -> some View``

``func luminanceToAlpha() -> some View``

~~``func mask<Mask>(Mask) -> some View``~~

``func mask<Mask>(alignment: Alignment, () -> Mask) -> some View``

``func matchedGeometryEffect<ID>(id: ID, in: Namespace.ID, properties: MatchedGeometryProperties, anchor: UnitPoint, isSource: Bool) -> some View``

``func matchedTransitionSource(id: some Hashable, in: Namespace.ID) -> some View``

``func matchedTransitionSource(id: some Hashable, in: Namespace.ID, configuration: (EmptyMatchedTransitionSourceConfiguration) -> some MatchedTransitionSourceConfiguration) -> some View``

``func materialActiveAppearance(MaterialActiveAppearance) -> some View``

``func menuActionDismissBehavior(MenuActionDismissBehavior) -> some View``

``func menuIndicator(Visibility) -> some View``

``func menuOrder(MenuOrder) -> some View``

``func menuStyle<S>(S) -> some View``

``func minimumScaleFactor(CGFloat) -> some View``

``func modifier<T>(T) -> ModifiedContent<Self, T>``

``func monospaced(Bool) -> some View``

``func monospacedDigit() -> some View``

``func moveDisabled(Bool) -> some View``

``func multilineTextAlignment(TextAlignment) -> some View``

``func navigationBarBackButtonHidden(Bool) -> some View``

~~``func navigationBarHidden(Bool) -> some View``~~

~~``func navigationBarItems<L>(leading: L) -> some View``~~

~~``func navigationBarItems<L, T>(leading: L, trailing: T) -> some View``~~

~~``func navigationBarItems<T>(trailing: T) -> some View``~~

~~``func navigationBarTitle(LocalizedStringKey) -> some View``~~

~~``func navigationBarTitle(Text) -> some View``~~

~~``func navigationBarTitle<S>(S) -> some View``~~

~~``func navigationBarTitle(Text, displayMode: NavigationBarItem.TitleDisplayMode) -> some View``~~

~~``func navigationBarTitle<S>(S, displayMode: NavigationBarItem.TitleDisplayMode) -> some View``~~

~~``func navigationBarTitle(LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode) -> some View``~~

``func navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode) -> some View``

``func navigationDestination<D, C>(for: D.Type, destination: (D) -> C) -> some View``

``func navigationDestination<V>(isPresented: Binding<Bool>, destination: () -> V) -> some View``

``func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View``

``func navigationDocument(URL) -> some View``

``func navigationDocument<D, I1, I2>(D, preview: SharePreview<I1, I2>) -> some View``

``func navigationDocument<D, I>(D, preview: SharePreview<I, Never>) -> some View``

``func navigationDocument<D, I>(D, preview: SharePreview<Never, I>) -> some View``

``func navigationDocument<D>(D, preview: SharePreview<Never, Never>) -> some View``

``func navigationSplitViewColumnWidth(CGFloat) -> some View``

``func navigationSplitViewColumnWidth(min: CGFloat?, ideal: CGFloat, max: CGFloat?) -> some View``

``func navigationSplitViewStyle<S>(S) -> some View``

``func navigationTitle(LocalizedStringKey) -> some View``

``func navigationTitle<V>(() -> V) -> some View``

``func navigationTitle<S>(S) -> some View``

``func navigationTitle(Text) -> some View``

``func navigationTitle(Binding<String>) -> some View``

``func navigationTransition(some NavigationTransition) -> some View``

~~``func navigationViewStyle<S>(S) -> some View``~~

``func offset(CGSize) -> some View``

``func offset(x: CGFloat, y: CGFloat) -> some View``

``func onAppear(perform: (() -> Void)?) -> some View``

``func onChange<V>(of: V, initial: Bool, () -> Void) -> some View``

``func onChange<V>(of: V, initial: Bool, (V, V) -> Void) -> some View``

~~``func onChange<V>(of: V, perform: (V) -> Void) -> some View``~~

``func onContinueUserActivity(String, perform: (NSUserActivity) -> ()) -> some View``

~~``func onContinuousHover(coordinateSpace: CoordinateSpace, perform: (HoverPhase) -> Void) -> some View``~~

``func onDisappear(perform: (() -> Void)?) -> some View``

``func onDrag(() -> NSItemProvider) -> some View``

``func onDrag<V>(() -> NSItemProvider, preview: () -> V) -> some View``

``func onDrop(of: [UTType], delegate: any DropDelegate) -> some View``

~~``func onDrop(of: [String], delegate: any DropDelegate) -> some View``~~

~~``func onDrop(of: [String], isTargeted: Binding<Bool>?, perform: ([NSItemProvider], CGPoint) -> Bool) -> some View``~~

~~``func onDrop(of: [String], isTargeted: Binding<Bool>?, perform: ([NSItemProvider]) -> Bool) -> some View``~~

``func onDrop(of: [UTType], isTargeted: Binding<Bool>?, perform: ([NSItemProvider], CGPoint) -> Bool) -> some View``

``func onDrop(of: [UTType], isTargeted: Binding<Bool>?, perform: ([NSItemProvider]) -> Bool) -> some View``

``func onGeometryChange<T>(for: T.Type, of: (GeometryProxy) -> T, action: (T) -> Void) -> some View``

``func onGeometryChange<T>(for: T.Type, of: (GeometryProxy) -> T, action: (T, T) -> Void) -> some View``

``func onHover(perform: (Bool) -> Void) -> some View``

``func onKeyPress(KeyEquivalent, action: () -> KeyPress.Result) -> some View``

``func onKeyPress(KeyEquivalent, phases: KeyPress.Phases, action: (KeyPress) -> KeyPress.Result) -> some View``

``func onKeyPress(characters: CharacterSet, phases: KeyPress.Phases, action: (KeyPress) -> KeyPress.Result) -> some View``

``func onKeyPress(keys: Set<KeyEquivalent>, phases: KeyPress.Phases, action: (KeyPress) -> KeyPress.Result) -> some View``

``func onKeyPress(phases: KeyPress.Phases, action: (KeyPress) -> KeyPress.Result) -> some View``

``func onLongPressGesture(minimumDuration: Double, maximumDistance: CGFloat, perform: () -> Void, onPressingChanged: ((Bool) -> Void)?) -> some View``

~~``func onLongPressGesture(minimumDuration: Double, maximumDistance: CGFloat, pressing: ((Bool) -> Void)?, perform: () -> Void) -> some View``~~

``func onLongPressGesture(minimumDuration: Double, perform: () -> Void, onPressingChanged: ((Bool) -> Void)?) -> some View``

~~``func onLongPressGesture(minimumDuration: Double, pressing: ((Bool) -> Void)?, perform: () -> Void) -> some View``~~

``func onOpenURL(perform: (URL) -> ()) -> some View``

``func onPencilDoubleTap(perform: (PencilDoubleTapGestureValue) -> Void) -> some View``

``func onPencilSqueeze(perform: (PencilSqueezeGesturePhase) -> Void) -> some View``

``func onPreferenceChange<K>(K.Type, perform: (K.Value) -> Void) -> some View``

``func onReceive<P>(P, perform: (P.Output) -> Void) -> some View``

``func onScrollGeometryChange<T>(for: T.Type, of: (ScrollGeometry) -> T, action: (T, T) -> Void) -> some View``

``func onScrollPhaseChange((ScrollPhase, ScrollPhase) -> Void) -> some View``

``func onScrollPhaseChange((ScrollPhase, ScrollPhase, ScrollPhaseChangeContext) -> Void) -> some View``

``func onScrollTargetVisibilityChange<ID>(idType: ID.Type, threshold: Double, ([ID]) -> Void) -> some View``

``func onScrollVisibilityChange(threshold: Double, (Bool) -> Void) -> some View``

``func onSubmit(of: SubmitTriggers, () -> Void) -> some View``

~~``func onTapGesture(count: Int, coordinateSpace: CoordinateSpace, perform: (CGPoint) -> Void) -> some View``~~

``func onTapGesture(count: Int, perform: () -> Void) -> some View``

``func opacity(Double) -> some View``

~~``func overlay<Overlay>(Overlay, alignment: Alignment) -> some View``~~

``func overlay<S>(S, ignoresSafeAreaEdges: Edge.Set) -> some View``

``func overlay<S, T>(S, in: T, fillStyle: FillStyle) -> some View``

``func overlay<V>(alignment: Alignment, content: () -> V) -> some View``

``func overlayPreferenceValue<Key, T>(Key.Type, (Key.Value) -> T) -> some View``

``func overlayPreferenceValue<K, V>(K.Type, alignment: Alignment, (K.Value) -> V) -> some View``

``func padding(EdgeInsets) -> some View``

``func padding(CGFloat) -> some View``

``func padding(Edge.Set, CGFloat?) -> some View``

``func paletteSelectionEffect(PaletteSelectionEffect) -> some View``

``func persistentSystemOverlays(Visibility) -> some View``

``func phaseAnimator<Phase>(some Sequence, content: (PlaceholderContentView<Self>, Phase) -> some View, animation: (Phase) -> Animation?) -> some View``

``func phaseAnimator<Phase>(some Sequence, trigger: some Equatable, content: (PlaceholderContentView<Self>, Phase) -> some View, animation: (Phase) -> Animation?) -> some View``

``func pickerStyle<S>(S) -> some View``

``func popover<Content>(isPresented: Binding<Bool>, attachmentAnchor: PopoverAttachmentAnchor, arrowEdge: Edge?, content: () -> Content) -> some View``

``func popover<Item, Content>(item: Binding<Item?>, attachmentAnchor: PopoverAttachmentAnchor, arrowEdge: Edge?, content: (Item) -> Content) -> some View``

``func position(CGPoint) -> some View``

``func position(x: CGFloat, y: CGFloat) -> some View``

``func preference<K>(key: K.Type, value: K.Value) -> some View``

``func preferredColorScheme(ColorScheme?) -> some View``

``func presentationBackground<S>(S) -> some View``

``func presentationBackground<V>(alignment: Alignment, content: () -> V) -> some View``

``func presentationBackgroundInteraction(PresentationBackgroundInteraction) -> some View``

``func presentationCompactAdaptation(PresentationAdaptation) -> some View``

``func presentationCompactAdaptation(horizontal: PresentationAdaptation, vertical: PresentationAdaptation) -> some View``

``func presentationContentInteraction(PresentationContentInteraction) -> some View``

``func presentationCornerRadius(CGFloat?) -> some View``

``func presentationDetents(Set<PresentationDetent>) -> some View``

``func presentationDetents(Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View``

``func presentationDragIndicator(Visibility) -> some View``

``func presentationSizing(some PresentationSizing) -> some View``

``func previewContext<C>(C) -> some View``

``func previewDevice(PreviewDevice?) -> some View``

``func previewDisplayName(String?) -> some View``

``func previewInterfaceOrientation(InterfaceOrientation) -> some View``

``func previewLayout(PreviewLayout) -> some View``

``func privacySensitive(Bool) -> some View``

``func progressViewStyle<S>(S) -> some View``

``func projectionEffect(ProjectionTransform) -> some View``

``func redacted(reason: RedactionReasons) -> some View``

``func refreshable(action: () async -> Void) -> some View``

``func renameAction(() -> Void) -> some View``

``func renameAction(FocusState<Bool>.Binding) -> some View``

``func replaceDisabled(Bool) -> some View``

``func rotation3DEffect(Angle, axis: (x: CGFloat, y: CGFloat, z: CGFloat), anchor: UnitPoint, anchorZ: CGFloat, perspective: CGFloat) -> some View``

``func rotationEffect(Angle, anchor: UnitPoint) -> some View``

``func safeAreaInset<V>(edge: HorizontalEdge, alignment: VerticalAlignment, spacing: CGFloat?, content: () -> V) -> some View``

``func safeAreaInset<V>(edge: VerticalEdge, alignment: HorizontalAlignment, spacing: CGFloat?, content: () -> V) -> some View``

``func safeAreaPadding(CGFloat) -> some View``

``func safeAreaPadding(EdgeInsets) -> some View``

``func safeAreaPadding(Edge.Set, CGFloat?) -> some View``

``func saturation(Double) -> some View``

``func scaleEffect(CGFloat, anchor: UnitPoint) -> some View``

``func scaleEffect(CGSize, anchor: UnitPoint) -> some View``

``func scaleEffect(x: CGFloat, y: CGFloat, anchor: UnitPoint) -> some View``

``func scaledToFill() -> some View``

``func scaledToFit() -> some View``

``func scenePadding(Edge.Set) -> some View``

``func scenePadding(ScenePadding, edges: Edge.Set) -> some View``

``func scrollBounceBehavior(ScrollBounceBehavior, axes: Axis.Set) -> some View``

``func scrollClipDisabled(Bool) -> some View``

``func scrollContentBackground(Visibility) -> some View``

``func scrollDisabled(Bool) -> some View``

``func scrollDismissesKeyboard(ScrollDismissesKeyboardMode) -> some View``

``func scrollIndicators(ScrollIndicatorVisibility, axes: Axis.Set) -> some View``

``func scrollIndicatorsFlash(onAppear: Bool) -> some View``

``func scrollIndicatorsFlash(trigger: some Equatable) -> some View``

``func scrollInputBehavior(ScrollInputBehavior, for: ScrollInputKind) -> some View``

``func scrollPosition(Binding<ScrollPosition>, anchor: UnitPoint?) -> some View``

``func scrollPosition(id: Binding<(some Hashable)?>, anchor: UnitPoint?) -> some View``

``func scrollTargetBehavior(some ScrollTargetBehavior) -> some View``

``func scrollTargetLayout(isEnabled: Bool) -> some View``

``func scrollTransition(ScrollTransitionConfiguration, axis: Axis?, transition: (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View``

``func scrollTransition(topLeading: ScrollTransitionConfiguration, bottomTrailing: ScrollTransitionConfiguration, axis: Axis?, transition: (EmptyVisualEffect, ScrollTransitionPhase) -> some VisualEffect) -> some View``

``func searchCompletion(String) -> some View``

``func searchDictationBehavior(TextInputDictationBehavior) -> some View``

``func searchFocused(FocusState<Bool>.Binding) -> some View``

``func searchFocused<V>(FocusState<V>.Binding, equals: V) -> some View``

``func searchPresentationToolbarBehavior(SearchPresentationToolbarBehavior) -> some View``

``func searchScopes<V, S>(Binding<V>, activation: SearchScopeActivation, () -> S) -> some View``

``func searchScopes<V, S>(Binding<V>, scopes: () -> S) -> some View``

``func searchSuggestions<S>(() -> S) -> some View``

``func searchSuggestions(Visibility, for: SearchSuggestionsPlacement.Set) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: some StringProtocol, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: Text?, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement, prompt: Text?, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<C>(text: Binding<String>, editableTokens: Binding<C>, placement: SearchFieldPlacement, prompt: some StringProtocol, token: (Binding<C.Element>) -> some View) -> some View``

``func searchable<S>(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: S) -> some View``

``func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: Text?) -> some View``

``func searchable(text: Binding<String>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: LocalizedStringKey) -> some View``

``func searchable(text: Binding<String>, placement: SearchFieldPlacement, prompt: Text?) -> some View``

``func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement, prompt: S) -> some View``

``func searchable(text: Binding<String>, placement: SearchFieldPlacement, prompt: LocalizedStringKey) -> some View``

~~``func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, suggestions: () -> S) -> some View``~~

~~``func searchable<S>(text: Binding<String>, placement: SearchFieldPlacement, prompt: Text?, suggestions: () -> S) -> some View``~~

~~``func searchable<V, S>(text: Binding<String>, placement: SearchFieldPlacement, prompt: S, suggestions: () -> V) -> some View``~~

``func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: S, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: Text?, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement, prompt: Text?, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (C.Element) -> T) -> some View``

``func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, placement: SearchFieldPlacement, prompt: S, token: (C.Element) -> T) -> some View``

``func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: S, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, isPresented: Binding<Bool>, placement: SearchFieldPlacement, prompt: Text?, token: (C.Element) -> T) -> some View``

``func searchable<C, T, S>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement, prompt: S, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement, prompt: LocalizedStringKey, token: (C.Element) -> T) -> some View``

``func searchable<C, T>(text: Binding<String>, tokens: Binding<C>, suggestedTokens: Binding<C>, placement: SearchFieldPlacement, prompt: Text?, token: (C.Element) -> T) -> some View``

``func sectionActions<Content>(content: () -> Content) -> some View``

``func selectionDisabled(Bool) -> some View``

``func sensoryFeedback<T>(SensoryFeedback, trigger: T) -> some View``

``func sensoryFeedback<T>(SensoryFeedback, trigger: T, condition: (T, T) -> Bool) -> some View``

``func sensoryFeedback<T>(trigger: T, (T, T) -> SensoryFeedback?) -> some View``

``func shadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View``

``func sheet<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, content: () -> Content) -> some View``

``func sheet<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)?, content: (Item) -> Content) -> some View``

``func simultaneousGesture<T>(T, including: GestureMask) -> some View``

``func simultaneousGesture<T>(T, isEnabled: Bool) -> some View``

``func simultaneousGesture<T>(T, name: String, isEnabled: Bool) -> some View``

``func speechAdjustedPitch(Double) -> some View``

``func speechAlwaysIncludesPunctuation(Bool) -> some View``

``func speechAnnouncementsQueued(Bool) -> some View``

``func speechSpellsOutCharacters(Bool) -> some View``

``func springLoadingBehavior(SpringLoadingBehavior) -> some View``

~~``func statusBar(hidden: Bool) -> some View``~~

``func statusBarHidden(Bool) -> some View``

``func strikethrough(Bool, pattern: Text.LineStyle.Pattern, color: Color?) -> some View``

``func submitLabel(SubmitLabel) -> some View``

``func submitScope(Bool) -> some View``

``func swipeActions<T>(edge: HorizontalEdge, allowsFullSwipe: Bool, content: () -> T) -> some View``

``func symbolEffect<T>(T, options: SymbolEffectOptions, isActive: Bool) -> some View``

``func symbolEffect<T, U>(T, options: SymbolEffectOptions, value: U) -> some View``

``func symbolEffectsRemoved(Bool) -> some View``

``func symbolRenderingMode(SymbolRenderingMode?) -> some View``

``func symbolVariant(SymbolVariants) -> some View``

~~``func tabItem<V>(() -> V) -> some View``~~

``func tabViewCustomization(Binding<TabViewCustomization>?) -> some View``

``func tabViewSidebarBottomBar<Content>(content: () -> Content) -> some View``

``func tabViewSidebarFooter<Content>(content: () -> Content) -> some View``

``func tabViewSidebarHeader<Content>(content: () -> Content) -> some View``

``func tabViewStyle<S>(S) -> some View``

``func tableColumnHeaders(Visibility) -> some View``

``func tableStyle<S>(S) -> some View``

``func tag<V>(V, includeOptional: Bool) -> some View``

``func task<T>(id: T, priority: TaskPriority, () async -> Void) -> some View``

``func task(priority: TaskPriority, () async -> Void) -> some View``

``func textCase(Text.Case?) -> some View``

``func textContentType(UITextContentType?) -> some View``

``func textEditorStyle(some TextEditorStyle) -> some View``

``func textFieldStyle<S>(S) -> some View``

``func textInputAutocapitalization(TextInputAutocapitalization?) -> some View``

``func textRenderer<T>(T) -> some View``

``func textScale(Text.Scale, isEnabled: Bool) -> some View``

``func textSelection<S>(S) -> some View``

``func textSelectionAffinity(TextSelectionAffinity) -> some View``

``func tint(Color?) -> some View``

``func toggleStyle<S>(S) -> some View``

~~``func toolbar(Visibility, for: ToolbarPlacement...) -> some View``~~

``func toolbar<Content>(content: () -> Content) -> some View``

``func toolbar<Content>(content: () -> Content) -> some View``

``func toolbar<Content>(id: String, content: () -> Content) -> some View``

``func toolbar(removing: ToolbarDefaultItemKind?) -> some View``

~~``func toolbarBackground(Visibility, for: ToolbarPlacement...) -> some View``~~

``func toolbarBackgroundVisibility(Visibility, for: ToolbarPlacement...) -> some View``

``func toolbarColorScheme(ColorScheme?, for: ToolbarPlacement...) -> some View``

``func toolbarForegroundStyle<S>(S, for: ToolbarPlacement...) -> some View``

``func toolbarRole(ToolbarRole) -> some View``

``func toolbarTitleDisplayMode(ToolbarTitleDisplayMode) -> some View``

``func toolbarTitleMenu<C>(content: () -> C) -> some View``

``func toolbarVisibility(Visibility, for: ToolbarPlacement...) -> some View``

``func tracking(CGFloat) -> some View``

``func transaction((inout Transaction) -> Void) -> some View``

``func transaction<V>((inout Transaction) -> Void, body: (PlaceholderContentView<Self>) -> V) -> some View``

``func transaction(value: some Equatable, (inout Transaction) -> Void) -> some View``

``func transformAnchorPreference<A, K>(key: K.Type, value: Anchor<A>.Source, transform: (inout K.Value, Anchor<A>) -> Void) -> some View``

``func transformEffect(CGAffineTransform) -> some View``

``func transformEnvironment<V>(WritableKeyPath<EnvironmentValues, V>, transform: (inout V) -> Void) -> some View``

``func transformPreference<K>(K.Type, (inout K.Value) -> Void) -> some View``

``func transition(AnyTransition) -> some View``

``func truncationMode(Text.TruncationMode) -> some View``

``func typeSelectEquivalent(LocalizedStringKey) -> some View``

``func typeSelectEquivalent<S>(S) -> some View``

``func typeSelectEquivalent(Text?) -> some View``

``func typesettingLanguage(Locale.Language, isEnabled: Bool) -> some View``

``func typesettingLanguage(TypesettingLanguage, isEnabled: Bool) -> some View``

``func underline(Bool, pattern: Text.LineStyle.Pattern, color: Color?) -> some View``

``func unredacted() -> some View``

``func userActivity<P>(String, element: P?, (P, NSUserActivity) -> ()) -> some View``

``func userActivity(String, isActive: Bool, (NSUserActivity) -> ()) -> some View``

``func visualEffect((EmptyVisualEffect, GeometryProxy) -> some VisualEffect) -> some View``

``func windowToolbarFullScreenVisibility(WindowToolbarFullScreenVisibility) -> some View``

``func writingToolsAffordanceVisibility(Visibility) -> some View``

``func writingToolsBehavior(WritingToolsBehavior) -> some View``

``func zIndex(Double) -> some View``

