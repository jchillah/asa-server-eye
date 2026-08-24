#!/usr/bin/env python3
"""Deploy Firestore Security Rules through the official Firebase Rules REST API.

This intentionally avoids firebase-tools' Service Usage preflight. Google still
checks the actual firebaserules permissions when the ruleset and release are
created/updated, so no authorization check is bypassed.
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

import google.auth.transport.requests
from google.oauth2 import service_account
import requests

API_SCOPE = "https://www.googleapis.com/auth/cloud-platform"
BASE_URL = "https://firebaserules.googleapis.com/v1"
DEFAULT_PROJECT = "asa-server-eye"
DEFAULT_RULES_FILE = "firestore.rules"
DEFAULT_RELEASE = "cloud.firestore"


def fail(message: str) -> None:
    print(f"Firestore Rules error: {message}", file=sys.stderr)
    raise SystemExit(1)


def authorized_session() -> requests.Session:
    credentials_path = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not credentials_path:
        fail("GOOGLE_APPLICATION_CREDENTIALS is not set")

    credentials = service_account.Credentials.from_service_account_file(
        credentials_path,
        scopes=[API_SCOPE],
    )
    credentials.refresh(google.auth.transport.requests.Request())

    session = requests.Session()
    session.headers.update(
        {
            "Authorization": f"Bearer {credentials.token}",
            "Content-Type": "application/json",
        }
    )
    return session


def request_json(
    session: requests.Session,
    method: str,
    url: str,
    *,
    payload: dict | None = None,
    params: dict | None = None,
    allow_404: bool = False,
) -> dict | None:
    response = session.request(
        method,
        url,
        data=json.dumps(payload) if payload is not None else None,
        params=params,
        timeout=60,
    )
    if allow_404 and response.status_code == 404:
        return None
    if not response.ok:
        fail(f"{method} {url} returned {response.status_code}: {response.text[:2000]}")
    if not response.content:
        return {}
    return response.json()


def main() -> None:
    project = os.environ.get("FIREBASE_PROJECT_ID", DEFAULT_PROJECT)
    rules_path = Path(os.environ.get("FIRESTORE_RULES_FILE", DEFAULT_RULES_FILE))
    if not rules_path.is_file():
        fail(f"Rules file not found: {rules_path}")

    rules = rules_path.read_text(encoding="utf-8")
    if len(rules.encode("utf-8")) >= 256 * 1024:
        fail("Rules file exceeds Firebase's 256 KiB source limit")

    session = authorized_session()
    project_name = f"projects/{project}"
    source = {"files": [{"name": rules_path.name, "content": rules}]}

    # Test syntax/semantics first. ERROR issues block deployment; warnings are
    # printed for audit but do not prevent a valid release.
    test_result = request_json(
        session,
        "POST",
        f"{BASE_URL}/{project_name}:test",
        payload={"source": source},
    ) or {}
    issues = test_result.get("issues", [])
    errors = [issue for issue in issues if issue.get("severity") == "ERROR"]
    for issue in issues:
        position = issue.get("sourcePosition", {})
        print(
            "Rules issue "
            f"[{issue.get('severity', 'UNKNOWN')}] "
            f"{position.get('fileName', rules_path.name)}:"
            f"{position.get('line', '?')}:"
            f"{position.get('column', '?')} - "
            f"{issue.get('description', '')}"
        )
    if errors:
        fail(f"Rules validation returned {len(errors)} error(s)")

    ruleset = request_json(
        session,
        "POST",
        f"{BASE_URL}/{project_name}/rulesets",
        payload={"source": source},
    ) or {}
    ruleset_name = ruleset.get("name")
    if not ruleset_name:
        fail("Firebase Rules API did not return a ruleset name")

    release_name = f"{project_name}/releases/{DEFAULT_RELEASE}"
    existing_release = request_json(
        session,
        "GET",
        f"{BASE_URL}/{release_name}",
        allow_404=True,
    )

    release_payload = {
        "name": release_name,
        "rulesetName": ruleset_name,
    }

    if existing_release is None:
        released = request_json(
            session,
            "POST",
            f"{BASE_URL}/{project_name}/releases",
            payload=release_payload,
        )
    else:
        released = request_json(
            session,
            "PATCH",
            f"{BASE_URL}/{release_name}",
            payload=release_payload,
            params={"updateMask": "rulesetName"},
        )

    if not released or released.get("rulesetName") != ruleset_name:
        fail("Firebase Rules release did not point to the newly created ruleset")

    print(f"Firestore rules deployed successfully: {ruleset_name}")


if __name__ == "__main__":
    main()
