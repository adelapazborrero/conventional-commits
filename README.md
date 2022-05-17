# Conventional-commits

Github action to test that latest commit follows standard rules
Will grab your latest commit and test the following:

  - Starts with conventional rule
    - If not, throws error
  - Checks if has scope
  - Check if has breaking change
  - Check if commit title is shorter than 72 characters
    - If longer, throws error
  - Check if has `refs:`
    - If not, throws warning

## How to use

```shell
  check_conventional_commit:
    name: Validate commit message 
    needs: check_commit_limit

    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
          ref: ${{github.event.after}}

      - name: Get Commit Message
        run: |
          MSG=$(git log --format=%B -n 1 ${{github.event.after}})
          echo "COMMIT_MESSAGE=$(echo ${MSG})" >> $GITHUB_ENV

      - name: Get Commit Title 
        run: |
          MSG=$(git log --format=%s -n 1 ${{github.event.after}})
          echo "COMMIT_MESSAGE_TITLE=$(echo ${MSG})" >> $GITHUB_ENV

      - name: Check conventional commit
        uses: Abeldlp/conventional-commits@v1.0.5
        with:
          github_commit: "${{env.COMMIT_MESSAGE}}"
          commit_title: "${{env.COMMIT_MESSAGE_TITLE}}"
```
