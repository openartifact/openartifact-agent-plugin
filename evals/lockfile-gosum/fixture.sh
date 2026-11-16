#!/usr/bin/env bash
# SPDX-FileCopyrightText: The OpenArtifact Authors
#
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail
printf 'export GOPROXY := https://oa.example.test/repos/go-all\n\nbuild:\n\tgo build ./...\n' > Makefile
cat > go.mod <<'MOD'
module example.com/acme/app

go 1.27

require (
	example.com/acme/quote v1.5.2
	example.com/acme/uuid v1.6.0
)

require (
	example.com/acme/sampler v1.3.0 // indirect
	example.com/acme/text v0.0.0-20170915032832-14c0d48ead0c // indirect
)
MOD
cat > go.sum <<'SUM'
example.com/acme/mod v0.17.0/go.mod h1:hTbmBsO62+eylJbnUtE2MGJUyE7QWk4xUqPFrRgJ+7c=
example.com/acme/quote v1.5.2 h1:w5fcysjrx7yqtD/aO+QwRjYZOKnaM9Uh2b40tElTs3Y=
example.com/acme/quote v1.5.2/go.mod h1:LzX7hefJvL54yjefDEDHNONDjII0t9xZLPXsUe+TKr0=
example.com/acme/sampler v1.3.0 h1:7uVkIFmeBqHfdjD+gZwtXXI+RODJ2Wc4O7MPEh/QiW4=
example.com/acme/sampler v1.3.0/go.mod h1:T1hPZKmBbMNahiBKFy5HrXp6adAjACjK9JXDnKaTXpA=
example.com/acme/text v0.0.0-20170915032832-14c0d48ead0c h1:qgOY6WgZOaTkIIMiVjBQcw93ERBE4m30iBm00nkL0i8=
example.com/acme/text v0.0.0-20170915032832-14c0d48ead0c/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
example.com/acme/uuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
example.com/acme/uuid v1.6.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
SUM
