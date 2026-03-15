#!/usr/bin/env bash
set -euo pipefail

OWNER="jchillah"
REPO="asa-server-eye"
PROJECT_NUMBER="41"
MILESTONE_TITLE="v0.1.0 MVP"
MILESTONE_DESC="Initial MVP release: Servers, Favorites, Settings, Localization, Android release prep"

echo "==> Creating labels..."
gh label create "feature"       --repo "$OWNER/$REPO" --color "1D76DB" --description "New feature" --force
gh label create "bug"           --repo "$OWNER/$REPO" --color "D73A4A" --description "Bug fix" --force
gh label create "chore"         --repo "$OWNER/$REPO" --color "BFDADC" --description "Maintenance / tooling" --force
gh label create "refactor"      --repo "$OWNER/$REPO" --color "C2E0C6" --description "Refactor without feature change" --force
gh label create "release"       --repo "$OWNER/$REPO" --color "5319E7" --description "Release related" --force
gh label create "ui"            --repo "$OWNER/$REPO" --color "FBCA04" --description "UI / UX work" --force
gh label create "localization"  --repo "$OWNER/$REPO" --color "0E8A16" --description "Localization / i18n" --force
gh label create "mvp"           --repo "$OWNER/$REPO" --color "0052CC" --description "Part of MVP scope" --force
gh label create "high-priority" --repo "$OWNER/$REPO" --color "B60205" --description "Needs early attention" --force

echo "==> Ensuring milestone exists..."
MILESTONE_NUMBER="$(gh api "repos/$OWNER/$REPO/milestones" --paginate --jq ".[] | select(.title == \"$MILESTONE_TITLE\") | .number" | head -n1 || true)"
if [ -z "${MILESTONE_NUMBER:-}" ]; then
  MILESTONE_NUMBER="$(gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    "repos/$OWNER/$REPO/milestones" \
    -f title="$MILESTONE_TITLE" \
    -f description="$MILESTONE_DESC" \
    --jq '.number')"
  echo "Created milestone #$MILESTONE_NUMBER"
else
  echo "Milestone already exists: #$MILESTONE_NUMBER"
fi

create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"

  echo "==> Creating issue: $title"
  local url
  url="$(gh issue create \
    --repo "$OWNER/$REPO" \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$MILESTONE_TITLE")"

  echo "Adding to project #$PROJECT_NUMBER: $url"
  gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$url" >/dev/null
}

create_issue \
"chore: create clean Flutter repository structure" \
$'## Summary\nCreate the clean base structure for ASA Server Eye.\n\n## Tasks\n- initialize Flutter project\n- verify base folders\n- add README\n- create first clean commit\n\n## Acceptance Criteria\n- project builds successfully\n- repository is ready for feature branches' \
"chore,mvp,high-priority"

create_issue \
"chore: setup GitHub labels, milestones and project board" \
$'## Summary\nConfigure repository workflow management.\n\n## Tasks\n- create labels\n- create milestone v0.1.0 MVP\n- configure GitHub Project board\n- define board columns and workflow\n\n## Acceptance Criteria\n- board is usable for daily work\n- all MVP issues can be tracked' \
"chore,mvp"

create_issue \
"chore: define MVP scope for v0.1.0" \
$'## Summary\nDocument and lock the MVP scope.\n\n## In Scope\n- Servers\n- Favorites\n- Settings\n- Localization (de/en)\n\n## Out of Scope\n- Notifications\n- Player Sightings\n\n## Acceptance Criteria\n- MVP scope documented in README or docs' \
"chore,mvp,high-priority"

create_issue \
"feature: integrate current server list MVP into clean repository" \
$'## Summary\nMove the working server list implementation into the clean repo.\n\n## Tasks\n- import server list feature\n- verify loading states\n- verify refresh\n- verify navigation to details\n\n## Acceptance Criteria\n- server list works in new repo\n- detail navigation works' \
"feature,mvp,high-priority"

create_issue \
"feature: integrate favorites MVP into clean repository" \
$'## Summary\nMove the working favorites implementation into the clean repo.\n\n## Tasks\n- import favorites feature\n- verify add/remove favorite\n- verify persistence\n\n## Acceptance Criteria\n- favorites work in clean repo' \
"feature,mvp,high-priority"

create_issue \
"feature: add settings screen foundation" \
$'## Summary\nCreate the Settings screen base for MVP.\n\n## Tasks\n- add settings screen\n- add route/navigation\n- prepare placeholders for language/about/legal\n\n## Acceptance Criteria\n- settings screen is reachable from bottom navigation' \
"feature,ui,mvp"

create_issue \
"bug: synchronize favorites with live server data" \
$'## Summary\nFavorites must display the current server population instead of snapshot data.\n\n## Tasks\n- centralize server state\n- resolve favorites from live server cache\n- verify detail/list/favorites consistency\n\n## Acceptance Criteria\n- same server shows same population everywhere' \
"bug,mvp,high-priority"

create_issue \
"feature: setup Flutter localization infrastructure" \
$'## Summary\nAdd localization base setup.\n\n## Tasks\n- add flutter_localizations\n- enable generated localization\n- add l10n folder with ARB files\n- add locale controller\n\n## Acceptance Criteria\n- app compiles with localization enabled' \
"feature,localization,mvp,high-priority"

create_issue \
"feature: localize bottom navigation" \
$'## Summary\nTranslate all bottom navigation labels.\n\n## Acceptance Criteria\n- Servers/Favorites/Settings switch with locale' \
"feature,localization,mvp"

create_issue \
"feature: localize server list screen" \
$'## Summary\nTranslate all visible strings in the server list screen.\n\n## Acceptance Criteria\n- no hardcoded user-facing strings remain on server list' \
"feature,localization,mvp"

create_issue \
"feature: localize server detail screen" \
$'## Summary\nTranslate all visible strings in the server detail screen.\n\n## Acceptance Criteria\n- no hardcoded user-facing strings remain on detail screen' \
"feature,localization,mvp"

create_issue \
"feature: localize favorites screen" \
$'## Summary\nTranslate all visible strings in the favorites screen.\n\n## Acceptance Criteria\n- no hardcoded user-facing strings remain on favorites screen' \
"feature,localization,mvp"

create_issue \
"feature: localize settings screen" \
$'## Summary\nTranslate all visible strings in the settings screen.\n\n## Acceptance Criteria\n- language labels and settings labels are localized' \
"feature,localization,mvp"

create_issue \
"chore: replace all hardcoded strings" \
$'## Summary\nFinish localization by replacing every hardcoded UI string.\n\n## Acceptance Criteria\n- no user-facing hardcoded strings remain in MVP screens' \
"chore,localization,mvp"

create_issue \
"feature: add legal and about screens" \
$'## Summary\nCreate About, Privacy, Imprint, and Support entry points for MVP.\n\n## Acceptance Criteria\n- legal/info screens are reachable from Settings' \
"feature,ui,mvp"

create_issue \
"release: prepare Android MVP release" \
$'## Summary\nPrepare the first Android MVP release.\n\n## Tasks\n- verify app name/icon/version\n- verify release signing\n- create internal test build\n- prepare store metadata\n\n## Acceptance Criteria\n- Android release candidate is buildable' \
"release,mvp,high-priority"

echo
echo "Done."
echo "Repo: https://github.com/$OWNER/$REPO"
echo "Project: https://github.com/users/$OWNER/projects/$PROJECT_NUMBER"
