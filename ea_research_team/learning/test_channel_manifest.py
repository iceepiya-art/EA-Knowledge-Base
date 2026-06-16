from channel_manifest import ChannelManifestStore


def test_scan_records_new_videos_and_skips_duplicates(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")

    first = store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {
                "video_id": "v001",
                "title": "A",
                "url": "https://youtu.be/v001",
                "published": "2026-01-01",
            },
            {
                "video_id": "v002",
                "title": "B",
                "url": "https://youtu.be/v002",
                "published": "2026-01-02",
            },
        ],
    )
    second = store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {
                "video_id": "v001",
                "title": "A updated",
                "url": "https://youtu.be/v001",
                "published": "2026-01-01",
            },
            {
                "video_id": "v003",
                "title": "C",
                "url": "https://youtu.be/v003",
                "published": "2026-01-03",
            },
        ],
    )

    assert first["new"] == 2
    assert first["duplicates"] == 0
    assert second["new"] == 1
    assert second["duplicates"] == 1
    assert store.count_by_status()["discovered"] == 3


def test_scan_records_and_updates_video_duration(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")

    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {
                "video_id": "v001",
                "title": "A",
                "url": "https://youtu.be/v001",
                "duration": 120,
            },
        ],
    )
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {
                "video_id": "v001",
                "title": "A updated",
                "url": "https://youtu.be/v001",
                "duration": 180,
            },
        ],
    )

    video = store.load()["videos"]["v001"]
    assert video["duration"] == 180


def test_unlearned_videos_excludes_written_and_conflict_statuses(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {"video_id": "v001", "title": "A", "url": "https://youtu.be/v001"},
            {"video_id": "v002", "title": "B", "url": "https://youtu.be/v002"},
            {"video_id": "v003", "title": "C", "url": "https://youtu.be/v003"},
        ],
    )
    store.update_video_status("v001", "written", note_paths=["raw/youtube/v001.md"])
    store.update_video_status("v002", "conflict")

    unlearned = store.get_unlearned_videos()

    assert [video["video_id"] for video in unlearned] == ["v003"]
