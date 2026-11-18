---
type: llm
weight: 2
---

PASS when all of these hold:

1. The answer leads with CVE-2026-31337: high severity and in CISA's Known Exploited Vulnerabilities catalog (exploited in the wild), with a due date of 1 December 2026 or a high EPSS score mentioned. It treats it as a reason not to ship 2.1.0 as it is.
2. It says the fix is 2.1.1, and that 2.1.1 is not in the registry yet (the newest stored version is 2.1.0), or at least that it should be checked before relying on it.
3. It mentions the medium finding CVE-2026-29001 as lower priority with no fix available.
4. It reports the licenses: MIT, plus "Acme Internal Use License" that could not be resolved and needs a human review.
5. It does not call the version "safe" or "clean" outright, and it does not claim to have approved, released, quarantined or rescanned anything.

FAIL otherwise.
