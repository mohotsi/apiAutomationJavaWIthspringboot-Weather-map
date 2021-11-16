Feature: Weather Stations



  Scenario: Register a weather station
    Given Client perform post operation for end point "stations" with body
    |external_id|name|latitude|longitude|altitude|
    |SF_TEST001 |San Francisco Test Station|37.76|-122.43|150|
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |SF_TEST001 |San Francisco Test Station|37.76|-122.43|150|
    When Client perform get operation for end point "stations"
    Then Response body data "contains"
    |external_id|name|latitude|longitude|altitude|
    |SF_TEST001 |San Francisco Test Station|37.76|-122.43|150|

  Scenario: Get the newly registered weather station info
  Given Client perform get operation for end point "stations/{id}"
  Then Response body data "should match with expected data below"
    |external_id|name|latitude|longitude|altitude|
    |SF_TEST001 |San Francisco Test Station|37.76|-122.43|150|

  Scenario: Update the station info
    Given Client perform put operation for end point "stations/{id}" with body
      |external_id|name|latitude|longitude|altitude|
      |SP_TEST002 |Cape Town|33.9249|18.4241|100|
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |SP_TEST002 |Cape Town|33.9249|18.4241|100|
    And Client perform get operation for end point "stations/{id}"
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |SP_TEST002 |Cape Town|33.9249|18.4241|100|

Scenario: Delete the weather station and confirm it has been deleted
  Given Client perform delete operation for end point "stations/{id}"
  And Client perform get operation for end point "stations/{id}"
  Then Response body data "should return error message"
    |code|message|
    |404001|Station not found|
 When Client perform get operation for end point "stations"
  Then Response body data "does not contain"
  |id  |external_id|name|latitude|longitude|altitude|
  | autogenerated|SP_TEST002 |Cape Town|33.9249|18.4241|100|





  Scenario Outline: Delete the non existing weather station2
    Given Client perform delete operation for end point "stations/{<id>}"
    Then Response body data "should return error message"
      |code|message|
      |<code>|<message>|
   Examples:
    |id|message|code|
    |999999999999999999999999|Station not found|404001|
    |b999999999999999999999999|Station id not valid|400002|
    |                         |Internal error|404000|
  Scenario Outline: get the non existing weather station2
    Given Client perform get operation for end point "stations/{<id>}"
    Then Response body data "should return error message"
      |code|message|
      |<code>|<message>|
    Examples:
      |id|message|code|
      |999999999999999999999999|Station not found|404001|
      |b999999999999999999999999|Station id not valid|400002|
      |                         |Internal error|404000|



  Scenario Outline: Register a weather with invalid data station
    Given Client perform post operation for end point "stations" with body
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    Then Response body data "should return error message"
      |code|message|
      |<code>|<message>|
    Examples:
      |external_id|name|latitude|longitude|altitude|code|message|
      |SF_TEST001 |San Francisco Test Station|90.1|-122.43|150|400001|Station latitude should be in (-90:90)|
      |SF_TEST001 |San Francisco Test Station|-90.1|-122.43|150|400001|Station latitude should be in (-90:90)|
      |SF_TEST001 |San Francisco Test Station|90|-180.1|150|400001|Station longitude should be in (-180:180)|
      |SF_TEST001 |San Francisco Test Station|90|180.1|150|400001|Station longitude should be in (-180:180)|
      | |San Francisco Test Station|90|-180|67|400001|Bad external id|
      |SF_TEST001 ||90|-180|150|400001|Bad or zero length station name|

  Scenario Outline: Register a weather with empty data station
    Given Client perform post operation for end point "stations" with with empty body
    Then Response body data "should return error message"
      |code|message|
      |<code>|<message>|
    Examples:
      |code|message|
      |400001|EOF|

  Scenario Outline: Register a weather longitude and latitude boundary analysis
    Given Client perform post operation for end point "stations" with body
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    Examples:
      |external_id|name|latitude|longitude|altitude|
      |SF_TEST001 |San Francisco Test Station|90.0|-122.43|150|
      |SF_TEST001 |San Francisco Test Station|-90.0|-122.43|150|
      |SF_TEST001 |San Francisco Test Station|5.0|-180.00|150|
      |SF_TEST001 |San Francisco Test Station|5.0|-100.00|150|
  Scenario Outline: Update the station info with latitude and longitude boundary analysis
    Given Client perform put operation for end point "stations/{id}" with body
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    And Client perform get operation for end point "stations/{id}"
    Then Response body data "should match with expected data below"
      |external_id|name|latitude|longitude|altitude|
      |<external_id> |<name>|<latitude>|<longitude>|<altitude>|
    Examples:
      |external_id|name|latitude|longitude|altitude|
      |SF_TEST001 |San Francisco Test Station|90.0|-122.43|150|
      |SF_TEST001 |San Francisco Test Station|-90.0|-122.43|150|
      |SF_TEST001 |San Francisco Test Station|5.0|-180.00|150|
      |SF_TEST001 |San Francisco Test Station|5.0|-100.00|150|


