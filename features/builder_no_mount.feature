Feature: Builder No Mount
  In order to preview localized html
  
  Scenario: EN should be at root
    Given a built app at "no-mount-app"
    Then "en/index.html" should exist at "no-mount-app" and include "Howdy"
    And cleanup built app at "no-mount-app"
    
  Scenario: EN mounted at root should not be in directory
    Given a built app at "no-mount-app"
    Then "index.html" should not exist at "no-mount-app"
    And cleanup built app at "no-mount-app"
    
  Scenario: Paths can be localized EN
    Given a built app at "no-mount-app"
    Then "en/hello.html" should exist at "no-mount-app" and include "Hello World"
    And cleanup built app at "no-mount-app"
    
  Scenario: EN mounted at root should not be in directory
    Given a built app at "no-mount-app"
    Then "hello.html" should not exist at "no-mount-app"
    And cleanup built app at "no-mount-app"
    
  Scenario: ES should be under namespace
    Given a built app at "test-app"
    Then "es/index.html" should exist at "test-app" and include "Como Esta?"
    And cleanup built app at "test-app"
    
  Scenario: Paths can be localized ES
    Given a built app at "test-app"
    Then "es/hola.html" should exist at "test-app" and include "Hola World"
    And cleanup built app at "test-app"