#!/bin/bash

set -e

echo "Creating base project structure..."

mkdir -p lib/app
mkdir -p lib/core/constants
mkdir -p lib/core/extensions
mkdir -p lib/core/network
mkdir -p lib/core/utils

mkdir -p lib/features/servers/data
mkdir -p lib/features/servers/domain
mkdir -p lib/features/servers/presentation

mkdir -p lib/features/favorites/data
mkdir -p lib/features/favorites/domain
mkdir -p lib/features/favorites/presentation

mkdir -p lib/features/settings/presentation

mkdir -p lib/l10n

mkdir -p assets/images
mkdir -p assets/icons

mkdir -p docs

echo "Creating README..."

cat > README.md << 'EOF'
# ASA Server Eye

ARK Survival Ascended companion app showing real-time server population.

## Features (MVP)

- Server list
- Server details
- Favorites
- Settings
- Localization (English / German)

## Planned Features

- Player sightings
- Push notifications
- Watchlists
- Premium alerts

## Tech Stack

Flutter  
Riverpod  
GoRouter  
Clean Architecture  
Feature-First Structure  

## Architecture
lib
├── app
├── core
├── features
│ ├── servers
│ ├── favorites
│ └── settings
└── l10n


## Development Workflow

1. Create issue
2. Create feature branch
3. Implement feature
4. Open pull request
5. Merge to main

## Project Board

https://github.com/users/jchillah/projects/41

## Repository

https://github.com/jchillah/asa-server-eye
EOF

echo "Creating l10n placeholder..."

cat > lib/l10n/app_en.arb << 'EOF'
{
  "@@locale": "en",
  "appTitle": "ASA Server Eye"
}
EOF

cat > lib/l10n/app_de.arb << 'EOF'
{
  "@@locale": "de",
  "appTitle": "ASA Server Eye"
}
EOF

echo "Creating basic Flutter entry files..."

cat > lib/app/app.dart << 'EOF'
import 'package:flutter/material.dart';

class AsaServerEyeApp extends StatelessWidget {
  const AsaServerEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASA Server Eye',
      home: Scaffold(
        appBar: AppBar(title: const Text('ASA Server Eye')),
        body: const Center(
          child: Text('ASA Server Eye MVP'),
        ),
      ),
    );
  }
}
EOF

echo "Updating main.dart..."

cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  runApp(const AsaServerEyeApp());
}
EOF

echo "Creating docs folder..."

cat > docs/architecture.md << 'EOF'
# Architecture

Feature-first Clean Architecture.

features/
  servers/
  favorites/
  settings/

core/
  shared utilities, networking, constants
EOF

echo "Project setup complete."