Feature: Builder Alt Path
  In order to preview localized html
  
  Scenario: EN should be at root
    Given a built app at "alt-path-app"
    Then "index.html" should exist at "alt-path-app" and include "Howdy"
    And cleanup built app at "alt-path-app"
    
  Scenario: EN mounted at root should not be in directory
    Given a built app at "alt-path-app"
    Then "lang_en/index.html" should not exist at "alt-path-app"
    And cleanup built app at "alt-path-app"
    
  Scenario: Paths can be localized EN
    Given a built app at "alt-path-app"
    Then "hello.html" should exist at "alt-path-app" and include "Hello World"
    And cleanup built app at "alt-path-app"
    
  Scenario: ES should be under namespace
    Given a built app at "alt-path-app"
    Then "lang_es/index.html" should exist at "alt-path-app" and include "Como Esta?"
    And cleanup built app at "alt-path-app"
    
  Scenario: Paths can be localized ES
    Given a built app at "alt-path-app"
    Then "lang_es/hola.html" should exist at "alt-path-app" and include "Hola World"
    And cleanup built app at "alt-path-app"