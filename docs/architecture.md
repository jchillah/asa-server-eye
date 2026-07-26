# Architecture

ASA Server Eye uses a feature-first Flutter structure. Features separate data,
domain and presentation responsibilities where the feature complexity warrants
it. Riverpod owns dependency construction and UI state.

```text
lib/
  app/
  core/
  features/
    alerts/
    auth/
    favorites/
    notifications/
    profile/
    servers/
    settings/
    sightings/
    subscriptions/
  l10n/

functions/src/
  accounts/
  alerts/
  subscriptions/
```

## Account deletion

Account deletion is a privileged backend workflow:

1. The client reauthenticates the current email/password user and refreshes the
   ID token.
2. The callable Function rejects missing or stale authentication.
3. The Function removes the user profile recursively, owned sightings and
   history, alert/notification data, subscription data, username reservations,
   profile storage and other UID references.
4. Firebase Authentication is deleted last. A cleanup failure therefore leaves
   the login available for an idempotent retry.

Clients cannot delete the root user document directly. Deploying the Function
and Firestore rules is a separate production operation.
