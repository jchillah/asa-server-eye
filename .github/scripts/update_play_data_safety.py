#!/usr/bin/env python3
"""Generate and publish ASA Server Eye's Google Play Data Safety CSV."""

from __future__ import annotations

import csv
import html
import io
import json
import os
import re
import sys
from dataclasses import dataclass
from typing import Iterable

import google.auth.transport.requests
from google.oauth2 import service_account
import requests

HELP_URL = "https://support.google.com/googleplay/android-developer/answer/10787469?hl=en"
# Current official sample linked by the Play Console Help article. The help
# page is client-rendered for some requests, so keep the official object as a
# validated fallback while still discovering newer links first.
OFFICIAL_SAMPLE_FALLBACK = (
    "https://storage.googleapis.com/support-kms-prod/"
    "b5v9It2EgwrgyY1gPFVB3jPUypc5lL3oNg2G"
)
API_SCOPE = "https://www.googleapis.com/auth/androidpublisher"
DEFAULT_PACKAGE_NAME = "com.jchillah.asaservereye"
ACCOUNT_DELETION_URL = (
    "https://jchillah.github.io/asa-server-eye-privacy-policy/#delete-account"
)


@dataclass(frozen=True)
class DataUse:
    shared: bool = False
    optional: bool = True
    collection_purposes: tuple[str, ...] = ("PSL_APP_FUNCTIONALITY",)
    sharing_purposes: tuple[str, ...] = ()


AD_PURPOSES = (
    "PSL_ADVERTISING",
    "PSL_ANALYTICS",
    "PSL_FRAUD_PREVENTION_SECURITY",
)

DATA_USES: dict[str, DataUse] = {
    "PSL_NAME": DataUse(
        shared=True,
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_ACCOUNT_MANAGEMENT"),
        sharing_purposes=("PSL_APP_FUNCTIONALITY",),
    ),
    "PSL_EMAIL": DataUse(
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_ACCOUNT_MANAGEMENT"),
    ),
    "PSL_USER_ACCOUNT": DataUse(
        shared=True,
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_ACCOUNT_MANAGEMENT"),
        sharing_purposes=("PSL_APP_FUNCTIONALITY",),
    ),
    "PSL_PHOTOS": DataUse(),
    "PSL_PURCHASE_HISTORY": DataUse(
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_ACCOUNT_MANAGEMENT"),
    ),
    "PSL_USER_GENERATED_CONTENT": DataUse(
        shared=True,
        sharing_purposes=("PSL_APP_FUNCTIONALITY",),
    ),
    "PSL_OTHER_APP_ACTIVITY": DataUse(
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_PERSONALIZATION"),
    ),
    "PSL_APPROX_LOCATION": DataUse(
        shared=True,
        optional=False,
        collection_purposes=AD_PURPOSES,
        sharing_purposes=AD_PURPOSES,
    ),
    "PSL_PERFORMANCE_DIAGNOSTICS": DataUse(
        shared=True,
        optional=False,
        collection_purposes=AD_PURPOSES,
        sharing_purposes=AD_PURPOSES,
    ),
    "PSL_USER_INTERACTION": DataUse(
        shared=True,
        optional=False,
        collection_purposes=AD_PURPOSES,
        sharing_purposes=AD_PURPOSES,
    ),
    "PSL_DEVICE_ID": DataUse(
        shared=True,
        optional=False,
        collection_purposes=(
            "PSL_APP_FUNCTIONALITY",
            "PSL_DEVELOPER_COMMUNICATIONS",
            *AD_PURPOSES,
        ),
        sharing_purposes=AD_PURPOSES,
    ),
}


def fail(message: str) -> None:
    print(f"Data Safety error: {message}", file=sys.stderr)
    raise SystemExit(1)


def _is_valid_template(text: str) -> bool:
    return (
        "Question ID (machine readable)" in text
        and "Response value" in text
        and "PSL_DATA_TYPES_" in text
    )


def download_template(session: requests.Session) -> str:
    candidates: list[str] = []
    try:
        response = session.get(HELP_URL, timeout=30)
        response.raise_for_status()
        decoded = html.unescape(response.text)
        candidates.extend(
            re.findall(
                r"https://storage\.googleapis\.com/[A-Za-z0-9_./?=&%-]+",
                decoded,
            )
        )
    except requests.RequestException as error:
        print(f"Warning: Help page lookup failed: {error}", file=sys.stderr)

    candidates.append(OFFICIAL_SAMPLE_FALLBACK)
    seen: set[str] = set()
    last_error: Exception | None = None

    for url in candidates:
        if url in seen:
            continue
        seen.add(url)
        try:
            response = session.get(url, timeout=30)
            response.raise_for_status()
            text = response.content.decode("utf-8-sig")
            if _is_valid_template(text):
                print(f"Using Google Data Safety template: {url}")
                return text
        except Exception as error:  # pragma: no cover - network fallback
            last_error = error

    fail(f"Google's current sample CSV could not be downloaded: {last_error}")
    return ""


def configure_rows(rows: list[dict[str, str]]) -> None:
    selected_types = set(DATA_USES)

    for row in rows:
        question_id = row.get("Question ID (machine readable)", "")
        response_id = row.get("Response ID (machine readable)", "")
        label = row.get("Human-friendly question label", "").lower()
        row["Response value"] = ""

        if question_id in {
            "PSL_DATA_COLLECTION_COLLECTS_PERSONAL_DATA",
            "PSL_DATA_COLLECTION_ENCRYPTED_IN_TRANSIT",
            "PSL_DATA_COLLECTION_USER_REQUEST_DELETE",
        }:
            row["Response value"] = "true"
            continue

        if "delet" in label and "url" in label:
            row["Response value"] = ACCOUNT_DELETION_URL
            continue

        if question_id.startswith("PSL_DATA_TYPES_"):
            if response_id in selected_types:
                row["Response value"] = "true"
            continue

        prefix = "PSL_DATA_USAGE_RESPONSES:"
        if not question_id.startswith(prefix):
            continue

        parts = question_id.split(":")
        if len(parts) < 3:
            continue
        data_type, question = parts[1], parts[2]
        spec = DATA_USES.get(data_type)
        if spec is None:
            continue

        if question == "PSL_DATA_USAGE_COLLECTION_AND_SHARING":
            if response_id == "PSL_DATA_USAGE_ONLY_COLLECTED":
                row["Response value"] = "true"
            elif response_id == "PSL_DATA_USAGE_ONLY_SHARED" and spec.shared:
                row["Response value"] = "true"
        elif question == "PSL_DATA_USAGE_EPHEMERAL":
            row["Response value"] = "false"
        elif question == "DATA_USAGE_USER_CONTROL":
            expected = (
                "PSL_DATA_USAGE_USER_CONTROL_OPTIONAL"
                if spec.optional
                else "PSL_DATA_USAGE_USER_CONTROL_REQUIRED"
            )
            if response_id == expected:
                row["Response value"] = "true"
        elif question == "DATA_USAGE_COLLECTION_PURPOSE":
            if response_id in spec.collection_purposes:
                row["Response value"] = "true"
        elif question == "DATA_USAGE_SHARING_PURPOSE":
            if spec.shared and response_id in spec.sharing_purposes:
                row["Response value"] = "true"


def validate(rows: list[dict[str, str]]) -> None:
    present_types = {
        row.get("Response ID (machine readable)", "")
        for row in rows
        if row.get("Question ID (machine readable)", "").startswith("PSL_DATA_TYPES_")
    }
    missing_types = set(DATA_USES) - present_types
    if missing_types:
        fail(f"Google template is missing expected data types: {sorted(missing_types)}")

    for data_type, spec in DATA_USES.items():
        prefix = f"PSL_DATA_USAGE_RESPONSES:{data_type}:"
        relevant = [
            row
            for row in rows
            if row.get("Question ID (machine readable)", "").startswith(prefix)
        ]
        answered_questions = {
            row["Question ID (machine readable)"].split(":")[-1]
            for row in relevant
            if row.get("Response value") in {"true", "false"}
        }
        required = {
            "PSL_DATA_USAGE_COLLECTION_AND_SHARING",
            "PSL_DATA_USAGE_EPHEMERAL",
            "DATA_USAGE_USER_CONTROL",
            "DATA_USAGE_COLLECTION_PURPOSE",
        }
        if spec.shared:
            required.add("DATA_USAGE_SHARING_PURPOSE")
        missing = required - answered_questions
        if missing:
            fail(f"Incomplete answers for {data_type}: {sorted(missing)}")

    for row in rows:
        if row.get("Answer requirement") == "REQUIRED" and not row.get(
            "Response value"
        ):
            fail(
                "Unhandled required Google question: "
                f"{row.get('Question ID (machine readable)', '')}"
            )


def render_csv(fieldnames: list[str], rows: Iterable[dict[str, str]]) -> str:
    output = io.StringIO(newline="")
    writer = csv.DictWriter(output, fieldnames=fieldnames, lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)
    return output.getvalue()


def publish(csv_text: str) -> None:
    credentials_path = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not credentials_path:
        fail("GOOGLE_APPLICATION_CREDENTIALS is not set")

    credentials = service_account.Credentials.from_service_account_file(
        credentials_path,
        scopes=[API_SCOPE],
    )
    credentials.refresh(google.auth.transport.requests.Request())
    package_name = os.environ.get("PLAY_PACKAGE_NAME", DEFAULT_PACKAGE_NAME)
    url = (
        "https://androidpublisher.googleapis.com/androidpublisher/v3/"
        f"applications/{package_name}/dataSafety"
    )
    response = requests.post(
        url,
        headers={
            "Authorization": f"Bearer {credentials.token}",
            "Content-Type": "application/json",
        },
        data=json.dumps({"safetyLabels": csv_text}),
        timeout=60,
    )
    if not response.ok:
        fail(
            f"Google Play Data Safety API returned {response.status_code}: "
            f"{response.text[:2000]}"
        )
    print("Google Play Data Safety declaration updated successfully.")


def main() -> None:
    template = download_template(requests.Session())
    reader = csv.DictReader(io.StringIO(template))
    if reader.fieldnames is None:
        fail("Google template has no CSV header")
    rows = list(reader)
    configure_rows(rows)
    validate(rows)
    csv_text = render_csv(reader.fieldnames, rows)

    output_path = os.environ.get("DATA_SAFETY_OUTPUT")
    if output_path:
        with open(output_path, "w", encoding="utf-8", newline="") as output:
            output.write(csv_text)

    publish(csv_text)


if __name__ == "__main__":
    main()
