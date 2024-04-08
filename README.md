# FLIXIE: Your Ultimate Movie Companion

Flixie is a user-friendly movie app built using Flutter. Discover new releases, trending films, and classics effortlessly. 
Flixie delivers a personalized and immersive movie experience just for you!!!

<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/41665985-6c38-4dd4-ab7c-075b928f50b0" width="110" height="220" > 
<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/6c88f51b-9bc5-4d92-99d7-7b2b88c23718" width="110" height="220">
<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/7e466b85-43a3-4afc-ba7b-e23d76e32e30" width="110" height="220">
<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/8d0c439b-daa8-4444-9ce7-fd420297769e" width="110" height="220">
<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/291a4d03-fcb8-4711-b491-c30775a04153" width="110" height="220">
<img src="https://github.com/ShrutiJain418/movie_app/assets/113288105/7c6b5e95-c1e5-45ca-b248-02afc6acbfd9" width="110" height="220"><br>

The project uses the [TMDB API](https://www.themoviedb.org/documentation/api) to fetch a list of movies, and includes features like
recommendations and watchlisting your favourite movies.

### Running the project

Before running, see instructions on how to [get a TMDB API key](#getting-a-tmdb-api-key).

Also, make sure to run on **Flutter beta** channel.

## App Overview

The application is composed by three primary screens: **Home**, **Watchlist** and **Profiles**.

On first launch, the app asks the user to create a profile. 

On the **Home** page you'll find a curated selection of upcoming and currently playing movies, along with a dynamic carousel slider showcasing featured titles.

Each movie shows as a poster using the image URL retrieved from the API. Tap on any movie to view its detailed description, where you can play it directly by clicking the play icon. You can also add the movie to your watchlist using the add icon.

Open the **Watchlist** page to see the list of favourites for the currently selected profile.

Use the **Profiles** page to choose from a variety of customized avatars to create or update your profile.

## Features

- **Sleek Interface**: Flixie boasts an intuitive and modern design, ensuring a seamless user experience.
  
- **TMDB Integration**: The app leverages TMDB APIs to fetch a wide range of movie data, including current releases, trending titles, and detailed information.
  
- **Profile Creation using Firebase Authentication**: Upon first launch, users are prompted to create a profile, allowing for personalized interactions and preferences.<br>
  (**Sign Up -> Sign In -> Email Verification -> Forgot Password -> Reset Password**)

- **Watchlist Functionality with Cloud Firestore**: Enables users to create and manage a watchlist, allowing them to save movies they're interested in for future viewing.
  
- **Movie Search**: Users can easily search for any movie using the built-in search functionality, allowing for quick access to specific titles or genres.
  
- **Profile Management**: The Profiles page offers users the ability to create and customize profiles, including selecting from a variety of avatars.

## App Structure

The project folders are structured like this:

```
/packages
  /core
    /lib
      /models
      /pages
      /services
      /widgets
```

All common functionality lives in `packages/core`. This includes a TMDB API wrapper, along with model classes with supporting serialization code where needed.

`/packages/core/lib/models`:
This folder contains the data models. Each model class typically represents a specific data entity and may include properties, methods, and serialization logic.

```
lib
  /models
    /description.dart
    /recommendation.dart
    /search.dart
    /topsearches.dart
    /watchlistmodel.dart
```

`/packages/core/lib/pages`:
The pages folder houses the screens or pages of the app. These files contain the UI layout, navigation logic, and interaction behavior for their respective screens. 

```
lib
  /pages
    /loginPage.dart
    /descriptionPage.dart
    /homePage.dart
    /searchPage.dart
    /profilePage.dart
```

`/packages/core/lib/services`:
This includes services for fetching movie data from the TMDB API, managing user authentication with Firebase Authentication, storing user data in Cloud Firestore, and any other backend-related tasks.

```
lib
  /services
    /api_services.dart
    /extraservices.dart
```

`/packages/core/lib/widgets`:
The widgets folder contains reusable UI components and widgets used throughout the app. These widgets encapsulate specific UI elements or functionality and can be easily reused across different screens.

```
lib
  /widgets
    /carousel.dart
    /navbar.dart
    /upcomingmovieWidgets.dart
```

## Future Roadmap

- Add more screens
- Polish the UI

Feel free to open issues if you'd like certain features to be implemented (though keep your expectations low, I'm doing this for free after all 😉).

## Packages in use

The "core" package of the app uses the following packages:

- [email_validator](https://pub.dev/packages/email_validator) Validates email addresses input by users, ensuring data integrity and accuracy during account creation and 
  login processes
- [dio](https://pub.dev/packages/dio) for the API client
- [youtube_player_iframe](https://pub.dev/packages/youtube_player_iframe) Enables video playback within the app, supporting various video formats and integration with 
  YouTube content
- [envied](https://pub.dev/packages/envied) for API key security
- [fluttermoji](https://pub.dev/packages/fluttermoji) Generates customizable avatars based on user preferences, enhancing the profile creation and customization experience
- [shared_preferences](https://pub.dev/packages/shared_preferences) Enables simple data persistence for storing user preferences and settings locally, enhancing the user 
  experience by preserving app state between sessions.

## Getting a TMDB API key

This project uses the TMDB API to get the latest movies data.

Before running the app you need to [sign up on the TMDB website](https://www.themoviedb.org/signup), then obtain an API key on the [settings API page](https://www.themoviedb.org/settings/api).

Once you have this, create an `.env` file inside `packages/core/`, and add your key:

```dart
// .env
TMDB_KEY=your-api-key
```

Then, run the code generator:

```
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate a `env.g.dart` file inside `packages/core/lib/api`, that is used when making requests to the TMDB API.

Congratulations, you're good to go. 😎









