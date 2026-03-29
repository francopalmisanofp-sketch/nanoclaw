#!/bin/bash
set -e
cd /app && npx tsc --outDir /tmp/dist 2>&1 >&2
ln -s /app/node_modules /tmp/dist/node_modules
chmod -R a-w /tmp/dist
cat > /tmp/input.json
# Extract modelOverride from input JSON and export as env var
MODEL=$(node -e "try{const j=JSON.parse(require('fs').readFileSync('/tmp/input.json','utf8'));if(j.modelOverride)console.log(j.modelOverride)}catch(e){}")
if [ -n "$MODEL" ]; then export ANTHROPIC_MODEL="$MODEL"; fi
node /tmp/dist/index.js < /tmp/input.json
