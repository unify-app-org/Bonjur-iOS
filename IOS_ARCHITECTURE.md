# Bonjur iOS — Architecture Reference

> Generated: 2026-06-04 | Build system: Tuist | Language: Swift

---

## Workspace Layout

```
Bonjur-iOS/
├── Workspace.swift          — defines 3 Tuist projects
├── Tuist.swift              — enforceExplicitDependencies: true
├── Package.swift            — MSAL (Microsoft Auth) via SPM
├── App/                     — Entry point & coordination
├── AppCore/                 — 8 shared infrastructure frameworks
└── AppFeature/              — 8 feature modules (Public + Impl each)
```

**Build configs**: Test / Staging / Prod (separate xcconfigs + app icons)  
**Localization**: az / en / ru (`Localizable.strings`)

---

## Architecture Pattern

```
Clean Architecture + Coordinator + MVVM + Feature State Machine

Presentation ─ ViewModel (UIFeatureViewModel)
                State (UIFeatureState / @Published)
                Action (user events → ViewModel)
                Effect (navigation / loading / error side-effects)
Domain       ─ UseCase (orchestrates repos)
Data         ─ Repository (maps DTOs → domain models)
               DataSource (raw API calls via NetworkService)
               DTO (Codable API models)
```

Every screen follows the **Feature<State, Action, Effect>** triad. ViewModels extend `UIFeatureViewModel<Feature>`.

---

## App Project

**Entry point**: `AppDelegate.swift`

### Startup sequence

```
AppDelegate.application(_:didFinishLaunchingWithOptions:)
  ├── AppDelegate+Core.swift   → register managers (TokenManager, DeviceManager)
  ├── AppDelegate+Navigation.swift → set up navigation stack
  └── AppDelegate+Feature.swift → call each feature's ModuleConfigurator.setup()
        ├── AuthModuleConfigurator.setup(diContainer:)
        ├── ClubsModuleConfigurator.setup(diContainer:)
        ├── CommunitiesModuleConfigurator.setup(diContainer:)
        ├── DiscoverModuleConfigurator.setup(diContainer:)
        ├── EventsModuleConfigurator.setup(diContainer:)
        ├── GroupsModuleConfigurator.setup(diContainer:)
        ├── HangoutsModuleConfigurator.setup(diContainer:)
        └── ProfileModuleConfigurator.setup(diContainer:)

SceneDelegate → AppCoordinator.start()
  ├── if authenticated → showTabBar()
  └── else            → showRegisterVC() (Onboarding flow)
```

### Coordinator

```
AppCoordinator (root UIWindow)
  ├── showRegisterVC() → UINavigationController + OnboardingViewController
  └── showTabBar()     → AppTabBarHostController (UITabBarController)
        ├── Discover
        ├── Clubs
        ├── Groups (Hangouts-adjacent)
        ├── Hangouts
        └── Profile
```

**FloatingDockRootView**: custom SwiftUI "+" create button overlaid on tab bar — opens `CreateView` action sheet for creating clubs / events / hangouts.

---

## AppCore — Shared Frameworks

### 1. DependencyInjection

`AppDIContainer.swift` — service locator

```swift
// Register
container.register(SomeProtocol.self, isSingleton: false) { SomeImpl() }

// Resolve (inside Builder / ViewModel)
let dep: SomeProtocol = container.resolve()
```

- `registry`: `[String: () -> Any]` — factory closures  
- `singletons`: `[String: Any]` — singleton cache  
- **Singletons**: Modules, TokenManager, APIClient, UserDefaults  
- **Transient**: ViewModels, Routers, UseCase instances

---

### 2. AppFoundation — Base Classes

| Type | Role |
|---|---|
| `UIFeature` | Protocol: associatedtypes State, Action, Effect |
| `UIFeatureDefinition<S,A,E>` | Concrete feature descriptor |
| `UIFeatureViewModel<Feature>` | Base ViewModel — holds store, dispatches actions, posts effects |
| `StoreOf<Feature>` | ObservableObject — holds `@Published var state`, handles actions |
| `UIFeatureController<Feature, Content>` | UIHostingController bridge (UIKit ↔ SwiftUI) |

**State updates**: `store.state` → SwiftUI re-renders automatically via `@Published`.  
**Effects**: posted via `effectClosure` → Router handles navigation side-effects.

---

### 3. AppNetwork

#### APIClient (`APIClient.swift`)
- Generic `request<T: Decodable>(endpoint:)` → `T`
- `requestRawData(endpoint:)` → `Data`
- Multipart form data support
- Auto token refresh on **401** (retry once with new token)
- Detailed `NetworkLogger` output

#### Endpoint protocol (`AppEndPoint.swift`)
```swift
protocol AppEndPoint {
    var path: String { get }
    var method: HTTPMethod { get }        // GET POST PUT PATCH DELETE
    var headers: [String: String] { get }
    var requiresAuth: Bool { get }
    var body: Encodable? { get }
    var queryParameters: [String: String]? { get }
    var multipartFormData: [MultipartFormData]? { get }
    var contentType: ContentType { get }  // .json | .formData
}
```

#### NetworkService (`NetworkService.swift`)
```swift
NetworkService<EndPoint: AppEndPoint>
  .fetch<T>()        // typed decode
  .fetchRawData()    // raw bytes
```

#### Token flow
```
Request → 401 received
  → TokenManager.getRefreshToken()
  → POST /auth/refresh
  → save new accessToken + refreshToken
  → retry original request
  → if refresh fails: clearTokens() → activityDelegate.refreshFailure() → logout
```

#### Error types (`APIError`)
`unauthorized` | `decodingError` | `networkError` | `unknown` | server errors

---

### 4. AppStorage

| File | Purpose |
|---|---|
| `KeychainImpl.swift` | Secure token storage (access + refresh tokens) |
| `UserDefaultsImpl.swift` | `isAuthenticated`, `communityId` |
| `DeviceManager.swift` | deviceId, OS version, app version, model |

---

### 5. AppUIKit — Design System

**Theme**: `Colors.swift`, `AppFonts.swift`, `Icons.swift`

**40+ reusable components**:

| Component | File |
|---|---|
| Button | `AppButton/` + `ButtonStyle` |
| Text field | `AppTextField/` |
| Text area | `TextView/` |
| Dropdown | `AppDropdownField/` |
| Date picker | `DatePickerTextField/` |
| Avatar | `AvatarView/` |
| Category chips | `CategorySelectionField/`, `SelectionChipsField/` |
| Radio select | `RadioSelectItemView/` |
| Bottom sheet | `AppBottomSheet/` |
| Alert | `AppAlert/`, `AppAlertPresenter/` |
| Empty state | `AppEmptyView/` |
| Filter screen | `FilterViewModel/`, `FilterScreen/` |
| Links field | `AppLinksField/`, `LinkItem/` |
| Image (cached) | `CachedAsyncImage/`, `ImageCache/` |
| Search | `SearchView/` |
| Segment picker | `CapsuleSegmentedPicker/` |
| Selectable list | `SelectableListItemView/` |
| Tab view | `AppTabView/` |

---

### 6. AppPresentationModel — Shared Domain Types

```swift
Member           { id, profileImage }
Tags             { id, type, title }
UserResponse     — full user profile
AccessType       — PUBLIC | PRIVATE
RequestType      — ACCEPTED | REJECTED | PENDING | none
BackgroundType   — GREEN | BLUE | PURPLE | ORANGE | RED | PINK
UserActivityRole — MEMBER | PRESIDENT | VICE_PRESIDENT | EVENT_CREATOR | notJoined
Gender           — MALE | FEMALE
```

---

### 7. AppLocalization

`AppLocalization.swift` protocol + `LocalizationDependencyContainer`  
`Extension+String.swift` for `.localized` sugar

---

### 8. AppUtils

Extensions: `Collection`, `Date`, `Encodable.toDictionary()`, `Optional`, `String`, `UIApplication`, `View`  
`AppSecrets.swift` — `baseURL` and environment config

---

## AppFeature — Feature Modules

### Internal folder pattern (every feature)

```
FeatureName/
├── Interface/
│   ├── FeatureNameModule.swift       ← public protocol (entry point)
│   └── FeatureNameModuleModel.swift  ← public models shared with other features
└── FeatureNameImpl/
    ├── DI/
    │   ├── DependencyContainer.swift    ← registers all types
    │   ├── ModuleConfigurator.swift     ← called from AppDelegate
    │   └── ModuleImpl.swift             ← implements public Module protocol
    ├── Data/
    │   ├── DTOs/                        ← Codable API models + PaginationQuery
    │   ├── DataSources/                 ← NetworkService calls (raw API)
    │   ├── EndPoint/                    ← AppEndPoint implementations
    │   └── Repo/                        ← DTO → domain model mapping
    ├── Domain/
    │   ├── Models/                      ← domain models + UIModel types
    │   └── UseCases/                    ← business logic
    └── Presentation/
        └── ScreenName/
            ├── Model/ScreenNameModel.swift    ← State / Action / Effect
            ├── Model/ScreenNameBuilder.swift  ← builds UIViewController
            ├── Model/ScreenNameRouter.swift   ← navigation destinations
            ├── ViewModel/ScreenNameViewModel.swift
            └── View/ScreenName*.swift         ← SwiftUI views + UIHostingController
```

---

### Feature: AppAuth

**Screens**: Onboarding → ChooseUniversity → SignIn → Welcome → AuthOptionalInfo

**SignIn data flow**:
```
SignInView (action: .login(email, password))
  → SignInViewModel.handle(.login)
    → AuthUsecases.login(communityId, email, password)
      → AuthRepo.login()
        → AuthDataSource.login(body: LoginRequest)
          → POST /auth/login
        ← LoginResponse { accessToken, refreshToken, userId, isFirstLogin }
      ← TokenManager.saveAccessToken() + saveRefreshToken()
      ← Bool isFirstLogin
    → if isFirstLogin: effect .navigateToWelcome
    → else: effect .navigateToHome
```

**Optional profile setup** (`AuthOptionalInfo`):
- Steps: bio → birthday → interests → gender → language → photos
- Sends multipart form data to `PATCH /auth/optionals`

**Communities API**: `GET /communities` → populates ChooseUniversity picker

**DI registration order**:
```
DataSource → Repo → UseCase → Module (singleton)
```

---

### Feature: Discover

**Dependencies**: Clubs, Events, Hangouts, Communities  
**Screens**: DiscoverView (browsing/search hub)  
**Data**: DiscoverDataSource → DiscoverRepo → DiscoverUseCase  
**Domain**: `UserModel.swift`

---

### Feature: Clubs

**Dependencies**: Events, Communities, Profile

**Screens**:
1. **List** — paginated (10/page), search, filter by category
2. **Details** — info, members, join/request button, links
3. **Create/Edit** — multipart upload (logo + cover image), form schema from API

**Key data methods** (ClubRepo):
```
fetchClubs(query: PaginationQuery)    → [ClubCardView.Model]
fetchClubDetails(clubId)              → ClubsDetailsModel.UIModel
fetchCreate()                         → [ClubsCreate.FieldSchema]  // server-driven form
createClub(request: MultipartFormData)
editClub(id:, request: MultipartFormData)
joinClub(id:)
```

**State machine** (ClubsModel):
```
State  { uiModel: [ClubCardView.Model], searchText, isLoading }
Action { fetchData, loadMore, searchChanged(String), itemOnTap(id) }
Effect { loading(Bool), error(APIError), navigateToDetail(id) }
```

---

### Feature: Events

**Dependencies**: Clubs, Communities

**Screens**: EventsList → EventDetails → EventCreate  
**Data**: EventsDataSource → EventsRepo → EventsUseCase

---

### Feature: Hangouts

**Dependencies**: Communities

**Screens**: HangoutList → HangoutDetails → HangoutCreate  
**Domain models**: `HangoutsCreate.swift`, `HangoutDetails.swift`

---

### Feature: Communities

**Dependencies**: Clubs, Events, Profile

**Screens**:
1. CommunityDetail — overview, member count, clubs
2. FacultyBrowse — list faculties
3. FacultySelection — pick faculty
4. FacultyStudentList — students in faculty
5. FacultyStudentSelectList — multi-select students

**Shared row components**: `FacultyRowView`, `MemberCellView`, `MemberListView`, `MemberSectionHeaderView`  
**Member section data**: `MemberListSectionViewData` with `MemberCellViewData` items

---

### Feature: Groups

**Screens**: GroupsList  
**Dependencies**: Clubs, Events, Hangouts

---

### Feature: Profile

**Dependencies**: Clubs, Events, Hangouts

**Screens**:
1. ProfileDetail — view any user's profile (interests, languages, degree, faculty)
2. EditProfile — editable form (multipart photo upload)
3. StudentCard — user's card with cover color picker
4. ProfileSettings — language, help, terms, logout, delete account

---

## Navigation Reference

```
AppCoordinator
  Auth flow (not authenticated)
    OnboardingViewController
      → ChooseUniversityViewController
        → SignInViewController
          → WelcomeViewController
            → AuthOptionalInfoViewController (if isFirstLogin)
              → AppCoordinator.showTabBar()

  Main flow (authenticated)
    AppTabBarHostController
      [0] Discover   → DiscoverViewController
      [1] Clubs      → ClubsViewController     → ClubDetailsVC → ClubCreateVC
      [2] Groups     → GroupsViewController
      [3] Hangouts   → HangoutsViewController  → HangoutDetailsVC → HangoutCreateVC
      [4] Profile    → ProfileDetailVC → EditProfileVC | StudentCardVC | SettingsVC
      
      FloatingDock ("+") → CreateView sheet
        → Create Club / Event / Hangout
```

Router destinations are enum cases; each Router has one `navigate(to:)` method.

---

## DI Wiring Example (full cycle)

```swift
// 1. AppDelegate calls:
ClubsModuleConfigurator.setup(diContainer: AppDIContainer.shared)

// 2. DependencyContainer.setup() registers:
container.register(ClubsDataSource.self)   { ClubsDataSourceImpl() }
container.register(ClubsRepo.self)          { ClubsRepoImpl() }
container.register(ClubsUseCase.self)       { ClubsUseCaseImpl() }
container.register(ClubsModule.self, isSingleton: true) { ClubsModuleImpl() }

// 3. Builder resolves at screen construction time:
struct Dependencies { let useCase: ClubsUseCase = resolve() }
let vm = ClubsViewModel(dependencies: .init())

// 4. ViewModel uses:
vm.handle(.fetchData)  →  useCase.fetchClubsData(query:)
```

---

## Key Files Quick-Reference

| Purpose | Path |
|---|---|
| App entry | `App/App/AppDelegate/AppDelegate.swift` |
| Root coordinator | `App/App/Coordinator/AppCoordinator.swift` |
| DI container | `AppCore/DependecyInjection/AppDIContainer.swift` |
| Base ViewModel | `AppCore/AppFoundation/Feature/FeatureViewModel.swift` |
| Feature store | `AppCore/AppFoundation/Feature/FeatureStore.swift` |
| API client | `AppCore/AppNetwork/APIClient/APIClient.swift` |
| Token manager | `AppCore/AppNetwork/Manager/TokenManager.swift` |
| Shared models | `AppCore/AppPresentationModel/AppPresentationModel.swift` |
| Base URL / env | `AppCore/AppUtils/Environment/AppSecrets.swift` |
| Localization strings | `App/App/Resources/{az,en,ru}.lproj/Localizable.strings` |
