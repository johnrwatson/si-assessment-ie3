# Commit Message Type/Prefix and Impact on Semantic Release

This README.md file provides a table that outlines different commit message types/prefixes and their corresponding impact on semantic release versioning.

Versions are assumed to be constructed in the following format `Major.Minor.Patch`

This is just an example standard for an organisation, can be adjusted accordingly. The precommit hook will enforce the above, ensuring everyone in the organisation has the same expectations of intent for releases versions.

| Commit Message Type/Prefix | Impact on Semantic Release      |
| -------------------------- | ------------------------------- |
| breaking                   | Increment Major version         |
| feat                       | Increment Minor Version         |
| minor                      | Increment Minor Version         |
| hotfix                     | Increment Patch Version         |
| fix                        | Increment Patch Version         |
| chore                      | Increment Patch Version         |
| docs                       | Increment Patch Version         |
| style                      | Increment Patch Version         |
| perf                       | Increment Patch Version         |
| test                       | Increment Patch Version         |
| patch                      | Increment Patch Version         |
| build                      | Rejected by precommit & tooling |
| cicd                       | Rejected by precommit & tooling |
| refactor                   | Rejected by precommit & tooling |
| !                          | Rejected                        |
| any-other-prefix           | Rejected                        |

Note: Regardless of the commit message type, if the commit footer contains the text "BREAKING CHANGE", the Major version will be incremented.
