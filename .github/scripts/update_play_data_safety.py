#!/usr/bin/env python3
"""Build and publish ASA Server Eye's Google Play Data Safety declaration.

The script deliberately downloads Google's current CSV template at runtime.
That keeps the machine-readable question IDs under Google's control and makes
new required questions fail closed instead of silently publishing stale data.
"""

from __future__ import annotations

import csv
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

HELP_URL = (
    "https://support.google.com/googleplay/android-developer/answer/10787469?hl=en"
)
API_SCOPE = "https://www.googleapis.com/auth/androidpublisher"
DEFAULT_PACKAGE_NAME = "com.jchillah.asaservereye"
ACCOUNT_DELETION_URL = (
    "https://jchillah.github.io/asa-server-eye-privacy-policy/#delete-account"
)


@dataclass(frozen=True)
class DataUse:
    collected: bool = True
    shared: bool = False
    optional: bool = True
    collection_purposes: tuple[str, ...] = ("PSL_APP_FUNCTIONALITY",)
    sharing_purposes: tuple[str, ...] = ()


DATA_USES: dict[str, DataUse] = {
    # Firebase account/profile data. Username and UID are also present on
    # explicitly shared premium sighting documents; e-mail is not.
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
    # Optional profile image.
    "PSL_PHOTOS": DataUse(),
    # Purchase identifiers/tokens are stored to verify Premium entitlement.
    "PSL_PURCHASE_HISTORY": DataUse(
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_ACCOUNT_MANAGEMENT"),
    ),
    # User-created sightings and optional notes can be intentionally shared.
    "PSL_USER_GENERATED_CONTENT": DataUse(
        shared=True,
        sharing_purposes=("PSL_APP_FUNCTIONALITY",),
    ),
    # Favorites and alert-rule actions stored for app functionality.
    "PSL_OTHER_APP_ACTIVITY": DataUse(
        collection_purposes=("PSL_APP_FUNCTIONALITY", "PSL_PERSONALIZATION"),
    ),
    # Google Mobile Ads SDK automatic data collection/sharing. Google documents
    # these purposes as advertising, analytics and fraud prevention/security.
    "PSL_APPROX_LOCATION": DataUse(
        shared=True,
        optional=False,
        collection_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
        sharing_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
    ),
    "PSL_PERFORMANCE_DIAGNOSTICS": DataUse(
        shared=True,
        optional=False,
        collection_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
        sharing_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
    ),
    "PSL_USER_INTERACTION": DataUse(
        shared=True,
        optional=False,
        collection_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
        sharing_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
    ),
    # AdMob identifiers plus FCM token used for notifications.
    "PSL_DEVICE_ID": DataUse(
        shared=True,
        optional=False,
        collection_purposes=(
            "PSL_APP_FUNCTIONALITY",
            "PSL_DEVELOPER_COMMUNICATIONS",
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
        sharing_purposes=(
            "PSL_ADVERTISING",
            "PSL_ANALYTICS",
            "PSL_FRAUD_PREVENTION_SECURITY",
        ),
    ),
}


def fail(message: str) -> None:
    print(f"Data Safety error: {message}", file=sys.stderr)
    raise SystemExit(1)


def download_template(session: requests.Session) -> str:
    response = session.get(HELP_URL, timeout=30)
    response.raise_for_status()

    candidates = re.findall(
        r'https://storage\.googleapis\.com/[^"\'<>\\s]+', response.text
    )
    if not candidates:
        fail("Google's current sample CSV link could not be found")

    last_error: Exception | None = None
    for url in candidates:
        try:
            csv_response = session.get(url.replace("&amp;", "&"), timeout=30)
            csv_response.raise_for_status()
            text = csv_response.content.decode("utf-8-sig")
            if "Question ID (machine readable)" in text and "PSL_DATA_TYPES_" in text:
                return text
        except Exception as error:  # pragma: no cover - network fallback
            last_error = error

    fail(f"Google's sample CSV could not be downloaded: {last_error}")
    return ""


def set_value(row: dict[str, str], value: str) -> None:
    row["Response value"] = value


def configure_rows(rows: list[dict[str, str]]) -> None:
    selected_types = set(DATA_USES)

    for row in rows:
        question_id = row.get("Question ID (machine readable)", "")
        response_id = row.get("Response ID (machine readable)", "")
        label = row.get("Human-friendly question label", "")
        row["Response value"] = ""

        if question_id == "PSL_DATA_COLLECTION_COLLECTS_PERSONAL_DATA":
            set_value(row, "true")
            continue
        if question_id == "PSL_DATA_COLLECTION_ENCRYPTED_IN_TRANSIT":
            set_value(row, "true")
            continue
        if question_id == "PSL_DATA_COLLECTION_USER_REQUEST_DELETE":
            set_value(row, "true")
            continue

        # Newer templates may contain a separate deletion URL question.
        normalized_label = label.lower()
        if "delet" in normalized_label and "url" in normalized_label:
            set_value(row, ACCOUNT_DELETION_URL)
            continue

        if question_id.startswith("PSL_DATA_TYPES_"):
            if response_id in selected_types:
                set_value(row, "true")
            continue

        prefix = "PSL_DATA_USAGE_RESPONSES:"
        if not question_id.startswith(prefix):
            continue

        parts = question_id.split(":")
        if len(parts) < 3:
            continue
        data_type = parts[1]
        question = parts[2]
        spec = DATA_USES.get(data_type)
        if spec is None:
            continue

        if question == "PSL_DATA_USAGE_COLLECTION_AND_SHARING":
            if response_id == "PSL_DATA_USAGE_ONLY_COLLECTED" and spec.collected:
                set_value(row, "true")
            elif response_id == "PSL_DATA_USAGE_ONLY_SHARED" and spec.shared:
                set_value(row, "true")
        elif question == "PSL_DATA_USAGE_EPHEMERAL":
            set_value(row, "false")
        elif question == "DATA_USAGE_USER_CONTROL":
            expected = (
                "PSL_DATA_USAGE_USER_CONTROL_OPTIONAL"
                if spec.optional
                else "PSL_DATA_USAGE_USER_CONTROL_REQUIRED"
            )
            if response_id == expected:
                set_value(row, "true")
        elif question == "DATA_USAGE_COLLECTION_PURPOSE":
            if response_id in spec.collection_purposes:
                set_value(row, "true")
        elif question == "DATA_USAGE_SHARING_PURPOSE":
            if spec.shared and response_id in spec.sharing_purposes:
                set_value(row, "true")


def validate(rows: list[dict[str, str]]) -> None:
    present_types = {
        row.get("Response ID (machine readable)", "")
        for row in rows
        if row.get("Question ID (machine readable)", "").startswith("PSL_DATA_TYPES_")
    }
    missing_types = set(DATA_USES) - present_types
    if missing_types:
        fail(f"Current Google template is missing expected data types: {sorted(missing_types)}")

    # Every selected type needs collection/sharing, ephemeral, user control,
    # and at least one collection purpose. Shared types also need a purpose.
    for data_type, spec in DATA_USES.items():
        relevant = [
            row
            for row in rows
            if row.get("Question ID (machine readable)", "").startswith(
                f"PSL_DATA_USAGE_RESPONSES:{data_type}:"
            )
        ]
        selected = {
            (
                row.get("Question ID (machine readable)", "").split(":")[-1],
                row.get("Response ID (machine readable)", ""),
            )
            for row in relevant
            if row.get("Response value") in {"true", "false"}
        }
        questions_with_value = {
            row.get("Question ID (machine readable)", "").split(":")[-1]
            for row in relevant
            if row.get("Response value") in {"true", "false"}
        }
        required_questions = {
            "PSL_DATA_USAGE_COLLECTION_AND_SHARING",
            "PSL_DATA_USAGE_EPHEMERAL",
            "DATA_USAGE_USER_CONTROL",
            "DATA_USAGE_COLLECTION_PURPOSE",
        }
        if spec.shared:
            required_questions.add("DATA_USAGE_SHARING_PURPOSE")
        missing = required_questions - questions_with_value
        if missing:
            fail(f"Incomplete answers for {data_type}: {sorted(missing)}")

        if not any(
            q == "PSL_DATA_USAGE_COLLECTION_AND_SHARING"
            and r == "PSL_DATA_USAGE_ONLY_COLLECTED"
            for q, r in selected
        ):
            fail(f"{data_type} is not marked as collected")

    # Fail closed if Google adds a new globally-required question that this
    # script does not yet understand.
    for row in rows:
        requirement = row.get("Answer requirement", "")
        value = row.get("Response value", "")
        question_id = row.get("Question ID (machine readable)", "")
        if requirement == "REQUIRED" and not value:
            fail(f"Unhandled required Google question: {question_id}")


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
    request = google.auth.transport.requests.Request()
    credentials.refresh(request)

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
    session = requests.Session()
    template = download_template(session)
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
