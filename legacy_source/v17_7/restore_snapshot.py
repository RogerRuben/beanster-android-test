#!/usr/bin/env python3
from pathlib import Path
import base64, gzip, json, hashlib
HERE=Path(__file__).resolve().parent
manifest=json.loads((HERE/'manifest.json').read_text(encoding='utf-8'))
for name, meta in manifest.items():
    enc=meta.get('encoded')
    if not enc: continue
    data=gzip.decompress(base64.b64decode((HERE/enc).read_text()))
    got=hashlib.sha256(data).hexdigest()
    if got!=meta['sha256']: raise SystemExit(f'hash mismatch: {name}')
    dst=HERE/'restored'/name
    dst.parent.mkdir(parents=True,exist_ok=True)
    dst.write_bytes(data)
    print('restored',name)
