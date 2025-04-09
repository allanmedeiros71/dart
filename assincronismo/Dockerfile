FROM dart:3.0.6 AS build

# Set the working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application source code
COPY . .

# Run build_runner to generate env.g.dart
RUN dart run build_runner build --delete-conflicting-outputs

# Build the executable
RUN dart compile exe bin/main.dart -o bin/assincronismo

# Build the runtime image
FROM debian:buster-slim

# Set the working directory
WORKDIR /app

# Copy the executable
COPY --from=build /app/bin/assincronismo /app/bin/

# Copy the .env file
COPY .env /app/

# Set the entrypoint
ENTRYPOINT ["/app/bin/assincronismo"]
