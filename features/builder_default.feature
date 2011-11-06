Feature: Builder Default
  In order to preview localized html
  
  Scenario: EN should be at root
    Given a built app at "test-app"
    Then "index.html" should exist at "test-app" and include "Howdy"
    And cleanup built app at "test-app"
    
  Scenario: EN mounted at root should not be in directory
    Given a built app at "test-app"
    Then "en/index.html" should not exist at "test-app"
    And cleanup built app at "test-app"
    
  Scenario: Paths can be localized EN
    Given a built app at "test-app"
    Then "hello.html" should exist at "test-app" and include "Hello World"
    And cleanup built app at "test-app"
    
  Scenario: ES should be under namespace
    Given a built app at "test-app"
    Then "es/index.html" should exist at "test-app" and include "Como Esta?"
    And cleanup built app at "test-app"
    
  Scenario: Paths can be localized ES
    Given a built app at "test-app"
    Then "es/hola.html" should exist at "test-app" and include "Hola World"
    And cleanup built app at "test-app"