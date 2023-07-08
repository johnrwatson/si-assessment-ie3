# John Watson - Infrastructure Engineer Technical Test - systeminit

## Overview

 This test aims to build, validate, containerize, and deploy a backend and frontend service to a cloud platform.

## Approach

I have broken the approach into three sections: Development Flow, Continuous Integration and then finally Continuous Delivery.

Hopefully this makes it easier to follow the path I have taken. I have also outlined the reasoning behind each of the bullets in the below list, along with the PR(s) that added that functionality if that helps.

## General Summary of Functionality:
1. Cut main and raise a PR back in with any changes you wish to introduce
2. CI will run off the PR and run build, testing + docker upload into GCR
3. On merge into main the commits will be analysed and the relevant tag will be added to the HEAD commit of main based on the commit messages.
4. Once the tag is added, a new workflow run will start to promote that tag/build into the development environment.

## Path Checklist

1. Development Flow: Branch protection, code integrity, and establish development flow:
   - [X] Add to README.md with details of the task
         - https://github.com/johnrwatson/si-assessment-ie3/pull/1
   - [X] Setup branch restrictions/push policies
         - Protecting release branches is critical to making sure you have some basic protection measures over the mainline. What would happen if someone accidentally force rebased over all the commits in main? This stops that happening and lots of other accidental or intentional behaviour. NB: without Github enterprise the rules are there but they are not enforced.
   - [X] Setup precommit
         - Precommit allows an organisation or project to assert specific standards on commit types and usually some basic rules like whitespace management. It can be a little annoying if implemented poorly, so I usually find it best to keep it simple with as few external dependencies as possible
         - https://github.com/johnrwatson/si-assessment-ie3/pull/2
   - [X] Setup semantic release
         - Semantic Release builds on the rules from the precommit hook and asserts that the expected release happens. In this github workflow it runs on all commits. On main it will execute the actual release of the tag onto main (creating a real release version). On all other branches it will simply log output the version that would be created if the PR was merged (assuming that it's up to date from a git perspective with main). This can be a handy way for developers to check the release impact they intend to create will happen before they merge.
         - It's noteworthy here that the frontend and backend are going to be tagged as a version together. This may or may not be ideal depending on organisation choice. Normally the Frontend and Backend would have separate repositories where each are individually versioned. When separated, it also allows you to individually build and ship each component which may be rewarding from a velocity standpoint. In this case, where they are so closely tied together and probably direct dependent on each other at a chosen version (and for the sake of keeping things simple) I have tagged the repository as a single tag, rather than splitting my application variant.
         - Because I plan to hook github workflows together, I am going to use a personal github token coined PA_TOKEN. This is the user token that will conduct the release of the tag, but also trigger any downstream workflows on the tag itself. If you use the default GITHUB_TOKEN it will stop you chaining workflows together to prevent workflow run-away. If this repository is to be forked the PA_TOKEN variable will need added to the repository as an action secret to allow semantic release to happen correctly. The token will need read and write into the repository code, along with conducting releases. See https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens for how to create user tokens.
         - https://github.com/johnrwatson/si-assessment-ie3/pull/3

2. CI (Continuous Integration): Build, Test, and Release flow:
   - [X] Build + Containerize the applications, with local deployment validation
         - Added a hosting/docker/Dockerfile into each application path and added a Makefile that allows quick validation of build, e.g. `make build-fe`. Additionally, `make deploy` immediately deploys the two tags of si-assessment-ie3-backend:latest and si-assessment-ie3-frontned:latest, which would be available locally if `make build-fe` / `make build-be` were used. The `local-development/docker-compose-stack.yml` file can be manipulated accordingly if the developer or tester wanted to check two different versions of the services together. On `make deploy` the frontend service can be reached on x and the backend service can be reached on y. Also individually added a `make validate-be` and `make validate-fe` function to quickly validate the basic http integrity of the application variant. This ensures that no code changes makes it very far without maintaining application integrity while the unit-tests and other code-validation still pass. This should stop non-compatible changes in the origin baseimage adversely affecting the compatibility with the code at a basic level.
         - Added all the above checks in a basic CI build pipeline
         - `frontend/src/stores/task.ts` and `frontend/src/stores/user.ts` were adjusted (poorly) to allow the backend and frontend to talk together in a docker-based environment. This could be refactored later to be an environment variable or similar (conducted in pull/7).
         - https://github.com/johnrwatson/si-assessment-ie3/pull/4
   - [X] Initiate tests in CI
     - All code-level tests added as a matrix to save as much time as possible in CI/feedback. In reality developer/tester time is magnitudes more important than CI cost, so this is the preferable route in most situations. Added an SBOM Generation to the tail end of the build workflow. This isn't ideal as it's a bit untidy and slows the critical path (with the build already being the slowest task) but in total it's only ~1 minute which is pretty quick. I couldn't quite get the Trivy scan to work in the pipeline within the time constraints but the example workflow provided (commented out) is very close, just an envrionment issue/diff between local:remote.
     - [X] Application Integrity: -
           - https://github.com/johnrwatson/si-assessment-ie3/pull/4
     - [X] Lint
           - https://github.com/johnrwatson/si-assessment-ie3/pull/5
     - [X] Unit Test
           - https://github.com/johnrwatson/si-assessment-ie3/pull/5
     - [ ] Security Scan
           - https://github.com/johnrwatson/si-assessment-ie3/pull/5
     - [X] SBOM Generation
           - https://github.com/johnrwatson/si-assessment-ie3/pull/5
   - [X] Initiate release flow to an Artifact Registry
           - On merge to main, it deploys the latest tags into a GCR respository (one for frontend, one for backend).
           - https://github.com/johnrwatson/si-assessment-ie3/pull/7
   - [ ] Register the service with the Artifact Database
           - Unfortunately didn't get time to get around to this, but registering the built artifacts in a metadata store would allow us to query their status and quality before deployment time. I.e. on test pass we register a key against the artifact in a metadatastore and then at deployment time we can query whether the artifact meets our criteria to be active in the given environment. For example, if we needed to have a SBOM (software bill of materials) available to run something in Production for complaince reasons, the metadata service would inform us whether that is the case or not.

3. CD (Continuous Delivery): Deploying the Applications
   - [X] Establish some baseline/basic IaC for environments
           - Created a very basic development environment using a Google Kubernetes Engine cluster in Autopilot mode. Leveraged my personal project (artifact-flow) using the free tier in us-west-1 for both the bucket for TF state and the cluster itself. Added a very basic github workflow for the creation and destruction of the infrastructure via CI. Usually this infrastructure wouldn't be within this repository and on-merge of the separate IaC repository the TF would be planned and applied automatically.
           - https://github.com/johnrwatson/si-assessment-ie3/pull/6
   - [ ] Automatic validation environment for development branches
           - Unfortunately didn't get time to get around to this, but I would have loved on PR creation for a development environment of the stack to be spun up to validate it. This has proved invaluable in the past for some of the projects I have worked on where development velocity is of highest criticality.
   - [X] Development environment establishment with Artifact metadata validation
           - Added a Google Kubernetes Autopilot cluster with a basic kubernetes manifest to deploy into the development environment

## Other Considerations
1. If the cluster or the kubernetes service is deleted the service IP built into the application will rotate, which will need a git update within the app before it will function as expected for the callout to the backend. This could be significantly improved so an artifact rebuild is not required.
2. If forking the repository, you will need to add both a PA_TOKEN but also a valid key for my personal GCP project in the form of the GOOGLE_CREDENTIALS variable. I've added all the reviewers as contributors so they can cut a branch + just work it through within my repository. If the PA_TOKEN variable is missing the semantic versioning will not function. Without the GOOGLE_CREDENTIALS the pipeline will be unable to push into GCR or deploy into the GKE cluster.
3. On the enterprise version of the CI system for Github it won't queue builds like it does on my free account, this will speed up the build if queueing is occuring.
4. It's critical that CI pipeline files are as clean as possible to make them easy to maintain. A lot of the "shell" within the CI files I would like to refactor out into centralised functions to make them as re-usable and clean as possible across multiple projects.
5. FE Application will be available on http://35.247.107.51:8080/ and BE on http://35.247.107.51:3030/. After pipeline finished the pods take ~2 minutes to apply the new version. In a production scenario you would simply use a k8s rollout strategy (blue/green or canary or similar) to get around this downtime between versions.
