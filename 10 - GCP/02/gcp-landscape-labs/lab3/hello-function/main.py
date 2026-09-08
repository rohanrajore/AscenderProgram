"""hello-function — an HTTP function (supplied complete)."""
import functions_framework
from flask import jsonify


@functions_framework.http
def hello(request):
    name = request.args.get("name", "world")
    return jsonify({"message": f"hello, {name}", "from": "cloud-run-function"})
