# pull-request-dependency-action
An action that checks for same-repo or external pull request dependencies using the GitHub Api    

Reference similar project: https://github.com/alvarocavalcanti/pierre-decheck

## Inputs

```yaml
  token:
    description: 'Access token'
    required: true
  repository-owner:
    description: 'Repository owner'
    required: true
  pull-request-body:
    description: 'Event Pull request body'
    required: true
```


## Example usage

```yaml
- name: Check pull request dependency
  uses: MarineXchange/pull-request-dependency-action@master
  with:
    token: ${{ secrets.GH_AUTH_TOKEN }}
    repository-owner: "MarineXchange"
    pull-request-payload: "${{ github.event.pull_request.body }}"
```

## Usage

Create a pull request  
Add "Depends on null" to the pull request body (description) for defining no dependency  
Add "Depends on repository/pullrequest-number" to the pull request body (description) for adding a dependency  

## Planned steps for dev
* Use Pull request opened/reopened/edited event
  * [Event reference](https://help.github.com/en/actions/reference/events-that-trigger-workflows#pull-request-event-pull_request)
  * [Payload reference](https://developer.github.com/v3/activity/events/types/#pullrequestevent)
* Check other repo if that PR has status 'merged'

## Open questions

Maybe run in a cron job, otherwise it doesn't get green without editing the PR? (if dependency got merged after this pr was created and check failed)
