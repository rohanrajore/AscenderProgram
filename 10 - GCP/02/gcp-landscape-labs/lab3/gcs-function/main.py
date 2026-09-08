"""gcs-function — an event-driven function (supplied complete).
Fires when an object is finalized in a bucket; logs what arrived. Nothing to edit.
"""
import functions_framework
from cloudevents.http import CloudEvent


@functions_framework.cloud_event
def on_upload(cloud_event: CloudEvent) -> None:
    data = cloud_event.data
    print(f"new object: gs://{data['bucket']}/{data['name']}  size={data.get('size')} bytes  type={data.get('contentType')}")
    print(f"event id={cloud_event['id']} type={cloud_event['type']}")
