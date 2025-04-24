#/bin/bash

sourcedocs generate --collapsible -r -o Documents --min-acl public -- -scheme Montage -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 16,OS=latest" -scmProvider system
