Feature: ci

  In order to know I have working software
  As a software delivery team member
  I want to receive notifications from my ci build

  @wip
  Scenario: no previous state and passing build
    Given I have ci jobs:
    | name | status  | activity |
    | job1 | success | sleeping |
    | job2 | success | sleeping |
    And a stdout ci handler
    When I engage in chicanery
    Then the exit status should be 0
    And the stdout should contain:
    """
    job1 is ok
    job2 is ok
    all jobs are ok
    """