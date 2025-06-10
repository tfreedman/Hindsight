import base64, hashlib, hmac, json, pathlib, struct, sys
from typing import Any, Sequence


def main(args: Sequence[str]) -> None:
	version: int = 1
	enddt: float = -1.0
	mxc: str = args[1]
	message: bytes = struct.pack(">d", enddt) + mxc.encode("UTF-8")
	
	keyfile: pathlib.Path = pathlib.Path(args[0])
	keydata: Any = json.loads(keyfile.read_bytes())
	key: bytes = base64.urlsafe_b64decode(keydata["k"] + '=')
	signature: bytes = hmac.digest(key, message, hashlib.sha512)
	
	token: bytes = struct.pack(">B", version) + signature + message
	print(base64.urlsafe_b64encode(token).decode("UTF-8").replace("=", ""))


if __name__ == "__main__":
	main(sys.argv[1 : ])
