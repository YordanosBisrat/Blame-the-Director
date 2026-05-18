# 🎬 Blame the Director

> A Flutter movie review app where every terrible film is **100% the director's fault.**

Browse real movies from TMDB, write your verdict, rate the film, and file your complaint — all powered by clean architecture, Bloc state management, and Dio networking.

---

## ✨ Features

- 🎥 **Browse** popular movies with posters, ratings, and release year (TMDB API)
- 🔍 **Search** movies in real time
- ✍️ **Write reviews** with a 1–5 star rating ("File your verdict")
- 📋 **View all your verdicts** in a dedicated tab
- ✏️ **Edit** any review — update text or rating
- 🗑️ **Delete** a review with a confirmation dialog
- 💀 Full **loading, error, and empty states** on every screen
- 🌐 All review CRUD operations hit a real REST API (DummyJSON)

---

## 📱 Screenshots

| Browse Movies | Movie Detail | My Verdicts |
|---|---|---|
| *(add screenshot)* | *(add screenshot)* | *(add screenshot)* |

> **To add screenshots:** run the app, take screenshots, and add them to a `/screenshots` folder in the repo. Then replace the cells above with `![Browse](screenshots/browse.png)` etc.

---

## 🏗️ Architecture

Clean Architecture with three layers:

```
lib/
├── core/
│   ├── constants/        # ApiConstants (base URLs, image paths)
│   ├── di/               # get_it service locator
│   ├── network/          # TmdbDioClient + DummyJsonDioClient
│   └── theme/            # AppTheme
│
└── features/
    └── movies/
        ├── data/
        │   ├── datasources/   # MovieRemoteDataSource, ReviewRemoteDataSource
        │   └── models/        # MovieModel, ReviewModel (fromJson / toJson)
        │
        ├── domain/
        │   ├── entities/      # Movie, Review (pure Dart, no Flutter)
        │   └── repositories/  # Abstract interfaces
        │
        └── presentation/
            ├── bloc/
            │   ├── movie_bloc/   # MovieBloc, MovieEvent, MovieState
            │   └── review_bloc/  # ReviewBloc, ReviewEvent, ReviewState
            ├── pages/            # HomePage, MovieDetailsPage
            └── widgets/          # MovieCard, ReviewCard, dialogs, EmptyStateWidget
```

---

## 🌐 API Strategy

| API | Role | Operations |
|---|---|---|
| **TMDB** | Movie data (posters, ratings, overview) | `GET /movie/popular` |
| **DummyJSON** | Review storage | `POST`, `GET`, `PUT`, `DELETE` /posts |

Reviews are serialised as a JSON string inside DummyJSON's `body` field:
```json
{
  "movieId": 550,
  "movieTitle": "Fight Club",
  "reviewText": "The twist made no sense. Blame the director.",
  "rating": 2
}
```

---

## 🧱 State Management — Bloc

### MovieBloc
| Event | State |
|---|---|
| `FetchMoviesEvent` | `MovieLoading` → `MovieLoaded` / `MovieError` |

### ReviewBloc
| Event | State |
|---|---|
| `FetchReviewsEvent` | `ReviewLoading` → `ReviewsLoaded` / `ReviewError` |
| `AddReviewEvent` | `ReviewLoading` → `ReviewOperationSuccess` / `ReviewError` |
| `UpdateReviewEvent` | `ReviewLoading` → `ReviewOperationSuccess` / `ReviewError` |
| `DeleteReviewEvent` | `ReviewLoading` → `ReviewOperationSuccess` / `ReviewError` |

`ReviewError` carries `previousReviews` so the UI never goes blank on failure.

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc ^9.1.1` | State management |
| `equatable ^2.0.7` | Value equality for Bloc states/events |
| `dio ^5.8.0+1` | HTTP client |
| `pretty_dio_logger ^1.4.0` | Request/response logging |
| `cached_network_image ^3.4.1` | Efficient image loading with placeholders |
| `get_it ^8.0.3` | Dependency injection / service locator |
| `flutter_dotenv ^5.2.1` | Secure API key management via `.env` |

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/YordanosBisrat/blame_the_director.git
cd blame_the_director
```

### 2. Create a `.env` file in the project root
```
TMDB_BEARER_TOKEN=your_tmdb_bearer_token_here
```

Get a free token at [themoviedb.org](https://www.themoviedb.org/settings/api).

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run the app
```bash
flutter run
```

---

## 🔐 Environment Variables

The TMDB bearer token is stored in a `.env` file and loaded at runtime via `flutter_dotenv`. The `.env` file is included in `pubspec.yaml` assets but should be added to `.gitignore` before pushing to a public repo:

```
# .gitignore
.env
```

---

## 📂 Folder Structure (full)

```
blame_the_director/
├── .env                          ← API keys (DO NOT commit to public repos)
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart
│   │   ├── di/
│   │   │   └── service_locator.dart
│   │   ├── network/
│   │   │   └── dio_client.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   └── features/
│       └── movies/
│           ├── data/
│           │   ├── datasources/
│           │   │   ├── movie_remote_data_source.dart
│           │   │   └── review_remote_data_source.dart
│           │   └── models/
│           │       ├── movie_model.dart
│           │       └── review_model.dart
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── movie.dart
│           │   │   └── review.dart
│           │   └── repositories/
│           │       ├── movie_repository.dart
│           │       └── review_repository.dart
│           └── presentation/
│               ├── bloc/
│               │   ├── movie_bloc/
│               │   │   ├── movie_bloc.dart
│               │   │   ├── movie_event.dart
│               │   │   └── movie_state.dart
│               │   └── review_bloc/
│               │       ├── review_bloc.dart
│               │       ├── review_event.dart
│               │       └── review_state.dart
│               ├── pages/
│               │   ├── home_page.dart
│               │   └── movie_details_page.dart
│               └── widgets/
│                   ├── movie_card.dart
│                   ├── review_card.dart
│                   ├── add_review_dialog.dart
│                   ├── edit_review_dialog.dart
│                   └── empty_state_widget.dart
└── test/
```

---

## 👤 Author
 
