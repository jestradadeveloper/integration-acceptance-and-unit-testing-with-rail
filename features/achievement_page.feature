Feature: Achievement Page

  In order to read others achievements
  As a guess user
  I want to see public achievements

  Scenario: guest user sees public achievements
  Given I am a guest user
  And there is a public achievement
  When I go to the achievement's page
  Then I must see archievement's content