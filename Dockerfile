FROM alpine:3.10

COPY test_commit_message.sh /test_commit_message.sh

ENTRYPOINT ["/test_commit_message.sh"]
