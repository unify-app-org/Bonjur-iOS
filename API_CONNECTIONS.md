# Bonjur iOS ↔ Backend — API Connection Map

> Generated: 2026-06-05 | Maps every `AppFeature` module's endpoints to backend microservices.

---

## Service Prefix Routing

iOS paths use short prefixes; gateway routes each to a microservice.

| iOS prefix | Microservice | Base mapping |
|---|---|---|
| `api/as/` | **auth-service** | `/v1/auth` |
| `api/sd/` | **static-data-service** | `/v1/categories`, `/v1/languages`, `/v1/communities` |
| `api/us/` | **user-service** | `/v1/users` |
| `api/cs/` | **club-service** | `/v1/clubs` |
| `api/hs/` | **hangout-service** | `/v1/hangouts` |
| `api/ds/` | **discover-service** | `/v1/clubs`, `/v1/hangouts` (read/browse) |

Endpoint files: `AppFeature/<Feature>/<Feature>Impl/Data/EndPoint/*.swift`
Backend host: `66.70.191.74:8080`

---

## Per-Feature Connection Map

### AppAuth (`AuthEnpoints`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `login` | POST | `api/as/v1/auth/login` | auth-service `AuthController.login` | ✅ |
| `register` | POST | `auth/register` | — | ⚠️ no service, no prefix — **dead/unused** |
| `getCommunities` | GET | `api/sd/v1/communities` | static-data `ClubController` | ✅ |
| `getLanguages` | GET | `api/sd/v1/languages` | static-data `LanguageController` | ✅ |
| `getCategories` | GET | `api/sd/v1/categories` | static-data `CategoryController` | ✅ |
| `sendOptionals` | PUT (multipart) | `api/us/v1/users` | user-service `updateUser` | ✅ |

Notes: First-login profile wizard → `sendOptionals` (multipart photos + query fields).
`register` path lacks gateway prefix — leftover, not backed by any controller.

---

### Profile (`ProfileEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `getUsers` | GET | `api/us/v1/users/profile` | user-service `getUserProfile` | ✅ |
| `updateUserData` | PUT (multipart) | `api/us/v1/users` | user-service `updateUser` | ✅ |
| `getUserById` | GET | `api/us/v1/users/{id}` | user-service `getById` | ✅ |
| `deleteAccount` | DELETE | `api/us/v1/users` | user-service `deleteUser` | ✅ |
| `getCategories` | GET | `api/sd/v1/categories` | static-data | ✅ |
| `getLanguages` | GET | `api/sd/v1/languages` | static-data | ✅ |
| `getMyClubs` | GET | `api/cs/v1/clubs/{userId}/myclubs` | club-service `getAllMyClubs` | ✅ |
| `myHangouts` | GET | `api/hs/v1/hangouts/{id}/myhangouts` | hangout-service `getAllMyHangouts` | ✅ |

---

### Clubs (`ClubsEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `createClub` | POST (multipart) | `api/cs/v1/clubs` | club-service `createClub` | ✅ |
| `getClubById` | GET | `api/cs/v1/clubs/{id}` | club-service `getClubById` | ✅ |
| `getMembersByClubId` | GET | `api/cs/v1/clubs/{id}/members` | club-service `getClubMembers` | ✅ |
| `editClub` | PUT (multipart) | `api/cs/v1/clubs/{id}` | club-service `updateClub` | ✅ |
| `joinClub` | POST | `api/cs/v1/clubs/{id}/join-club` | club-service `joinClub` | ✅ |
| `getClubs` | GET | `api/ds/v1/clubs` | discover-service `getAllClubs` | ✅ |
| `getCategories` | GET | `api/sd/v1/categories` | static-data | ✅ |

**Backend endpoints NOT consumed by iOS Clubs** (available, unused):
`DELETE /{clubId}/exit`, `POST /{clubId}/role`, `GET /join-requests`,
`POST /join-requests/status`, `GET /joined` (used by Groups), `DELETE /{id}`.

---

### Hangouts (`HangoutsEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `getHangouts` | GET | `api/ds/v1/hangouts` | discover-service `getAllClubs`(hangouts) | ✅ |
| `createHangout` | POST | `api/hs/v1/hangouts` | hangout-service `create` | ✅ |
| `editHangout` | PUT | `api/hs/v1/hangouts/{id}` | hangout-service `update` | ✅ |
| `hangoutDetail` | GET | `api/hs/v1/hangouts/{id}` | hangout-service `getById` | ✅ |
| `members` | GET | `api/hs/v1/hangouts/{id}/members` | hangout-service `getHangoutMembers` | ✅ |
| `getCategories` | GET | `api/sd/v1/categories` | static-data | ✅ |

**Backend endpoints NOT consumed here:** `DELETE /{hangoutId}`, `POST /join`
(used by Discover), `POST /requests/{hangoutId}`, `GET /join-requests`,
`DELETE /exit/{hangoutId}`, `GET /get-joined` (used by Groups).

---

### Discover (`DiscoverEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `getHangouts` | GET | `api/ds/v1/hangouts` | discover-service | ✅ |
| `getCommunities` | GET | `api/ds/v1/clubs/communities` | discover-service `getAllCommunity` | ✅ |
| `getClubs` | GET | `api/ds/v1/clubs` | discover-service `getAllClubs` | ✅ |
| `getCategories` | GET | `api/sd/v1/categories` | static-data | ✅ |
| `getUser` | GET | `api/us/v1/users/profile` | user-service | ✅ |
| `getUserById` | GET | `api/us/v1/users/{id}` | user-service | ✅ |
| `joinHangout` | POST | `api/hs/v1/hangouts/join` | hangout-service `join` | ✅ |

---

### Communities (`CommunityEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `getClubById` | GET | `api/cs/v1/clubs/{id}` | club-service | ✅ |
| `getMembersByClubId` | GET | `api/cs/v1/clubs/{id}/members` | club-service | ✅ |
| `getClubs` | GET | `api/ds/v1/clubs` | discover-service | ✅ |

Note: Community detail = club-service data (no standalone community service). Confirmed by design.

---

### Groups (`GroupsEndPoint`)

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `joinedClubs` | GET | `api/cs/v1/clubs/joined` | club-service `getAllJoinedClubs` | ✅ |
| `joinedHangouts` | GET | `api/hs/v1/hangouts/get-joined` | hangout-service `getAllJoinedHangouts` | ✅ |

---

### Events (`EventsEndPoint`) — ❌ NOT CONNECTED

| Case | Method | iOS Path | Backend | Status |
|---|---|---|---|---|
| `test` | POST | `test/test` | — | ❌ placeholder |

- `EventsDataSource` protocol is **empty** (no methods).
- Presentation layer (List / Details / Create) exists but has **no live data**.
- **Blocked on backend**: no `event-service` exists yet. Backend devs assigned.

---

## Summary

| Feature | Connected | Backend service |
|---|---|---|
| AppAuth | ✅ (`register` dead) | auth + static-data + user |
| Profile | ✅ | user + static-data + club + hangout |
| Clubs | ✅ | club + discover + static-data |
| Hangouts | ✅ | hangout + discover + static-data |
| Discover | ✅ | discover + static-data + user + hangout |
| Communities | ✅ | club + discover |
| Groups | ✅ | club + hangout |
| **Events** | ❌ | none — pending `event-service` |

### Action Items
1. **Events** — fully stubbed (`test/test`, empty DataSource). Wire once `event-service` ships.
2. **`register` endpoint** — `auth/register` has no prefix + no backend. Remove if unused.
3. **Logout** — commented out in auth-service (`/v1/auth/logout`); iOS has no logout endpoint either. Token cleared client-side only.
4. **Notifications** — no endpoints on either side yet. Backend devs assigned.

---

## Backend Endpoints PROVIDED but NOT yet Connected in iOS

These controllers are live on the backend. iOS has no `AppEndPoint` case calling them.

### club-service (`api/cs/v1/clubs`)

| Method | Path | Backend handler | Purpose | Maps to iOS screen |
|---|---|---|---|---|
| DELETE | `/{clubId}/exit` | `exitUser` | Leave a club | Club Details "exit" (with owner-transfer gate) |
| POST | `/{clubId}/role` | `changeUserRole` (body `ChangeRoleRequest`) | Assign member role | Member Management — assign role |
| GET | `/join-requests` | `getJoinRequests` (paged) | List pending join requests | Private club — owner approval inbox |
| POST | `/join-requests/status` | `updateJoinRequestStatus` (body `UpdateJoinRequestStatusRequest`) | Approve/reject join request | Private club — approve/reject |
| DELETE | `/{id}` | `deleteClub` | Delete club | Club Details — owner delete |

### hangout-service (`api/hs/v1/hangouts`)

| Method | Path | Backend handler | Purpose | Maps to iOS screen |
|---|---|---|---|---|
| DELETE | `/{hangoutId}` | `delete` | Delete hangout | Hangout Details — owner delete |
| POST | `/requests/{hangoutId}` | `handleJoinRequest` (body `JoinRequestDecisionDto`) | Approve/reject hangout join | Private hangout — owner approval |
| GET | `/join-requests` | `getPendingJoinRequests` (paged) | List pending hangout join requests | Hangout owner — request inbox |
| DELETE | `/exit/{hangoutId}` | `leaveHangout` | Leave hangout | Hangout Details — exit |

### auth-service (`api/as/v1/auth`)

| Method | Path | Backend handler | Status |
|---|---|---|---|
| GET | `/v1/auth` | `test` | Healthcheck stub — not for app use |
| POST | `/logout` | — | **Commented out** in controller; not available |

> Note: hangout `POST /join` and `GET /get-joined`, club `GET /joined` and `GET /{userId}/myclubs`,
> hangout `GET /{userId}/myhangouts` ARE connected (via Discover / Groups / Profile) — not listed here.

### Connection Gap Summary

| Capability | Backend ready | iOS connected | Gap |
|---|---|---|---|
| Leave club / hangout | ✅ | ❌ | add `exit` endpoint cases |
| Delete club / hangout | ✅ | ❌ | add `delete` cases (owner action) |
| Role management | ✅ (club) | ❌ | add `changeUserRole` |
| Join-request approval flow | ✅ (club + hangout) | ❌ | add list + status/decision cases |

**Takeaway:** Private-visibility + ownership flows (leave, delete, role, approve requests)
are fully built on backend but have **no iOS wiring yet**. Largest connectable surface
without waiting on backend devs.
