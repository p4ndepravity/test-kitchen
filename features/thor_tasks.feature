Feature: Run `kitchen test` Thor tasks on individual instances and full collection
  In order to run `kitchen test` tasks with minimal setup under CI environments
  As an operator or CI script
  I want to run a Thor command to run `kitchen test` executions

  Background:
    Given a file named "Thorfile" with:
    """
    require 'kitchen/thor_tasks'
    Kitchen::ThorTasks.new
    """
    Given a file named ".kitchen.yml" with:
    """
    ---
    driver:
      name: dummy

    provisioner:
      name: dummy

    platforms:
      - name: cool
      - name: beans

    suites:
      - name: client
      - name: server
    """

  @spawn
  Scenario: Listing Thor tasks
    When I run `thor -T`
    Then the output should contain "thor kitchen:all"
    And the output should contain "thor kitchen:client-beans"
    And the output should contain "thor kitchen:client-cool"
    And the output should contain "thor kitchen:server-beans"
    And the output should contain "thor kitchen:server-cool"
    And the exit status should be 0

  @spawn
  Scenario: Running an instance task
    When I run `thor kitchen:server-beans`
    Then the output should contain "Testing <server-beans>"
    And the output should contain "Creating <server-beans>"
    And the output should contain "Converging <server-beans>"
    And the output should contain "Setting up <server-beans>"
    And the output should contain "Verifying <server-beans>"
    And the output should contain "Destroying <server-beans>"
    And the exit status should be 0

  @spawn
  Scenario: Running the "kitchen:all" task
    When I run `thor kitchen:all`
    Then the output should contain "Testing <client-cool>"
    Then the output should contain "Testing <client-beans>"
    Then the output should contain "Testing <server-cool>"
    Then the output should contain "Testing <server-beans>"
    And the exit status should be 0
